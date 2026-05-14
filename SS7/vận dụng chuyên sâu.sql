CREATE DATABASE ss7_vandungchuyensau;
USE ss7_vandungchuyensau;

CREATE TABLE Students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    amount DECIMAL(15, 2),
    payment_date DATETIME,
    INDEX idx_student_date (student_id, payment_date)
);

INSERT INTO Students (id, name, email) VALUES 
(1, 'Nguyen Van A', 'vana@gmail.com'),
(2, 'Le Thi B', 'thib@gmail.com'),
(3, 'Tran Van C', 'vanc@gmail.com'),
(4, 'Pham Minh D', 'minhd@gmail.com');

INSERT INTO Payments (student_id, amount, payment_date) VALUES 
(1, 500000, '2024-05-20 10:00:00'), 
(2, 200000, '2023-12-15 09:00:00'), 
(4, 1500000, '2024-01-10 14:30:00'); 

SELECT s.name, s.email
FROM Students s
WHERE NOT EXISTS (
    SELECT 1 
    FROM Payments p 
    WHERE p.student_id = s.id 
    AND p.payment_date >= '2024-01-01 00:00:00' 
    AND p.payment_date <= '2024-12-31 23:59:59'
);