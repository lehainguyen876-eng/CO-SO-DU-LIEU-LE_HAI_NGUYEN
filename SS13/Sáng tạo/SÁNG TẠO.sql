create database SS13_sangtao;
use SS13_sangtao;

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

create table price_changes_log (
    log_id int auto_increment primary key,
    medicine_id int,
    old_price decimal(18,2),
    new_price decimal(18,2),
    change_type varchar(20),
    change_diff decimal(18,2),
    changed_at datetime default current_timestamp,
    foreign key (medicine_id) references medicines(medicine_id)
);

insert into patients values 
(1, 'nguyen van an', '0901111222', '1990-05-15'),
(2, 'tran thi binh', '0912222333', '1985-08-20'),
(3, 'le hoang cuong', '0923333444', '2000-12-01');

insert into employees values 
(101, 'dr. hoang minh', 'doctor', 20000.00),
(102, 'dr. lan anh', 'doctor', 25000.00),
(103, 'nurse thu ha', 'nurse', 12000.00);

insert into departments values 
(1, 'khoa ngoai'), 
(2, 'khoa noi'), 
(3, 'khoa icu');

insert into beds values 
(101, 1, 1), 
(201, 2, null), 
(301, 3, 2);

insert into appointments values 
(104, 1, 101, '2026-06-10 08:30:00', 'pending'),
(105, 2, 102, '2026-05-01 09:00:00', 'completed'),
(106, 3, 101, '2026-05-02 10:00:00', 'cancelled');

insert into inventory values 
(10, 'khau trang y te n95', 1000), 
(11, 'gang tay vo trung', 500), 
(12, 'dung dich sat khuan', 200);

insert into medicines values 
(1, 'amoxicillin 500mg', 15000, 100), 
(2, 'panadol extra', 5000, 5);

insert into patient_invoices values 
(1, 1500000.00, now()), 
(2, 0, now()), 
(3, 0, now());

insert into products (name, price, stock) values 
('may do huyet ap omron', 850000.00, 20), 
('may do duong huyet', 450000.00, 15);

insert into services values 
(1, 'sieu am o bung', 200000.00), 
(2, 'xet nghiem mau', 150000.00), 
(3, 'chup x-quang', 250000.00);

insert into wallets values 
(1, 500000.00, 'active'), 
(2, 50000.00, 'active'), 
(3, 1000000.00, 'inactive');

drop trigger if exists preventpastappointments;
delimiter //
create trigger preventpastappointments
before update on appointments
for each row
begin
    if new.appointment_date < now() then
        signal sqlstate '45000' 
        set message_text = 'lỗi: không thể đặt lịch khám vào thời điểm trong quá khứ';
    end if;
end //
delimiter ;

drop trigger if exists preventstatusrevert;
delimiter //
create trigger preventstatusrevert
before update on appointments
for each row
begin
    if old.status = 'completed' then
        signal sqlstate '45000'
        set message_text = 'lỗi: không được phép thay đổi trạng thái của những lịch khám đã hoàn thành';
    end if;
end //
delimiter ;

drop trigger if exists trg_trackpricechanges;
delimiter //
create trigger trg_trackpricechanges
before update on medicines
for each row
begin
    if new.price <= 0 then
        signal sqlstate '45000'
        set message_text = 'lỗi: giá thuốc mới không hợp lệ';
    elseif new.price <> old.price then
        set @diff = 0;
        set @status = '';
        if new.price > old.price then
            set @status = 'tăng giá';
            set @diff = new.price - old.price;
        else
            set @status = 'giảm giá';
            set @diff = old.price - new.price;
        end if;
        insert into price_changes_log (medicine_id, old_price, new_price, change_type, change_diff)
        values (old.medicine_id, old.price, new.price, @status, @diff);
    end if;
end //
delimiter ;

drop trigger if exists trg_preventdoublebookinginsert;
delimiter //
create trigger trg_preventdoublebookinginsert
before insert on appointments
for each row
begin
    if exists (
        select 1 from appointments 
        where doctor_id = new.doctor_id 
        and appointment_date = new.appointment_date 
        and status <> 'cancelled'
    ) then
        signal sqlstate '45000'
        set message_text = 'lỗi: bác sĩ đã có lịch hẹn vào khung giờ này';
    end if;
end //
delimiter ;

drop trigger if exists trg_preventdoublebookingupdate;
delimiter //
create trigger trg_preventdoublebookingupdate
before update on appointments
for each row
begin
    if exists (
        select 1 from appointments 
        where doctor_id = new.doctor_id 
        and appointment_date = new.appointment_date 
        and status <> 'cancelled'
        and appointment_id <> old.appointment_id
    ) then
        signal sqlstate '45000'
        set message_text = 'lỗi: bác sĩ đã có lịch hẹn vào khung giờ này';
    end if;
end //
delimiter ;	

select * from patients;
select * from employees;
select * from appointments;
select * from medicines;

select * from price_changes_log;
select * from patient_invoices;
select * from wallets;

update appointments set appointment_date = '2020-01-01 08:00:00' where appointment_id = 104;

update appointments set status = 'completed' where appointment_id = 104;

update appointments set status = 'cancelled' where appointment_id = 104;

update medicines set price = 20000 where medicine_id = 1;

select * from price_changes_log;

insert into appointments values (205, 1, 101, '2026-06-10 08:30:00', 'pending');