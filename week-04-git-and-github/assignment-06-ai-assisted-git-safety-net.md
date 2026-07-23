# Assignment 6 — Building an AI-Assisted Git Safety Net (PR Ready Check)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In Week 2 you built Claude Code hooks that block a dangerous action *before* it happens (`PreToolUse`), and a restricted skill that could look but not touch (`allowed-tools` without `Write`). In this assignment you will discover that Git has the exact same idea, decades older: a **pre-commit hook** that blocks a commit before it's created.

You will build both halves of a real "PR Ready" workflow:

1. A **Git hook that follows fixed rules** — scans staged changes for hardcoded secrets and oversized files and refuses the commit. No AI involved, no guessing, just a rule that gives the same answer every time.
2. A **restricted Claude Code skill** (`/pr-ready`) that reads your staged diff and drafts a Pull Request title, description, and a short list of things worth a second look — the kind of judgment a fixed rule can't make (mixed changes, missing context, unclear intent). The skill never commits, pushes, or opens the PR. You do that yourself, using its draft as a starting point.

This mirrors the Agentic Loop from Week 3's Linux triage assignment: **Gather → Analyze → Human Act → Verify**. The hook and the skill both gather and analyze; only you act.

---

# Task 0 — Confirm Your Fork and Create a Feature Branch

## Goal

Confirm you are working in your own fork, then create a dedicated branch for this assignment.

### Evidence

#### Screenshot 1 — Output of git remote -v and git branch showing the new branch

![alt text](screenshots/Wk4-assgn6-screenshot1-output-remote-v.PNG)

---

### Notes

**1. Why create a dedicated branch instead of doing this work on main?**

A dedicated branch allows changes to be developed and tested without affecting the stable main branch. It provides an isolated environment where features, fixes, or experiments can be worked on safely. Branching also makes collaboration easier because multiple developers can work on different tasks simultaneously, review changes through Pull Requests, and merge only approved code into main. This helps prevent accidental issues and maintains a clean project history.

---

# Task 1 — Stage a Change With Realistic Risk

## Goal

On your own fork of this repository (the one you've been submitting your DMI work in since onboarding), create a new branch and stage a change that a real reviewer should catch: a hardcoded-looking secret and a leftover debug statement.

### Evidence

#### Screenshot 1 — Output of  `git status` showing the staged file on feature/ai-pr-ready

![alt text](screenshots/Wk4-assgn6-screenshot2-git-status-output.PNG)

---

### Notes

**1. Why does this assignment use an obviously fake key instead of a real one?**

**Why does this assignment use an obviously fake key instead of a real one?**

The assignment uses an obviously fake key to teach secure coding practices without exposing real credentials. It allows identifying hardcoded secrets during code reviews while ensuring there is no risk of compromising actual accounts or cloud resources. This provides a safe, realistic learning environment for understanding how sensitive information should be handled.

---

# Task 2 — Write a Real Git Pre-Commit Hook

## Goal

Create a tracked, shareable pre-commit hook that blocks a commit containing secret-like patterns or files over 1MB.

### Evidence

#### Screenshot 2 — `hooks/pre-commit` open in VS Code showing the full script

![alt text](screenshots/Wk4-assgn6-screenshot2-hook-pre-commit-in-vs-code.PNG)

---

#### Screenshot 3 — Output of `git config core.hooksPath` confirming it points to `hooks`

![alt text](screenshots/Wk4-assgn6-screenshot3-git-configure-hookPath-output.PNG)

---

### Notes

**1. Why is `hooks/pre-commit` tracked in the repo instead of living only in `.git/hooks/`?**

The hook is tracked in the repository so everyone on the team can use the same checks. If it stays in .git/hooks, it only exists on one person's computer and cannot be shared with others.

---

**2. Compare this to `PreToolUse` from Week 2 Assignment 6. What does each one intercept, and what do they have in common?**

The pre-commit hook checks files before they are committed to Git, while PreToolUse checks commands before an AI tool executes them. The pre-commit hook protects the code repository, and PreToolUse protects the development environment. Both help prevent mistakes before they happen.

---

# Task 3 — Prove the Hook Blocks the Risky Commit

## Goal

Attempt to commit the staged file from Task 1 and show the hook rejecting it.

### Evidence

#### Screenshot 4 — Terminal showing `git commit` rejected with the hook's "BLOCKED" message naming the exact file

![alt text](screenshots/Wk4-assgn6-screenshot4-blocked-commit.PNG)

---

### Notes

**1. Which line in `hooks/pre-commit` matched your fake key, and why did it match?**

The line that uses grep -qE 'AKIA[0-9A-Z]{16}...' matched the fake key because it looks for text that starts with AKIA followed by 16 uppercase letters or numbers, which matches the fake AWS access key.

---

**2. Could this hook have caught a poorly-named variable that stores a secret without the `AKIA` prefix? What does that tell you about the limits of a fixed rule like this?**

No. If the secret did not match the AKIA pattern, the hook might not detect it. This shows that fixed rules can catch known patterns but may miss secrets with different formats or names.

---

# Task 4 — Build the `/pr-ready` Skill

## Goal

Create a manually invoked Claude Code skill that reads your staged changes and produces a PR-readiness report and a draft PR description — without writing, committing, or pushing anything itself.

### Evidence

#### Screenshot 5 — `SKILL.md` frontmatter showing `allowed-tools: Bash, Read, Grep` (no `Write`) and `disable-model-invocation: true`

![alt text](screenshots/Wk4-assgn6-screenshot5-skills-md-showing-read-grep-vs-code.PNG)

---

#### Screenshot 6 — `/pr-ready` output while the risky file is still staged, showing it flagged the secret and/or debug statement

![alt text](screenshots/Wk4-assgn6-screenshot6-claude-pr-ready-output.PNG)

---

### Notes

**1. Why does `/pr-ready` have `Bash` and `Read` but not `Write`?**

/pr-ready only needs to read the staged changes and review them. It does not need Write because it should not edit files, commit changes, or push code.

---

**2. The pre-commit hook and `/pr-ready` both looked at the same staged diff. Did they flag the same things? What did one catch that the other didn't?**

They both detected the fake AWS key. The pre-commit hook blocked the commit because of the key, while /pr-ready also pointed out the debug echo statement and drafted a PR title and description.

---

# Task 5 — Fix the Issues and Re-Verify

## Goal

Remove the secret and debug statement, then prove both gates now pass clean.

### Evidence

#### Screenshot 7 — `git commit` succeeding after the fix (no BLOCKED message)

![alt text](screenshots/Wk4-assgn6-screenshot7-git-commit-no-blockage.PNG)

---

#### Screenshot 8 — Second `/pr-ready` run showing a clean risk report and a drafted PR title + description

![alt text](screenshots/Wk4-assgn6-screenshot8-claude-pr-ready.PNG)

---

### Notes

**1. What exactly did you change to satisfy the pre-commit hook?**

I removed the fake AWS key and the debug echo statement from scripts/notify.sh. This allowed the file to pass the pre-commit hook because it no longer contained content that matched the hook's security checks.

---

# Task 6 — Push and Open a Pull Request Using the AI Draft

## Goal

Push your branch and open a real Pull Request, using `/pr-ready`'s drafted title and description as your starting point — read it critically and edit before you use it.

**Important:** Open this Pull Request with base repository set to **your own fork** — not the shared upstream `pravinmishraaws/devops-micro-internship-pravinmishra` repository. This assignment's hook and skill files are your own practice work, not a change meant for the shared class repo.

### Evidence

#### Screenshot 9 — Your Pull Request showing the base repository is your own fork, plus the title and description, with the `/pr-ready` draft visible for comparison (paste it in the PR conversation or your notes below)

![alt text](screenshots/Wk4-assgn6-screenshot9-pull-request.PNG)

---

#### PR Link

`https://github.com/DMI-C3-Michael-Okanlawon/devops-micro-internship-interviews/pull/1`

---

### Notes

**1. What, if anything, did you edit in the AI's drafted PR description before using it? Why?**

I edited the AI's draft to better reflect the work I actually completed. I included the pre-commit hook and the /pr-ready skill because they were key parts of the assignment, making the Pull Request more accurate and complete.

---

**2. If you had blindly copy-pasted the AI's draft without reading it, what could go wrong?**

The Pull Request could contain incorrect or incomplete information. Reviewing the AI's draft helped me correct mistakes and ensure it accurately described my changes before submitting it.

---

**3. Why does this PR need to target your own fork instead of the shared upstream repository?**

This assignment is for practicing Git and GitHub workflows in my own repository. Targeting my fork keeps the shared upstream repository free from practice changes and prevents affecting the main project or other contributors.

---

# Task 7 — Map the Workflow to the Agentic Loop

## Goal

Explain this assignment's workflow using the same Gather → Analyze → Human Act → Verify structure from Week 3.

### Notes

**1. Which step(s) represent Gather?**

Gather is when the pre-commit hook and the /pr-ready skill read the staged changes using commands like git diff --cached and git status to collect information about what will be committed.

---

**2. Which step(s) represent Analyze?**

Analyze is when the pre-commit hook checks for secrets or oversized files, and /pr-ready reviews the staged changes for issues like debug statements, credential-like strings, and prepares a draft Pull Request.

---

**3. Which step is Human Act, and why must a human — not Claude — run `git commit`, `git push`, and open the PR?**

Human Act is when I decide to commit, push my branch, and create the Pull Request. A human must do these actions because they change the repository, and the final decision should remain with the developer.

---

**4. Which step is Verify?**

Verify is when I review the hook's output, check the /pr-ready report, confirm the Pull Request details are correct, and ensure everything is ready before submitting.

---

**5. In one or two sentences: why do you need *both* the fixed-rule pre-commit hook and the AI skill? Isn't one enough?**

The pre-commit hook quickly blocks known problems using fixed rules, while the AI skill provides a broader review and explains potential issues. Using both gives better protection than relying on only one.

---

# Task 8 — LinkedIn Post

## Goal

Publish a LinkedIn post summarizing what you built and what you learned about combining fixed-rule safety checks with AI-assisted review.

### Evidence

#### LinkedIn Post URL

`https://www.linkedin.com/posts/michael-okanlawon_devops-git-github-share-7485959049403027457-LBqx/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC9A9-IBmPTPhzYSqhRaCI1i6ENsTRA8KEw`

---

## Key Learnings

Add 3-5 bullet points on what you learned this week.

1. I learned how to use Git branching to develop features safely without affecting the main branch.

2. I gained hands-on experience with GitHub workflows, including forking, syncing, pushing changes, and creating Pull Requests.
3. Built a Git pre-commit hook that automatically blocks commits containing credential-like strings or oversized files.
4. Created a Claude Code /pr-ready skill that reviews staged changes and drafts Pull Request details without making changes.
5. Understood that the best DevOps workflows combine rule-based automation, AI-assisted review, and human judgment before code is merged.

---

# Submission Instructions

- Ensure `hooks/pre-commit` and `.claude/skills/pr-ready/SKILL.md` are committed to your GitHub repository
- Add all required screenshots to your submission
- All written answers must be in your own words
- Do not use a real secret or credential anywhere in your submission — the fake key in Task 1 is intentional and must stay clearly fake
- Open your Pull Request against your own fork, not the shared upstream repository
- Push your final changes to your forked repository
- Include your PR link and LinkedIn post URL

---

## GitHub Repository URL

Paste your forked repository URL here:

`https://github.com/DMI-C3-Michael-Okanlawon/devops-micro-internship-interviews.git`

---

# Completion Checklist

- [ ] Branch `feature/ai-pr-ready` created with a staged file containing a fake secret and a debug statement
- [ ] `hooks/pre-commit` created and tracked in the repo (not only in `.git/hooks/`)
- [ ] `core.hooksPath` configured to point at `hooks/`
- [ ] Pre-commit hook shown blocking the risky commit
- [ ] `.claude/skills/pr-ready/SKILL.md` created with correct `allowed-tools` (no `Write`) and `disable-model-invocation: true`
- [ ] `/pr-ready` run against the risky diff and shown flagging issues
- [ ] Risky file fixed; `git commit` succeeds cleanly
- [ ] `/pr-ready` re-run showing a clean report and drafted PR title/description
- [ ] Pull Request opened using the AI draft as a starting point, with your own fork as the base repository (not upstream), PR link included
- [ ] Agentic Loop mapping (Task 7) completed in your own words
- [ ] LinkedIn post published and URL submitted
- [ ] All required screenshots added
- [ ] GitHub repository URL provided

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://pravinmishra.com/dmi  
- 🎓 DevOps for Beginners (Udemy): https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 Agentic AI DevOps with Claude Code: https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/  
- 🎓 DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm: https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
