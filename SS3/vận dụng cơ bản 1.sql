CREATE DATABASE IF NOT EXISTS session3_van_dung;
USE session3_van_dung;

CREATE TABLE PRODUCTS (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    OriginalPrice DECIMAL(18, 2)
);

INSERT INTO PRODUCTS (ProductID, ProductName, Category, OriginalPrice)
VALUES
(1, 'iPhone 15', 'Electronics', 20000000),
(2, 'Samsung Refrigerator', 'Electronics', 15000000),
(3, 'Water Spinach', 'Food', 10000),
(4, 'Filtered Fresh Milk 4', 'Food', 28000);

SET SQL_SAFE_UPDATES = 0;

UPDATE PRODUCTS 
SET OriginalPrice = OriginalPrice * 0.9
WHERE Category = 'Electronics';

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM PRODUCTS;