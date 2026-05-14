create database ss5_vdungchuyensau;
use ss5_vdungchuyensau;

CREATE TABLE IF NOT EXISTS Drivers (
    driver_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_name VARCHAR(255),
    status VARCHAR(50),
    trust_score INT,
    distance_km DECIMAL(5,2)
);

INSERT INTO Drivers (driver_name, status, trust_score, distance_km) VALUES 
('Nguyễn Văn A', 'AVAILABLE', 90, 1.5),  
('Trần Thị B', 'AVAILABLE', 85, 1.5),    
('Lê Văn C', 'AVAILABLE', 95, 0.5),      
('Phạm Văn D', 'BUSY', 99, 0.2),         
('Hoàng Văn E', 'AVAILABLE', 70, 0.4);   

select
    driver_id, 
    driver_name, 
    status, 
    trust_score, 
    distance_km
from 
    Drivers
where 
    status = 'AVAILABLE'               
    AND trust_score >= 80              

order by 
    distance_km ASC,                   
    trust_score DESC;                  