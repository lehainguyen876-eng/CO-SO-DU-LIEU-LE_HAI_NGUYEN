create database SS11_VD2;
use SS11_VD2;

create table if not exists inventory (
    item_id int primary key,
    item_name varchar(100) not null,
    stock_quantity int not null default 0
);

insert ignore into inventory (item_id, item_name, stock_quantity) 
values (10, 'khau trang y te n95', 1000);

drop procedure if exists addinventory;

delimiter //

create procedure addinventory(in p_item_id int, in p_quantity int)
begin
    if p_quantity > 0 then
        update inventory
        set stock_quantity = stock_quantity + p_quantity
        where item_id = p_item_id;
    else
        signal sqlstate '45000'
        set message_text = 'loi: so luong nhap kho phai lon hon 0';
    end if;
end //

delimiter ;

