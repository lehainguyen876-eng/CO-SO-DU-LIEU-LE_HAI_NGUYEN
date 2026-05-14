create database ss6_vandungcoban2;
use ss6_vandungcoban2;

create table rooms (
    room_id int primary key,
    hotel_id int,
    room_name varchar(100),
    price_per_night decimal(18, 2)
);

insert into rooms (room_id, hotel_id, room_name, price_per_night) values
(1, 101, 'phòng đơn tiêu chuẩn', 500000),
(2, 101, 'phòng đôi cao cấp', 800000),
(3, 102, 'phòng suite hướng biển', 1200000),
(4, 102, 'phòng deluxe', 950000),
(5, 103, 'phòng tập thể', 200000);

select hotel_id, min(price_per_night) as cheapest_price
from rooms
group by hotel_id;