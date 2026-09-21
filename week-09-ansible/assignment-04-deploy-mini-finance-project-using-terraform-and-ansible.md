# Assignment 4 — Deploy Mini Finance Project Using Terraform and Ansible

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will provision an Azure VM with Terraform and use Ansible to automate the install, deploy, and verify workflow for the Mini Finance static website — a clean separation between infrastructure and configuration management.

---

# Task 1 — Set Up Folder Layout

## Goal

Create the `mini-finance` project with separate `terraform/` and `ansible/` subdirectories.

### Evidence

#### Screenshot 1 — Terminal or editor showing the complete `mini-finance` project tree

![alt text](screenshots/Wk9-A4-SS1-Tree.PNG)

---

# Task 2 — Terraform — Azure VM + NSG (Ports 22/80)

## Goal

Provision an Ubuntu 22.04 Standard_B1s VM with a public IP, SSH key authentication, and an NSG allowing SSH (22) and HTTP (80), and output the public IP.

### Evidence

#### Screenshot 2 — Terminal showing the end of a successful `terraform apply`

![alt text](screenshots/Wk9-A4-SS2-Terraform-Apply.PNG)

---

#### Screenshot 3 — Terminal showing `terraform output public_ip`

![](screenshots/Wk9-A4-SS3-Output-of-public-IP.PNG)

---

#### Screenshot 4 — Terraform code or Azure Portal showing NSG inbound rules for ports 22 and 80

![alt text](screenshots/Wk9-A4-SS4-NSG-Ports-22-and-80.PNG)

---

# Task 3 — Configure Passwordless SSH

## Goal

Connect to the VM with SSH using the injected key and run `hostname` remotely without a password prompt.

### Evidence

#### Screenshot 5 — Terminal showing the successful passwordless SSH hostname check

![alt text](screenshots/Wk9-A4-SS5-Passwordless-SSH-Hostname-Check.PNG)

---

# Task 4 — Ansible — Multi-Play: Install → Deploy → Verify

## Goal

Create `ansible/inventory.ini` and a three-play `site.yml` that installs Nginx and Git, clones and deploys the Mini Finance repository to `/var/www/html/` with a reload handler, and verifies HTTP 200 from `localhost`.

### Evidence

#### Screenshot 6 — Editor showing `inventory.ini` and the three plays in `site.yml`

![alt text](screenshots/Wk9-A4-SS6-Editor-showing-inventory-and-site-ini.PNG)

---

#### Screenshot 7 — Terminal showing `ansible-playbook -i inventory.ini site.yml` with HTTP 200, assertion OK, and no failures

![alt text](screenshots/Wk9-A4-SS7-HTTP-200_OK.PNG)

---

# Task 5 — Test End-to-End Functionality

## Goal

Confirm the Mini Finance site is publicly accessible and correctly served by Nginx.

### Evidence

#### Screenshot 8 — Browser showing the Mini Finance site loaded from `http://<public_ip>` with the URL visible

![alt text](screenshots/Wk9-A4-SS8-Public-IP-Opened-via-Browser.PNG)

---

### Notes

Describe an issue you faced and how you fixed it, and what you learned.

I faced an intermittent SSH connectivity issue between Ansible and the Azure VM. My ISP changed my public IP, so the NSG rule no longer allowed traffic from my laptop. Even after updating the rule, some connections timed out because of unstable routing. I fixed this by updating the SSH rule with my current IP range and configuring Ansible to retry failed connections and keep successful sessions alive. After that, Ansible connected successfully, installed Nginx and Git, deployed the Mini Finance website, and verified an HTTP 200 response.

I learned how Terraform and Ansible complement each other in a real deployment. Terraform created the Azure infrastructure and security rules, while Ansible handled the server configuration, application deployment, and verification. I also learned the importance of checking each layer separately when troubleshooting: the VM status, NSG rules, SSH service, direct SSH connection, and finally Ansible connectivity.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the Terraform + Ansible deployment, mentioning the Azure VM, secure networking, passwordless SSH, Nginx deployment, and HTTP verification, with one challenge you faced and how you fixed it, and one real-world example of this workflow.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/michael-okanlawon_devops-terraform-ansible-share-7507729233666801664-sDCq/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC9A9-IBmPTPhzYSqhRaCI1i6ENsTRA8KEw`

---

#### Screenshot — Published LinkedIn post showing the text and at least one image or proof

![alt text](screenshots/Wk9-A4-SS-Linkedin-Post.PNG)

---

# Submission Instructions

- Add all required screenshots in your submission
- The `mini-finance` project tree and `inventory.ini` may have the final IP octet masked
- Do not expose private keys or other secrets

---

# Completion Checklist

- [ ] Task 1: `mini-finance` project structure created (Screenshot 1)
- [ ] Task 2: Azure VM and NSG provisioned with Terraform (Screenshots 2–4)
- [ ] Task 3: Passwordless SSH verified (Screenshot 5)
- [ ] Task 4: Ansible install/deploy/verify plays run successfully (Screenshots 6–7)
- [ ] Task 5: Site verified in the browser (Screenshot 8)
- [ ] Reflection notes written (Notes)
- [ ] LinkedIn post published and URL submitted
- [ ] No sensitive data exposed

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
