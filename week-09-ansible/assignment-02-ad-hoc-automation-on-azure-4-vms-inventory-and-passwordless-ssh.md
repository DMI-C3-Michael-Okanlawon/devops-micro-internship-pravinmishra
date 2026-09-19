# Assignment 2 — Ad-Hoc Automation on Azure: 4 VMs, Inventory & Passwordless SSH

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will provision four Azure Linux VMs with Terraform, configure passwordless SSH, build a custom Ansible inventory with web/app/db groups, and run ad-hoc commands across individual hosts and groups.

---

# Task 1 — Provision 4 Azure VMs (Terraform)

## Goal

Provision four Ubuntu 22.04 VMs (`web1`, `web2`, `app1`, `db1`, Standard_B1s) with SSH key authentication and public IPs, in a VNet with an NSG allowing SSH (22) and HTTP (80), and output all four public IPs.

### Evidence

#### Screenshot 1 — Terminal showing successful `terraform apply` output and `terraform output public_ips`

![alt text](screenshots/Wk9-A2-SS1-Terraform-apply-and-output-public-IPs.PNG)

---

#### Screenshot 2 — Azure Portal showing all four running Ubuntu VMs

![alt text](screenshots/Wk9-A2-SS2-Azure-Portal-Showing-Running-Instances.PNG)

---

#### Screenshot 3 — Network Security Group inbound rules showing SSH 22 and HTTP 80

![alt text](screenshots/Wk9-A2-SS3-Port-80-and-22-opened.PNG)

---

# Task 2 — Configure Passwordless SSH

## Goal

Connect to each of the four VMs as `azureuser` and run `hostname` remotely without a password prompt.

### Evidence

#### Screenshot 4 — Terminal showing successful `hostname` output from all four passwordless SSH tests

![alt text](screenshots/Wk9-A2-SS4-Passwordless-SSH-to-the-four-EC2-Instances.PNG)

---

# Task 3 — Create a Custom Ansible Inventory

## Goal

Create `inventory.ini` mapping VM indices 0–1 to `[web]`, index 2 to `[app]`, and index 3 to `[db]`, with `ansible_user` and `ansible_ssh_private_key_file` set under `[all:vars]`.

### Evidence

#### Screenshot 5 — Editor or terminal showing `inventory.ini` with the web, app, db, and all:vars sections

![alt text](screenshots/Wk9-A2-SS5-Ansible-Inventory-Ini.PNG)

---

# Task 4 — Run Your First Ansible Ad-Hoc Commands

## Goal

Run `ping`, `whoami`, and `uptime` against all hosts; install and start Nginx on the `web` group with `--become`; install `htop` on all hosts; and run `df -h` on `db` and `free -m` on all hosts.

### Evidence

#### Screenshot 6 — Terminal showing `ansible ping` SUCCESS for all four hosts

![alt text](screenshots/Wk9-A2-SS6-Ansible-built-in-ping.PNG)

---

#### Screenshot 7 — Terminal showing `uptime` output for all four hosts

![alt text](screenshots/Wk9-A2-SS7-Ansible-Uptime-all-Hosts.PNG)

---

#### Screenshot 8 — Terminal showing Nginx installation and service start on the web group

![alt text](screenshots/Wk9-A2-SS8-Nginx-Web-Active.PNG)

---

#### Screenshot 9 — Terminal showing `htop` installation on all hosts and group-targeted command output

![alt text](screenshots/Wk9-A2-SS9-Htop-installation-and-target-groups.PNG)

---

### Notes

Describe an issue you faced and how you fixed it, what you learned, when you'd use an ad-hoc command instead of a playbook, and one challenge you faced during SSH or inventory setup.

One major issue I faced was Azure rejecting the local Terraform deployment because the subscription required MFA for resource-management operations. I moved the deployment to Azure Cloud Shell, where the MFA session was accepted. The first Cloud Shell deployment created only the resource group before the subscription temporarily became read-only. I preserved the Terraform state, confirmed the subscription was enabled again, reviewed a fresh plan and successfully created the remaining 16 resources.

I learned how Terraform state supports recovery after a partial deployment, how Ansible inventory groups allow the same command to target selected servers, and how passwordless SSH enables Ansible to manage several machines from one control node.

I would use an ad-hoc command for quick, one-time tasks such as checking uptime, testing connectivity, installing a troubleshooting tool or confirming service status. I would use a playbook for repeatable deployments, multi-step configurations and changes that need to be maintained in version control.

One SSH challenge was that my ISP changes my public IP frequently. Restricting port 22 to one `/32` address quickly blocked access, while Cloud Shell could only detect its own public IP. For this short-lived lab, I temporarily allowed SSH from any source, kept password authentication disabled and relied strictly on SSH key authentication. I also verified the inventory structure with `ansible-inventory --graph` and tested all four hosts with the Ansible ping module before running administrative commands.


---

# Submission Instructions

- Add all required screenshots in your submission
- Public IP addresses may be redacted
- Do not expose, upload, or commit the SSH private key

---

# Completion Checklist

- [ ] Task 1: Four Azure VMs provisioned with Terraform (Screenshots 1–3)
- [ ] Task 2: Passwordless SSH verified on all four VMs (Screenshot 4)
- [ ] Task 3: `inventory.ini` created with web/app/db groups (Screenshot 5)
- [ ] Task 4: Ad-hoc ping, uptime, Nginx, and htop commands run successfully (Screenshots 6–9)
- [ ] Reflection notes written (Notes)
- [ ] No private key material exposed

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
