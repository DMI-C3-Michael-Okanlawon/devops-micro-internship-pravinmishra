#!/usr/bin/env bash
# Read pipeline status and logs only. Never start or modify runs.
set -uo pipefail
umask 077

ORG="https://dev.azure.com/Michael-Okanlawon-DMI-Cohort-3"
PROJECT="Week10-SelfHosted-Agent"
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="$ROOT/reports"
STAMP="$(date -u +%Y%m%dT%H%M%S)-$$"

command -v az >/dev/null || { echo "ERROR: Azure CLI missing."; exit 1; }
command -v python3 >/dev/null || { echo "ERROR: Python 3 missing."; exit 1; }

mkdir -p "$REPORT_DIR"
REPORT="$REPORT_DIR/triage-$STAMP.txt"
OVERALL=0

say() {
  printf '%s\n' "$*" | tee -a "$REPORT"
}

# Suppress suspected credential lines before saving log evidence.
# Pattern filtering is a precaution, not a guarantee of secret detection.
sanitize() {
  python3 -c '
import re, sys
blocked = re.compile(
    r"password|passwd|secret|token|authorization|"
    r"private.key|AccountKey|SharedAccessSignature|"
    r"client_secret|://[^/\s]+:[^@\s]+@|"
    r"[?&]sig=|eyJ[A-Za-z0-9_-]{15,}|"
    r"[A-Za-z0-9_+=/-]{60,}",
    re.I
)
for line in sys.stdin:
    if not blocked.search(line):
        sys.stdout.write(line)
'
}

match_category() {
  local category="$1" pattern="$2" fix="$3"
  local evidence
  evidence="$(grep -Ein -- "$pattern" "$LOG" | head -n 4 || true)"
  if [[ -n "$evidence" ]]; then
    say "CATEGORY: $category"
    say "Evidence (sanitized log line numbers):"
    say "$evidence"
    say "Recommended human action: $fix"
    MATCHES=$((MATCHES + 1))
  fi
}

check_dependency() {
  match_category "Dependency" \
    'npm ERR!.*(E404|ERESOLVE|ETARGET)|npm error.*(E404|ERESOLVE|ETARGET)|No matching version found|Could not resolve dependency|Unable to locate package|Could not find a version that satisfies' \
    "Check the package name and version in the failed installation command; correct the dependency declaration and push the fix yourself."
}

check_build() {
  match_category "Build" \
    'Compilation failed|Failed to compile|Build failed|error TS[0-9]+|SyntaxError:|Module not found|Cannot find module' \
    "Inspect the file or module named in the error; correct its syntax, import, or build configuration and push the fix yourself."
}

check_test() {
  match_category "Test" \
    'AssertionError|ERR_ASSERTION|Expected.*Received|(^|[[:space:]])FAIL[[:space:]]|[1-9][0-9]* failing|Tests:.*[1-9][0-9]* failed|test failed' \
    "Inspect the failing assertion and expected result; correct the intentional test change and push the fix yourself."
}

check_authentication() {
  match_category "Authentication" \
    'AADSTS[0-9]+|TF400813|401 Unauthorized|403 Forbidden|Authentication failed|unauthorized_client|Invalid client secret|Permission denied \(publickey\)|not authorized to access' \
    "Review the affected identity and permissions privately; repair authentication yourself without sharing credentials."
}

check_agent() {
  match_category "Agent/runner availability" \
    'No agent found|No available agents|agent.*offline|runner.*offline|No hosted parallelism|all.*agents.*busy|waiting for.*(agent|runner)|agent.*lost communication' \
    "Check the assigned pool and agent availability; start or repair the agent yourself if the evidence supports that action."
}

# Azure GET log responses can be JSON strings, arrays, or value objects.
decode_log() {
  python3 -c '
import json, sys
data = json.load(sys.stdin)
def emit(value):
    if isinstance(value, str):
        print(value)
    elif isinstance(value, list):
        for item in value:
            emit(item)
    elif isinstance(value, dict) and "value" in value:
        emit(value["value"])
    else:
        raise ValueError("Unexpected log response")
emit(data)
'
}

inspect_pipeline() {
  local pipeline_id="$1" name="$2"
  local run_id status result log_ids log_id
  local logs_ok=1
  say ""
  say "PIPELINE: $name (ID $pipeline_id)"

  if ! run_id="$(az pipelines runs list \
    --organization "$ORG" --project "$PROJECT" \
    --pipeline-ids "$pipeline_id" \
    --query-order QueueTimeDesc --top 1 \
    --query '[0].id' --output tsv --only-show-errors 2>/dev/null)"; then
    say "UNKNOWN: Cannot read runs. Check CLI login and Build Read access."
    OVERALL=1
    return
  fi

  run_id="$(printf '%s' "$run_id" | tr -d '\r\n')"
  if [[ ! "$run_id" =~ ^[0-9]+$ ]]; then
    say "UNKNOWN: No run found."
    OVERALL=1
    return
  fi

  if ! status="$(az pipelines runs show \
    --organization "$ORG" --project "$PROJECT" --id "$run_id" \
    --query status --output tsv --only-show-errors 2>/dev/null)" ||
     ! result="$(az pipelines runs show \
    --organization "$ORG" --project "$PROJECT" --id "$run_id" \
    --query result --output tsv --only-show-errors 2>/dev/null)"; then
    say "UNKNOWN: Cannot read run details."
    OVERALL=1
    return
  fi

  status="$(printf '%s' "$status" | tr -d '\r\n')"
  result="$(printf '%s' "$result" | tr -d '\r\n')"
  say "Run ID: $run_id"
  say "Status: $status"
  say "Result: ${result:-not available}"
  say "URL: $ORG/$PROJECT/_build/results?buildId=$run_id"

  if [[ "$status" == "completed" && "$result" == "succeeded" ]]; then
    say "HEALTHY: Latest run succeeded. No failure category triggered."
    return
  fi

  OVERALL=1
  if [[ "$status" != "completed" ]]; then
    say "PENDING: Run is unfinished. This alone does not prove an agent failure."
  else
    say "NOT HEALTHY: Inspecting available log evidence."
  fi

  LOG="$REPORT_DIR/pipeline-$pipeline_id-run-$run_id-$STAMP.log"
  : > "$LOG"

  if ! log_ids="$(az devops invoke \
    --organization "$ORG" --area build --resource logs \
    --route-parameters project="$PROJECT" buildId="$run_id" \
    --http-method GET --api-version 7.1 \
    --query 'value[].id' --output tsv \
    --only-show-errors 2>/dev/null)"; then
    say "UNKNOWN: Could not fetch log index; no diagnosis claimed."
    return
  fi

  if [[ -z "$log_ids" ]]; then
    say "UNKNOWN: No logs available yet; no diagnosis claimed."
    return
  fi

  log_ids="$(printf '%s' "$log_ids" | tr -d '\r')"
  for log_id in $log_ids; do
    [[ "$log_id" =~ ^[0-9]+$ ]] || continue
    printf '\n--- Run %s / log %s ---\n' "$run_id" "$log_id" >> "$LOG"
    if ! az devops invoke \
      --organization "$ORG" --area build --resource logs \
      --route-parameters project="$PROJECT" buildId="$run_id" logId="$log_id" \
      --http-method GET --api-version 7.1 \
      --accept-media-type application/json \
      --output json --only-show-errors 2>/dev/null |
      decode_log 2>/dev/null | sanitize >> "$LOG"; then
      logs_ok=0
    fi
  done

  MATCHES=0
  check_dependency
  check_build
  check_test
  check_authentication
  check_agent

  if [[ "$MATCHES" -eq 0 ]]; then
    say "UNCLASSIFIED: Available evidence did not match the five categories."
    say "Recommended human action: Review the failed task in Azure DevOps."
  fi
  if [[ "$logs_ok" -eq 0 ]]; then
    say "LIMITATION: Some logs could not be read; evidence is incomplete."
  fi
  say "Pattern matches are diagnostic candidates, not proof of root cause."
  say "Sanitized evidence file: $LOG"
}

say "EpicBook Pipeline Triage"
say "Checked at: $(date -u +%FT%TZ)"
say "Safety: Read-only remote operations; local reports only."

inspect_pipeline 4 "EpicBook infrastructure"
inspect_pipeline 5 "EpicBook application"

say ""
if [[ "$OVERALL" -eq 0 ]]; then
  say "OVERALL: HEALTHY — both latest runs succeeded."
else
  say "OVERALL: NOT CONFIRMED HEALTHY — review findings above."
fi
say "Report: $REPORT"
exit "$OVERALL"
