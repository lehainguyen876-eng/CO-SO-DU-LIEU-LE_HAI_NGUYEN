CREATE DATABASE SS11_VD1;
USE SS11_VD1;

CREATE TABLE IF NOT EXISTS appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100),
    doctor_name VARCHAR(100),
    appointment_date DATE,
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending'
);

INSERT INTO appointments (appointment_id, patient_name, doctor_name, appointment_date, status) VALUES
(101, 'Nguyen Van A', 'Dr. Smith', '2023-10-01', 'completed'),
(102, 'Tran Thi B', 'Dr. Jones', '2023-10-02', 'pending'),
(103, 'Le Van C', 'Dr. Smith', '2023-10-03', 'cancelled'),
(104, 'Pham Thi D', 'Dr. Jones', '2023-10-04', 'pending'),
(105, 'Hoang Van E', 'Dr. Smith', '2023-10-05', 'completed');

DROP PROCEDURE IF EXISTS cancelappointment;

DELIMITER //

CREATE PROCEDURE cancelappointment(IN p_appointment_id INT)
BEGIN
    UPDATE appointments
    SET status = 'cancelled'
    WHERE appointment_id = p_appointment_id 
      AND status = 'pending';
END //

DELIMITER ;

CALL cancelappointment(104);
SELECT * FROM appointments WHERE appointment_id = 104;

CALL cancelappointment(105);
SELECT * FROM appointments WHERE appointment_id = 105;