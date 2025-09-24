# Student Records Database

## Table of Contents

1. Project Overview
2. Database Design
3. Tables and Relationships
4. Sample Data
5. SQL Queries
6. Indexes
7. User Management
8. How to Run
9. Author

---

## Project Overview

This project implements a **Student Records Management System** using **MySQL**. The system manages information about:

* Students
* Instructors
* Departments
* Courses
* Enrollments
* Grades

It demonstrates proper **relational database design**, including **primary keys, foreign keys, composite keys, and constraints**, as well as **indexes** for optimized querying.

The database uses **utf8mb4 character set** to fully support text, including emojis, and ensures reliable transactions using the **InnoDB engine**.

---

## Database Design

The database `student_records` is structured to maintain **data integrity, consistency, and relationships**. Key features include:

* Natural primary keys for students, instructors, courses, and departments.
* Composite primary keys for enrollments (student + course + semester).
* Foreign keys with `ON UPDATE CASCADE` and `ON DELETE SET NULL/ CASCADE` to handle changes and deletions safely.
* Constraints on grade values and uniqueness of key fields like emails and department names.

---

## Tables and Relationships

| Table           | Description                                                            |
| --------------- | ---------------------------------------------------------------------- |
| **Departments** | Stores department codes and names (unique).                            |
| **Students**    | Stores student personal info and department affiliation.               |
| **Instructors** | Stores instructor personal info and department affiliation.            |
| **Courses**     | Stores courses, their department, and assigned instructor.             |
| **Enrollments** | Junction table linking students to courses per semester. Composite PK. |
| **Grades**      | Stores grades for each enrollment. Linked to Enrollments.              |

### Relationship Highlights

* **One-to-Many**: Department → Students, Department → Instructors, Department → Courses
* **Many-to-Many**: Students ↔ Courses (via Enrollments)
* **Grades** linked to each enrollment to store the student's result.

---

## Sample Data

* 10 Departments (SCI, ENG, BUS, ART, EDU, LAW, MED, AGR, IT, MUS)
* 10 Students with full personal info
* 10 Instructors assigned to departments
* 10 Courses linked to departments and instructors
* Enrollments for **Sem-1** and **Sem-2 2025/2026**
* Grades for all enrollments with letter and numeric points

---

## SQL Queries

The database includes sample queries demonstrating **INNER JOIN, LEFT JOIN, RIGHT JOIN**:

1. List all students with their enrolled courses (INNER JOIN)
2. Show all students, even if not enrolled (LEFT JOIN)
3. Show all courses and enrolled students (RIGHT JOIN)
4. Show all instructors and courses they teach (LEFT JOIN)
5. Show all courses with their departments (INNER JOIN)
6. Show all departments and instructors (LEFT JOIN)

---

## Indexes

* **`idx_student_lastname`**: Speeds up searches by student last name
* **`idx_enrollment_semester`**: Speeds up queries filtered by semester
* **`idx_course_semester`**: Optimizes queries filtering by course and semester

---

## User Management

* Created a user: **`student_admin`**
* Privileges:

  * `INSERT` to add records
  * `UPDATE` to modify existing records
* Password can be securely altered using `ALTER USER`.

---

## How to Run

1. Open MySQL Workbench or any SQL client.
2. Copy and execute the full SQL script starting with:

   ```sql
   CREATE DATABASE student_records CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE student_records;
   ```
3. Execute table creation commands, sample data inserts, and queries.
4. Test the queries provided to see the relationships and joins in action.

---

## Author

**Elizabeth Atieno**

* Designed and implemented the database
* Created sample data and queries for testing and demonstration
