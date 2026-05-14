create database ss7_vandung;
use ss7_vandung;

create table courses (
	id int auto_increment primary key,
    title varchar(50),
    price decimal(10, 2),
    instructor_id int
);

insert into courses (title, price, instructor_id) value
('HTML5 & CSS3', 500000, 5),
('JavaScript Basic', 600000, 5),
('Java Core', 500000, 10),
('Python for AI', 600000, 11),
('Database Design', 450000, 12),
('NodeJS Backend', 800000, 13);

select title, price from courses 
where price in ( 
	select price 
    from courses
    where instructor_id = 5
);