create database SS11_chuyensau;
use SS11_chuyensau;

create table if not exists patients (
    patient_id int primary key auto_increment,
    full_name varchar(100) not null,
    patient_type enum('BHYT', 'VIP', 'THUONG') not null
);

drop procedure if exists calculate_discharge_cost;

delimiter //

create procedure calculate_discharge_cost(
    in p_total_cost decimal(18,2),      
    in p_patient_type varchar(20),      
    out p_final_amount decimal(18,2),   
    out p_status_message varchar(100)   
)
begin
    if p_total_cost < 0 then
        set p_final_amount = 0;
        set p_status_message = 'Lỗi: Chi phí không hợp lệ';
    else
        case p_patient_type
            when 'BHYT' then
                set p_final_amount = p_total_cost * 0.2;
            when 'VIP' then
                set p_final_amount = p_total_cost * 0.9;
            when 'THUONG' then
                set p_final_amount = p_total_cost;
            else
                set p_final_amount = p_total_cost;
        end case;
        
        set p_status_message = 'Đã tính toán xong';
    end if;
end //

delimiter ;

call calculate_discharge_cost(1000000, 'BHYT', @final1, @msg1);
select @final1 as so_tien_thu, @msg1 as trang_thai;

call calculate_discharge_cost(1000000, 'VIP', @final2, @msg2);
select @final2 as so_tien_thu, @msg2 as trang_thai;

call calculate_discharge_cost(1000000, 'THUONG', @final3, @msg3);
select @final3 as so_tien_thu, @msg3 as trang_thai;

call calculate_discharge_cost(-500000, 'BHYT', @final4, @msg4);
select @final4 as so_tien_thu, @msg4 as trang_thai;