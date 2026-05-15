CREATE DATABASE IF NOT EXISTS RikkeiClinicDB;
USE RikkeiClinicDB;


CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    date_of_birth DATE
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(18,2) NOT NULL
);

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE Beds (
    bed_id INT PRIMARY KEY,
    dept_id INT NOT NULL,
    patient_id INT DEFAULT NULL,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE Patient_Invoices (
    patient_id INT PRIMARY KEY,
    total_due DECIMAL(18,2) NOT NULL DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(18,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE Services (
    service_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(18,2) NOT NULL
);

CREATE TABLE Wallets (
    patient_id INT PRIMARY KEY,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

CREATE TABLE Service_Usages (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    actual_price DECIMAL(18,2) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);


INSERT INTO Patients VALUES 
(1, 'Nguyen Van An', '0901111222', '1990-05-15');
INSERT INTO Patients VALUES 
(2, 'Tran Thi Binh', '0912222333', '1985-08-20');
INSERT INTO Patients VALUES 
(3, 'Le Hoang Cuong', '0923333444', '2000-12-01');

INSERT INTO Employees VALUES 
(101, 'Dr. Hoang Minh', 'Doctor', 20000.00);
INSERT INTO Employees VALUES 
(102, 'Dr. Lan Anh', 'Doctor', 25000.00);
INSERT INTO Employees VALUES 
(103, 'Nurse Thu Ha', 'Nurse', 12000.00);

INSERT INTO Departments VALUES 
(1, 'Khoa Ngoai'), 
(2, 'Khoa Noi'), 
(3, 'Khoa ICU');

INSERT INTO Beds VALUES 
(101, 1, 1), 
(201, 2, NULL),
(301, 3, 2);

INSERT INTO Appointments VALUES 
(104, 1, 101, '2026-06-10 08:30:00', 'Pending');
INSERT INTO Appointments VALUES 
(105, 2, 102, '2026-05-01 09:00:00', 'Completed');
INSERT INTO Appointments VALUES 
(106, 3, 101, '2026-05-02 10:00:00', 'Cancelled');

INSERT INTO Inventory VALUES 
(10, 'Khau trang y te N95', 1000), 
(11, 'Gang tay vo trung', 500), 
(12, 'Dung dich sat khuan', 200);
INSERT INTO Medicines VALUES 
(1, 'Amoxicillin 500mg', 15000, 100), 
(2, 'Panadol Extra', 5000, 5);
INSERT INTO Patient_Invoices VALUES 
(1, 1500000.00, NOW()), 
(2, 0, NOW()), 
(3, 0, NOW());
INSERT INTO Products (name, price, stock) VALUES 
('May do huyet ap Omron', 850000.00, 20), 
('May do duong huyet', 450000.00, 15);
INSERT INTO Services VALUES 
(1, 'Sieu am o bung', 200000.00), 
(2, 'Xet nghiem mau', 150000.00), 
(3, 'Chup X-Quang', 250000.00);
INSERT INTO Wallets VALUES 
(1, 500000.00, 'Active'), 
(2, 50000.00, 'Active'), 
(3, 1000000.00, 'Inactive');

DROP TRIGGER IF EXISTS PreventPastAppointments;
DELIMITER //
CREATE TRIGGER PreventPastAppointments
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF NEW.appointment_date < NOW() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'lỗi: không thể đặt lịch khám vào thời điểm trong quá khứ';
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS PreventStatusRevert;
DELIMITER //
CREATE TRIGGER PreventStatusRevert
BEFORE UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lỗi: không được phép thay đổi trạng thái của những lịch khám đã hoàn thành';
    END IF;
END //
DELIMITER ;

select appointment_id, patient_id, appointment_date, status 
from Appointments;

select * from Appointments where appointment_id = 104;

select * from Appointments where appointment_date < now();

select * from Appointments where status = 'Completed';
