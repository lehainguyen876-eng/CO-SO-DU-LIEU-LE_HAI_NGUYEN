CREATE DATABASE ss7_phantich;
USE ss7_phantich;

CREATE TABLE Courses (
    id INT PRIMARY KEY,
    title VARCHAR(255)
);

CREATE TABLE Enrollments (
    enroll_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT 
);

INSERT INTO Courses VALUES (1, 'Java Core'), (2, 'Python for AI');

INSERT INTO Enrollments (course_id) VALUES (1), (NULL);

SELECT * FROM Courses c
WHERE NOT EXISTS (
    SELECT 1 FROM Enrollments e WHERE e.course_id = c.id
);