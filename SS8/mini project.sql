create database if not exists mini_project;
use mini_project;

create table category (
    id int primary key auto_increment,
    name varchar(100) not null unique
);

create table customer (
    id int primary key auto_increment,
    name varchar(100) not null,
    email varchar(100) unique not null,
    birthday date,
    gender tinyint check (gender in (0, 1))
);

create table product (
    id int primary key auto_increment,
    name varchar(100) not null,
    price decimal(10, 2) not null check (price > 0),
    category_id int,
    foreign key (category_id) references category(id)
);

create table orders (
    id int primary key auto_increment,
    customer_id int,
    order_date date not null,
    foreign key (customer_id) references customer(id)
);

create table order_detail (
    order_id int,
    product_id int,
    quantity int not null check (quantity > 0),
    price_at_order decimal(10, 2),
    primary key (order_id, product_id),
    foreign key (order_id) references orders(id),
    foreign key (product_id) references product(id)
);

insert into category (name) values ('điện tử'), ('gia dụng'), ('thời trang'), ('sách'), ('đồ chơi');

insert into customer (name, email, birthday, gender) values 
('nguyen van a', 'a@gmail.com', '2000-01-01', 1),
('le thi b', 'b@gmail.com', '1995-05-10', 0),
('tran van c', 'c@gmail.com', '2005-12-20', 1),
('pham thi d', 'd@gmail.com', '2002-08-15', 0),
('hoang van e', 'e@gmail.com', '1990-03-30', 1);

insert into product (name, price, category_id) values 
('iphone 15', 25000000, 1),
('laptop dell', 18000000, 1),
('nồi chiên', 2000000, 2),
('áo thun', 300000, 3),
('sách sql', 150000, 4);

insert into orders (customer_id, order_date) values 
(1, '2024-01-10'), (2, '2024-02-15'), (3, '2024-03-05'), (1, '2024-04-20'), (4, '2024-05-01');

insert into order_detail (order_id, product_id, quantity, price_at_order) values 
(1, 1, 1, 25000000), 
(1, 2, 1, 18000000), 
(2, 3, 2, 2000000), 
(3, 4, 5, 300000),
(4, 1, 1, 25000000);

update product set price = 26000000 where id = 1;
update customer set email = 'nguyenvana_new@gmail.com' where id = 1;
delete from order_detail where order_id = 4 and product_id = 1;

select name, email, 
       case when gender = 1 then 'nam' else 'nữ' end as gender_text 
from customer;

select *, (year(now()) - year(birthday)) as age 
from customer 
order by age asc 
limit 3;

select o.id, o.order_date, c.name 
from orders o 
inner join customer c on o.customer_id = c.id;

select c.name, count(p.id) as total_products 
from category c 
join product p on c.id = p.category_id 
group by c.id, c.name 
having total_products >= 2;

select * from product 
where price > (select avg(price) from product);

select * from customer 
where id not in (select distinct customer_id from orders);

select * from product p1 
where price = (select max(price) from product p2 where p2.category_id = p1.category_id);

select name from customer where id in (
    select customer_id from orders where id in (
        select order_id from order_detail where product_id in (
            select id from product where category_id = (
                select id from category where name = 'điện tử'
            )
        )
    )
);