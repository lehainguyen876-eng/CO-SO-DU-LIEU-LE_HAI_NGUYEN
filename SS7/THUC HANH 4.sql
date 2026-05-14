create database ss7_thuchanh4;
use ss7_thuchanh4;

create table customers (
    id int primary key,
    name varchar(100)
);

insert into customers (id, name) values
(1, 'nguyen van minh'),
(2, 'tran thi ha');

create table orders (
    id int primary key,
    totalamount int,
    customerid int,
    foreign key (customerid) references customers(id)
);

insert into orders (id, totalamount, customerid) values
(101, 500, 1),
(102, 300, 1),
(103, 200, null);

select customerid 
from orders 
where customerid is not null;

select * 
from (
    select customerid, sum(totalamount) 
    from orders 
    where customerid is not null 
    group by customerid
) as order_summary;

select customers.name, orders.totalamount
from customers
inner join orders on customers.id = orders.customerid;