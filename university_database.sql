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
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    date_of_birth DATE NOT NULL,
    enrolment_year INT NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    teacher_id INT NOT NULL,
    credits INT NOT NULL,
    year_of_study INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

CREATE TABLE Enrolments (
    enrolment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolment_date DATE NOT NULL,
    academic_year VARCHAR(9) NOT NULL,
    UNIQUE (student_id, course_id, academic_year),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    assessment_name VARCHAR(100) NOT NULL,
    assessment_type VARCHAR(50) NOT NULL,
    weighting DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CHECK (weighting > 0 AND weighting <= 100)
);

CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrolment_id INT NOT NULL,
    assessment_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    UNIQUE (enrolment_id, assessment_id),
    FOREIGN KEY (enrolment_id) REFERENCES Enrolments(enrolment_id),
    FOREIGN KEY (assessment_id) REFERENCES Assessments(assessment_id),
    CHECK (score >= 0 AND score <= 100)
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
('James', 'Turner', 'james.turner@uni.ac.uk', 1),
('Emily', 'Carter', 'emily.carter@uni.ac.uk', 2),
('Daniel', 'Walker', 'daniel.walker@uni.ac.uk', 2),
('Aisha', 'Patel', 'aisha.patel@uni.ac.uk', 3),
('Adam', 'Brown', 'adam.brown@uni.ac.uk', 3),
('Leah', 'Evans', 'leah.evans@uni.ac.uk', 4),
('Henry', 'Wood', 'henry.wood@uni.ac.uk', 4),
('Amira', 'Khan', 'amira.khan@uni.ac.uk', 5),
('Noah', 'Roberts', 'noah.roberts@uni.ac.uk', 5);

INSERT INTO Courses (course_name, department_id, teacher_id, credits, year_of_study)
VALUES
('Microeconomics', 1, 1, 20, 1),
('Macroeconomics', 1, 2, 20, 2),
('Database Systems', 2, 3, 20, 2),
('Programming Fundamentals', 2, 4, 20, 1),
('Business Analytics', 3, 5, 20, 2),
('Marketing Principles', 3, 6, 20, 1),
('Linear Algebra', 4, 7, 20, 1),
('Statistics', 4, 8, 20, 2),
('Research Methods', 5, 9, 20, 1),
('Social Theory', 5, 10, 20, 2);

-- =========================================
-- TEMP TABLES FOR STUDENT NAMES
-- =========================================

CREATE TEMPORARY TABLE temp_first_names (
    first_name VARCHAR(50),
    gender VARCHAR(10)
);

INSERT INTO temp_first_names (first_name, gender)
VALUES
('Oliver', 'Male'),
('George', 'Male'),
('Harry', 'Male'),
('Jack', 'Male'),
('Noah', 'Male'),
('Leo', 'Male'),
('Arthur', 'Male'),
('Oscar', 'Male'),
('Henry', 'Male'),
('Theo', 'Male'),
('William', 'Male'),
('Thomas', 'Male'),
('James', 'Male'),
('Lucas', 'Male'),
('Joshua', 'Male'),
('Ethan', 'Male'),
('Daniel', 'Male'),
('Matthew', 'Male'),
('Adam', 'Male'),
('Ryan', 'Male'),
('Emma', 'Female'),
('Olivia', 'Female'),
('Amelia', 'Female'),
('Isla', 'Female'),
('Ava', 'Female'),
('Sophia', 'Female'),
('Grace', 'Female'),
('Lily', 'Female'),
('Freya', 'Female'),
('Charlotte', 'Female'),
('Emily', 'Female'),
('Ella', 'Female'),
('Sophie', 'Female'),
('Chloe', 'Female'),
('Lucy', 'Female'),
('Aisha', 'Female'),
('Fatema', 'Female'),
('Zara', 'Female'),
('Hannah', 'Female'),
('Layla', 'Female');

CREATE TEMPORARY TABLE temp_last_names (
    last_name VARCHAR(50)
);

INSERT INTO temp_last_names (last_name)
VALUES
('Smith'),
('Jones'),
('Taylor'),
('Brown'),
('Williams'),
('Wilson'),
('Johnson'),
('Davies'),
('Wright'),
('Walker'),
('White'),
('Edwards'),
('Green'),
('Hall'),
('Thomas'),
('Clarke'),
('Jackson'),
('Wood'),
('Turner'),
('Scott');

-- =========================================
-- INSERT 300 STUDENTS
-- =========================================

INSERT INTO Students (first_name, last_name, gender, date_of_birth, enrolment_year, department_id)
WITH name_pool AS (
    SELECT
        f.first_name,
        l.last_name,
        f.gender,
        ROW_NUMBER() OVER (ORDER BY l.last_name, f.first_name) AS rn
    FROM temp_first_names f
    CROSS JOIN temp_last_names l
)
SELECT
    first_name,
    last_name,
    gender,
    DATE_ADD('2000-01-01', INTERVAL (rn * 8) DAY) AS date_of_birth,
    CASE
        WHEN rn <= 100 THEN 2022
        WHEN rn <= 200 THEN 2023
        ELSE 2024
    END AS enrolment_year,
    ((rn - 1) % 5) + 1 AS department_id
FROM name_pool
WHERE rn <= 300;

-- =========================================
-- ENROLMENTS
-- EACH STUDENT GETS 3 COURSES
-- =========================================

INSERT INTO Enrolments (student_id, course_id, enrolment_date, academic_year)
SELECT
    s.student_id,
    CASE s.department_id
        WHEN 1 THEN 1
        WHEN 2 THEN 3
        WHEN 3 THEN 5
        WHEN 4 THEN 7
        WHEN 5 THEN 9
    END,
    '2023-09-20',
    '2023/2024'
FROM Students s;

INSERT INTO Enrolments (student_id, course_id, enrolment_date, academic_year)
SELECT
    s.student_id,
    CASE s.department_id
        WHEN 1 THEN 2
        WHEN 2 THEN 4
        WHEN 3 THEN 6
        WHEN 4 THEN 8
        WHEN 5 THEN 10
    END,
    '2023-09-20',
    '2023/2024'
FROM Students s;

INSERT INTO Enrolments (student_id, course_id, enrolment_date, academic_year)
SELECT
    s.student_id,
    CASE s.department_id
        WHEN 1 THEN 5
        WHEN 2 THEN 7
        WHEN 3 THEN 9
        WHEN 4 THEN 1
        WHEN 5 THEN 3
    END,
    '2023-09-20',
    '2023/2024'
FROM Students s;

-- =========================================
-- ASSESSMENTS
-- =========================================

INSERT INTO Assessments (course_id, assessment_name, assessment_type, weighting)
VALUES
(1, 'Microeconomics Coursework', 'Coursework', 40.00),
(1, 'Microeconomics Exam', 'Exam', 60.00),
(2, 'Macroeconomics Coursework', 'Coursework', 30.00),
(2, 'Macroeconomics Exam', 'Exam', 70.00),
(3, 'Database Systems Coursework', 'Coursework', 50.00),
(3, 'Database Systems Exam', 'Exam', 50.00),
(4, 'Programming Fundamentals Coursework', 'Coursework', 40.00),
(4, 'Programming Fundamentals Exam', 'Exam', 60.00),
(5, 'Business Analytics Coursework', 'Coursework', 50.00),
(5, 'Business Analytics Exam', 'Exam', 50.00),
(6, 'Marketing Principles Coursework', 'Coursework', 40.00),
(6, 'Marketing Principles Exam', 'Exam', 60.00),
(7, 'Linear Algebra Coursework', 'Coursework', 40.00),
(7, 'Linear Algebra Exam', 'Exam', 60.00),
(8, 'Statistics Coursework', 'Coursework', 40.00),
(8, 'Statistics Exam', 'Exam', 60.00),
(9, 'Research Methods Coursework', 'Coursework', 70.00),
(9, 'Research Methods Exam', 'Exam', 30.00),
(10, 'Social Theory Coursework', 'Coursework', 50.00),
(10, 'Social Theory Exam', 'Exam', 50.00);

-- =========================================
-- GRADES
-- =========================================

INSERT INTO Grades (enrolment_id, assessment_id, score)
SELECT
    e.enrolment_id,
    a.assessment_id,
    ROUND(
        LEAST(
            95,
            GREATEST(
                18,
                (
                    CASE
                        WHEN MOD(e.student_id, 20) = 0 THEN 74
                        WHEN MOD(e.student_id, 20) BETWEEN 1 AND 8 THEN 63
                        WHEN MOD(e.student_id, 20) BETWEEN 9 AND 15 THEN 54
                        WHEN MOD(e.student_id, 20) BETWEEN 16 AND 18 THEN 44
                        ELSE 32
                    END
                    +
                    CASE
                        WHEN a.assessment_type = 'Coursework' THEN 4
                        ELSE 0
                    END
                    +
                    CASE
                        WHEN e.course_id IN (5, 10) THEN 3
                        WHEN e.course_id IN (3, 9) THEN 2
                        WHEN e.course_id IN (4, 7) THEN -2
                        ELSE 0
                    END
                    +
                    (RAND() * 8 - 4)
                )
            )
        ),
        2
    ) AS score
FROM Enrolments e
JOIN Assessments a
    ON e.course_id = a.course_id;

-- =========================================
-- ANALYSIS QUERIES
-- =========================================

-- Course Performance
SELECT
    c.course_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS weighted_average_grade,
    CASE
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 70 THEN 'First'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 60 THEN '2:1'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 50 THEN '2:2'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 40 THEN 'Third'
        ELSE 'Fail'
    END AS classification
FROM Grades g
JOIN Enrolments e ON g.enrolment_id = e.enrolment_id
JOIN Assessments a ON g.assessment_id = a.assessment_id
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name
ORDER BY weighted_average_grade DESC;

-- Top Students
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS weighted_average_grade,
    CASE
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 70 THEN 'First'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 60 THEN '2:1'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 50 THEN '2:2'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 40 THEN 'Third'
        ELSE 'Fail'
    END AS classification
FROM Grades g
JOIN Enrolments e ON g.enrolment_id = e.enrolment_id
JOIN Assessments a ON g.assessment_id = a.assessment_id
JOIN Students s ON e.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY weighted_average_grade DESC
LIMIT 10;

-- Department Performance
SELECT
    d.department_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS weighted_average_grade
FROM Departments d
JOIN Courses c ON d.department_id = c.department_id
JOIN Enrolments e ON c.course_id = e.course_id
JOIN Grades g ON e.enrolment_id = g.enrolment_id
JOIN Assessments a ON g.assessment_id = a.assessment_id
GROUP BY d.department_name
ORDER BY weighted_average_grade DESC;

-- Coursework vs Exam
SELECT
    a.assessment_type,
    ROUND(AVG(g.score), 2) AS average_score,
    CASE
        WHEN AVG(g.score) >= 70 THEN 'First'
        WHEN AVG(g.score) >= 60 THEN '2:1'
        WHEN AVG(g.score) >= 50 THEN '2:2'
        WHEN AVG(g.score) >= 40 THEN 'Third'
        ELSE 'Fail'
    END AS classification
FROM Grades g
JOIN Assessments a ON g.assessment_id = a.assessment_id
GROUP BY a.assessment_type;

-- Grade Distribution
SELECT
    CASE
        WHEN g.score >= 70 THEN 'First'
        WHEN g.score >= 60 THEN '2:1'
        WHEN g.score >= 50 THEN '2:2'
        WHEN g.score >= 40 THEN 'Third'
        ELSE 'Fail'
    END AS classification,
    COUNT(*) AS total_results
FROM Grades g
GROUP BY classification
ORDER BY total_results DESC;

-- Enrolment vs Performance
SELECT
    c.course_name,
    COUNT(DISTINCT e.student_id) AS total_enrolments,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS weighted_average_grade
FROM Courses c
LEFT JOIN Enrolments e
    ON c.course_id = e.course_id
LEFT JOIN Grades g
    ON e.enrolment_id = g.enrolment_id
LEFT JOIN Assessments a
    ON g.assessment_id = a.assessment_id
GROUP BY c.course_name
HAVING COUNT(DISTINCT e.student_id) > 0
ORDER BY total_enrolments DESC, weighted_average_grade DESC;
