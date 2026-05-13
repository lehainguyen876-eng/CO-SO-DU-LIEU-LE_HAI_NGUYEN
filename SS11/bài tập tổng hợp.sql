create database SS11_tonghop;
use SS11_tonghop;

create table if not exists medicines (
    medicine_id int primary key,
    name varchar(100) not null,
    price decimal(18,2) not null,
    stock int not null default 0
);

create table if not exists patient_invoices (
    patient_id int primary key,
    total_due decimal(18,2) default 0
);

insert ignore into medicines values (1, 'amoxicillin 500mg', 15000, 100);
insert ignore into medicines values (2, 'panadol extra', 5000, 50);
insert ignore into patient_invoices (patient_id, total_due) values (1, 0), (2, 0);

drop procedure if exists processprescription;

delimiter $$

create procedure processprescription(
    in p_patient_id int,
    in p_medicine_id int,
    in p_quantity int,
    in p_discount_code varchar(20),
    out p_status_message varchar(100)
)
begin
    declare v_stock int;
    declare v_price decimal(18,2);
    declare v_amount decimal(18,2);

    select stock, price into v_stock, v_price 
    from medicines 
    where medicine_id = p_medicine_id;

    if v_stock < p_quantity then
        set p_status_message = 'Thất bại: Kho không đủ thuốc';
    else
        set v_amount = p_quantity * v_price;

        if p_discount_code = 'NV-RIKKEI' then
            set v_amount = v_amount * 0.5;
        end if;

        update medicines 
        set stock = stock - p_quantity 
        where medicine_id = p_medicine_id;

        update patient_invoices 
        set total_due = total_due + v_amount 
        where patient_id = p_patient_id;

        set p_status_message = 'Thành công: Đã xử lý đơn thuốc';
    end if;
end $$

delimiter ;

call processprescription(1, 1, 10, null, @msg1);
select @msg1 as status, total_due from patient_invoices where patient_id = 1;

call processprescription(1, 1, 10, 'NV-RIKKEI', @msg2);
select @msg2 as status, total_due from patient_invoices where patient_id = 1;

call processprescription(1, 1, 500, null, @msg3);
select @msg3 as status;