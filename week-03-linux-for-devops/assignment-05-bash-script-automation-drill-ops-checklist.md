# Assignment 5 — Bash Script Automation Drill (OPS Checklist)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will practice Bash scripting by building a series of small automation scripts covering environment setup, variables, arrays, loops, file conditionals, if-else logic, and functions. These scripts form the foundation of real-world Linux automation used in DevOps, cloud, and production support environments.

---

# Task 1 — Bash Environment & Workspace Setup

## Goal

Verify that Bash is available on your system and create a clean workspace for this assignment.

### Evidence

#### Screenshot 1 — Output of `echo $SHELL` and `bash --version`

(week-03-linux-for-devops\screenshots\A5 Screenshot 1 — Output of echo SHELL and Bash version.PNG)

---

#### Screenshot 2 — Output of `pwd` and `ls -lah` showing the scripts directory

(week-03-linux-for-devops\screenshots\A5 Screenshot 2 pwd and ls -la for bash scripting.PNG)

---

### Notes

Answer the following in your own words:

**1. What is Bash?**

Bash (Bourne Again Shell) is a command-line interpreter that lets one interact with a Linux system. It also allows writing of scripts to automate repetitive tasks and execute commands in sequence.

---

**2. What is the difference between shell and Bash?**

A shell is a program that lets users communicate with the operating system through commands. Bash is one type of shell, just like Zsh or Fish. In simple terms, Bash is a specific implementation of a shell.

---

**3. Why is it important to confirm the Bash version before writing scripts?**

Checking the Bash version helps ensure that the features and syntax used in the script are supported. This reduces compatibility issues when running the script on different systems.

---

# Task 2 — Your First Bash Script

## Goal

Create your first Bash script, make it executable, and run it from the terminal.

### Evidence

#### Screenshot 1 — Content of `first-script.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 3 content of first bash script.PNG)

---

#### Screenshot 2 — Output of `./first-script.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 4 first-script-sh output.PNG)

---

#### Screenshot 3 — Output of `ls -l first-script.sh` showing executable permission

(week-03-linux-for-devops\screenshots\A5 Screenshot 5 showing execuatable permission.PNG)

---

### Notes

Answer the following in your own words:

**1. What is the purpose of `#!/bin/bash`?**

#!/bin/bash is called a shebang. It tells the operating system to use the Bash interpreter to run the script, ensuring it executes with the correct shell.

---

**2. Why do we use `chmod +x` before running a script?**

chmod +x gives the script execute permission, allowing it to be run as a program instead of just being treated as a text file.

---

**3. What is the difference between running a script using `./script.sh` and `bash script.sh`?**

./script.sh runs the script as an executable, so the script must have execute permission (chmod +x) and will use the interpreter specified in the shebang (#!/bin/bash).
bash script.sh runs the script directly with the Bash interpreter, so it does not require execute permission or rely on the shebang.

---

# Task 3 — Variables: User Information Script

## Goal

Use variables to store and display user-related information.

### Evidence

#### Screenshot 1 — Content of `user-info.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 6 content of user-info-sh.PNG)

---

#### Screenshot 2 — Output of `./user-info.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 7 output of user-info-sh.PNG)

---

### Notes

Answer the following in your own words:

**1. What is a variable in Bash?**

A variable in Bash is a named placeholder used to store data, such as text or numbers, so it can be reused throughout a script without repeating the same value.

---

**2. Why should we avoid spaces around the `=` sign when creating variables?**

Bash requires variable assignments to have no spaces around the = sign. If spaces are added, Bash treats the variable name as a command, which results in a command not found error.

---

**3. How do you access the value stored inside a Bash variable?**

You access the value of a Bash variable by placing a dollar sign ($) before its name. For example, if the variable is full_name, you can display its value using echo $full_name.

---

# Task 4 — Arrays & Loops: Tools Checklist Script

## Goal

Use arrays and loops to print a checklist of tools used in Bash scripting.

### Evidence

#### Screenshot 1 — Content of `tools-checklist.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 8 content tools-checklist-sh.PNG)

---

#### Screenshot 2 — Output of `./tools-checklist.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 9 output of tools-checklist-sh.PNG)

---

### Notes

Answer the following in your own words:

**1. What is an array in Bash?**

An array in Bash is a variable that can store multiple values under a single name. Each value is stored at a different position, called an index.

---

**2. Why are arrays useful in scripts?**

Arrays make it easier to manage and process a group of related values. Instead of creating many separate variables, you can store everything in one array and work with the values using loops.

---

**3. What does `"${tools[@]}"` mean?**

"${tools[@]}" represents all the elements stored in the tools array. It allows the script to access each item in the array, one at a time, while preserving spaces in individual values if there are any.

---

**4. What is the purpose of the `for` loop in this script?**

The **for** loop goes through each item in the array and performs the same action on it. In this script, it is used to display each tool in the checklist one after another.

---

# Task 5 — Loops: Number Counter Script

## Goal

Use loops to repeat a task multiple times.

### Evidence

#### Screenshot 1 — Content of `counter.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 10 content of counter-sh.PNG)

---

#### Screenshot 2 — Output of `./counter.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 11 output of counter-sh.PNG)

---

### Notes

Answer the following in your own words:

**1. What is a loop?**

A loop is a way of repeating the same set of commands multiple times without writing them over again, it continues until a certain condition is met.

---

**2. Why do we use loops in Bash scripting?**

We use loops to automate repetitive tasks. Instead of writing the same command many times, a loop runs it for us, making the script shorter, cleaner, and easier to maintain.

---

**3. How many times did the loop run in your script?**

The loop ran 5 times because it went through the numbers 1, 2, 3, 4, and 5, printing a message for each one.

---

**4. What would you change if you wanted the loop to run 10 times?**

I would change the list of numbers in the for loop to include 1 through 10, or use a range like {1..10} so the loop runs 10 times instead of 5.

---

# Task 6 — Files & Conditionals: File Validation Script

## Goal

Use file checks and conditionals to verify whether files and directories exist.

### Evidence

#### Screenshot 1 — Output of `ls -lah ../test-folder`

(week-03-linux-for-devops\screenshots\A5 Screenshot 12 ls-lah test-folder.PNG)

---

#### Screenshot 2 — Content of `file-check.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 13 content of file-check-sh.PNG)

---

#### Screenshot 3 — Output of `./file-check.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 14 output of file-chech-sh.PNG)

---

### Notes

Answer the following in your own words:

**1. What does `-d` check in Bash?**

-d checks whether a directory exists at the specified path. It returns true if the directory is found.

---

**2. What does `-f` check in Bash?**

-f checks whether a regular file exists at the specified path. It returns true only if the file is found.

---

**3. Why should file and directory paths be stored in variables?**

Storing file and directory paths in variables makes the script easier to read and maintain. If the path changes later, you only need to update it in one place instead of changing it everywhere in the script.

---

**4. What happens if the file does not exist?**

If the file does not exist, the -f check returns false, and the script executes the else block. This allows the script to display a message or take another action instead of failing unexpectedly.

---

# Task 7 — Conditionals: Pass or Retry Script

## Goal

Use if-else conditionals to make decisions based on a variable value.

### Evidence

#### Screenshot 1 — Content of `score-check.sh` with `score=85`

(week-03-linux-for-devops\screenshots\A5 Screenshot 15 content of score-check-sh.PNG)

---

#### Screenshot 2 — Output showing `Result: Pass`

(week-03-linux-for-devops\screenshots\A5 Screenshot 16 output of score-check-sh 85.PNG)

---

#### Screenshot 3 — Content of `score-check.sh` with `score=55`
(week-03-linux-for-devops\screenshots\A5 Screenshot 17 content of score-check-sh 55.PNG)

---

#### Screenshot 4 — Output showing `Result: Retry`

(week-03-linux-for-devops\screenshots\A5 Screenshot 18 output of score-check-sh 55.PNG)

---

### Notes

Answer the following in your own words:

**1. What is the purpose of if-else in Bash?**

The if-else statement allows a Bash script to make decisions. It checks whether a condition is true and runs one set of commands if it is, or a different set if it is not.

---

**2. What does `-ge` mean?**

-ge means greater than or equal to. It is used to compare two numbers and checks whether the first number is greater than or equal to the second.

---

**3. Why should conditions be tested with different values?**

Testing with different values helps confirm that the script behaves correctly in different situations. It ensures both the if and else parts work as we want them to.

---

**4. How can conditionals help in automation scripts?**

Conditionals help a script make decisions automatically based on different situations. For example, a script can check if a file exists, verify a service is running, or decide whether to continue or display an error message based on the result.

---

# Task 8 — Functions: Final Bash Automation Script

## Goal

Create a final Bash script using functions to organize reusable code.

### Evidence

#### Screenshot 1 — Content of `final-automation.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 19 content final-automation.PNG)

---

#### Screenshot 2 — Output of `./final-automation.sh`

(week-03-linux-for-devops\screenshots\A5 Screenshot 20 output final-automation-sh.PNG)

---

#### Screenshot 3 — Output of `ls -lah` showing all created scripts

(week-03-linux-for-devops\screenshots\A5 Screenshot 21 ls-lah showing all scripts created.PNG)

---

### Notes

Answer the following in your own words:

**1. What is a function in Bash?**

A function in Bash is a named block of commands that performs a specific task. Instead of writing the same code multiple times, you can write it once inside a function and call it whenever you need it.

---

**2. Why are functions useful in scripts?**

Functions make scripts easier to read, organize, and maintain. They reduce repetition and allow you to reuse the same code whenever a task needs to be performed.

---

**3. Which functions did you create in this script?**

In my final automation script, I created functions to:

Print the script header and assignment details.
Check whether the required directory exists.
Check whether the required file exists.
Display the Bash tools checklist.
Print the completion message.

---

**4. How does this final script combine variables, arrays, loops, conditionals, files, and functions?**

The script stores important information such as my name, assignment name, and file paths in variables. It uses an array to hold the list of Bash tools and a for loop to print each tool. It uses if-else statements to check whether the required directory and file exist. These tasks are grouped into functions, making the script organized, reusable, and easier to maintain.

---

# LinkedIn Post (Required)

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/michael-okanlawon_devops-linux-bash-activity-7483790929447968768-vMI1?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC9A9-IBmPTPhzYSqhRaCI1i6ENsTRA8KEw`

---

#### Screenshot — Published LinkedIn post

(week-03-linux-for-devops\screenshots\A5 LinkedIn Post.PNG)

---

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- All script files must be created and run successfully
- Required notes must be answered clearly for every task
- Do not expose sensitive information (keys, passwords, credentials)

---

# Completion Checklist

- [ ] Task 1: Environment setup verified, workspace created (Screenshots 1–2, Notes answered)
- [ ] Task 2: First script created, executed, permissions verified (Screenshots 1–3, Notes answered)
- [ ] Task 3: Variables script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 4: Arrays and loops script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 5: Counter loop script created and run (Screenshots 1–2, Notes answered)
- [ ] Task 6: File validation script created and run (Screenshots 1–3, Notes answered)
- [ ] Task 7: Pass/Retry conditional script tested with both values (Screenshots 1–4, Notes answered)
- [ ] Task 8: Final automation script created and run (Screenshots 1–3, Notes answered)
- [ ] All scripts run without errors
- [ ] Full Name visible in all required screenshots
- [ ] LinkedIn post published and URL submitted
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