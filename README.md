# University Database Analysis (SQL + Power BI)

## Overview
This project involves designing and analysing a relational database to model a university system, including students, courses, enrolments, assessments, and academic performance.

The database was built using MySQL, and a simulated dataset of 300 students was generated to reflect a realistic UK university environment. SQL was used to analyse the data, and Power BI was used to visualise key insights.

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
- The **Grades** table links enrolments to assessments, ensuring students only receive grades for courses they are enrolled in  
- Primary and foreign keys maintain referential integrity  
- Unique constraints prevent duplicate enrolments and duplicate grade entries  

---

## Data Generation
A simulated dataset was created to reflect a realistic academic environment:

- **300 students** distributed across 5 departments  
- **10 courses**, with each department offering multiple modules  
- Each student is enrolled in **3 courses** (department-based + elective)  
- Each course includes both **coursework and exam assessments**  
- A **weighted grading system** is applied to reflect real academic structures  

Grades were generated to follow a realistic UK classification distribution:
- Most results fall within **2:1 (60–69%) and 2:2 (50–59%)**  
- Smaller proportions of **First-class (70%+)**, **Third (40–49%)**, and **Fail (<40%)**  
- Coursework scores are slightly higher than exam scores to reflect typical performance patterns  

---

## Key Analysis & Insights

### Course Performance
- Academic performance varies across courses  
- Some subjects consistently achieve higher average grades than others  
- More quantitative courses tend to have lower average performance  

### Student Performance
- A small group of students consistently achieve **First-class results**  
- Top-performing students demonstrate strong performance across multiple courses  

### Enrolment vs Performance
- Higher enrolment does not necessarily lead to higher academic performance  
- Smaller courses can achieve stronger average results  

### Department Performance
- Academic performance varies across departments  
- Some departments consistently outperform others, influenced by subject type  

### Assessment Analysis
- Students perform better in **coursework than exams**  
- Assessment format has a clear impact on academic outcomes  

### Grade Distribution
- Most students fall within the **2:1 and 2:2 classification ranges**  
- Fewer students achieve First-class results  
- Lower classifications (Third/Fail) represent a smaller proportion of outcomes  

---

## Tools Used
- **MySQL** – database design, data generation, and analysis  
- **Power BI** – data visualisation and dashboard creation  

---

## Files
- `university_database.sql`  
  → Full database schema, data generation scripts, and analysis queries  

---

## How to Run
1. Open MySQL Workbench  
2. Run the `university_database.sql` script  
3. Execute the analysis queries included at the end of the script  

---
