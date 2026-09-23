#!/usr/bin/env bash

set -uo pipefail

INVENTORY="${1:-ansible/inventory.ini}"
PLAYBOOK="${2:-ansible/site.yml}"
REPORT_DIR="reports"
RAW_REPORT="${REPORT_DIR}/ansible-check-raw.txt"
RISK_REPORT="${REPORT_DIR}/ansible-risk-report.txt"

mkdir -p "$REPORT_DIR"

classify_task() {
  local task_name="$1"
  local task_lower

  task_lower="$(printf '%s' "$task_name" | tr '[:upper:]' '[:lower:]')"

  if [[ "$task_lower" =~ firewall|ufw|firewalld|iptables|security[[:space:]]group ]]; then
    printf '%s' "Firewall rule changes"
  elif [[ "$task_lower" =~ user|sudo|sudoers|authorized.key|ssh.key|password|group ]]; then
    printf '%s' "User or sudo changes"
  elif [[ "$task_lower" =~ remove|delete|absent|uninstall|purge ]]; then
    printf '%s' "Package or file removal"
  elif [[ "$task_lower" =~ restart|reload|service|handler ]]; then
    printf '%s' "Service restarts or handlers"
  else
    printf '%s' "No required risk-category match"
  fi
}

risk_level_for_category() {
  local category="$1"

  case "$category" in
    "Firewall rule changes")
      printf '%s' "HIGH"
      ;;
    "User or sudo changes")
      printf '%s' "HIGH"
      ;;
    "Package or file removal")
      printf '%s' "HIGH"
      ;;
    "Service restarts or handlers")
      printf '%s' "MEDIUM"
      ;;
    *)
      printf '%s' "LOW"
      ;;
  esac
}

extract_changed_tasks() {
  awk '
    /^TASK \[/ || /^RUNNING HANDLER \[/ {
      task = $0
      sub(/^[^[]*\[/, "", task)
      sub(/\][[:space:]]*\**[[:space:]]*$/, "", task)
    }

    /^(changed|would change): \[/ {
      if (task != "") {
        print task
      }
    }
  ' "$RAW_REPORT" | awk '!seen[$0]++'
}

sum_recap_value() {
  local field="$1"

  grep -E '^[^[:space:]]+[[:space:]]+:' "$RAW_REPORT" |
    sed -nE "s/.*${field}=([0-9]+).*/\1/p" |
    awk '{ total += $1 } END { print total + 0 }'
}

printf '%s\n' "Running read-only Ansible check..."
printf 'Inventory: %s\n' "$INVENTORY"
printf 'Playbook:  %s\n\n' "$PLAYBOOK"

set +e
ansible-playbook \
  -i "$INVENTORY" \
  "$PLAYBOOK" \
  --check \
  --diff 2>&1 | tee "$RAW_REPORT"
ANSIBLE_EXIT="${PIPESTATUS[0]}"
set -e

mapfile -t CHANGED_TASKS < <(extract_changed_tasks)

UNREACHABLE_TOTAL="$(sum_recap_value "unreachable")"
FAILED_TOTAL="$(sum_recap_value "failed")"

RISKY_COUNT=0
LOW_COUNT=0

{
  printf '\n'
  printf '%s\n' "========================================"
  printf '%s\n' "ANSIBLE CHANGE RISK REVIEW"
  printf '%s\n' "========================================"
  printf 'Generated: %s\n' "$(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  printf 'Inventory: %s\n' "$INVENTORY"
  printf 'Playbook: %s\n' "$PLAYBOOK"
  printf 'Ansible check exit code: %s\n' "$ANSIBLE_EXIT"
  printf 'Unique changed tasks: %s\n' "${#CHANGED_TASKS[@]}"
  printf 'Unreachable hosts: %s\n' "$UNREACHABLE_TOTAL"
  printf 'Failed hosts: %s\n' "$FAILED_TOTAL"
  printf '\n'

  printf '%s\n' "Risk-category findings"
  printf '%s\n' "----------------------------------------"

  if ((${#CHANGED_TASKS[@]} == 0)); then
    printf '%s\n' "No changed tasks were reported."
  else
    for task_name in "${CHANGED_TASKS[@]}"; do
      category="$(classify_task "$task_name")"
      risk_level="$(risk_level_for_category "$category")"

      printf 'Task: %s\n' "$task_name"
      printf 'Category: %s\n' "$category"
      printf 'Risk level: %s\n\n' "$risk_level"

      if [[ "$risk_level" == "HIGH" || "$risk_level" == "MEDIUM" ]]; then
        ((RISKY_COUNT += 1))
      else
        ((LOW_COUNT += 1))
      fi
    done
  fi

  printf '%s\n' "Category definitions"
  printf '%s\n' "----------------------------------------"
  printf '%s\n' "1. Service restarts or handlers"
  printf '%s\n' "2. Firewall rule changes"
  printf '%s\n' "3. User or sudo changes"
  printf '%s\n' "4. Package or file removal"
  printf '\n'

  printf '%s\n' "Overall status"
  printf '%s\n' "----------------------------------------"

  if ((UNREACHABLE_TOTAL > 0 || FAILED_TOTAL > 0 || ANSIBLE_EXIT != 0)); then
    printf '%s\n' "HOLD"
    printf '%s\n' "Reason: The check reported failed/unreachable hosts or a non-zero exit code."
  elif ((RISKY_COUNT > 0)); then
    printf '%s\n' "HOLD"
    printf '%s\n' "Reason: One or more changed tasks matched a required risk category."
    printf '%s\n' "A human must review and approve the change before any real playbook run."
  else
    printf '%s\n' "LOW RISK"
    printf '%s\n' "Reason: No changed task matched the four required risk categories."
    printf '%s\n' "This is an assessment only, not permission to apply the playbook."
  fi

  printf '\nRisky findings: %s\n' "$RISKY_COUNT"
  printf 'Other changed tasks: %s\n' "$LOW_COUNT"
  printf '%s\n' "========================================"
} | tee "$RISK_REPORT"

printf '\nRaw output saved to: %s\n' "$RAW_REPORT"
printf 'Risk report saved to: %s\n' "$RISK_REPORT"