create database ss6_vandunghchuyensau;
use ss6_vandunghchuyensau;

create table bookings (
    booking_id int primary key,
    user_id int,
    status varchar(20)
);

insert into bookings (booking_id, user_id, status) values
(1, 1001, 'completed'), (2, 1001, 'cancelled'), (3, 1001, 'cancelled'), 
(4, 1001, 'cancelled'), (5, 1001, 'cancelled'), (6, 1001, 'cancelled'),
(7, 1001, 'cancelled'), (8, 1001, 'completed'), (9, 1001, 'completed'),
(10, 1001, 'completed'), (11, 1002, 'completed'), (12, 1002, 'cancelled');

select 
    user_id, 
    count(*) as total_bookings,
    sum(case when status = 'cancelled' then 1 else 0 end) as cancelled_bookings
from bookings
group by user_id
having 
    count(*) >= 10 
    and sum(case when status = 'cancelled' then 1 else 0 end) > 5;