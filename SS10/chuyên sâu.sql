CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100)
);

CREATE TABLE Invoices (
    Invoice_ID INT PRIMARY KEY,
    Patient_ID INT,
    Dept_ID INT,
    Amount DECIMAL(10, 2)
);

INSERT INTO Departments VALUES (1, 'Nội'), (2, 'Ngoại');
INSERT INTO Invoices VALUES 
(101, 1, 1, 500.00), 
(102, 2, 1, 300.00), 
(103, 3, 2, 1000.00);

CREATE VIEW Department_Revenue_View AS
SELECT 
    d.Dept_Name,
    COUNT(i.Patient_ID) AS Total_Patients,
    SUM(i.Amount) AS Total_Revenue
FROM Departments d
LEFT JOIN Invoices i ON d.Dept_ID = i.Dept_ID
GROUP BY d.Dept_Name;

SELECT * FROM Department_Revenue_View;

UPDATE Department_Revenue_View 
SET Total_Revenue = 5000 
WHERE Dept_Name = 'Nội';