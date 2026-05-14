create database ss6_vandungcoban;
use ss6_vandungcoban;

create table bookings (
    id int primary key,
    city varchar(50),
    total_price decimal(18, 2),
    status varchar(20)
);

insert into bookings (id, city, total_price, status) values
(1, 'da nang', 5000000000, 'completed'),
(2, 'nha trang', 3000000000, 'completed'),
(3, 'ha noi', 1000000000, 'cancelled'),
(4, 'hue', 0, 'completed');

select city, sum(total_price) as revenue
from bookings
where status = 'completed'
group by city
having sum(total_price) > 0;