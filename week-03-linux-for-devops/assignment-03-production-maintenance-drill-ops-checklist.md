# Assignment 3 — Production Maintenance Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will treat your already deployed React application (on Ubuntu VM with Nginx) as a live production system. You will perform structured operational checks covering network validation, service health, log analysis, resource monitoring, configuration verification, and incident simulation with recovery — mirroring real on-call DevOps responsibilities.

---

# Task 1 — Server Access & Networking Validation

## Goal

Verify that the deployed React application is reachable from the browser and confirm basic network connectivity of the Ubuntu VM.

### Evidence

#### Screenshot 1 — Browser showing the React app with your Full Name visible on the UI

(week-03-linux-for-devops\screenshots\A3 Screenshot 1.PNG)

---

#### Screenshot 2 — Output of `ip a`

(week-03-linux-for-devops\screenshots\A3 screenshot 2 output ip a.PNG)

---

#### Screenshot 3 — Output of `sudo ss -tulpen`

(week-03-linux-for-devops\screenshots\A3 screenshot 3 sudo ss -tulpen.PNG)

---

#### Screenshot 4 — Output of `sudo ufw status`

(week-03-linux-for-devops\screenshots\A3 screenshot 4 sudo ufw status.PNG)

---

### Notes

Answer the following in your own words:

**1. What proves Nginx is listening on 0.0.0.0:80?**

Nginx was running and I was able to access my React application from the browser using the VM's public IP. I also confirmed that Nginx was listening on port 80, which means it was accepting HTTP requests from any network interface.

---

**2. What proves SSH is active on port 22?**

I was able to connect to the Ubuntu VM using SSH with my .pem key. This confirmed that the SSH service was running and listening on port 22.

---

**3. Did you find any unexpected open ports? Explain briefly.**

No. I did not find any unexpected open ports. The public access was limited to port 22 for SSH and port 80 for HTTP. Although there was an "All traffic" rule, it only allowed communication from the default security group and was not exposed to the public internet.

---

# Task 2 — Service Health & Systemd Validation (Nginx)

## Goal

Verify that Nginx is properly installed, running, enabled at boot, and safely configured.

### Evidence

#### Screenshot 1 — Output of `systemctl status nginx --no-pager`

(week-03-linux-for-devops\screenshots\A3 screenshot 5systemctl status nginx --no-pager.PNG)

---

#### Screenshot 2 — Output of `sudo nginx -t`

(week-03-linux-for-devops\screenshots\A3 screenshot 6 sudo nginx -t.PNG)

---

#### Screenshot 3 — Output of `sudo ss -lptn '( sport = :80 )'`

(week-03-linux-for-devops\screenshots\A3 screenshot 7 sudo ss -lptn sport = 80.PNG)

---

### Notes

Answer the following in your own words:

**1. What happens if Nginx fails to restart in production?**

If Nginx fails to restart in production, the application will become unavailable and users will not be able to access the website. The issue should be investigated by checking the Nginx configuration and logs, fixing the root cause, and restarting the service to restore access.

---

**2. What's your basic rollback plan?**

If a change causes Nginx to fail, I will revert the last configuration or deployment to the previous working version, test the configuration with sudo nginx -t, then restart Nginx and confirm the application is accessible again.

---

# Task 3 — Logs & Request Trace

## Goal

Verify real traffic flow and analyze logs to understand system behavior and errors.

### Evidence

#### Screenshot 1 — Output of `sudo tail -n 30 /var/log/nginx/access.log`

(week-03-linux-for-devops\screenshots\A3 screenshot 8 sudo tail -n 30 var-log-nginx-access.log)

---

#### Screenshot 2 — Output of `sudo tail -n 30 /var/log/nginx/error.log`

(week-03-linux-for-devops\screenshots\A3 screenshot 9 sudo tail -n 30 var-log-nginx-error.log)

---

#### Screenshot 3 — Output of `sudo journalctl -u nginx --no-pager -n 50`

(week-03-linux-for-devops\screenshots\A3 10 screenshot sudo journalctl -u nginx --no-pager -n 50.PNG)

---

### Notes

Answer the following in your own words:

**1. Were there any errors in the logs?**

- If yes, mention 1–2 example error lines from the logs and explain what each one means in simple terms.
- If no, explain what it means if the error log is empty or shows no recent errors during your check.

No. There were no actual errors in the Nginx error log during my check.

The only entry was:

2026/07/12 17:07:03 [notice] 24575#24575: using inherited sockets from "5;6;"

This is a notice, not an error. It simply means Nginx reused existing sockets while starting or restarting the service. This is normal behaviour and shows that Nginx restarted successfully.

Since there were no recent error messages in the error log, it indicates that Nginx was running without any problems at the time I checked.

---

**2. If there were no errors, what does that indicate about the system?**

It indicates that the Nginx server was running normally during my check. There were no issues with the service starting, restarting, or handling requests. This shows that the web server was stable and working as expected.

---

**3. Based on the access logs, were your curl requests visible in the log entries? What does that prove about traffic flow?**

I did not see my own curl requests in the last 30 log entries. Most of the requests shown were from bots and internet scanners.

Even so, the access log confirms that Nginx was receiving requests and returning different HTTP status codes like 200, 302, 400, and 405. This proves that traffic was reaching the server, Nginx was processing the requests, and it was responding correctly.

---

# Task 4 — System Resource Health Check (Capacity Red Flags)

## Goal

Assess server capacity and detect potential performance or failure risks.

### Evidence

#### Screenshot 1 — Output of `uptime`

(week-03-linux-for-devops\screenshots\A3 screenshot 11 uptime.PNG)

---

#### Screenshot 2 — Output of `free -h`

(week-03-linux-for-devops\screenshots\A3 screenshot 12 free -h.PNG)

---

#### Screenshot 3 — Output of `df -h`

(week-03-linux-for-devops\screenshots\A3 screenshot 12 free -h.PNG)

---

#### Screenshot 4 — Output of `sudo du -sh /var/* | sort -h`

(week-03-linux-for-devops\screenshots\A3 screenshot 14 sudo du -sh var  sort -h.PNG)

---

### Notes

Answer the following in your own words:

**1. Which resource looks most critical right now? (CPU/load, memory, or disk) Explain why.**

The disk looks like the most critical resource. It is already 62% used, while the CPU load is 0.00 and there is still about 585 MB of available memory. The server is not under heavy load at the moment, but the disk usage should be monitored so it does not get too high.

---

**2. What happens if disk becomes 100% full in a production server?**

If the disk becomes 100% full, the server will start having issues. Applications may not be able to save data, logs will stop writing, and some services may fail to start or crash. This can make the website or application unavailable to users, so it is important to keep enough free disk space at all times.

---

# Task 5 — Configuration & Deployment Verification

## Goal

Ensure the correct React build is deployed and Nginx is serving it properly.

### Evidence

#### Screenshot 1 — Output of `ls -lah /var/www/html | head -n 20`

(week-03-linux-for-devops\screenshots\A3 screenshot 15 ls -lah var www html head -n 20.PNG)

---

#### Screenshot 2 — Output of `grep -R "Deployed by" -n /var/www/html 2>/dev/null | head`

(week-03-linux-for-devops\screenshots\A3 screenshot 16 grep -R Deployed by -n var www html 2 dev null head.PNG)

---

#### Screenshot 3 — Output of `grep -n "try_files" /etc/nginx/sites-available/default`

(week-03-linux-for-devops\screenshots\A3 screenshot 17 grep -n try-files etc-nginx-sites-available-default.PNG)

---

### Notes

Answer the following in your own words:

**1. How do you confirm that the correct version of the application is deployed?**

I confirmed it by checking the contents of /var/www/html and verifying that the React build files (index.html, asset-manifest.json, static/, etc.) were present with the expected deployment timestamp. I also used grep to verify the deployment marker and checked the Nginx configuration to confirm that the try_files $uri /index.html; rule is configured, which ensures the deployed React application is being served correctly.

---

# Task 6 — Nginx Configuration Failure Simulation

## Goal

Simulate a real-world Nginx misconfiguration and recover the service safely.

### Evidence

#### Screenshot 1 — Output of `sudo nginx -t` showing the syntax error (broken config)

(week-03-linux-for-devops\screenshots\A3 screenshot 18 sudo nginx -t error.PNG)

---

#### Screenshot 2 — Output of `sudo nginx -t` showing syntax ok (fixed config)

(week-03-linux-for-devops\screenshots\A3 screenshot 19 sudo nginx -t fixed.PNG)

---

#### Screenshot 3 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

(week-03-linux-for-devops\screenshots\A3 screenshot 20 curl -I http 16 171 58 175.PNG)

---

### Notes

Answer the following in your own words:

**1. What caused the configuration failure?**

The configuration failed because of a syntax error in the Nginx configuration file. I intentionally removed the semicolon after the index index.html directive, so Nginx could not parse the configuration correctly.

---

**2. How did you fix the issue?**

I edited the configuration file and added the missing semicolon back. After that, I ran sudo nginx -t to confirm the syntax was valid, then reloaded Nginx and verified the application was accessible with a 200 OK response.

---

**3. How can you avoid this kind of issue in real production systems?**

Always test the configuration with sudo nginx -t before reloading or restarting Nginx. Also, review configuration changes carefully, keep backups of working configurations, and test changes in a staging environment before deploying them to production.

---

# Task 7 — Web Application Failure Simulation

## Goal

Simulate missing deployment content and recover the application safely.

### Evidence

#### Screenshot 1 — Output of `curl -I http://<public-ip>` showing failure (non-200 response)

(week-03-linux-for-devops\screenshots\A3 screenshot 21 curl -I http 16 171 58 175 error.PNG)

---

#### Screenshot 2 — Output of `curl -I http://<public-ip>` confirming recovery (200 OK)

(week-03-linux-for-devops\screenshots\A3 screenshot 22 curl -I http 16 171 58 175.PNG)

---

### Notes

Answer the following in your own words:

**1. What caused the application to break in this scenario?**

The application broke because the deployed React files were no longer available in the web root. As a result, Nginx could not find the application files it needed to serve requests and returned a 500 Internal Server Error instead of a successful response.

---

**2. How did you fix the issue and restore the application?**

I restored the original application files by moving the backup folder back to /var/www/html. After confirming the files were in place, I tested the application with curl and verified it was responding with HTTP 200 OK again.

---

**3. What steps would you take to prevent this kind of issue in real production systems?**

Always keep a backup of the current deployment, use a deployment process that supports rollback, verify that all application files are deployed successfully before switching traffic, and perform a health check after deployment to confirm the application is working as expected.

---

# Task 8 — Security & Reliability Review

## Goal

Review and reflect on the security and reliability practices applied during this assignment.

### Security & Reliability Notes

Answer the following in your own words:

**1. Why is SSH key-based authentication more secure than sharing passwords?**

SSH key-based authentication is more secure because it uses a pair of cryptographic keys instead of a password that can be guessed or stolen. The private key stays on the user's device, making it much harder for attackers to gain access.

---

**2. Why should only required ports be open on a production server?**

Only the ports required by the application should be open to reduce the server's attack surface. This also follows the principle of least privilege, where only the minimum access needed is allowed. Closing unnecessary ports helps prevent unauthorized access and reduces the risk of security attacks.

---

**3. Why is it important for Nginx to be enabled on boot?**

Enabling Nginx on boot ensures the web server starts automatically whenever the server restarts. This helps keep the application available without requiring manual intervention.

---

**4. What are the risks of sharing secrets, keys, or credentials publicly?**

If secrets, SSH keys, or credentials are exposed, attackers can use them to access servers, steal data, modify applications, or misuse cloud resources. This can lead to security breaches, downtime, and unexpected costs.

---

**5. Why should cloud resources be stopped or terminated when they are no longer needed?**

Stopping or terminating unused cloud resources helps reduce unnecessary costs and limits security risks. It also prevents idle resources from being forgotten and potentially misused.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://lnkd.in/p/e8NYySb3`

---

#### Screenshot — Published LinkedIn post

(week-03-linux-for-devops\screenshots\Week 3 assignment 3 LinkedIn screenshot.PNG)

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [ ] Task 1: Screenshots (browser, ip a, ss -tulpen, ufw status) + Notes answered
- [ ] Task 2: Screenshots (nginx status, nginx -t, ss port 80) + Notes answered
- [ ] Task 3: Screenshots (access log, error log, journalctl) + Notes answered
- [ ] Task 4: Screenshots (uptime, free -h, df -h, du -sh) + Notes answered
- [ ] Task 5: Screenshots (ls html, grep deployed by, grep try_files) + Notes answered
- [ ] Task 6: Screenshots (nginx -t fail, nginx -t pass, curl recovery) + Notes answered
- [ ] Task 7: Screenshots (curl failure, curl recovery) + Notes answered
- [ ] Task 8: Security & Reliability Notes answered
- [ ] LinkedIn post published and URL submitted
- [ ] Full Name visible in all required screenshots
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