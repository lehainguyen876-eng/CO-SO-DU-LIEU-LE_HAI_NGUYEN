CREATE DATABASE OnlineLearningSystem;
USE OnlineLearningSystem;

CREATE TABLE Instructor (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    duration INT NOT NULL, 
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    birthday DATE,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    UNIQUE (student_id, course_id) 
);

CREATE TABLE Result (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    midterm_score DECIMAL(4,2) CHECK (midterm_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    UNIQUE (student_id, course_id) 
);

INSERT INTO Instructor (full_name, email) VALUES 
('Nguyễn Văn A', 'anv@gmail.com'),
('Trần Thị B', 'btt@gmail.com'),
('Lê Văn C', 'clv@gmail.com'),
('Phạm Minh D', 'dpm@gmail.com'),
('Hoàng Anh E', 'eha@gmail.com');

INSERT INTO Course (course_name, description, duration, instructor_id) VALUES 
('Java Web', 'Lập trình backend với Java', 24, 1),
('React JS', 'Lập trình frontend hiện đại', 20, 2),
('Database MySQL', 'Thiết kế và quản trị CSDL', 15, 3),
('Python Basic', 'Cơ bản về Python', 12, 4),
('UI/UX Design', 'Thiết kế giao diện người dùng', 10, 5);

INSERT INTO Student (full_name, birthday, email) VALUES 
('Lê Hải Nguyên', '2005-01-01', 'nguyenlh@gmail.com'),
('Nguyễn Văn Nam', '2005-05-15', 'namnv@gmail.com'),
('Trần Thu Hà', '2005-10-20', 'hatt@gmail.com'),
('Lê Minh Tâm', '2004-12-30', 'tamlm@gmail.com'),
('Vũ Việt Hoàng', '2005-03-12', 'hoangvv@gmail.com');

INSERT INTO Enrollment (student_id, course_id, enrollment_date) VALUES 
(1, 1, '2026-04-01'),
(1, 2, '2026-04-02'),
(2, 3, '2026-04-01'),
(3, 1, '2026-04-05'),
(4, 5, '2026-04-10');

INSERT INTO Result (student_id, course_id, midterm_score, final_score) VALUES 
(1, 1, 8.5, 9.0),
(2, 3, 7.0, 8.0),
(3, 1, 6.5, 7.5);

UPDATE Student SET email = 'nguyen_new@gmail.com' WHERE student_id = 1;
UPDATE Course SET description = 'Lập trình ReactJS nâng cao' WHERE course_id = 2;
UPDATE Result SET final_score = 9.5 WHERE student_id = 1 AND course_id = 1;

DELETE FROM Enrollment WHERE student_id = 4 AND course_id = 5;


SELECT * FROM Student;

SELECT * FROM Instructor;

SELECT c.course_name, c.description, i.full_name AS teacher_name 
FROM Course c 
JOIN Instructor i ON c.instructor_id = i.instructor_id;


SELECT s.full_name, c.course_name, e.enrollment_date 
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Course c ON e.course_id = c.course_id;


SELECT s.full_name, c.course_name, r.midterm_score, r.final_score 
FROM Result r
JOIN Student s ON r.student_id = s.student_id
JOIN Course c ON r.course_id = c.course_id;