create database ss6_thuchanh1;
use ss6_thuchanh1;

create table departments (
    deptid int primary key,
    deptname varchar(50),
    rating varchar(20)
);

insert into departments (deptid, deptname, rating) values
(1, 'sales', 'excellent'),
(2, 'hr', 'good'),
(3, 'it', 'excellent');

create table employees (
    empid int primary key,
    empname varchar(100),
    phone varchar(15),
    kpiscore decimal(5,2),
    deptid int,
    foreign key (deptid) references departments(deptid)
);

insert into employees (empid, empname, phone, kpiscore, deptid) values
(1, 'nguyen van a', '0123456789', 85.5, 1),
(2, 'le thi b', '0987654321', 92.0, 1),
(3, 'tran van c', '0555444333', 70.5, 2),
(4, 'pham thi d', '0111222333', 88.0, 3);

select empname, kpiscore
from employees
where kpiscore > (select avg(kpiscore) from employees);

select *
from employees
where deptid in (select deptid from departments where rating = 'excellent');

select *
from (select empname, phone from employees) as employeecontacts;