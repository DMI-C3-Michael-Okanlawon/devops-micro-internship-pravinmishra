---
name: ansible-risk-review
description: Run and analyze the read-only Ansible check-mode risk report without applying changes.
disable-model-invocation: true
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(MSYS_NO_PATHCONV=1 wsl.exe -d Ubuntu-24.04 -- /bin/bash -lc "cd /mnt/e/dmi/devops-micro-internship-pravinmishra/week-09-ansible/assignment-06-ansible-risk-review && source /home/michael/ansible-onboarding/.venv/bin/activate && ./ansible-check-review.sh")
disallowed-tools:
  - Write
  - Edit
  - NotebookEdit
---

# Ansible Risk Review

Perform a read-only review of pending Ansible changes.

## Required procedure

1. Read `CLAUDE.md`.

2. Run only this approved command:

   `MSYS_NO_PATHCONV=1 wsl.exe -d Ubuntu-24.04 -- /bin/bash -lc "cd /mnt/e/dmi/devops-micro-internship-pravinmishra/week-09-ansible/assignment-06-ansible-risk-review && source /home/michael/ansible-onboarding/.venv/bin/activate && ./ansible-check-review.sh"`

3. Read `reports/ansible-risk-report.txt`.

4. Report:

   - Unique changed tasks
   - Unreachable and failed host totals
   - Each changed task and its category
   - Risk level and explanation
   - Overall `LOW RISK` or `HOLD` recommendation

5. State clearly that the result is analysis only and does not authorize application.

## Mandatory restrictions

- Never run `ansible-playbook` directly.
- Never run a command that omits `--check --diff`.
- Never modify the inventory, playbook, roles, script, report, or managed host.
- Never use Write, Edit, or NotebookEdit.
- Never apply, converge, fix, remediate, or roll back a change.
- Never run the real playbook.
- Never recommend automatic application.
- If failed or unreachable hosts are present, recommend `HOLD`.
- If a required risk category is detected, recommend `HOLD`.
- Only the human operator may approve and run the real playbook.