create database SS11_sangtao;
use SS11_sangtao;

create table if not exists departments (
    dept_id int primary key,
    dept_name varchar(100) not null
);

create table if not exists patients (
    patient_id int primary key,
    full_name varchar(100) not null
);

create table if not exists appointments (
    appt_id int primary key,
    patient_id int,
    appointment_date datetime,
    status varchar(20),
    foreign key (patient_id) references patients(patient_id)
);

create table if not exists beds (
    bed_id int primary key,
    dept_id int,
    patient_id int null,
    foreign key (dept_id) references departments(dept_id),
    foreign key (patient_id) references patients(patient_id)
);

insert ignore into departments values (1, 'Emergency'), (2, 'Inpatient');
insert ignore into patients values (1, 'Le Hai Nguyen'), (2, 'Tran Thi B');
insert ignore into appointments values (1001, 1, '2026-05-13', 'Pending');
insert ignore into beds values (101, 1, 1), (201, 2, null);
insert ignore into appointments values (1002, 2, '2026-05-10', 'Completed');

drop procedure if exists findavailablebed;
delimiter $$
create procedure findavailablebed(
    in p_dept_id int,
    out p_bed_id int
)
begin
    select bed_id into p_bed_id
    from beds
    where dept_id = p_dept_id and patient_id is null
    limit 1;
end $$
delimiter ;

drop procedure if exists transferpatientbed;
delimiter $$
create procedure transferpatientbed(
    in p_patient_id int,
    in p_target_dept_id int,
    out p_new_bed_id int,
    out p_status_message varchar(255)
)
begin
    declare v_current_status varchar(20);
    declare v_dept_name varchar(100);
    declare v_found_bed_id int;

    select status into v_current_status 
    from appointments 
    where patient_id = p_patient_id 
    order by appointment_date desc limit 1;

    select dept_name into v_dept_name from departments where dept_id = p_target_dept_id;

    if v_current_status = 'Completed' then
        set p_new_bed_id = 0;
        set p_status_message = 'Error: Bệnh nhân đã làm thủ tục xuất viện, không thể chuyển khoa.';
    
    elseif v_dept_name is null then
        set p_new_bed_id = 0;
        set p_status_message = 'Error: Mã khoa chuyển đến không tồn tại.';

    else
        call findavailablebed(p_target_dept_id, v_found_bed_id);

        if v_found_bed_id is null then
            set p_new_bed_id = 0;
            set p_status_message = concat('Từ chối: Khoa ', v_dept_name, ' đã hết giường trống.');
        else
            update beds set patient_id = null where patient_id = p_patient_id;
            update beds set patient_id = p_patient_id where bed_id = v_found_bed_id;
            
            set p_new_bed_id = v_found_bed_id;
            set p_status_message = 'Đã tính toán xong: Chuyển giường thành công.';
        end if;
    end if;
end $$
delimiter ;

call transferpatientbed(1, 2, @bed1, @msg1);
select @bed1 as New_Bed, @msg1 as Status;

call transferpatientbed(1, 1, @bed2, @msg2);
select @bed2 as New_Bed, @msg2 as Status;

call transferpatientbed(2, 2, @bed3, @msg3);
select @bed3 as New_Bed, @msg3 as Status;

call transferpatientbed(1, 99, @bed4, @msg4);
select @bed4 as New_Bed, @msg4 as Status;