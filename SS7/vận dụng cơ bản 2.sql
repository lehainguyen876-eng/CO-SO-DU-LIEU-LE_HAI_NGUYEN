create database ss7_vandung2;
use ss7_vandung2;

create table payments (
    payment_id int auto_increment primary key,
    student_id int,
    amount decimal(15, 2)
);

insert into payments (student_id, amount) values
(1, 6000000), (1, 5000000), 
(2, 12000000),             
(3, 2000000),              
(4, 9000000);

select sum(total_spent) as grand_total_vip
from (
    select student_id, sum(amount) as total_spent
    from payments 
    group by student_id 
    having sum(amount) > 10000000
) as vip_student; 