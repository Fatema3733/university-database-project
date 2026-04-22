
 =========================================================
-- UNIVERSITY DATABASE SYSTEM
-- This project models a university database system containing:
-- departments, teachers, students, courses, enrolments,
-- assessments, and grades.
--
-- Features included:
-- - relational database design with foreign keys
-- - validation using CHECK constraints
-- - triggers for additional business rules
-- - realistic student enrolment logic
-- - performance analysis queries
-- =========================================================
-- 1. RESET DATABASE
-- =========================================================
DROP DATABASE IF EXISTS UniversityDatabase;
CREATE DATABASE UniversityDatabase;
USE UniversityDatabase;

-- =========================================================
-- 2. CREATE TABLES
-- =========================================================

-- Stores university departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Stores teacher records
CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    CONSTRAINT fk_teachers_department
        FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Stores student records
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    date_of_birth DATE NOT NULL,
    enrolment_year INT NOT NULL,
    department_id INT NOT NULL,
    CONSTRAINT fk_students_department
        FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    CONSTRAINT chk_students_gender
        CHECK (gender IN ('Male', 'Female')),
    CONSTRAINT chk_students_enrolment_year
        CHECK (enrolment_year BETWEEN 2022 AND 2024)
);

-- Stores course records
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    department_id INT NOT NULL,
    teacher_id INT NOT NULL,
    credits INT NOT NULL,
    year_of_study INT NOT NULL,
    CONSTRAINT fk_courses_department
        FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    CONSTRAINT fk_courses_teacher
        FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id),
    CONSTRAINT chk_courses_credits
        CHECK (credits > 0),
    CONSTRAINT chk_courses_year_of_study
        CHECK (year_of_study BETWEEN 1 AND 4)
);

-- Stores student course enrolments
CREATE TABLE Enrolments (
    enrolment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolment_date DATE NOT NULL,
    academic_year VARCHAR(9) NOT NULL,
    CONSTRAINT uq_enrolment
        UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT fk_enrolments_student
        FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_enrolments_course
        FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT chk_enrolments_academic_year
        CHECK (academic_year IN ('2023/2024'))
);

-- Stores assessment components for each course
CREATE TABLE Assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    assessment_name VARCHAR(100) NOT NULL,
    assessment_type VARCHAR(50) NOT NULL,
    weighting DECIMAL(5,2) NOT NULL,
    CONSTRAINT fk_assessments_course
        FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT chk_assessment_type
        CHECK (assessment_type IN ('Coursework', 'Exam')),
    CONSTRAINT chk_assessment_weighting
        CHECK (weighting > 0 AND weighting <= 100),
    CONSTRAINT uq_assessment_name_per_course
        UNIQUE (course_id, assessment_name)
);

-- Stores student grades for each assessment
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrolment_id INT NOT NULL,
    assessment_id INT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    CONSTRAINT uq_grade
        UNIQUE (enrolment_id, assessment_id),
    CONSTRAINT fk_grades_enrolment
        FOREIGN KEY (enrolment_id) REFERENCES Enrolments(enrolment_id),
    CONSTRAINT fk_grades_assessment
        FOREIGN KEY (assessment_id) REFERENCES Assessments(assessment_id),
    CONSTRAINT chk_grade_score
        CHECK (score >= 0 AND score <= 100)
);


-- =========================================================
-- 3. CREATE TRIGGERS
-- =========================================================
-- These triggers enforce additional business rules that are
-- not fully covered by standard constraints.

DELIMITER $$

-- Prevents a student's date of birth from being set in the future
CREATE TRIGGER trg_students_check_dob_insert
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    IF NEW.date_of_birth > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Date of birth cannot be in the future.';
    END IF;
END$$

CREATE TRIGGER trg_students_check_dob_update
BEFORE UPDATE ON Students
FOR EACH ROW
BEGIN
    IF NEW.date_of_birth > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Date of birth cannot be in the future.';
    END IF;
END$$

-- Ensures that the assigned teacher belongs to the same department as the course
CREATE TRIGGER trg_courses_teacher_department_insert
BEFORE INSERT ON Courses
FOR EACH ROW
BEGIN
    DECLARE teacher_department_id INT;

    SELECT department_id
    INTO teacher_department_id
    FROM Teachers
    WHERE teacher_id = NEW.teacher_id;

    IF teacher_department_id <> NEW.department_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Teacher must belong to the same department as the course.';
    END IF;
END$$

CREATE TRIGGER trg_courses_teacher_department_update
BEFORE UPDATE ON Courses
FOR EACH ROW
BEGIN
    DECLARE teacher_department_id INT;

    SELECT department_id
    INTO teacher_department_id
    FROM Teachers
    WHERE teacher_id = NEW.teacher_id;

    IF teacher_department_id <> NEW.department_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Teacher must belong to the same department as the course.';
    END IF;
END$$

DELIMITER ;


-- =========================================================
-- 4. INSERT DEPARTMENTS
-- =========================================================
INSERT INTO Departments (department_name)
VALUES
('Economics'),
('Computer Science'),
('Business'),
('Mathematics'),
('Social Sciences');


-- =========================================================
-- 5. INSERT TEACHERS
-- =========================================================
INSERT INTO Teachers (first_name, last_name, email, department_id)
VALUES
('Sarah', 'Mitchell', 'sarah.mitchell@uni.ac.uk', 1),
('James', 'Turner', 'james.turner@uni.ac.uk', 1),
('Oliver', 'Reid', 'oliver.reid@uni.ac.uk', 1),

('Emily', 'Carter', 'emily.carter@uni.ac.uk', 2),
('Daniel', 'Walker', 'daniel.walker@uni.ac.uk', 2),
('Chloe', 'Wilson', 'chloe.wilson@uni.ac.uk', 2),

('Aisha', 'Patel', 'aisha.patel@uni.ac.uk', 3),
('Adam', 'Brown', 'adam.brown@uni.ac.uk', 3),
('Grace', 'Morgan', 'grace.morgan@uni.ac.uk', 3),

('Matthew', 'Scott', 'matthew.scott@uni.ac.uk', 4),
('Leah', 'Evans', 'leah.evans@uni.ac.uk', 4),
('Henry', 'Wood', 'henry.wood@uni.ac.uk', 4),

('Amira', 'Khan', 'amira.khan@uni.ac.uk', 5),
('Noah', 'Roberts', 'noah.roberts@uni.ac.uk', 5),
('Zara', 'Shah', 'zara.shah@uni.ac.uk', 5);


-- =========================================================
-- 6. INSERT COURSES
-- 3 courses per department = 15 total
-- =========================================================
INSERT INTO Courses (course_name, department_id, teacher_id, credits, year_of_study)
VALUES
('Microeconomics', 1, 1, 20, 1),
('Macroeconomics', 1, 2, 20, 2),
('Econometrics', 1, 3, 20, 3),

('Programming Fundamentals', 2, 4, 20, 1),
('Database Systems', 2, 5, 20, 2),
('Data Structures', 2, 6, 20, 2),

('Marketing Principles', 3, 7, 20, 1),
('Business Analytics', 3, 8, 20, 2),
('Organisational Behaviour', 3, 9, 20, 2),

('Calculus', 4, 10, 20, 1),
('Linear Algebra', 4, 11, 20, 1),
('Statistics', 4, 12, 20, 2),

('Research Methods', 5, 13, 20, 1),
('Social Theory', 5, 14, 20, 2),
('Public Policy', 5, 15, 20, 3);


-- =========================================================
-- 7. TEMPORARY NAME TABLES
-- Used to generate realistic student names
-- =========================================================
CREATE TEMPORARY TABLE temp_first_names (
    first_name VARCHAR(50),
    gender VARCHAR(10)
);

INSERT INTO temp_first_names VALUES
('Oliver','Male'),('George','Male'),('Harry','Male'),('Jack','Male'),
('Noah','Male'),('Leo','Male'),('Arthur','Male'),('Oscar','Male'),
('Henry','Male'),('Theo','Male'),('William','Male'),('Thomas','Male'),
('James','Male'),('Lucas','Male'),('Joshua','Male'),('Ethan','Male'),
('Daniel','Male'),('Matthew','Male'),('Adam','Male'),('Ryan','Male'),
('Ahmed','Male'),('Omar','Male'),('Yusuf','Male'),('Ali','Male'),
('Ibrahim','Male'),('Hassan','Male'),('Bilal','Male'),('Zayn','Male'),

('Emma','Female'),('Olivia','Female'),('Amelia','Female'),('Isla','Female'),
('Ava','Female'),('Sophia','Female'),('Grace','Female'),('Lily','Female'),
('Freya','Female'),('Charlotte','Female'),('Emily','Female'),('Ella','Female'),
('Sophie','Female'),('Chloe','Female'),('Lucy','Female'),('Hannah','Female'),
('Zara','Female'),('Aisha','Female'),('Fatema','Female'),('Amira','Female'),
('Layla','Female'),('Maya','Female'),('Nadia','Female'),('Sara','Female'),
('Maryam','Female'),('Noor','Female'),('Yasmin','Female');

CREATE TEMPORARY TABLE temp_last_names (
    last_name VARCHAR(50)
);

INSERT INTO temp_last_names VALUES
('Smith'),('Jones'),('Taylor'),('Brown'),('Williams'),('Wilson'),
('Johnson'),('Davies'),('Wright'),('Walker'),('White'),('Edwards'),
('Green'),('Hall'),('Thomas'),('Clarke'),('Jackson'),('Wood'),
('Turner'),('Scott'),('Morgan'),('Evans'),('Reid'),('Cooper'),
('Hill'),('Ward'),('Morris'),('Cook'),('Bailey'),('Parker'),
('Patel'),('Khan'),('Ali'),('Hussain'),('Rahman'),('Ahmed'),
('Shah'),('Begum'),('Chowdhury'),('Uddin');


-- =========================================================
-- 8. INSERT 300 STUDENTS
-- Duplicate full names are allowed for realism
-- =========================================================
INSERT INTO Students (
    first_name,
    last_name,
    gender,
    date_of_birth,
    enrolment_year,
    department_id
)
SELECT
    fn.first_name,
    ln.last_name,
    fn.gender,
    DATE_ADD('2000-01-01', INTERVAL FLOOR(RAND() * 1500) DAY) AS date_of_birth,
    CAST(ELT(FLOOR(1 + (RAND() * 3)), '2022', '2023', '2024') AS UNSIGNED) AS enrolment_year,
    FLOOR(1 + (RAND() * 5)) AS department_id
FROM temp_first_names fn
CROSS JOIN temp_last_names ln
ORDER BY RAND()
LIMIT 300;


-- =========================================================
-- 9. INSERT ENROLMENTS
-- Each student receives:
-- - 2 random courses from their own department
-- - 1 random elective from another department
-- =========================================================

-- Two home-department courses per student
INSERT INTO Enrolments (student_id, course_id, enrolment_date, academic_year)
SELECT
    ranked_courses.student_id,
    ranked_courses.course_id,
    '2023-09-20' AS enrolment_date,
    '2023/2024' AS academic_year
FROM (
    SELECT
        s.student_id,
        c.course_id,
        ROW_NUMBER() OVER (
            PARTITION BY s.student_id
            ORDER BY RAND()
        ) AS row_num
    FROM Students s
    JOIN Courses c
        ON s.department_id = c.department_id
) AS ranked_courses
WHERE ranked_courses.row_num <= 2;

-- One elective course from outside the student's department
INSERT INTO Enrolments (student_id, course_id, enrolment_date, academic_year)
SELECT
    ranked_electives.student_id,
    ranked_electives.course_id,
    '2023-09-20' AS enrolment_date,
    '2023/2024' AS academic_year
FROM (
    SELECT
        s.student_id,
        c.course_id,
        ROW_NUMBER() OVER (
            PARTITION BY s.student_id
            ORDER BY RAND()
        ) AS row_num
    FROM Students s
    JOIN Courses c
        ON s.department_id <> c.department_id
) AS ranked_electives
WHERE ranked_electives.row_num = 1;


-- =========================================================
-- 10. INSERT ASSESSMENTS
-- Two assessments per course
-- =========================================================
INSERT INTO Assessments (course_id, assessment_name, assessment_type, weighting)
VALUES
(1, 'Microeconomics Coursework', 'Coursework', 40.00),
(1, 'Microeconomics Exam', 'Exam', 60.00),
(2, 'Macroeconomics Coursework', 'Coursework', 30.00),
(2, 'Macroeconomics Exam', 'Exam', 70.00),
(3, 'Econometrics Coursework', 'Coursework', 50.00),
(3, 'Econometrics Exam', 'Exam', 50.00),

(4, 'Programming Fundamentals Coursework', 'Coursework', 40.00),
(4, 'Programming Fundamentals Exam', 'Exam', 60.00),
(5, 'Database Systems Coursework', 'Coursework', 50.00),
(5, 'Database Systems Exam', 'Exam', 50.00),
(6, 'Data Structures Coursework', 'Coursework', 40.00),
(6, 'Data Structures Exam', 'Exam', 60.00),

(7, 'Marketing Principles Coursework', 'Coursework', 40.00),
(7, 'Marketing Principles Exam', 'Exam', 60.00),
(8, 'Business Analytics Coursework', 'Coursework', 50.00),
(8, 'Business Analytics Exam', 'Exam', 50.00),
(9, 'Organisational Behaviour Coursework', 'Coursework', 50.00),
(9, 'Organisational Behaviour Exam', 'Exam', 50.00),

(10, 'Calculus Coursework', 'Coursework', 40.00),
(10, 'Calculus Exam', 'Exam', 60.00),
(11, 'Linear Algebra Coursework', 'Coursework', 40.00),
(11, 'Linear Algebra Exam', 'Exam', 60.00),
(12, 'Statistics Coursework', 'Coursework', 40.00),
(12, 'Statistics Exam', 'Exam', 60.00),

(13, 'Research Methods Coursework', 'Coursework', 70.00),
(13, 'Research Methods Exam', 'Exam', 30.00),
(14, 'Social Theory Coursework', 'Coursework', 50.00),
(14, 'Social Theory Exam', 'Exam', 50.00),
(15, 'Public Policy Coursework', 'Coursework', 40.00),
(15, 'Public Policy Exam', 'Exam', 60.00);


-- =========================================================
-- 11. VALIDATION CHECK
-- This query checks whether assessment weightings total 100
-- for each course
-- =========================================================
SELECT
    course_id,
    SUM(weighting) AS total_weighting
FROM Assessments
GROUP BY course_id
HAVING SUM(weighting) <> 100;


-- =========================================================
-- 12. INSERT GRADES
-- Grade generation includes:
-- - student ability bands
-- - coursework bonus
-- - subject difficulty adjustment
-- - random variation
-- =========================================================
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
                        WHEN e.course_id IN (8, 14) THEN 3
                        WHEN e.course_id IN (5, 13) THEN 2
                        WHEN e.course_id IN (10, 4) THEN -2
                        ELSE 0
                    END
                    +
                    CASE
                        WHEN e.course_id IN (1, 2, 3) THEN 1
                        WHEN e.course_id IN (10, 11, 12) THEN -1
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


-- =========================================================
-- 13. SANITY CHECKS
-- =========================================================
SELECT COUNT(*) AS department_count FROM Departments;
SELECT COUNT(*) AS teacher_count FROM Teachers;
SELECT COUNT(*) AS student_count FROM Students;
SELECT COUNT(*) AS course_count FROM Courses;
SELECT COUNT(*) AS enrolment_count FROM Enrolments;
SELECT COUNT(*) AS assessment_count FROM Assessments;
SELECT COUNT(*) AS grade_count FROM Grades;

-- Expected totals:
-- Departments: 5
-- Teachers: 15
-- Students: 300
-- Courses: 15
-- Enrolments: 900
-- Assessments: 30
-- Grades: 1800


-- =========================================================
-- 14. ANALYSIS QUERIES
-- =========================================================

-- ---------------------------------------------------------
-- Query A: Course Performance
-- Calculates the weighted average grade for each course
-- ---------------------------------------------------------
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
JOIN Enrolments e
    ON g.enrolment_id = e.enrolment_id
JOIN Assessments a
    ON g.assessment_id = a.assessment_id
JOIN Courses c
    ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name
ORDER BY weighted_average_grade DESC;

-- ---------------------------------------------------------
-- Query B: Top 10 Students
-- Identifies the highest-performing students overall
-- ---------------------------------------------------------
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS weighted_average_grade,
    CASE
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 70 THEN 'First'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 60 THEN '2:1'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 50 THEN '2:2'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 40 THEN 'Third'
        ELSE 'Fail'
    END AS classification
FROM Students s
JOIN Enrolments e
    ON s.student_id = e.student_id
JOIN Grades g
    ON e.enrolment_id = g.enrolment_id
JOIN Assessments a
    ON g.assessment_id = a.assessment_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY weighted_average_grade DESC
LIMIT 10;

-- ---------------------------------------------------------
-- Query C: Department Performance by Course Ownership
-- Measures results in courses owned by each department
-- ---------------------------------------------------------
SELECT
    d.department_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS weighted_average_grade
FROM Departments d
JOIN Courses c
    ON d.department_id = c.department_id
JOIN Enrolments e
    ON c.course_id = e.course_id
JOIN Grades g
    ON e.enrolment_id = g.enrolment_id
JOIN Assessments a
    ON g.assessment_id = a.assessment_id
GROUP BY d.department_id, d.department_name
ORDER BY weighted_average_grade DESC;

-- ---------------------------------------------------------
-- Query D: Student Performance by Home Department
-- Measures how students from each department perform overall
-- ---------------------------------------------------------
SELECT
    d.department_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS weighted_average_grade
FROM Departments d
JOIN Students s
    ON d.department_id = s.department_id
JOIN Enrolments e
    ON s.student_id = e.student_id
JOIN Grades g
    ON e.enrolment_id = g.enrolment_id
JOIN Assessments a
    ON g.assessment_id = a.assessment_id
GROUP BY d.department_id, d.department_name
ORDER BY weighted_average_grade DESC;

-- ---------------------------------------------------------
-- Query E: Coursework vs Exam Performance
-- Compares average performance in coursework and exams
-- ---------------------------------------------------------
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
JOIN Assessments a
    ON g.assessment_id = a.assessment_id
GROUP BY a.assessment_type
ORDER BY average_score DESC;

-- ---------------------------------------------------------
-- Query F: Grade Distribution
-- Shows the number of results in each classification band
-- ---------------------------------------------------------
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

-- ---------------------------------------------------------
-- Query G: Enrolment vs Performance
-- Shows enrolment count and average performance per course
-- ---------------------------------------------------------
SELECT
    c.course_name,
    COUNT(DISTINCT e.student_id) AS total_enrolments,
    ROUND(SUM(g.score * a.weighting) / NULLIF(SUM(a.weighting), 0), 2) AS weighted_average_grade
FROM Courses c
LEFT JOIN Enrolments e
    ON c.course_id = e.course_id
LEFT JOIN Grades g
    ON e.enrolment_id = g.enrolment_id
LEFT JOIN Assessments a
    ON g.assessment_id = a.assessment_id
GROUP BY c.course_id, c.course_name
HAVING COUNT(DISTINCT e.student_id) > 0
ORDER BY total_enrolments DESC, weighted_average_grade DESC;

-- ---------------------------------------------------------
-- Query H: Student Course Results
-- Gives a course-level breakdown for each student
-- ---------------------------------------------------------
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_name,
    ROUND(SUM(g.score * a.weighting) / SUM(a.weighting), 2) AS course_average,
    CASE
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 70 THEN 'First'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 60 THEN '2:1'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 50 THEN '2:2'
        WHEN SUM(g.score * a.weighting) / SUM(a.weighting) >= 40 THEN 'Third'
        ELSE 'Fail'
    END AS classification
FROM Students s
JOIN Enrolments e
    ON s.student_id = e.student_id
JOIN Courses c
    ON e.course_id = c.course_id
JOIN Grades g
    ON e.enrolment_id = g.enrolment_id
JOIN Assessments a
    ON g.assessment_id = a.assessment_id
GROUP BY s.student_id, s.first_name, s.last_name, c.course_id, c.course_name
ORDER BY s.student_id, c.course_name;
