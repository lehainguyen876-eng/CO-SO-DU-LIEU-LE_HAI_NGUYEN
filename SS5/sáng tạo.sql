CREATE DATABASE phantich_ss5;
USE phantich_ss5;

CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    fullname VARCHAR(255),
    total_orders INT
);

INSERT INTO Users (user_id, fullname, total_orders) VALUES
(1, 'Nguyen Van A', 600),   
(2, 'Le Thi B', 250),       
(3, 'Tran Van C', 45),        
(4, 'Pham Thi D', NULL),    
(5, 'Hoang Van E', 500);    

SELECT 
    fullname AS Ten_Khach_Hang,
    CASE 
        WHEN total_orders >= 500 THEN 'Kim Cương'
        WHEN total_orders >= 100 THEN 'Vàng'
        WHEN total_orders < 100  THEN 'Bạc'
        ELSE 'Bạc' 
    END AS Xep_Hang
FROM Users;