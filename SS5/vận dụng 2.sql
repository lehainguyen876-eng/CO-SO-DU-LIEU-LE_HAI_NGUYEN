create database ss5_vdung;
use ss5_vdung;

CREATE TABLE IF NOT EXISTS Restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(255),
    created_at DATETIME
);

INSERT INTO Restaurants (restaurant_name, created_at) VALUES 
('Quán Phở Xưa', '2023-01-01 08:00:00'),
('Trà Sữa GenZ', '2026-04-20 10:30:00'),
('Bún Đậu Mắm Tôm', '2026-04-24 09:00:00'),
('Cơm Tấm Đêm', '2026-04-24 15:00:00'),
('Sushi Bar', '2025-12-25 18:00:00'),
('Lẩu Cá Đuối', '2026-04-24 14:00:00');

SELECT 
    restaurant_name, 
    created_at
FROM 
    Restaurants
ORDER BY 
    created_at DESC
LIMIT 5;
