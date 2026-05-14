CREATE DATABASE online_learning_db;
USE online_learning_db;

CREATE TABLE Teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name NVARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name NVARCHAR(100) NOT NULL,
    dob DATE,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name NVARCHAR(100) NOT NULL,
    description TEXT,
    lessons INT CHECK (lessons > 0),
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enroll_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    UNIQUE(student_id, course_id)
);

CREATE TABLE Score (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    midterm_score DECIMAL(4,2) CHECK (midterm_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    UNIQUE(student_id, course_id)
);

INSERT INTO Teacher (full_name, email) VALUES 
('Nguyễn Văn An', 'an.nv@university.edu.vn'),
('Lê Thị Bình', 'binh.lt@university.edu.vn'),
('Trần Văn Cường', 'cuong.tv@university.edu.vn'),
('Phạm Minh Đức', 'duc.pm@university.edu.vn'),
('Hoàng Lan Anh', 'anh.hl@university.edu.vn');

INSERT INTO Course (course_name, description, lessons, teacher_id) VALUES 
('SQL Cơ Bản', 'Làm quen với truy vấn dữ liệu', 10, 1),
('Python Pro', 'Lập trình Python ứng dụng', 20, 2),
('Web Design', 'Thiết kế giao diện UX/UI', 15, 3),
('Java Core', 'Lập trình Java hướng đối tượng', 25, 4),
('Data Science', 'Phân tích dữ liệu với R', 30, 5);

-- Thêm ít nhất 5 sinh viên
INSERT INTO Student (full_name, dob, email) VALUES 
('Nguyễn Sinh Viên A', '2005-01-01', 'sva@gmail.com'),
('Trần Sinh Viên B', '2005-02-02', 'svb@gmail.com'),
('Lê Sinh Viên C', '2004-03-03', 'svc@gmail.com'),
('Phạm Sinh Viên D', '2005-04-04', 'svd@gmail.com'),
('Hoàng Sinh Viên E', '2004-05-05', 'sve@gmail.com');

INSERT INTO Enrollment (student_id, course_id) VALUES 
(1, 1), (1, 2), (2, 1), (3, 3), (4, 4);

INSERT INTO Score (student_id, course_id, midterm_score, final_score) VALUES 
(1, 1, 8.5, 9.0),
(2, 1, 7.0, 7.5),
(3, 3, 9.0, 8.0);

UPDATE Student SET email = 'sinhvien_a_new@gmail.com' WHERE student_id = 1;

UPDATE Course SET description = 'Học SQL chuyên sâu cho Data' WHERE course_id = 1;

UPDATE Score SET final_score = 9.5 WHERE student_id = 1 AND course_id = 1;

DELETE FROM Enrollment WHERE enrollment_id = 5;

SELECT * FROM Student;

SELECT * FROM Teacher;

SELECT * FROM Course;

SELECT E.enrollment_id, S.full_name, C.course_name, E.enroll_date
FROM Enrollment E
JOIN Student S ON E.student_id = S.student_id
JOIN Course C ON E.course_id = C.course_id;

SELECT S.full_name, C.course_name, Sc.midterm_score, Sc.final_score
FROM Score Sc
JOIN Student S ON Sc.student_id = S.student_id
JOIN Course C ON Sc.course_id = C.course_id;