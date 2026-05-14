/* PHẦN PHÂN TÍCH LOGIC:
   1. Lỗi tài chính: Cột Price thiếu NOT NULL và CHECK (Price >= 0).
   2. Lỗi bộ nhớ: ProductName dùng VARCHAR(255) quá dài cho tên sản phẩm ngắn.
   3. Thiếu AUTO_INCREMENT cho ID dẫn đến khó quản lý bản ghi.
*/

CREATE DATABASE my_store;
USE my_store;

CREATE TABLE Products (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(15, 2) NOT NULL,
    Description VARCHAR(500)
);