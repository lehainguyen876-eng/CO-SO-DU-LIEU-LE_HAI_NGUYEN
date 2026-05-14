CREATE TABLE Pharmacy_Inventory (
    Inventory_ID INT AUTO_INCREMENT PRIMARY KEY,
    Drug_Name VARCHAR(255),
    Batch_Number VARCHAR(50),
    Expiry_Date DATE,
    Quantity INT
);

CREATE INDEX idx_drug_name ON Pharmacy_Inventory(Drug_Name);
CREATE INDEX idx_expiry_date ON Pharmacy_Inventory(Expiry_Date);

DROP INDEX idx_drug_name ON Pharmacy_Inventory;
DROP INDEX idx_expiry_date ON Pharmacy_Inventory;

CREATE INDEX idx_drug_expiry ON Pharmacy_Inventory(Drug_Name, Expiry_Date);

EXPLAIN SELECT * FROM Pharmacy_Inventory 
WHERE Drug_Name = 'Paracetamol' AND Expiry_Date < '2026-12-31';

ALTER TABLE Pharmacy_Inventory ADD FULLTEXT(Drug_Name);
SELECT * FROM Pharmacy_Inventory WHERE MATCH(Drug_Name) AGAINST('Sero');