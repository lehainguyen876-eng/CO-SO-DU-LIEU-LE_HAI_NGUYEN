DROP TABLE IF EXISTS Patients;
CREATE TABLE Patients (
Patient_ID INT AUTO_INCREMENT PRIMARY KEY,
    Full_Name VARCHAR(100),
    Phone VARCHAR(20),
    Age INT,
    Room_Number INT,
    HIV_Status VARCHAR(50),
    Mental_Health_History VARCHAR(255),
    Address VARCHAR(255)
);

DELIMITER //
DROP TABLE IF EXISTS SeedPatients;
CREATE PROCEDURE SeedPatients()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Room_Number, HIV_Status, Mental_Health_History, Address)
        VALUES (
            CONCAT('Patient ', i), 
            CONCAT('090', i), 
            FLOOR(RAND()*100), 
            FLOOR(100 + RAND()*100),
            IF(RAND() > 0.5, 'Negative', 'Positive'),
            IF(RAND() > 0.8, 'Anxiety', 'None'),
            'Ho Chi Minh City'
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL SeedPatients();

CREATE VIEW Reception_Patient_View AS
SELECT 
    Patient_ID, 
    Full_Name, 
    Age, 
    Room_Number,
    Phone
FROM Patients
WHERE Age > 0
WITH CHECK OPTION;

SELECT * FROM Reception_Patient_View WHERE Phone = '09012345';

EXPLAIN SELECT * FROM Reception_Patient_View WHERE Phone = '09012345';

CREATE INDEX idx_phone ON Patients(Phone);

EXPLAIN SELECT * FROM Reception_Patient_View WHERE Phone = '09012345';

UPDATE Reception_Patient_View SET Age = 31 WHERE Patient_ID = 1;

UPDATE Reception_Patient_View SET Age = -5 WHERE Patient_ID = 1;

DELIMITER //
CREATE PROCEDURE TestInsert()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO Patients (Full_Name, Phone, Age, Room_Number, HIV_Status, Mental_Health_History, Address)
        VALUES ('New Patient', CONCAT('091', i), 30, 201, 'Negative', 'None', 'Hanoi');
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

CALL TestInsert();