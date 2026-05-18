create database SS14_phantich;
use SS14_phantich;

create table patients (
    patient_id int primary key,
    full_name varchar(100) not null,
    phone varchar(15) unique not null,
    date_of_birth date
);

create table patient_invoices (
    patient_id int primary key,
    total_due decimal(18,2) not null default 0,
    last_updated datetime default current_timestamp,
    foreign key (patient_id) references patients(patient_id)
);

create table wallets (
    patient_id int primary key,
    balance decimal(18,2) not null default 0,
    status varchar(20) not null default 'active',
    foreign key (patient_id) references patients(patient_id)
);

insert into patients (patient_id, full_name, phone, date_of_birth) values
(1, 'nguyen van an', '0901111222', '1990-05-15'),
(2, 'tran thi binh', '0912222333', '1985-08-20'),
(3, 'le hoang cuong', '0923333444', '2000-12-01');

insert into patient_invoices (patient_id, total_due) values
(1, 1500000.00), 
(2, 300000.00),
(3, 0.00);

insert into wallets (patient_id, balance, status) values
(1, 500000.00, 'active'),    
(2, 50000.00, 'active'),     
(3, 1000000.00, 'inactive');


drop procedure if exists process_payment;

delimiter //

create procedure process_payment(
    in p_patient_id int,
    in p_amount decimal(18,2),
    out p_status_message varchar(255)
)
begin
    declare v_balance decimal(18,2);
    declare v_status varchar(20);

    declare exit handler for sqlexception
    begin
        rollback;
        set p_status_message = 'lỗi: hệ thống gặp sự cố bất ngờ';
    end;

    start transaction;

    if p_amount <= 0 then
        rollback;
        set p_status_message = 'lỗi: số tiền thanh toán phải lớn hơn 0';
    else
        select balance, status into v_balance, v_status 
        from wallets 
        where patient_id = p_patient_id;

        if v_balance is null then
            rollback;
            set p_status_message = 'lỗi: tài khoản ví không tồn tại';
        elseif v_status != 'active' then
            rollback;
            set p_status_message = 'lỗi: ví điện tử đang bị khóa';
        elseif v_balance < p_amount then
            rollback;
            set p_status_message = 'lỗi: số dư ví không đủ để thanh toán';
        else
            update wallets 
            set balance = balance - p_amount 
            where patient_id = p_patient_id;

            update patient_invoices 
            set total_due = total_due - p_amount,
                last_updated = current_timestamp
            where patient_id = p_patient_id;

            commit;
            set p_status_message = 'thanh toán một chạm thành công';
        end if;
    end if;
end //

delimiter ;


set @result1 = '';
call process_payment(1, 200000, @result1);
select @result1 as status_1;
select * from wallets where patient_id = 1;
select * from patient_invoices where patient_id = 1;

set @result2 = '';
call process_payment(2, 100000, @result2);
select @result2 as status_2;
select * from wallets where patient_id = 2;
select * from patient_invoices where patient_id = 2;

set @result3 = '';
call process_payment(1, -50000, @result3);
select @result3 as status_3;