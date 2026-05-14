create database ss7_thuchanh2;
use ss7_thuchanh2;alter

create table students (
    id int primary key,
    name varchar(100),
    classid varchar(10),
    score decimal(4,1)
);

insert into students (id, name, classid, score) values
(1, 'nguyen van a', 'a1', 8),
(2, 'tran thi b', 'a1', 9),
(3, 'le van c', 'a2', 5),
(4, 'pham thi d', 'a2', 6),
(5, 'hoang van e', 'a3', 10);

select *
from students
where score > (select avg(score) from students);

select classid, avg(score) as averagescore
from students
group by classid
having avg(score) > (select avg(score) * 1.2 from students);