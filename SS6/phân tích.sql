create database ss6_phantich;
use ss6_phantich;

create table bookings (
    booking_id int primary key,
    hotel_id int,
    total_price decimal(18, 2),
    status varchar(20)
);

insert into bookings (booking_id, hotel_id, total_price, status) values
(1, 101, 3500000, 'completed'),
(2, 101, 4000000, 'completed'),
(3, 101, 1500000, 'cancelled'),
(4, 102, 5000000, 'completed'),
(5, 102, 2000000, 'failed');

insert into bookings (booking_id, hotel_id, total_price, status)
select 
    n + 5, 
    101, 
    3200000, 
    'completed'
from (
    select a.n + b.n * 10 + c.n * 100 as n
    from (select 0 as n union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) a
    cross join (select 0 as n union all select 1 union all select 2 union all select 3 union all select 4 union all select 5 union all select 6 union all select 7 union all select 8 union all select 9) b
    cross join (select 0 as n union all select 1 union all select 2) c
) numbers
where n < 50;

select 
    hotel_id, 
    count(*) as total_completed,
    avg(total_price) as avg_revenue
from bookings
where status = 'completed'
group by hotel_id
having 
    count(*) >= 50 
    and avg(total_price) > 3000000;