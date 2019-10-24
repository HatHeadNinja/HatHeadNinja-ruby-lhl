# Assessment Test Runner

This repository is how you will take your assessment test. From this repo you will start your test, write your solutions, and submit your answers using the command line. Please take the time to carefully follow each step.

Due to the inclusion of embedded screenshots, we suggest you read this file in HTML format, here:

<https://github.com/lighthouse-labs/assessment-exam-student-ruby>

## Getting Started

Please carefully follow the instructions below to get started.

**Important Note:** If you make a mistake in performing these steps (and see unexpected behavior), you will need to RESTART from step 1 (clone the repo)!

---

> 1. Clone the repository

To start, **CLONE** (do not _fork_) this repo to your local Vagrant machine, and `cd` into the folder:

```terminal
git clone git@github.com:lighthouse-labs/assessment-exam-student-ruby.git
cd assessment-exam-student-ruby
```

> 2. Install Required Packages

Run the following command from within the project directory:

```terminal
bundle install
```

---

> 3. Open the entire project in Visual Studio Code

Open the entire project directory in VS Code. You should see the directory tree on the left hand side:

![screenshot of vscode](./img/1-vscode.png)

---

> 4. Specify your exact **GitHub user name** in the file `config.yml`

This is **case-sensitive** so make sure you match it exactly.

![screenshot of GitHub](https://d.pr/i/DJBM/5kFTOJ8Q+)

![screenshot of VS Code](./img/2-student-id.png)

**NOTE: Ensure your user name is spelled correctly!**

---

> 5. Specify your exam code in the file `config.yml`

The exam code can be found [in this reading on Compass](https://web.compass.lighthouselabs.ca/4c01411e-afe1-464c-a9aa-d5157bb9c2b1). Enter it under your student id in the `config.yml` file

![screenshot of VS Code](./img/3-exam-code.png)

---

> 5. Start the test from a terminal window

Enter the command below to start the test:

- Once you start the exam, the test timer will start.

```terminal
bundle exec rake exam:start
```

This command downloads the test questions to your local file system. You should see new files in the `answers/` directory.

You should see output that looks like this (note: output may vary based on which test you are taking):

```
Contacting Server to Start Exam "web-06"

Server Response: 5 Questions:
  Creating Question 00  (30 Points) Answer file: answers/00.rb
  Creating Question 01  (30 Points) Answer file: answers/01.rb
  Creating Question 02  (20 Points) Answer file: answers/02.rb
  Creating Question 03  (20 Points) Answer file: answers/03.rb
  Creating Question 04  (20 Points) Answer file: answers/04.rb
```

If you see an error, please let the proctor know. **You may need to re-clone and restart the process from step 1 if the problem persists!**

---

## Answering Questions

Now you're ready to start answering questions! Follow these steps carefully:

> 1. Expand the `answers/` directory in your code editor.

Note that the question numbering starts at 0.

---

> 2. Execute the test code

From the command line, execute the automated tests for the first question, question 0, using the command below (question numbering starts at 0):

```terminal
bundle exec rake exam:question[0]
```

---

> 3. Read the output carefully

Notice that none of the tests for question 0 are passing.

---

> 4. Write some code

Implement the code to make the first test pass, located in `answers/00.rb`.

Run the `bundle exec rake exam:question[0]` command again to make sure you are starting to see solutions.

Notice that your score for the question also went up. The number of automated tests passing the primary factor for how your score is calculated.

It is recommended that you run the `bundle exec rake exam:question[number]` command frequently.

---

> 5. Repeat for all questions

Once you complete `exam:question[0]`, repeat these steps but this time with `exam:question[1]` (the code for which should is in `answers/01.rb`).

## Submission Grading

- You can submit questions multiple times during your development process
- Points are awarded based on how your solutions perform during evaluation
- Submissions will still be accepted after the end of the test period
