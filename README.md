# University Database System (SQL)

## Overview  
This project involves designing and building a relational database to model a university system, including students, courses, enrolments, assessments, and academic performance.  

The database was developed in MySQL, with a simulated dataset of 300 students to reflect a realistic UK university environment. Alongside building the schema, I focused on enforcing data integrity and analysing performance using SQL.  

---

## Objectives  
- Build a structured relational database from scratch  
- Enforce data integrity using constraints and triggers  
- Simulate realistic student enrolment and grading patterns  
- Analyse academic performance across courses and departments  
- Explore differences between coursework and exam results  

---

## Database Structure  
The database consists of seven core tables:  

- **Departments**  
- **Teachers**  
- **Students**  
- **Courses**  
- **Enrolments**  
- **Assessments**  
- **Grades**  

Key design features:  
- One-to-many relationships between departments and students, teachers, and courses  
- A many-to-many relationship between students and courses, resolved through the **Enrolments** table  
- The **Grades** table links enrolments to assessments at a detailed level  
- Primary and foreign keys maintain referential integrity  
- Unique constraints prevent duplicate enrolments and grade records  

---

## Data Integrity & Validation  
To strengthen the database, additional rules were implemented beyond standard constraints:  

- Prevents **future dates of birth**  
- Ensures **teachers are assigned only to courses within their department**  
- Prevents **assessment weightings exceeding 100% per course**  
- Ensures **grades are only recorded for assessments within the correct course**  

Validation queries are also included to check:  
- assessment weightings per course  
- any invalid grade relationships  

---

## Data Generation  
A simulated dataset was created to reflect a realistic academic environment:  

- **300 students** distributed across 5 departments  
- **15 courses**, with each department offering multiple modules  
- Each student is enrolled in:  
  - 2 courses within their department  
  - 1 elective course from another department  
- Each course includes both **coursework and exam assessments**  
- A **weighted grading system** is used to calculate results  

Grades were generated to reflect realistic patterns:  
- Most results fall within **2:1 (60–69%) and 2:2 (50–59%)**  
- A smaller proportion of **First-class**, **Third**, and **Fail** outcomes  
- Coursework scores are slightly higher than exam scores  

---

## Key Analysis & Insights  

### Course Performance  
- Performance varies across courses  
- Some subjects consistently achieve higher average grades  

### Student Performance  
- A small group of students consistently achieve **First-class results**  
- High-performing students tend to perform well across multiple courses  

### Department Performance  
- Clear variation in performance across departments  
- Differences are likely influenced by subject difficulty  

### Assessment Analysis  
- Students perform better in **coursework than exams**  
- Assessment type has a noticeable impact on outcomes  

### Grade Distribution  
- Most results fall within **2:1 and 2:2 classifications**  
- Fewer students achieve First-class results  
- Lower classifications make up a smaller share overall  

### Enrolment vs Performance  
- Higher enrolment does not necessarily lead to better performance  
- Some smaller courses achieve stronger average results  

---

## Tools Used  
- **MySQL** – database design, data generation, and analysis  

---

## Files  
- `university_database.sql`  
  → Full database schema, triggers, data generation, and analysis queries  

---

## How to Run  
1. Open MySQL Workbench  
2. Run the `university_database.sql` script  
3. Execute the analysis queries at the end of the file  
