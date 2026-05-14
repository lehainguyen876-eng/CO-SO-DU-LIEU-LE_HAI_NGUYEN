create database tonghop_ss5;
use tonghop_ss5;

create table orders (
    id int primary key auto_increment,
    total_amount decimal(15, 2),
    status varchar(50),
    note text,
    user_id int null
);

insert into orders (total_amount, status, note, user_id) values
(4500000, 'delivered', 'giao gấp trong sáng nay', 101),
(2500000, 'pending', 'đơn hàng bình thường', null),
(3000000, 'shipping', 'cần gấp', 102),
(5500000, 'pending', 'giao gấp', 103),
(3500000, 'cancelled', 'giao gấp', 104),
(10000000, 'pending', 'đơn ảo siêu lớn', null),
(2100000, 'pending', 'không có từ khóa', 105),
(2200000, 'pending', 'đơn ảo 1', null),
(2300000, 'pending', 'đơn ảo 2', null),
(2400000, 'pending', 'đơn ảo 3', null);

select 
    id, 
    total_amount, 
    status, 
    note, 
    user_id,
    case 
        when total_amount > 4000000 then 'nguy hiểm'
        else 'bình thường'
    end as alert_level
from orders
where 
    (total_amount between 2000000 and 5000000)
    and (status <> 'cancelled')
    and (
        note like '%gấp%' 
        or user_id is null
    )
order by total_amount desc
limit 20 offset 40;