create database if not exists mini_social_network ;
use mini_social_network;

drop table if exists post_logs;
drop table if exists friends;
drop table if exists likes;
drop table if exists comments;
drop table if exists posts;
drop table if exists users;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) not null unique,
    password varchar(255) not null,
    email varchar(100) not null unique,
    created_at datetime default current_timestamp
) engine=innodb;

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    like_count int default 0,
    comment_count int default 0,
    created_at datetime default current_timestamp,
    constraint fk_posts_user foreign key (user_id) references users(user_id),
    fulltext key ft_post_content (content)
) engine=innodb;

create table comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    constraint fk_comments_post foreign key (post_id) references posts(post_id) on delete cascade,
    constraint fk_comments_user foreign key (user_id) references users(user_id)
) engine=innodb;

create table likes (
    like_id int auto_increment primary key,
    user_id int not null,
    post_id int not null,
    created_at datetime default current_timestamp,
    constraint fk_likes_post foreign key (post_id) references posts(post_id) on delete cascade,
    constraint fk_likes_user foreign key (user_id) references users(user_id),
    constraint unique_user_post_like unique (user_id, post_id)
) engine=innodb;

create table friends (
    friendship_id int auto_increment primary key,
    user_id int not null,
    friend_id int not null,
    status varchar(20) default 'pending',
    created_at datetime default current_timestamp,
    constraint fk_friends_user foreign key (user_id) references users(user_id),
    constraint fk_friends_friend foreign key (friend_id) references users(user_id),
    constraint chk_not_self_friend check (user_id != friend_id),
    constraint chk_friend_status check (status in ('pending', 'accepted'))
) engine=innodb;

alter table friends add unique index uq_friendship_bidirectional (
    (least(user_id, friend_id)), 
    (greatest(user_id, friend_id))
);

create table post_logs (
    log_id int auto_increment primary key,
    post_id int not null,
    post_content text not null,
    deleted_at datetime default current_timestamp
) engine=innodb;

create or replace view view_user_info as
select user_id, username, email, created_at
from users;

delimiter $$
create procedure sp_register_user (
    in p_username varchar(50),
    in p_password varchar(255),
    in p_email varchar(100)
)
begin
    if exists (select 1 from users where username = p_username) then
        signal sqlstate '45000' set message_text = 'loi: ten dang nhap da ton tai!';
    elseif exists (select 1 from users where email = p_email) then
        signal sqlstate '45000' set message_text = 'loi: dia chi email da duoc dang ky!';
    else
        insert into users (username, password, email) values (p_username, p_password, p_email);
    end if;
end $$
delimiter ;

delimiter $$
create procedure sp_create_post (
    in p_user_id int,
    in p_content text
)
begin
    if not exists (select 1 from users where user_id = p_user_id) then
        signal sqlstate '45000' set message_text = 'loi: nguoi dung khong ton tai!';
    else
        insert into posts (user_id, content) values (p_user_id, p_content);
    end if;
end $$
delimiter ;

delimiter $$
create trigger tg_after_like_insert
after insert on likes
for each row
begin
    update posts set like_count = like_count + 1 where post_id = new.post_id;
end $$
delimiter ;

delimiter $$
create trigger tg_after_like_delete
after delete on likes
for each row
begin
    update posts 
    set like_count = case when like_count > 0 then like_count - 1 else 0 end 
    where post_id = old.post_id;
end $$
delimiter ;

delimiter $$
create trigger tg_after_comment_insert
after insert on comments
for each row
begin
    update posts set comment_count = comment_count + 1 where post_id = new.post_id;
end $$
delimiter ;

delimiter $$
create trigger tg_after_comment_delete
after delete on comments
for each row
begin
    update posts 
    set comment_count = case when comment_count > 0 then comment_count - 1 else 0 end 
    where post_id = old.post_id;
end $$
delimiter ;

delimiter $$
create procedure sp_send_friend_request (
    in p_user_id int,
    in p_friend_id int
)
begin
    if p_user_id = p_friend_id then
        signal sqlstate '45000' set message_text = 'loi: khong the gui loi moi ket ban cho chinh minh!';
    else
        insert into friends (user_id, friend_id, status) values (p_user_id, p_friend_id, 'pending');
    end if;
end $$
delimiter ;

delimiter $$
create procedure sp_respond_friend_request (
    in p_friendship_id int,
    in p_action varchar(10)
)
begin
    if not exists (select 1 from friends where friendship_id = p_friendship_id) then
        signal sqlstate '45000' set message_text = 'loi: yeu cau ket ban khong ton tai!';
    else
        if p_action = 'accept' then
            update friends set status = 'accepted' where friendship_id = p_friendship_id;
        elseif p_action = 'reject' then
            delete from friends where friendship_id = p_friendship_id;
        else
            signal sqlstate '45000' set message_text = 'loi: hanh dong khong hop le!';
        end if;
    end if;
end $$
delimiter ;

delimiter $$
create procedure sp_user_activity_report ()
begin
    select 
        u.user_id,
        u.username,
        u.email,
        count(distinct p.post_id) as total_posts,
        count(distinct l.like_id) as total_likes_given,
        count(distinct c.comment_id) as total_comments_made
    from users u
    left join posts p on u.user_id = p.user_id
    left join likes l on u.user_id = l.user_id
    left join comments c on u.user_id = c.user_id
    group by u.user_id, u.username, u.email
    order by total_posts desc, u.user_id asc;
end $$
delimiter ;

delimiter $$
create procedure sp_get_friend_recommendations (in p_user_id int)
begin
    with direct_friends as (
        select friend_id as person_id from friends where user_id = p_user_id and status = 'accepted'
        union
        select user_id as person_id from friends where friend_id = p_user_id and status = 'accepted'
    ),
    friends_of_friends as (
        select f.friend_id as recommended_id from friends f
        join direct_friends df on f.user_id = df.person_id where f.status = 'accepted'
        union
        select f.user_id as recommended_id from friends f
        join direct_friends df on f.friend_id = df.person_id where f.status = 'accepted'
    )
    select r.recommended_id, u.username, u.email, count(*) as mutual_friends_count
    from friends_of_friends r
    join users u on r.recommended_id = u.user_id
    where r.recommended_id != p_user_id
      and r.recommended_id not in (select person_id from direct_friends)
    group by r.recommended_id, u.username, u.email
    order by mutual_friends_count desc;
end $$
delimiter ;

delimiter $$
create trigger tg_after_post_delete
after delete on posts
for each row
begin
    insert into post_logs (post_id, post_content) values (old.post_id, old.content);
end $$
delimiter ;

delimiter $$
create procedure sp_delete_post (
    in p_post_id int,
    in p_user_id int
)
begin
    declare sql_error int default false;
    declare continue handler for sqlexception set sql_error = true;

    start transaction;
    if exists (select 1 from posts where post_id = p_post_id and user_id = p_user_id) then
        delete from posts where post_id = p_post_id;
        
        if sql_error then
            rollback;
            signal sqlstate '45000' set message_text = 'giao dich that bai!';
        else
            commit;
        end if;
    else
        rollback;
        signal sqlstate '45000' set message_text = 'loi: bai viet khong ton tai hoac khong co quyen xoa!';
    end if;
end $$
delimiter ;

delimiter $$
create procedure sp_delete_user_account (in p_user_id int)
begin
    declare sql_error int default false;
    declare continue handler for sqlexception set sql_error = true;

    start transaction;

    if exists (select 1 from users where user_id = p_user_id) then
        delete from likes where user_id = p_user_id or post_id in (select post_id from posts where user_id = p_user_id);
        delete from comments where user_id = p_user_id or post_id in (select post_id from posts where user_id = p_user_id);
        delete from friends where user_id = p_user_id or friend_id = p_user_id;
        delete from posts where user_id = p_user_id;
        delete from users where user_id = p_user_id;

        if sql_error then
            rollback;
            signal sqlstate '45000' set message_text = 'giao dich loi! da rollback.';
        else
            commit;
        end if;
    else
        rollback;
        signal sqlstate '45000' set message_text = 'loi: tai khoan khong ton tai.';
    end if;
end $$
delimiter ;

call sp_register_user('alex_mercer', 'hashed_p1', 'alex@network.com');
call sp_register_user('john_doe', 'hashed_p2', 'john@network.com');
call sp_register_user('marry_jane', 'hashed_p3', 'marry@network.com');
call sp_register_user('elon_musk', 'hashed_p4', 'elon@network.com');

call sp_create_post(1, 'hello world! trai nghiem mang xa hoi moi.');
call sp_create_post(2, 'mysql 8.0 mang lai nhieu cai tien rat dang gia.');
call sp_create_post(3, 'dang thiet ke kien truc he thong csdl mang xa hoi.');

insert into likes (user_id, post_id) values (2, 1), (3, 1), (1, 2);
insert into comments (post_id, user_id, content) values (1, 2, 'chao mung gia nhap he thong!'), (2, 3, 'chinh xac ban oi.');

call sp_send_friend_request(1, 2);
call sp_respond_friend_request(1, 'accept');

call sp_send_friend_request(2, 3);
call sp_respond_friend_request(2, 'accept');

insert into users (username, password, email) values 
('robert_downey', 'hashed_pw5', 'robert@network.com'),
('scarlett_j', 'hashed_pw6', 'scarlett@network.com'),
('chris_evans', 'hashed_pw7', 'chris@network.com');

insert into posts (user_id, content) values 
(5, 'love you 3000! bo phim moi tuyet voi qua.'),
(6, 'vua hoan thanh xong buoi tap cuong do cao.'),
(7, 'ai di xem phim vao cuoi tuan nay khong?');

insert into likes (user_id, post_id) values 
(5, 5), (6, 5), (7, 5), (5, 6), (6, 7);

insert into comments (post_id, user_id, content) values 
(5, 6, 'huyen thoai luon anh oi!'),
(5, 7, 'mot thoi de nho.'),
(6, 5, 'dinh cao qua chi yeu.'),
(7, 6, 'cho em dang ky mot slot di chung voi.');

call sp_send_friend_request(5, 6);
call sp_respond_friend_request(3, 'accept');

call sp_send_friend_request(6, 7);
call sp_respond_friend_request(4, 'accept');

select post_id, content, like_count, comment_count from posts;
select * from view_user_info;
call sp_user_activity_report();
call sp_get_friend_recommendations(5);
select post_id, content from posts where match(content) against('csdl mang xa hoi');
call sp_delete_post(3, 3);
select * from post_logs;
call sp_delete_user_account(1);
select * from users;
select * from posts;
select * from likes;
select * from friends;