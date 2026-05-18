create database SS14_sangtao_db;
use SS14_sangtao_db;

create table patients (
	patient_id int primary key,
    full_name varchar(100) not null
);

create table employees (
	employees_id int primary key,
    full_name varchar(100) not null,
    position varchar(50) not null
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
    appointment_id int auto_increment primary key,
    patient_id int not null,
    doctor_id int not null,
    appointment_date datetime not null,
    status varchar(20) not null default 'pending',
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references employees(employee_id)
);

insert into patients (patient_id, full_name) values 
(1, 'nguyen van an'), (2, 'tran thi binh'), (3, 'le hoang cuong'), (4, 'pham minh duc');

insert into employees (employee_id, full_name, position) values 
(101, 'dr. hoang minh', 'doctor');

insert into departments (dept_id, dept_name) values 
(1, 'khoa ngoai'), (2, 'khoa noi');

insert into beds (bed_id, dept_id, patient_id) values
(501, 1, null),
(502, 2, 2);

drop procedure if exists find_available_bed;
drop procedure if exists automate_emergency_admission;

-- procedure phụ: dò tìm giường trống theo khoa
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

-- procedure master: điều phối giao dịch nhập viện khẩn cấp
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

-- kịch bản 1: nhập viện thành công (bệnh nhân 1 vào khoa ngoại id = 1, giường trống 501)
set @test_msg = '';
call automate_emergency_admission(1, 101, '2026-05-18 09:00:00', 1, @test_msg);
select @test_msg as scenario_1;
select * from beds;
select * from appointments;

-- kịch bản 2: bẫy hết giường trống (bệnh nhân 3 tiếp tục xin vào khoa ngoại id = 1 nhưng giường 501 đã bị chiếm ở trên)
set @test_msg = '';
call automate_emergency_admission(3, 101, '2026-05-18 09:15:00', 1, @test_msg);
select @test_msg as scenario_2;

-- kịch bản 3: bẫy bệnh nhân đang nội trú (bệnh nhân 2 đang nằm viện sẵn ở giường 502, yêu cầu nhập viện tiếp)
set @test_msg = '';
call automate_emergency_admission(2, 101, '2026-05-18 09:30:00', 2, @test_msg);
select @test_msg as scenario_3;

-- kịch bản 4: chuyển vào khoa không tồn tại (bệnh nhân 4 yêu cầu vào khoa có id = 99)
set @test_msg = '';
call automate_emergency_admission(4, 101, '2026-05-18 09:45:00', 99, @test_msg);
select @test_msg as scenario_4;