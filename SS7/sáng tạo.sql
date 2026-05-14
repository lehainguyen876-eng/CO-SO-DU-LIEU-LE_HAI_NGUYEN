CREATE DATABASE ss7_sangtao;
USE ss7_sangtao;

CREATE TABLE Courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    price DECIMAL(15, 2)
);

INSERT INTO Courses (title, price) VALUES 
('Java Core', 500000),
('Python AI', 700000),
('Web Basic', 300000),
('Database Design', 400000);

SELECT 
    title, 
    price, 
    (price - (SELECT AVG(price) FROM Courses)) AS Price_Difference
FROM Courses;