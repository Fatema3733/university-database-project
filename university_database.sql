-- =========================================
-- RESET DATABASE
-- =========================================
DROP DATABASE IF EXISTS UniversityDatabase;
CREATE DATABASE UniversityDatabase;
USE UniversityDatabase;

-- =========================================
-- TABLES
-- =========================================

CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    enrolment_year INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) UNIQUE,
    department_id INT,
    teacher_id INT,
    credits INT,
    year_of_study INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

CREATE TABLE Enrolments (
    enrolment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrolment_date DATE,
    academic_year VARCHAR(9),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    assessment_name VARCHAR(100),
    assessment_type VARCHAR(50),
    weighting DECIMAL(5,2),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrolment_id INT,
    assessment_id INT,
    score DECIMAL(5,2),
    FOREIGN KEY (enrolment_id) REFERENCES Enrolments(enrolment_id),
    FOREIGN KEY (assessment_id) REFERENCES Assessments(assessment_id)
);

-- =========================================
-- INSERT DATA
-- =========================================

INSERT INTO Departments (department_name)
VALUES
('Economics'),
('Computer Science'),
('Business'),
('Mathematics'),
('Social Sciences');

INSERT INTO Teachers (first_name, last_name, email, department_id)
VALUES
('Sarah', 'Mitchell', 'sarah.mitchell@uni.ac.uk', 1),
('James', 'Turner', 'james.turner@uni.ac.uk', 2),
('Emily', 'Carter', 'emily.carter@uni.ac.uk', 3),
('Daniel', 'Walker', 'daniel.walker@uni.ac.uk', 4),
('Amira', 'Khan', 'amira.khan@uni.ac.uk', 5);

INSERT INTO Courses (course_name, department_id, teacher_id, credits, year_of_study)
VALUES
('Microeconomics', 1, 1, 20, 1),
('Macroeconomics', 1, 1, 20, 2),
('Database Systems', 2, 2, 20, 2),
('Programming Fundamentals', 2, 2, 20, 1),
('Business Analytics', 3, 3, 20, 2),
('Linear Algebra', 4, 4, 20, 1),
('Research Methods', 5, 5, 20, 1),
('Social Theory', 5, 5, 20, 2);

-- Generate Students
INSERT INTO Students (first_name, last_name, gender, date_of_birth, enrolment_year, department_id)
SELECT 
    ELT(FLOOR(1 + (RAND() * 10)), 'Oliver','George','Harry','Jack','Noah','Leo','Arthur','Oscar','Henry','Theo'),
    ELT(FLOOR(1 + (RAND() * 10)), 'Smith','Jones','Taylor','Brown','Williams','Wilson','Johnson','Davies','Wright','Walker'),
    ELT(FLOOR(1 + (RAND() * 2)), 'Male','Female'),
    DATE_ADD('2000-01-01', INTERVAL FLOOR(RAND()*1500) DAY),
    ELT(FLOOR(1 + (RAND() * 3)), 2022, 2023, 2024),
    FLOOR(1 + (RAND() * 5))
FROM information_schema.tables
LIMIT 300;

-- Enrolments
INSERT INTO Enrolments (student_id, course_id, enrolment_date, academic_year)
SELECT 
    s.student_id,
    FLOOR(1 + (RAND() * 8)),
    '2023-09-20',
    '2023/2024'
FROM Students s
LIMIT 900;

-- Assessments
INSERT INTO Assessments (course_id, assessment_name, assessment_type, weighting)
VALUES
(1,'Coursework','Coursework',40),(1,'Exam','Exam',60),
(2,'Coursework','Coursework',30),(2,'Exam','Exam',70),
(3,'Coursework','Coursework',50),(3,'Exam','Exam',50),
(4,'Coursework','Coursework',40),(4,'Exam','Exam',60),
(5,'Coursework','Coursework',50),(5,'Exam','Exam',50),
(6,'Coursework','Coursework',40),(6,'Exam','Exam',60),
(7,'Coursework','Coursework',70),(7,'Exam','Exam',30),
(8,'Coursework','Coursework',50),(8,'Exam','Exam',50);

-- Grades
INSERT INTO Grades (enrolment_id, assessment_id, score)
SELECT 
    e.enrolment_id,
    a.assessment_id,
    CASE
        WHEN RAND() < 0.1 THEN ROUND(70 + RAND()*30, 2)
        WHEN RAND() < 0.5 THEN ROUND(60 + RAND()*10, 2)
        WHEN RAND() < 0.8 THEN ROUND(50 + RAND()*10, 2)
        WHEN RAND() < 0.95 THEN ROUND(40 + RAND()*10, 2)
        ELSE ROUND(RAND()*40, 2)
    END
FROM Enrolments e
JOIN Assessments a ON e.course_id = a.course_id;

-- =========================================
-- ANALYSIS QUERIES
-- =========================================

-- Course Performance
SELECT
    c.course_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS avg_grade
FROM Grades g
JOIN Enrolments e ON g.enrolment_id = e.enrolment_id
JOIN Assessments a ON g.assessment_id = a.assessment_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name
ORDER BY avg_grade DESC;

-- Top Students
SELECT
    CONCAT(s.first_name,' ',s.last_name) AS student_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting),2) AS avg_grade
FROM Students s
JOIN Enrolments e ON s.student_id = e.student_id
JOIN Grades g ON e.enrolment_id = g.enrolment_id
JOIN Assessments a ON g.assessment_id = a.assessment_id
GROUP BY s.student_id
ORDER BY avg_grade DESC
LIMIT 10;

-- Department Performance
SELECT
    d.department_name,
    ROUND(AVG(g.score),2) AS avg_score
FROM Departments d
JOIN Courses c ON d.department_id = c.department_id
JOIN Enrolments e ON c.course_id = e.course_id
JOIN Grades g ON e.enrolment_id = g.enrolment_id
GROUP BY d.department_name;

-- Coursework vs Exam
SELECT
    a.assessment_type,
    ROUND(AVG(g.score),2) AS avg_score
FROM Grades g
JOIN Assessments a ON g.assessment_id = a.assessment_id
GROUP BY a.assessment_type;

-- Grade Distribution
SELECT
    CASE
        WHEN score >= 70 THEN 'First'
        WHEN score >= 60 THEN '2:1'
        WHEN score >= 50 THEN '2:2'
        WHEN score >= 40 THEN 'Third'
        ELSE 'Fail'
    END AS classification,
    COUNT(*) AS total
FROM Grades
GROUP BY classification;
