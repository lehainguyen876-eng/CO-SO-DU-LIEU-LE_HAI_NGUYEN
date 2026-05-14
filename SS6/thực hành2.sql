CREATE DATABASE thuchanh2_ss6;
USE thuchanh2_ss6;

CREATE TABLE Employees (
    EmpId INT PRIMARY KEY,
    FullName VARCHAR(50),
    Department VARCHAR(50)
);

INSERT INTO Employees (EmpId, FullName, Department) VALUES
(101, 'Nguyễn Văn Tuấn', 'IT'),
(102, 'Trần Mai Phương', 'IT'),
(103, 'Lê Quốc Bảo', 'Sales'),
(104, 'Phạm Hải Yến', 'Sales'),
(105, 'Hoàng Minh Trí', 'Sales'),
(106, 'Đặng Thị Hoa', 'Marketing'),
(107, 'Vũ Trọng Phụng', NULL);

SELECT 
    Department, 
    COUNT(EmpId) AS TotalEmployees
FROM 
    Employees
WHERE 
    Department IS NOT NULL
GROUP BY 
    Department
HAVING 
    TotalEmployees >= 2;