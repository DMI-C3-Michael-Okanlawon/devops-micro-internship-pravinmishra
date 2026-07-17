# Assignment 6 — Build an AI-Assisted Linux Health Check (AI-Assisted Linux Incident Triage)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash triage script that checks the health of your Ubuntu server and Nginx application, connect it to Claude Code as a reusable `/linux-triage` skill, simulate a controlled Nginx incident, use the skill to gather and analyze evidence, recover the service manually, and verify recovery. The workflow follows the Agentic Loop: Gather → Analyze → Human Act → Verify.

---

# Task 1 — Confirm the Healthy Baseline and Create the Workspace

## Goal

Confirm that Nginx and the React application are healthy before building the automation.

### Evidence

#### Screenshot 1 — Output of `systemctl is-active nginx`, `ss -ltn | grep ':80'`, and `curl -I http://localhost`

(week-03-linux-for-devops\screenshots\A6 Screenshot 1 Nginx active.PNG)

---

#### Screenshot 2 — Output of `pwd` and `find . -maxdepth 4 -type d | sort` showing the workspace folder structure

(week-03-linux-for-devops\screenshots\A6 Screenshot 2 pwd.PNG)

---

### Notes

Answer the following in your own words:

**1. What proves that Nginx is running?**

The systemctl is-active nginx command returned active, which confirms that the Nginx service is running successfully on the server.

---

**2. What proves that the server is listening for HTTP traffic?**

The ss -ltn | grep ':80' command showed that the server is listening on port 80, which is the default port for HTTP traffic. Also, the curl -I http://localhost command returned HTTP/1.1 200 OK, confirming that Nginx is responding to HTTP requests.

---

**3. Why must you capture a healthy baseline before simulating an incident?**

A healthy baseline gives me a reference point for how the server should behave before anything goes wrong. It makes it easier to identify the impact of the incident, compare the system before and after recovery, and confirm that everything is working normally once the issue has been fixed.

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Tell Claude exactly what this project does and what it is not allowed to do.

### Evidence

#### Screenshot 3 — CLAUDE.md open in VS Code showing all four sections (Project Overview, Incident Workflow, Safety Rules, Output Rules)

(week-03-linux-for-devops\screenshots\A6 Screenshot 3 — CLAUDE.md open in VS Code showing all four sections.PNG)

---

### Notes

Answer the following in your own words:

**1. Why should Claude receive project-specific operational rules?**

Project-specific operational rules help Claude understand the purpose of the project and the limits of what it is allowed to do. This ensures that its suggestions are relevant, consistent and safe for the environment it is working with.

---

**2. Why is the human required to execute the recovery command?**

The human is required to execute the recovery command because changes to a production server should always be under human control. Claude can recommend the correct action, but the final decision and execution should be done by the person managing the server.

---

**3. Which rule prevents Claude from making an unsupported diagnosis?**

The rule that tells Claude not to guess and to clearly separate observations from recommendations prevents it from making an unsupported diagnosis. It ensures that Claude only bases its conclusions on the evidence it has collected.

---

# Task 3 — Use Agentic AI to Plan Before Writing the Script

## Goal

Use Claude Code to inspect the environment and produce a read-only plan before creating any Bash code.

### Evidence

#### Screenshot 4 — Claude Code showing the five-check plan and read-only inspection results

(week-03-linux-for-devops\screenshots\A6 Task 3 — Using Agentic AI to Plan Before Writing the Script.PNG)

---

### Notes

Answer the following in your own words:

**1. Which part of this task represents the Gather phase?**

The Gather phase is when Claude inspects the Ubuntu server by checking the Nginx service, port 80, HTTP response, disk usage and available memory before making any recommendations or writing any code.

---

**2. Did Claude follow the instruction not to create files? How did you verify this?**

Yes. Claude followed the instruction by only inspecting the environment and providing a step-by-step implementation plan. It did not create or modify any files, which I verified because no new files were generated in the project directory.

---

**3. Why is planning before coding useful in DevOps automation?**

Planning before coding helps identify the requirements and the checks that need to be performed before writing the script. This reduces errors, improves the quality of the automation and makes it easier to build a reliable solution.

---

# Task 4 — Build the Linux Triage Bash Script

## Goal

Create one Bash script that gathers consistent Linux and Nginx health evidence.

### Evidence

#### Screenshot 5 — Top section of `linux-triage.sh` showing variables, thresholds, and the checks array

(week-03-linux-for-devops\screenshots\A6 Screenshot 5 Top of section.PNG)

---

#### Screenshot 6 — Middle section showing check functions and conditionals
(week-03-linux-for-devops\screenshots\A6 Screenshot 6 Functions and conditions.PNG)

---

#### Screenshot 7 — Bottom section showing the loop, summary function, and exit behavior

(week-03-linux-for-devops\screenshots\A6 Screenshot 7 loop summary exit.PNG)

---

#### Screenshot 8 — Output of `bash -n scripts/linux-triage.sh` (no syntax errors) and `ls -l scripts/linux-triage.sh` showing executable permission

(week-03-linux-for-devops\screenshots\A6 Screenshot 8 ls -l scripts-linux-triage.PNG)

---

### Notes

Answer the following in your own words:

**1. What is stored in the checks array?**

The checks array stores the names of all the health check functions that the script needs to run. These include checking the Nginx service, port 80, HTTP response, disk usage and available memory.

---

**2. How does the `for` loop use that array?**

The for loop goes through each function name stored in the checks array and executes them one after another. This allows the script to run all the health checks automatically without repeating code.

---

**3. Why are the health checks separated into functions?**

The health checks are separated into functions to make the script easier to read, maintain and troubleshoot. Each function performs a specific task, which also makes the script easier to update or reuse.

---

**4. What is the purpose of `$(...)` in this script?**

'$(...)' is used for command substitution. It runs a command and stores its output so it can be used elsewhere in the script. For example, it is used to get the current date, hostname and the results of system commands.

---

**5. Why does the script use different exit codes for HEALTHY, WARN, and FAIL?**

The script uses different exit codes so that the health status of the server can be identified easily. An exit code of 0 means the system is healthy, 1 indicates a warning that should be monitored, and 2 indicates a failure that requires immediate attention. This also makes it easier for other scripts or automation tools to respond appropriately.

---

# Task 5 — Run and Understand the Healthy-State Report

## Goal

Run the Bash script against the healthy server and verify that it creates a report.

### Evidence

#### Screenshot 9 — Output of `./scripts/linux-triage.sh` showing your Full Name and all five check results

(A6 Screenshot 9 showing Full Name and all five check results.PNG)

---

#### Screenshot 10 — Output showing the captured exit code and final summary

(A6 Screenshot 10 exit output 0.PNG)

---

### Notes

Answer the following in your own words:

**1. What is the overall status of your healthy baseline?**

The overall status of my healthy baseline is HEALTHY. All five health checks passed successfully, with no warnings or failures, confirming that the server and Nginx application were working as expected.

---

**2. Which exact Linux evidence proves the application is serving traffic?**

The curl -I http://localhost command returned HTTP/1.1 200 OK, which confirms that the application is responding to HTTP requests. The script also reported "Local HTTP check returned status 200," proving that the application is serving traffic.
---

**3. Did your script return exit code 0 or 1? Explain why.**

My script returned exit code 0 because all the health checks passed successfully. There were no warnings or failures, so the overall system status was HEALTHY.

---

**4. What is the difference between a warning and a failure in this script?**

A warning means that a resource, such as disk space or available memory, is approaching an unhealthy level but the system is still running. A failure means that a critical check, such as the Nginx service, port 80, or the HTTP response, has failed and requires immediate attention.

---

# Task 6 — Create and Run the /linux-triage Skill

## Goal

Turn the Bash script into a reusable, manually invoked Agentic AI workflow.

### Evidence

#### Screenshot 11 — `SKILL.md` showing the frontmatter, allowed tool restrictions, and safety rules

(week-03-linux-for-devops\screenshots\A6 Screenshot 11 cat Skill md.PNG)

---

#### Screenshot 12 — `/linux-triage` output for the healthy server

(A6 Screenshot 12 — linux-triage  output for the healthy server.PNG)

---

### Notes

Answer the following in your own words:

**1. Why does this skill have Bash, Read, and Grep, but not Write?**

This skill only needs to run the Bash script, read its output and search for information if needed. It does not need permission to create, modify or delete files, so the Write tool is not required.

---

**2. Why is `disable-model-invocation: true` useful for this skill?**

disable-model-invocation: true ensures that the skill only performs the specific workflow it was designed for instead of calling another model or generating unrelated responses. This keeps the behaviour predictable and focused.

---

**3. What part is performed by Bash, and what part is performed by Claude?**

Bash performs the Linux health checks by running commands and collecting system information. Claude reads the output, explains the findings and recommends what the human should do if any issues are detected.

---

**4. Why is this better than asking Claude "Is my server healthy?" without giving it evidence?**

This approach is better because Claude bases its response on real system data collected from the server instead of making assumptions. The health assessment is supported by evidence, making the results more accurate and reliable.

---

# Task 7 — Simulate an Nginx Incident and Let the Skill Diagnose It

## Goal

Create a controlled service failure, gather evidence through Bash, and let Claude analyze the evidence without taking recovery action.

### Evidence

#### Screenshot 13 — Output showing Nginx is inactive and the HTTP request fails

(week-03-linux-for-devops\screenshots\A6 Screenshot 13 Output showing Nginx is inactive and the HTTP request fails.PNG)

---

#### Screenshot 14 — `/linux-triage` output showing failed evidence, most likely cause, and a suggested recovery command

(week-03-linux-for-devops\screenshots\A6 Screenshot 14 failed evidence.PNG)

---

#### Screenshot 15 — `incident-failure-report.txt` showing the failed checks and your Full Name

(week-03-linux-for-devops\screenshots\A6 Screenshot 15 Incide Failure report txt.PNG)

---

### Notes

Answer the following in your own words:

**1. Which three checks failed?**

The three failed checks were the Nginx service status, the Port 80 listening check and the local HTTP response check.

---

**2. What evidence supports the conclusion that Nginx is unavailable?**

The evidence showed that the Nginx service was inactive, Port 80 was no longer listening and the HTTP request to http://localhost failed. These results confirmed that Nginx was unavailable.

---

**3. Did Claude execute the recovery command? Why is that important?**

No. Claude only recommended the recovery command and did not execute it. This is important because changes to a server should remain under human control to prevent accidental or unsafe actions.

---

**4. Which phase of the Agentic Loop is represented by the Bash report?**

The Bash report represents the Gather phase because it collects health information and system evidence from the server.

---

**5. Which phase is represented by Claude's explanation?**

Claude's explanation represents the Analyze phase because it interprets the evidence collected by the Bash script and explains the likely cause of the problem.

---

# Task 8 — Recover Manually, Verify Again, and Write the Incident Summary

## Goal

Recover the service as the human operator and prove that the system is healthy again.

### Evidence

#### Screenshot 16 — Output showing Nginx is active and `curl -I http://localhost` returns 200 OK

(week-03-linux-for-devops\screenshots\A6 Screenshot 16 Output showing Nginx is active after remediation.PNG)

---

#### Screenshot 17 — Second `/linux-triage` output showing successful recovery with no FAIL results

(week-03-linux-for-devops\screenshots\A6 Screenshot 17 — Second linux-triage output showing successful recovery.PNG)

---

#### Screenshot 18 — Output of `ls -lah reports` showing both `incident-failure-report.txt` and `recovery-report.txt`

(week-03-linux-for-devops\screenshots\A6 Screenshot 18 — Output of ls -lah reports.PNG)

---

#### Screenshot 19 — `incident-summary.md` showing all required sections and your Full Name

(week-03-linux-for-devops\screenshots\A6 Screenshot 19 — incident-summary.md)

---

### Notes

Answer the following in your own words:

**1. What action did you execute manually?**

I manually restarted the Nginx service using sudo systemctl start nginx after reviewing the evidence and Claude's recommendation.

---

**2. What evidence proves that the service recovered?**

The Nginx service became active again, curl -I http://localhost returned HTTP 200 OK, and the second triage report showed all health checks passing with no failures.

---

**3. Why is the second triage run necessary?**

The second triage run confirms that the recovery action was successful and verifies that the server has returned to a healthy state.

---

**4. What could go wrong if an AI agent automatically restarted every failed service?**

An AI agent could restart the wrong service, interrupt running applications, hide the real cause of an issue or create additional problems without human approval. Human oversight helps ensure that recovery actions are safe and appropriate.

---

**5. In one sentence, explain the difference between using AI as a chatbot and using AI in this agentic workflow.**

A chatbot mainly answers questions, while an agentic AI workflow gathers evidence, analyses the results, follows defined safety rules and supports the human in making operational decisions.

---

# Incident Summary

Fill in all seven sections below in your own words.

**Full Name:** Michael Okanlawon

**Date:** 17/07/2026

---

**1. Reported Symptom**

The React application became unavailable because the Nginx service was stopped during the incident simulation.

---

**2. Evidence Collected**

The Bash triage report showed that the Nginx service was inactive, Port 80 was not listening and the HTTP request to localhost failed. Disk usage and available memory remained healthy.

---

**3. Most Likely Cause**

The Nginx service was stopped, preventing the web server from serving the React application.

---

**4. Human-Approved Recovery Action**

I manually restarted the Nginx service using:
sudo systemctl start nginx

---

**5. Verification**

After restarting Nginx, the service became active, the HTTP request returned **200 OK**, and the second triage report showed all checks passing with an overall HEALTHY status.

---

**6. Safety Decision**

Claude only analysed the evidence and suggested the recovery command. The recovery action was performed manually to maintain human control over changes to the server.

---

**7. Agentic Loop Mapping**

Gather: Bash script collected Linux and Nginx health information.

Analyze: Claude interpreted the Bash report and identified the likely cause.

Human Act: I manually restarted the Nginx service.

Verify: I reran the health checks and confirmed that the server returned to a healthy state.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/michael-okanlawon_devops-linux-aws-activity-7483906002413719552-tFYV?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC9A9-IBmPTPhzYSqhRaCI1i6ENsTRA8KEw`

---

#### Screenshot — Published LinkedIn post

(week-03-linux-for-devops\screenshots\Week 3 Assignment 6 linkedln screenshot.PNG)

---

# GitHub Repository URL

Paste the URL of your GitHub folder or repository containing the assignment files here:

`_____`

---

# Submission Instructions

- Add all required screenshots in your submission
- Full Name must be visible in required screenshots and the Bash report
- All written answers must be in your own words
- Do not expose sensitive information (keys, passwords, AWS account IDs, tokens)
- GitHub URL must be included in this document

---

# Completion Checklist

- [ ] Task 1: Healthy baseline confirmed, workspace created (Screenshots 1–2, Notes answered)
- [ ] Task 2: CLAUDE.md created with all four sections (Screenshot 3, Notes answered)
- [ ] Task 3: Five-check plan produced by Claude using read-only tools (Screenshot 4, Notes answered)
- [ ] Task 4: `linux-triage.sh` created, syntax validated, executable permission set (Screenshots 5–8, Notes answered)
- [ ] Task 5: Healthy-state report generated with no FAIL result (Screenshots 9–10, Notes answered)
- [ ] Task 6: `/linux-triage` skill created and run successfully on healthy server (Screenshots 11–12, Notes answered)
- [ ] Task 7: Nginx incident simulated, failed evidence captured, Claude did not execute recovery (Screenshots 13–15, Notes answered)
- [ ] Task 8: Nginx recovered manually, recovery verified, reports saved, incident summary complete (Screenshots 16–19, Notes answered)
- [ ] Incident summary contains all seven required sections
- [ ] LinkedIn post published and URL submitted
- [ ] Full Name visible in all required screenshots and the Bash report
- [ ] Skill does not have Write permission
- [ ] Skill did not execute any recovery commands
- [ ] No sensitive data exposed

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