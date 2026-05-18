drop database if exists rikkeiclinicdb;
create database rikkeiclinicdb;
use rikkeiclinicdb;

create table patients (
    patient_id int primary key,
    full_name varchar(100) not null,
    phone varchar(15) unique not null,
    date_of_birth date
);

create table employees (
    employee_id int primary key,
    full_name varchar(100) not null,
    position varchar(50) not null,
    salary decimal(18,2) not null
);

create table departments (
    dept_id int primary key,
    dept_name varchar(100) not null
);

create table beds (
    bed_id int primary key,
    dept_id int not null,
    patient_id int default null,
    foreign key (dept_id) references departments(dept_id),
    foreign key (patient_id) references patients(patient_id)
);

create table appointments (
    appointment_id int primary key,
    patient_id int not null,
    doctor_id int not null,
    appointment_date datetime not null,
    status varchar(20) not null default 'pending',
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references employees(employee_id)
);

create table inventory (
    item_id int primary key,
    item_name varchar(100) not null,
    stock_quantity int not null default 0
);

create table medicines (
    medicine_id int primary key,
    name varchar(100) not null,
    price decimal(18,2) not null,
    stock int not null default 0
);

create table patient_invoices (
    patient_id int primary key,
    total_due decimal(18,2) not null default 0,
    last_updated datetime default current_timestamp,
    foreign key (patient_id) references patients(patient_id)
);

create table products (
    product_id int auto_increment primary key,
    name varchar(150) not null,
    price decimal(18,2) not null,
    stock int not null default 0
);

create table services (
    service_id int primary key,
    name varchar(100) not null,
    price decimal(18,2) not null
);

create table wallets (
    patient_id int primary key,
    balance decimal(18,2) not null default 0,
    status varchar(20) not null default 'active',
    foreign key (patient_id) references patients(patient_id)
);

create table service_usages (
    usage_id int auto_increment primary key,
    patient_id int not null,
    service_id int not null,
    actual_price decimal(18,2) default 0,
    created_at datetime default current_timestamp,
    foreign key (patient_id) references patients(patient_id),
    foreign key (service_id) references services(service_id)
);

insert into patients (patient_id, full_name, phone, date_of_birth) values
(1, 'nguyen van an', '0901111222', '1990-05-15'),
(2, 'tran thi binh', '0912222333', '1985-08-20'),
(3, 'le hoang cuong', '0923333444', '2000-12-01');

insert into employees (employee_id, full_name, position, salary) values
(101, 'dr. hoang minh', 'doctor', 20000.00),
(102, 'dr. lan anh', 'doctor', 25000.00),
(103, 'nurse thu ha', 'nurse', 12000.00);

insert into departments (dept_id, dept_name) values
(1, 'khoa ngoai'),
(2, 'khoa noi'),
(3, 'khoa icu');

insert into beds (bed_id, dept_id, patient_id) values
(101, 1, 1),    
(201, 2, null), 
(301, 3, 2);    

insert into appointments (appointment_id, patient_id, doctor_id, appointment_date, status) values
(104, 1, 101, '2026-06-10 08:30:00', 'pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'cancelled');

insert into inventory (item_id, item_name, stock_quantity) values
(10, 'khau trang y te n95', 1000),
(11, 'gang tay vo trung', 500),
(12, 'dung dich sat khuan', 200);

insert into medicines (medicine_id, name, price, stock) values
(1, 'amoxicillin 500mg', 15000, 100),  
(2, 'panadol extra', 5000, 5);         

insert into patient_invoices (patient_id, total_due) values
(1, 1500000.00), 
(2, 0),
(3, 0);

insert into products (name, price, stock) values
('may do huyet ap omron', 850000.00, 20),
('may do duong huyet', 450000.00, 15);

insert into services (service_id, name, price) values
(1, 'sieu am o bung', 200000.00),
(2, 'xet nghiem mau', 150000.00),
(3, 'chup x-ray', 250000.00);

insert into wallets (patient_id, balance, status) values
(1, 500000.00, 'active'),    
(2, 50000.00, 'active'),     
(3, 1000000.00, 'inactive');

drop procedure if exists payhospitalfee;

delimiter //
create procedure payhospitalfee(
    in p_patient_id int,
    in p_amount decimal(18,2)
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    update wallets 
    set balance = balance - p_amount 
    where patient_id = p_patient_id;

    signal sqlstate '45000' set message_text = 'system error';

    update patient_invoices 
    set total_due = total_due - p_amount 
    where patient_id = p_patient_id;

    commit;
end //
delimiter ;

drop procedure if exists transferbed;

delimiter //
create procedure transferbed(
    in p_patient_id int,
    in p_new_bed_id int
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    update beds 
    set patient_id = null 
    where patient_id = p_patient_id;

    update beds 
    set patient_id = p_patient_id 
    where bed_id = p_new_bed_id;

    commit;
end //
delimiter ;

drop procedure if exists issue_medicine;

delimiter //
create procedure issue_medicine(
    in p_patient_id int,
    in p_medicine_id int,
    in p_quantity int,
    out p_status_message varchar(255)
)
begin
    declare v_stock int;
    declare v_price decimal(18,2);

    declare exit handler for sqlexception
    begin
        rollback;
        set p_status_message = 'lỗi: hệ thống gặp sự cố bất ngờ';
    end;

    start transaction;

    select stock, price into v_stock, v_price 
    from medicines 
    where medicine_id = p_medicine_id;

    if v_stock is null then
        rollback;
        set p_status_message = 'lỗi: mã thuốc không tồn tại';
    elseif v_stock < p_quantity then
        rollback;
        set p_status_message = 'lỗi: số lượng tồn kho không đủ';
    else
        update medicines 
        set stock = stock - p_quantity 
        where medicine_id = p_medicine_id;

        update patient_invoices 
        set total_due = total_due + (p_quantity * v_price),
            last_updated = current_timestamp
        where patient_id = p_patient_id;

        commit;
        set p_status_message = 'đã cấp phát thành công';
    end if;
end //
delimiter ;

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

drop procedure if exists find_available_bed;
drop procedure if exists automate_emergency_admission;

delimiter //
create procedure find_available_bed(
    in p_dept_id int,
    out p_bed_id int
)
begin
    set p_bed_id = null;
    select bed_id into p_bed_id 
    from beds 
    where dept_id = p_dept_id and patient_id is null 
    limit 1;
end //
delimiter ;

delimiter //
create procedure automate_emergency_admission(
    in p_patient_id int,
    in p_doctor_id int,
    in p_date datetime,
    in p_dept_id int,
    out p_status_message varchar(255)
)
begin
    declare v_is_resident int default 0;
    declare v_dept_exists int default 0;
    declare v_allocated_bed_id int default null;

    declare exit handler for sqlexception
    begin
        rollback;
        set p_status_message = 'error: unexpected system error';
    end;

    start transaction;

    select count(*) into v_is_resident 
    from beds 
    where patient_id = p_patient_id;

    if v_is_resident > 0 then
        rollback;
        set p_status_message = 'Từ chối: Bệnh nhân đang lưu trú';
    else
        select count(*) into v_dept_exists 
        from departments 
        where dept_id = p_dept_id;

        if v_dept_exists = 0 then
            rollback;
            set p_status_message = 'Từ chối: Khoa không tồn tại';
        else
            call find_available_bed(p_dept_id, v_allocated_bed_id);

            if v_allocated_bed_id is null then
                rollback;
                set p_status_message = 'Từ chối: Khoa hiện đã hết giường';
            else
                insert into appointments (patient_id, doctor_id, appointment_date, status) 
                values (p_patient_id, p_doctor_id, p_date, 'completed');

                update beds 
                set patient_id = p_patient_id 
                where bed_id = v_allocated_bed_id;

                commit;
                set p_status_message = 'Thành công: Đã tự động lập lịch và xếp giường';
            end if;
        end if;
    end if;
end //
delimiter ;

drop procedure if exists processequipmentpurchase;

delimiter //
create procedure processequipmentpurchase(
    in p_patient_id int,
    in p_product_id int,
    in p_quantity int,
    out p_status_message varchar(255)
)
begin
    declare v_stock int;
    declare v_price decimal(18,2);
    declare v_balance decimal(18,2);
    declare v_status varchar(20);
    declare v_total_cost decimal(18,2);

    declare exit handler for sqlexception
    begin
        rollback;
        set p_status_message = 'Thất bại: Hệ thống gặp sự cố bất ngờ';
    end;

    start transaction;

    if p_quantity <= 0 then
        rollback;
        set p_status_message = 'Thất bại: Số lượng mua phải lớn hơn 0';
    else
        select stock, price into v_stock, v_price 
        from products 
        where product_id = p_product_id;

        if v_stock is null then
            rollback;
            set p_status_message = 'Thất bại: Sản phẩm không tồn tại';
        elseif v_stock < p_quantity then
            rollback;
            set p_status_message = 'Thất bại: Kho không đủ sản phẩm';
        else
            set v_total_cost = p_quantity * v_price;

            select balance, status into v_balance, v_status 
            from wallets 
            where patient_id = p_patient_id;

            if v_balance is null then
                rollback;
                set p_status_message = 'Thất bại: Ví tài khoản không tồn tại';
            elseif v_status != 'active' then
                rollback;
                set p_status_message = 'Thất bại: Ví đang bị khóa';
            elseif v_balance < v_total_cost then
                rollback;
                set p_status_message = 'Thất bại: Số dư ví không đủ';
            else
                update products 
                set stock = stock - p_quantity 
                where product_id = p_product_id;

                update wallets 
                set balance = balance - v_total_cost 
                where patient_id = p_patient_id;

                commit;
                set p_status_message = 'Thành công: Đã xử lý đơn hàng';
            end if;
        end if;
    end if;
end //
delimiter ;