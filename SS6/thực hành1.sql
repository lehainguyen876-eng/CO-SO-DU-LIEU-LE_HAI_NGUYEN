CREATE DATABASE thuchanh_ss6;
USE thuchanh_ss6;

CREATE TABLE Departments (
    DeptId INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

INSERT INTO Departments (DeptId, DeptName) VALUES
(1, 'IT'),
(2, 'Sales'),
(3, 'Marketing');

CREATE TABLE Employees (
    EmpId INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptId INT
);

INSERT INTO Employees (EmpId, EmpName, DeptId) VALUES
(101, 'Nguyễn Văn Tuấn', 1),
(102, 'Trần Mai Phương', 1),
(103, 'Lê Quốc Bảo', NULL);

SELECT * FROM Employees AS e INNER JOIN Departments AS d ON e.DeptId = d.DeptId;

SELECT * FROM Employees AS e LEFT JOIN Departments AS d ON e.DeptId = d.DeptId;

SELECT * FROM Employees AS e RIGHT JOIN Departments AS d ON e.DeptId = d.DeptId;