create database ss5_phantich;
use ss5_phantich;

CREATE TABLE IF NOT EXISTS Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255),
    reason VARCHAR(50),
    total_amount DECIMAL(10,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Orders (customer_name, reason, total_amount, created_at) VALUES 
('Anh Bình', 'KHACH_HUY', 150000, '2026-04-24 10:00:00'),
('Chị An', 'BOM_HANG', 220000, '2026-04-24 11:30:00'),
('Anh Tú', 'DELIVERED', 50000, '2026-04-24 12:00:00'), 
('Chị Hoa', 'QUAN_DONG_CUA', 300000, '2026-04-23 09:00:00'),
('Anh Đức', 'KHONG_CO_TAI_XE', 120000, '2026-04-24 14:00:00');

SELECT 
    order_id, 
    customer_name, 
    reason, 
    total_amount,
    created_at
FROM 
    Orders
WHERE 
    reason IN ('KHACH_HUY', 'QUAN_DONG_CUA', 'KHONG_CO_TAI_XE', 'BOM_HANG')
ORDER BY 
    created_at DESC;