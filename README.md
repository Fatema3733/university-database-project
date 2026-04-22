# University Database Analysis (SQL + Power BI)

## Overview
This project involves designing and analysing a relational database to model a university system, including students, courses, enrolments, assessments, and academic performance.

The database was built using MySQL, and a simulated dataset of 300 students was generated to reflect a realistic academic environment. SQL was used to analyse the data, and Power BI was used to visualise key insights.

---

## Objectives
- Analyse student performance across courses  
- Identify top-performing students  
- Evaluate course demand and enrolment trends  
- Compare performance across departments  
- Assess differences between coursework and exam results  
- Examine grade distribution across UK classification bands  

---

## Database Structure
The database consists of the following core tables:

- **Departments**
- **Teachers**
- **Students**
- **Courses**
- **Enrolments**
- **Assessments**
- **Grades**

Key design features:
- One-to-many relationships between departments and students, teachers, and courses  
- A many-to-many relationship between students and courses resolved through the **Enrolments** table  
- The **Grades** table links enrolments to assessments, ensuring accurate performance tracking  
- Primary and foreign keys maintain referential integrity  

---

## Data Generation
A simulated dataset was created to reflect a realistic UK university environment:

- 300 students across 5 departments  
- Multiple courses per department  
- Each student enrolled in multiple courses  
- Coursework and exam-based assessments  
- Weighted grading system applied  

Grades were generated to follow a realistic distribution:
- Most results fall within **2:1 and 2:2**  
- Smaller proportions of **First, Third, and Fail**  
- Coursework scores are slightly higher than exam scores  

---

## Key Insights

### Course Performance
- Academic performance varies across courses  
- Some subjects achieve higher average grades than others  
- Quantitative subjects tend to have lower average performance  

### Student Performance
- A small group of students consistently achieve **First-class results**  
- Top-performing students demonstrate strong performance across multiple courses  

### Enrolment vs Performance
- Higher enrolment does not necessarily lead to higher academic performance  
- Smaller courses can achieve stronger average results  

### Department Performance
- Performance varies across departments  
- Some departments consistently outperform others  

### Assessment Analysis
- Students perform better in **coursework than exams**  
- Assessment type has a clear impact on outcomes  

### Grade Distribution
- Most students fall within the **2:1 and 2:2 ranges**  
- Fewer students achieve First-class results  
- Lower classifications (Third/Fail) are less common  

---

## Tools Used
- **MySQL** – database design, data generation, and analysis  
- **Power BI** – data visualisation and dashboard creation  

---

## Files
- `university_database.sql`  
  → Full database schema, data generation, and analysis queries  

---

## How to Run
1. Open MySQL Workbench  
2. Run the `university_database.sql` script  
3. Execute the analysis queries included in the file  

---
