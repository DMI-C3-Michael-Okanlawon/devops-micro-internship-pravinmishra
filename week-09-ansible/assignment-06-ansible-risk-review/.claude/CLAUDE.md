# Ansible Change Risk Review

## Purpose

This project uses Claude Code only to review pending Ansible changes. Claude may inspect files, run the approved dry-run review script, read reports, classify risk, and explain findings. Claude must never apply infrastructure changes.

## Required Change-Review Workflow

1. Inspect the inventory, playbook, roles, and this CLAUDE.md file.
2. Run the read-only `ansible-check-review.sh` wrapper.
3. The wrapper must use `ansible-playbook --check --diff`.
4. Review the generated report for changed, unreachable, and failed results.
5. Classify each unique changed task into exactly one of these four categories:
   - Service restarts or handlers
   - Firewall rule changes
   - User or sudo changes
   - Package or file removal
6. Explain the risk and recommend whether the change should proceed or be held for human review.
7. Stop after the analysis. A human must review the recommendation and run the real playbook manually.
8. After the human applies the change, verify inventory connectivity and run the dry-run review again.

## Safety Rules

- Never run `ansible-playbook` without both `--check` and `--diff`.
- Never remove, bypass, or override Ansible check mode.
- Never apply, converge, remediate, fix, or roll back the playbook automatically.
- Never run an Ansible ad-hoc command that changes a managed host.
- Never restart or stop a service on a managed host.
- Never add, remove, or modify firewall rules.
- Never create, modify, or remove users, groups, passwords, SSH keys, or sudo permissions.
- Never install, upgrade, downgrade, or remove packages.
- Never create, modify, move, or remove remote files.
- Never execute remote shell or command tasks that could change a host.
- Never modify the inventory, playbook, roles, variables, or configuration as part of a risk review.
- Never expose SSH private keys, Ansible Vault passwords, cloud credentials, secrets, or sensitive inventory values.
- Never interpret a low-risk result as permission to apply a playbook.
- If the dry run reports unreachable or failed hosts, recommend holding the change for investigation.
- If any risky change is detected, recommend holding it for human review.
- Only the human operator may run the real playbook after reviewing and approving the report.

## Approved Read-Only Operations

Claude may:

- Read project files.
- Search project files.
- Run `bash -n ansible-check-review.sh`.
- Run `./ansible-check-review.sh`.
- Run Ansible commands only when they include `--check --diff`.
- Read the generated risk report.
- Explain findings and make recommendations.

## Human-Only Commands

The following actions are reserved for the human operator:

- Running the real `ansible-playbook` command.
- Approving or rejecting a proposed change.
- Applying remediation.
- Verifying the managed host after the real change.