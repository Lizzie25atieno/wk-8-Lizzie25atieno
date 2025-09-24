CREATE DATABASE student_records 
  CHARACTER SET utf8mb4 -- This command line ensures that the Database understands all letters and emojis.
  COLLATE utf8mb4_unicode_ci; -- This command line decides how letters are compared and sorted inside the box.
-- Use the student_records database we created.
USE student_records;

-- 1. Departments Table
-- Each department has a unique code (like SCI) and a name
CREATE TABLE Departments (
    dept_code VARCHAR(10) PRIMARY KEY,   -- Natural key (e.g., SCI, ENG)
    dept_name VARCHAR(100) NOT NULL UNIQUE -- Department name must be unique and not empty
) ENGINE=InnoDB; -- This comand line makes sure data doesn’t get lost if power goes out (transactions). Its like Making sure this databse is strong, safe, and has locks for my tables.


-- 2. Students Table
-- Stores information about students
-- Each student belongs to a department

CREATE TABLE Students (
    student_number VARCHAR(20) PRIMARY KEY, -- Natural student ID (e.g., S2025-001)
    first_name VARCHAR(50) NOT NULL,        -- Student’s first name
    last_name VARCHAR(50) NOT NULL,         -- Student’s last name
    date_of_birth DATE NOT NULL,            -- Birthday
    email VARCHAR(100) UNIQUE,              -- Must be unique
    phone VARCHAR(15),                      -- Phone number
    address VARCHAR(255),                   -- Student’s address
    enrollment_date DATE NOT NULL,          -- Date of joining
    dept_code VARCHAR(10),                  -- Department they belong to
    FOREIGN KEY (dept_code) REFERENCES Departments(dept_code)
        ON UPDATE CASCADE      -- If dept_code changes, student updates too
        ON DELETE SET NULL     -- If department is deleted, student still exists but has no dept
) ENGINE=InnoDB;


-- 3. Instructors Table
-- Stores teacher information
-- Each instructor belongs to a department
CREATE TABLE Instructors (
    instructor_number VARCHAR(20) PRIMARY KEY, -- Natural instructor ID (e.g., I2025-001)
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    dept_code VARCHAR(10), -- FK: which department they belong to
    FOREIGN KEY (dept_code) REFERENCES Departments(dept_code)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;


-- 4. Courses Table
-- Stores course information
-- Each course belongs to a department and is taught by one instructor

CREATE TABLE Courses (
    course_code VARCHAR(10) PRIMARY KEY,     -- Natural key (e.g., CS101)
    course_name VARCHAR(100) NOT NULL,       -- Name of the course
    credits INT NOT NULL,                    -- Number of credits
    dept_code VARCHAR(10),                   -- FK: Department offering the course
    instructor_number VARCHAR(20),           -- FK: Instructor teaching the course
    FOREIGN KEY (dept_code) REFERENCES Departments(dept_code)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (instructor_number) REFERENCES Instructors(instructor_number)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;


-- 5. Enrollments Table
-- Junction table: connects Students and Courses
-- One student can enroll in many courses
-- One course can have many students
-- Composite PK: student + course + semester

CREATE TABLE Enrollments (
    student_number VARCHAR(20),  -- FK: which student
    course_code VARCHAR(10),     -- FK: which course
    semester VARCHAR(20),        -- Example: 'sem 1 - 2025/2026'
    PRIMARY KEY (student_number, course_code, semester), -- Composite PK
    FOREIGN KEY (student_number) REFERENCES Students(student_number)
        ON UPDATE CASCADE
        ON DELETE CASCADE, -- If student is deleted, their enrollments vanish
    FOREIGN KEY (course_code) REFERENCES Courses(course_code)
        ON UPDATE CASCADE
        ON DELETE CASCADE  -- If course is deleted, related enrollments vanish
) ENGINE=InnoDB;


-- 6. Grades Table
-- Stores grade info for each enrollment
-- Linked to Enrollments table using (student, course, semester)

CREATE TABLE Grades (
    grade_id VARCHAR(20) PRIMARY KEY,        -- Natural grade ID (e.g., G2025-001)
    student_number VARCHAR(20),
    course_code VARCHAR(10),
    semester VARCHAR(20),
    grade_value VARCHAR(2) NOT NULL CHECK (grade_value IN ('A','B+','B','C+','C','D','F')), -- Letter grade
    grade_points DECIMAL(3,2), -- Numeric points (e.g., 4.00 for A)
    FOREIGN KEY (student_number, course_code, semester)
        REFERENCES Enrollments(student_number, course_code, semester)
        ON UPDATE CASCADE
        ON DELETE CASCADE -- If enrollment is deleted, grade also goes
) ENGINE=InnoDB;

-- Insert values into our tables.

-- 1. Departments 
INSERT INTO Departments (dept_code, dept_name) VALUES
('SCI', 'School of Science'),
('ENG', 'School of Engineering'),
('BUS', 'School of Business'),
('ART', 'School of Arts'),
('EDU', 'School of Education'),
('LAW', 'School of Law'),
('MED', 'School of Medicine'),
('AGR', 'School of Agriculture'),
('IT',  'School of Information Technology'),
('MUS', 'School of Music');


-- 2. Students 
INSERT INTO Students (student_number, first_name, last_name, date_of_birth, email, phone, address, enrollment_date, dept_code) VALUES
('S2025-001', 'Alice', 'Otieno', '2002-04-15', 'alice.otieno@example.com', '0711111111', 'Nairobi, Kenya', '2023-09-01', 'SCI'),
('S2025-002', 'Brian', 'Omondi', '2001-11-20', 'brian.omondi@example.com', '0722222222', 'Kisumu, Kenya', '2023-09-01', 'ENG'),
('S2025-003', 'Cynthia', 'Mwangi', '2003-01-10', 'cynthia.mwangi@example.com', '0733333333', 'Mombasa, Kenya', '2023-09-01', 'BUS'),
('S2025-004', 'David', 'Mutua', '2000-07-25', 'david.mutua@example.com', '0744444444', 'Eldoret, Kenya', '2023-09-01', 'ART'),
('S2025-005', 'Emily', 'Njenga', '2002-09-05', 'emily.njenga@example.com', '0755555555', 'Thika, Kenya', '2023-09-01', 'EDU'),
('S2025-006', 'Felix', 'Okoth', '2001-03-18', 'felix.okoth@example.com', '0766666666', 'Kakamega, Kenya', '2023-09-01', 'LAW'),
('S2025-007', 'Grace', 'Achieng', '2002-05-12', 'grace.achieng@example.com', '0777777777', 'Kisii, Kenya', '2023-09-01', 'MED'),
('S2025-008', 'Henry', 'Kimani', '2003-02-28', 'henry.kimani@example.com', '0788888888', 'Nakuru, Kenya', '2023-09-01', 'AGR'),
('S2025-009', 'Irene', 'Wanjiru', '2002-06-30', 'irene.wanjiru@example.com', '0799999999', 'Nyeri, Kenya', '2023-09-01', 'IT'),
('S2025-010', 'James', 'Odhiambo', '2000-12-19', 'james.odhiambo@example.com', '0700000000', 'Siaya, Kenya', '2023-09-01', 'MUS');


-- 3. Instructors
INSERT INTO Instructors (instructor_number, first_name, last_name, email, phone, dept_code) VALUES
('I2025-001', 'Tom', 'Kariuki', 'tom.kariuki@example.com', '0712345678', 'SCI'),
('I2025-002', 'Mary', 'Otieno', 'mary.otieno@example.com', '0723456789', 'ENG'),
('I2025-003', 'Peter', 'Mwangi', 'peter.mwangi@example.com', '0734567890', 'BUS'),
('I2025-004', 'Lucy', 'Kamau', 'lucy.kamau@example.com', '0745678901', 'ART'),
('I2025-005', 'Samuel', 'Ochieng', 'samuel.ochieng@example.com', '0756789012', 'EDU'),
('I2025-006', 'Janet', 'Njoroge', 'janet.njoroge@example.com', '0767890123', 'LAW'),
('I2025-007', 'Michael', 'Onyango', 'michael.onyango@example.com', '0778901234', 'MED'),
('I2025-008', 'Dorothy', 'Akinyi', 'dorothy.akinyi@example.com', '0789012345', 'AGR'),
('I2025-009', 'Kennedy', 'Muriithi', 'kennedy.muriithi@example.com', '0790123456', 'IT'),
('I2025-010', 'Agnes', 'Were', 'agnes.were@example.com', '0701234567', 'MUS');


-- 4. Courses 
-- Each course tied to a department and an instructor
INSERT INTO Courses (course_code, course_name, credits, dept_code, instructor_number) VALUES
('CS101', 'Intro to Computer Science', 3, 'SCI', 'I2025-001'),
('EN201', 'Engineering Mechanics', 4, 'ENG', 'I2025-002'),
('BU301', 'Principles of Accounting', 3, 'BUS', 'I2025-003'),
('AR101', 'History of Art', 2, 'ART', 'I2025-004'),
('ED202', 'Curriculum Studies', 3, 'EDU', 'I2025-005'),
('LW101', 'Introduction to Law', 4, 'LAW', 'I2025-006'),
('MD301', 'Human Anatomy', 5, 'MED', 'I2025-007'),
('AG101', 'Crop Science', 3, 'AGR', 'I2025-008'),
('IT201', 'Database Systems', 4, 'IT', 'I2025-009'),
('MU101', 'Music Theory', 2, 'MUS', 'I2025-010');


-- 5A. Enrollments 
-- Students taking courses in Sem-1 2025/2026
INSERT INTO Enrollments (student_number, course_code, semester) VALUES
('S2025-001', 'CS101', 'Sem-1 2025/2026'),
('S2025-002', 'EN201', 'Sem-1 2025/2026'),
('S2025-003', 'BU301', 'Sem-1 2025/2026'),
('S2025-004', 'AR101', 'Sem-1 2025/2026'),
('S2025-005', 'ED202', 'Sem-1 2025/2026'),
('S2025-006', 'LW101', 'Sem-1 2025/2026'),
('S2025-007', 'MD301', 'Sem-1 2025/2026'),
('S2025-008', 'AG101', 'Sem-1 2025/2026'),
('S2025-009', 'IT201', 'Sem-1 2025/2026'),
('S2025-010', 'MU101', 'Sem-1 2025/2026');


-- 6A. Grades 
-- Each enrollment gets a grade
INSERT INTO Grades (grade_id, student_number, course_code, semester, grade_value, grade_points) VALUES
('G2025-001', 'S2025-001', 'CS101', 'Sem-1 2025/2026', 'A', 4.00),
('G2025-002', 'S2025-002', 'EN201', 'Sem-1 2025/2026', 'B+', 3.50),
('G2025-003', 'S2025-003', 'BU301', 'Sem-1 2025/2026', 'B', 3.00),
('G2025-004', 'S2025-004', 'AR101', 'Sem-1 2025/2026', 'A', 4.00),
('G2025-005', 'S2025-005', 'ED202', 'Sem-1 2025/2026', 'C+', 2.50),
('G2025-006', 'S2025-006', 'LW101', 'Sem-1 2025/2026', 'B+', 3.50),
('G2025-007', 'S2025-007', 'MD301', 'Sem-1 2025/2026', 'A', 4.00),
('G2025-008', 'S2025-008', 'AG101', 'Sem-1 2025/2026', 'B', 3.00),
('G2025-009', 'S2025-009', 'IT201', 'Sem-1 2025/2026', 'A', 4.00),
('G2025-010', 'S2025-010', 'MU101', 'Sem-1 2025/2026', 'C', 2.00);



-- 5B. Enrollments (records for Sem-2 2025/2026)
-- Students taking courses in Sem-2 2025/2026
INSERT INTO Enrollments (student_number, course_code, semester) VALUES
('S2025-001', 'IT201', 'Sem-2 2025/2026'),   -- Alice now studies Database Systems
('S2025-002', 'BU301', 'Sem-2 2025/2026'),   -- Brian tries Accounting
('S2025-003', 'EN201', 'Sem-2 2025/2026'),   -- Cynthia switches to Engineering Mechanics
('S2025-004', 'ED202', 'Sem-2 2025/2026'),   -- David studies Curriculum Studies
('S2025-005', 'CS101', 'Sem-2 2025/2026'),   -- Emily learns Intro to Computer Science
('S2025-006', 'MU101', 'Sem-2 2025/2026'),   -- Felix explores Music Theory
('S2025-007', 'AG101', 'Sem-2 2025/2026'),   -- Grace tries Agriculture
('S2025-008', 'LW101', 'Sem-2 2025/2026'),   -- Henry studies Law
('S2025-009', 'AR101', 'Sem-2 2025/2026'),   -- Irene joins History of Art
('S2025-010', 'MD301', 'Sem-2 2025/2026');   -- James takes Human Anatomy


-- 6B. Grades (records for Sem-2 2025/2026)
-- Grades linked to the new enrollments
INSERT INTO Grades (grade_id, student_number, course_code, semester, grade_value, grade_points) VALUES
('G2025-011', 'S2025-001', 'IT201', 'Sem-2 2025/2026', 'A', 4.00),
('G2025-012', 'S2025-002', 'BU301', 'Sem-2 2025/2026', 'B', 3.00),
('G2025-013', 'S2025-003', 'EN201', 'Sem-2 2025/2026', 'B+', 3.50),
('G2025-014', 'S2025-004', 'ED202', 'Sem-2 2025/2026', 'C', 2.00),
('G2025-015', 'S2025-005', 'CS101', 'Sem-2 2025/2026', 'A', 4.00),
('G2025-016', 'S2025-006', 'MU101', 'Sem-2 2025/2026', 'C+', 2.50),
('G2025-017', 'S2025-007', 'AG101', 'Sem-2 2025/2026', 'B+', 3.50),
('G2025-018', 'S2025-008', 'LW101', 'Sem-2 2025/2026', 'A', 4.00),
('G2025-019', 'S2025-009', 'AR101', 'Sem-2 2025/2026', 'B', 3.00),
('G2025-020', 'S2025-010', 'MD301', 'Sem-2 2025/2026', 'A', 4.00);


-- 1. List all students with their enrolled courses (INNER JOIN)
-- INNER JOIN shows only students who are actually enrolled in a course.
SELECT Students.student_number, Students.first_name, Students.last_name, 
       Enrollments.course_code, Enrollments.semester
FROM Students
INNER JOIN Enrollments 
    ON Students.student_number = Enrollments.student_number;


-- 2. Show all students and their enrolled courses (LEFT JOIN)
-- LEFT JOIN shows ALL students, even if they are not enrolled in any course.
-- If a student has no enrollment, course_code and semester will be NULL.
SELECT Students.student_number, Students.first_name, Students.last_name, 
       Enrollments.course_code, Enrollments.semester
FROM Students
LEFT JOIN Enrollments 
    ON Students.student_number = Enrollments.student_number;


-- 3. Show all courses and the students enrolled in them (RIGHT JOIN)
-- RIGHT JOIN ensures we see ALL courses, even if no students have enrolled.
-- If no student is enrolled, student_number will be NULL.
SELECT Students.student_number, Students.first_name, Students.last_name, 
       Courses.course_code, Courses.course_name
FROM Students
RIGHT JOIN Enrollments 
    ON Students.student_number = Enrollments.student_number
RIGHT JOIN Courses 
    ON Enrollments.course_code = Courses.course_code;


-- 4. Show all instructors and the courses they teach (LEFT JOIN)
-- LEFT JOIN ensures we see ALL instructors, even those who are not teaching any course yet.
SELECT Instructors.instructor_number, Instructors.first_name, Instructors.last_name, 
       Courses.course_name
FROM Instructors
LEFT JOIN Courses 
    ON Instructors.instructor_number = Courses.instructor_number;


-- 5. Show all courses with their departments (INNER JOIN)
-- Every course must belong to a department, so INNER JOIN is fine here.
SELECT Courses.course_code, Courses.course_name, Departments.dept_name
FROM Courses
INNER JOIN Departments 
    ON Courses.dept_code = Departments.dept_code;


-- 6. Show all departments and the instructors in them (LEFT JOIN)
-- LEFT JOIN ensures we see ALL departments, even if no instructors exist in them.
SELECT Departments.dept_code, Departments.dept_name, 
       Instructors.instructor_number, Instructors.first_name, Instructors.last_name
FROM Departments
LEFT JOIN Instructors 
    ON Departments.dept_code = Instructors.dept_code;


-- Create an index on last_name so searching/filtering students by surname is faster
CREATE INDEX idx_student_lastname
ON Students (last_name);

-- Create an index on semester in Enrollments to speed up queries by semester
CREATE INDEX idx_enrollment_semester
ON Enrollments (semester);

-- Create a composite index (multiple columns) for frequent queries using both course_code and semester
CREATE INDEX idx_course_semester
ON Enrollments (course_code, semester);

-- Create a new user (replace 'password123' with a secure password)
CREATE USER 'student_admin'@'localhost' IDENTIFIED BY 'password123';

-- Grant INSERT privilege so this user can only add records, not delete or drop tables
GRANT INSERT ON student_records.* TO 'student_admin'@'localhost';

-- Now ALTER the user: for example, change the password
ALTER USER 'student_admin'@'localhost' IDENTIFIED BY 'newsecurepassword';

-- Granting more privilege to the user
GRANT UPDATE ON student_records.* TO 'student_admin'@'localhost';

