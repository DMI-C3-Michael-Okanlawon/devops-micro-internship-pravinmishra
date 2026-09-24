# Assignment 2 — Deploy Mini Finance Project via Azure DevOps Pipeline

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build an Azure DevOps CI/CD pipeline that deploys the Mini Finance static website to an Ubuntu VM running Nginx: importing the repo into Azure Repos, provisioning the VM with Terraform and Ansible, connecting via an SSH Service Connection, and deploying on every commit to `main`.

---

# Task 1 — Import the Repository

## Goal

Import `https://github.com/pravinmishraaws/Azure-Static-Website` into Azure Repos and confirm `index.html` is present.

### Evidence

#### Screenshot 1 — Azure Repos showing the imported repository files with `index.html` visible

![alt text](screenshots/Wk10-A2-SS1-Imported-Repo-Showing-Index-html.PNG)

---

# Task 2 — Prepare the Target VM

## Goal

Provision a Linux VM with Terraform (ports 22/80 open), then use Ansible to install and start Nginx and prepare `/var/www/html`.

### Evidence

#### Screenshot 2 — Terraform output or cloud console showing the running VM and public IP

![alt text](screenshots/Wk10-A2-SS2-Cloud-Shell-Showing-running-VM.PNG)

---

#### Screenshot 3 — Terminal showing Ansible completed successfully and Nginx is active

![alt text](screenshots/Wk10-A2-SS3-Nginx-running.PNG)

---

# Task 3 — Create an SSH Service Connection

## Goal

Create the password-based SSH Service Connection `ubuntu-nginx-ssh` pointing to the VM, and validate it.

### Evidence

#### Screenshot 4 — SSH Service Connection configuration page showing the connection details and successful validation, with the password hidden

![alt text](screenshots/Wk10-A2-SS4-Connection-details.PNG)

---

# Task 4 — Author the YAML Pipeline

## Goal

Write a pipeline triggered on `main` that checks out the repo, copies files to `/var/www/html` via `CopyFilesOverSSH@0`, and verifies the deployment directory via an `SSH@0` task, using `ubuntu-nginx-ssh` and the self-hosted (or available Microsoft-hosted) pool.

### Evidence

#### Screenshot 5 — Pipeline YAML definition open in the Azure DevOps editor

![alt text](screenshots/Wk10-A2-SS5-Pipeline-YAML-Showing-in-Azure-DevOps-Editor.PNG)

---

# Task 5 — Verify Deployment

## Goal

Confirm the pipeline run succeeded (checkout, SSH connection, file transfer, remote verification) and the Mini Finance website is live at the VM's public IP.

### Evidence

#### Screenshot 6 — Successful Azure DevOps pipeline run log summary

![alt text](screenshots/Wk10-A2-SS6-Log-summary.PNG)

---

#### Screenshot 7 — Browser showing the deployed website with the VM public IP visible

![alt text](screenshots/Wk10-A2-SS7-Browser-showing-website.PNG)

---

### Notes

Include the VM public URL. Describe any issue you faced and how you fixed it (e.g. parallelism/agent-pool issues).

VM public URL: http://168.62.42.41/
Issue and fix: My Azure Cloud Shell session was ephemeral, so the SSH key from an earlier session was unavailable. I generated a new SSH key, added its public key to the VM with az vm user update, and updated the VM’s network security rule to allow SSH from the required source addresses. I then configured Nginx and the deployer account, connected the pipeline through the ubuntu-nginx-ssh service connection, and ran it on the online agent in SelfHostedPool. The checkout, file copy, and remote verification steps all succeeded.

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not commit the VM password to the repository or write it directly in YAML

---

# Completion Checklist

- [ ] Task 1: Repository imported into Azure Repos (Screenshot 1)
- [ ] Task 2: VM provisioned and Nginx configured (Screenshots 2–3)
- [ ] Task 3: SSH Service Connection created and validated (Screenshot 4)
- [ ] Task 4: YAML pipeline authored (Screenshot 5)
- [ ] Task 5: Pipeline run succeeded and site verified (Screenshots 6–7)
- [ ] VM URL and issue notes written (Notes)
- [ ] No passwords, tokens, or credentials exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
