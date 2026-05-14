CREATE TABLE Records_North (
    Record_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100),
    Diagnosis TEXT,
    Record_Date DATE
);

CREATE TABLE Records_South (
    Record_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100),
    Diagnosis TEXT,
    Record_Date DATE
);

INSERT INTO Records_North VALUES (1, 'Nguyen Van A', 'Flu', '2026-04-28');
INSERT INTO Records_South VALUES (1, 'Le Thi B', 'Cold', '2026-04-28');

CREATE VIEW National_Record_View AS
SELECT *, 'North' AS Branch_Name FROM Records_North
UNION ALL
SELECT *, 'South' AS Branch_Name FROM Records_South;

SELECT * FROM National_Record_View;