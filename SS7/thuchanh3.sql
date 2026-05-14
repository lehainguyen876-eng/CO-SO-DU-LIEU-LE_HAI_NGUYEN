create database ss7_thuchanh3;
use ss7_thuchanh3;

	create table regions (
    id int primary key,
    regionname varchar(50)
);

insert into regions (id, regionname) values
(1, 'miền bắc'),
(2, 'miền nam');

create table stores (
    id int primary key,
    storename varchar(100),
    regionid int,
    foreign key (regionid) references regions(id)
);

insert into stores (id, storename, regionid) values
(101, 'ch hà nội', 1),
(102, 'ch hcm', 2);

create table staffs (
    id int primary key,
    name varchar(100),
    storeid int,
    foreign key (storeid) references stores(id)
);

insert into staffs (id, name, storeid) values
(1001, 'nguyen van a', 101),
(1002, 'tran thi b', 101),
(1003, 'le van c', 102);

select name
from staffs
where storeid in 
(
    select id
    from stores
    where regionid in 
    (
        select id
        from regions
        where regionname = 'miền bắc'
    )
);