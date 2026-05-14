create database ss5_vd1;
use ss5_vd1;

CREATE TABLE Restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(255),
    address VARCHAR(255),
    district VARCHAR(50),
    rating DECIMAL(2,1)
);

INSERT INTO Restaurants (restaurant_name, address, district, rating) VALUES
('Phở Q1', '123 Lê Lợi', 'Quận 1', 2.5),    
('Cơm Tấm Q1', '45 NTMK', 'Quận 1', 4.5),   
('Bún Bò Q3', '78 Võ Văn Tần', 'Quận 3', 4.2), 
('Mì Quảng Q3', '10 Cách Mạng T8', 'Quận 3', 3.0), 
('Ốc Q4', '99 Vĩnh Khánh', 'Quận 4', 4.8); 

select restaurant_name, address, rating
from Restaurants
where district in ('Quận 1', 'Quận 3') 
  and rating > 4.0;