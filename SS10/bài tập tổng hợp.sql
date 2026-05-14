CREATE TABLE Patients (
    Patient_ID CHAR(5) PRIMARY KEY,
    Full_Name VARCHAR(100) NOT NULL,
    Admission_Time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Vitals_Logs (
    Log_ID INT AUTO_INCREMENT PRIMARY KEY,
    Patient_ID CHAR(5),
    Heart_Rate INT CHECK (Heart_Rate > 0),
    Blood_Pressure VARCHAR(20),
    Record_Time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

CREATE INDEX idx_patient_time ON Vitals_Logs(Patient_ID, Record_Time);

CREATE VIEW ER_Dashboard_View AS
SELECT 
    p.Patient_ID,
    p.Full_Name,
    COALESCE(CAST(v.Heart_Rate AS CHAR), 'Pending') AS Current_Heart_Rate,
    v.Blood_Pressure,
    CASE 
        WHEN v.Heart_Rate > 120 OR v.Heart_Rate < 50 THEN 'CRITICAL'
        ELSE 'STABLE'
    END AS Urgency_Level,
    v.Record_Time
FROM Patients p
LEFT JOIN Vitals_Logs v ON p.Patient_ID = v.Patient_ID

WHERE v.Record_Time = (
    SELECT MAX(Record_Time) 
    FROM Vitals_Logs 
    WHERE Patient_ID = p.Patient_ID
) OR v.Record_Time IS NULL;

UPDATE ER_Dashboard_View 
SET Urgency_Level = 'STABLE' 
WHERE Patient_ID = 'BN001';