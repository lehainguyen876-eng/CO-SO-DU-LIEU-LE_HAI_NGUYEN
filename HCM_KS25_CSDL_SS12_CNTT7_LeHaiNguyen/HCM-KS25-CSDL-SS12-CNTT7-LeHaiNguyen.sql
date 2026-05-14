CREATE DATABASE StudentDB;
USE StudentDB;

-- 1. Bảng Khoa
CREATE TABLE Department (
    DeptID VARCHAR(5) PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- 2. Bảng SinhVien
CREATE TABLE Student (
    StudentID VARCHAR(6) PRIMARY KEY,
    FullName VARCHAR(50),
    Gender VARCHAR(10),
    BirthDate DATE,
    DeptID VARCHAR(5),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

-- 3. Bảng MonHoc
CREATE TABLE Course (
    CourseID VARCHAR(6) PRIMARY KEY,
    CourseName VARCHAR(50),
    Credits INT
);

-- 4. Bảng DangKy
CREATE TABLE Enrollment (
    StudentID VARCHAR(6),
    CourseID VARCHAR(6),
    Score DECIMAL(4,2), 
    PRIMARY KEY (StudentID, CourseID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Chèn dữ liệu mẫu
INSERT INTO Department VALUES
('IT','Information Technology'),
('BA','Business Administration'),
('ACC','Accounting');

INSERT INTO Student VALUES
('S00001','Nguyen An','Male','2003-05-10','IT'),
('S00002','Tran Binh','Male','2003-06-15','IT'),
('S00003','Le Hoa','Female','2003-08-20','BA'),
('S00004','Pham Minh','Male','2002-12-12','ACC'),
('S00005','Vo Lan','Female','2003-03-01','IT'),
('S00006','Do Hung','Male','2002-11-11','BA'),
('S00007','Nguyen Mai','Female','2003-07-07','ACC'),
('S00008','Tran Phuc','Male','2003-09-09','IT');

create view viewstudentbasic as
select s.studentid, s.fullname, d.deptname
from student s
join department d on s.deptid = d.deptid;

select * from viewstudentbasic;

create index idxFullName on Student(Fullname);

delimiter $$
create procedure getstudentsit()
begin
    select 
        s.Studentid, 
        s.FullName, 
        s.Gender, 
        s.BirthDate, 
        s.Deptid, 
        d.Deptname
    from Student s
    join department d on s.deptid = d.deptid
    where d.deptname = 'information technology';
end $$
delimiter ;

call getstudentsit();

create view ViewStudentCountByDept as
select d.deptname, count(s.studentid) as TotalStudents
from department d
left join student s on d.deptid = s.deptid
group by d.DeptName;

select * from ViewStudentCountByDept
where totalstudents = (select max(totalstudents) 
from ViewStudentCountByDept);



