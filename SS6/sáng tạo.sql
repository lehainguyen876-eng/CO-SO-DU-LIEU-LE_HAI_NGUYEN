create database ss6_sangtao;
use ss6_sangtao;

create table rooms (
    room_id int primary key,
    room_name varchar(100)
);

create table bookings (
    booking_id int primary key,
    room_id int,
    status varchar(20)
);

insert into rooms (room_id, room_name) values
(1, 'phòng tiêu chuẩn 101'),
(2, 'phòng tiêu chuẩn 102'),
(3, 'phòng vip 201'),
(4, 'phòng tổng thống');

insert into bookings (booking_id, room_id, status) values
(1, 1, 'completed'),
(2, 2, 'cancelled'),
(3, null, 'failed'); -- bản ghi có room_id null gây bẫy logic

select 
    r.room_id, 
    r.room_name
from rooms r
left join bookings b on r.room_id = b.room_id
where b.room_id is null;