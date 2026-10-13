# Assignment 4 — Docker Volumes

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will learn how Docker Volumes and Bind Mounts provide persistent storage for containers, deploying applications that retain logs and data even after containers are stopped or removed.

---

# Task 1 — Deploy a Standalone Application with Persistent Logs Using Bind Mounts

## Goal

Run an Nginx container (`myweb`) with a Bind Mount from `~/nginx-logs` to `/var/log/nginx`, verify the site loads, confirm logs are written, remove the container, and confirm the logs persist on the host.

### Evidence

#### Screenshot 1 — Output of `docker images`

![alt text](screenshots/Wk11-A4-SS1-docker-images.PNG)

---

#### Screenshot 2 — Output of `docker search nginx`

![alt text](screenshots/Wk11-A4-SS2-docker-search-nginx.PNG)

---

#### Screenshot 3 — Successful `docker pull nginx` (if applicable)

![alt text](screenshots/Wk11-A4-SS3-Docker-pull-nginx.PNG)

---

#### Screenshot 4 — Creation of the `~/nginx-logs` directory

![alt text](screenshots/Wk11-A4-SS4-Creation-of-nginx-logs.PNG)

---

#### Screenshot 5 — Output of `docker run` with the Bind Mount

![alt text](screenshots/Wk11-A4-SS5-Docker-run.PNG)

---

#### Screenshot 6 — Output of `docker ps` showing the running `myweb` container

![alt text](screenshots/Wk11-A4-SS6-Docker-PS.PNG)

---

#### Screenshot 7 — Browser displaying the Nginx Welcome Page

![alt text](screenshots/Wk11-A4-SS7-Browser-showing-nginx-welcome-page.PNG)

---

#### Screenshot 8 — Output of `ls ~/nginx-logs` showing `access.log` and `error.log`

![alt text](screenshots/Wk11-A4-SS8-ngix-logs.PNG)

---

#### Screenshot 9 — Successful removal of the container

![alt text](screenshots/Wk11-A4-SS9-Removal-of-container.PNG)

---

#### Screenshot 10 — Output of `ls ~/nginx-logs` confirming the log files remain after the container has been removed

![alt text](screenshots/Wk11-A4-SS10-ls-nginx-log-showing-removed-container.PNG)

---

# Task 2 — Deploy Two Containers with Persistent Data Using Docker Volumes

## Goal

Create a custom network `mynetwork` and a Docker volume `shared-data`, build and run a `backend` container that writes to the shared volume and a `frontend` container that reads from it, and confirm updates are reflected immediately.

### Evidence

#### Screenshot 1 — Project folder structure

![alt text](screenshots/Wk11-A4-SS11-Project-folder-structure.PNG)

---

#### Screenshot 2 — Output of `docker network create mynetwork`

![alt text](screenshots/Wk11-A4-SS12-docker-create-mynetwork.PNG)

---

#### Screenshot 3 — Output of `docker volume create shared-data`

![alt text](screenshots/Wk11-A4-SS13-docker-create-shared-data.PNG)

---

#### Screenshot 4 — Backend Dockerfile

![alt text](screenshots/Wk11-A4-SS14-backend-dockerfile.PNG)

---

#### Screenshot 5 — Successful backend image build

![alt text](screenshots/Wk11-A4-SS15-Backend-image-build.PNG)

---

#### Screenshot 6 — Frontend Dockerfile

![alt text](screenshots/Wk11-A4-SS16-frontend-dockerfile.PNG)

---

#### Screenshot 7 — Successful frontend image build

![alt text](screenshots/Wk11-A4-SS17-frontend-image-build.PNG)

---

#### Screenshot 8 — Output of `docker ps` showing both containers

![alt text](screenshots/Wk11-A4-SS18-docker-ps-showing-both-containers.PNG)

---

#### Screenshot 9 — Successful execution of `docker exec backend curl http://localhost/write`

![alt text](screenshots/Wk11-A4-SS19-backend-curl.PNG)

---

#### Screenshot 10 — Browser displaying "Hello from Backend!"

![alt text](screenshots/Wk11-A4-SS20-browser-showing-backend-welcome.PNG)

---

#### Screenshot 11 — Browser displaying "Test Data 1" after the first update

![alt text](screenshots/Wk11-A4-SS21-browser-showing-test-1.PNG)

---

#### Screenshot 12 — Browser displaying "Test Data 2 - New Update" after the second update

![alt text](screenshots/Wk11-A4-SS22-browser-showing-test-2.PNG)

---

# LinkedIn Post (Optional)

## Goal

Create a LinkedIn post covering the assignment, Docker Hub repository, steps performed, and key learning outcomes.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/michael-okanlawon_docker-devops-azure-share-7515669975328587776-ywJ0/?highlightedUpdateUrn=urn%3Ali%3Aactivity%3A7515669976997920768&highlightedUpdateType=SOCIAL_SHARE&origin=SOCIAL_SHARE&utm_source=share&utm_medium=member_desktop&rcm=ACoAAC9A9-IBmPTPhzYSqhRaCI1i6ENsTRA8KEw`

---

#### Screenshot — Published LinkedIn post

![alt text](screenshots/Wk11-A4-SS-linkedin-post.PNG)

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information

---

# Completion Checklist

- [ ] Task 1: Bind-mounted persistent logs verified before and after container removal (Screenshots 1–10)
- [ ] Task 2: Docker volume shared between frontend and backend verified (Screenshots 1–12)
- [ ] No sensitive information exposed

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
