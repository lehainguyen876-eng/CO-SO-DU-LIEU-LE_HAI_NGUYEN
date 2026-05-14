CREATE DATABASE IF NOT EXISTS session3_chuyen_sau;
USE session3_chuyen_sau;

CREATE TABLE CUSTOMERS (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    LastPurchaseDate DATE,
    Status VARCHAR(20),
    Gender VARCHAR(10),
    DateOfBirth DATE,
    Points INT,
    Address VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO CUSTOMERS (FullName, Email, City, LastPurchaseDate, Status) VALUES
('Nguyễn Văn A', 'anv@gmail.com', 'Hà Nội', '2025-05-20', 'Active'),
('Trần Thị B', 'btt@gmail.com', 'Hà Nội', '2026-02-10', 'Active'),
('Lê Văn C', NULL, 'Hà Nội', '2025-01-15', 'Active'),
('Phạm Minh D', 'dpm@gmail.com', 'Hà Nội', '2024-12-01', 'Locked'),
('Hoàng An E', 'eha@gmail.com', 'TP HCM', '2025-03-01', 'Active');

SELECT FullName, Email 
FROM CUSTOMERS
WHERE 
    City = 'Hà Nội' 
    AND LastPurchaseDate <= '2026-04-01' 
    AND Email IS NOT NULL 
    AND Status != 'Locked';