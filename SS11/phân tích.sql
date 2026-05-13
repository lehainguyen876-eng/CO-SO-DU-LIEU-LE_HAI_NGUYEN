create database if not exists SS1_phantich;
use SS1_phantich;


create table if not exists Patients (
    patient_id int primary key,
    full_name varchar(100),
    phone varchar(15) unique
);

create table if not exists Patient_Invoices (
    patient_id int primary key,
    total_due decimal(18,2),
    foreign key (patient_id) references Patients(patient_id)
);

insert ignore into Patients values (1, 'Nguyen Van A', '0901111222');
insert ignore into Patients values (2, 'Tran Thi B', '0912222333');
insert ignore into Patient_Invoices values (1, 500000);
insert ignore into Patient_Invoices values (2, 1200000);

drop procedure if exists GetPatientDebt;

delimiter //

create procedure GetPatientDebt(
    in p_patient_id int,
    in p_phone varchar(15),
    out p_total_debt decimal(18,2),
    out p_status_message varchar(100)
)
begin
    if p_patient_id is null and (p_phone is null or p_phone = '') then
        set p_total_debt = 0;
        set p_status_message = 'Lỗi: Vui lòng nhập ID hoặc Số điện thoại để tra cứu';
    else
        set p_total_debt = null;
        
        select total_due into p_total_debt
        from Patient_Invoices i
        join Patients p on i.patient_id = p.patient_id
        where (p_patient_id is not null and p.patient_id = p_patient_id)
           or (p_patient_id is null and p.phone = p_phone)
        limit 1;

        if p_total_debt is not null then
            set p_status_message = 'Tra cứu thành công';
        else
            set p_total_debt = 0;
            set p_status_message = 'Thông báo: Không tìm thấy thông tin bệnh nhân';
        end if;
    end if;
end //

delimiter ;

call GetPatientDebt(1, null, @debt1, @msg1);
select @debt1 as debt, @msg1 as status;

call GetPatientDebt(null, '0912222333', @debt2, @msg2);
select @debt2 as debt, @msg2 as status;

call GetPatientDebt(null, null, @debt3, @msg3);
select @debt3 as debt, @msg3 as status;

call GetPatientDebt(999, null, @debt4, @msg4);
select @debt4 as debt, @msg4 as status;