-- Bước 1: Tạo CSDL QuanLySinhVien
CREATE DATABASE QuanLySinhVien;
-- Bước 2: Chọn Database QuanLySinhVien để thao tác với cơ sở dữ liệu này:
USE QuanLySinhVien;
-- Bước 3: Tiếp theo sử dụng câu lệnh Create Table để tạo bảng Class với các trường ClassId, ClassName, StartDate, Status như sau:
CREATE TABLE Class
(
    ClassID   INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME    NOT NULL,
    Status    BIT
);
-- Bước 4: Tạo bảng Student với các thuộc tính StudentId, StudentName, Address, Phone, Status, ClassId với rằng buộc như sau:
CREATE TABLE Student
(
    StudentId   INT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address     VARCHAR(50),
    Phone       VARCHAR(20),
    Status      BIT,
    ClassId     INT         NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);
-- Bước 5: Tạo bảng Subject với các thuộc tính SubId, SubName, Credit, Status với các ràng buộc như sau :
CREATE TABLE Subject
(
    SubId   INT AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit  TINYINT     NOT NULL DEFAULT 1 CHECK ( Credit >= 1 ),
    Status  BIT                  DEFAULT 1
);
-- Bước 6: Tạo bảng Mark với các thuộc tính MarkId, SubId, StudentId, Mark, ExamTimes với các ràng buộc như sau :
CREATE TABLE Mark
(
    MarkId    INT AUTO_INCREMENT PRIMARY KEY,
    SubId     INT NOT NULL,
    StudentId INT NOT NULL,
    Mark      FLOAT   DEFAULT 0 CHECK ( Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);
insert into class (classname, startdate, status)
values
    ('mathematics', '2024-09-01', 1),
    ('physics', '2024-09-01', 1),
    ('biology', '2024-09-01', 1);
insert into student (studentname, address, phone, status, classid)
values
    ('john doe', '123 main st', '123-456-7890', 1, 1),
    ('jane smith', '456 oak st', '987-654-3210', 1, 2),
    ('alice johnson', '789 elm st', '555-123-4567', 1, 3),
    ('john doen', 'st', '123-456-7880', 1, 1),
    ('jae smith', '456 oak st', '987-684-3210', 1, 2),
    ('ali johnson', 'st', '555-123-4867', 1, 3);
insert into subject (subname, credit, status)
values
    ('algebra', 3, 1),
    ('mechanics', 4, 1),
    ('biology basics', 2, 1);
insert into mark (subid, studentid, mark, examtimes)
values
    (1, 1, 85, 1),
    (1, 2, 90, 1),
    (1, 3, 75, 1),
    (2, 1, 78, 1),
    (2, 2, 82, 1),
    (2, 3, 88, 1),
    (3, 1, 95, 1),
    (3, 2, 85, 1),
    (3, 3, 80, 1);
# Hiển thị số lượng sinh viên theo từng địa chỉ nơi ở.
select count(*) as SoLuongSinhVien, Student.Address from quanlysinhvien.student group by Address;

# Hiển thị các thông tin môn học có điểm thi lớn nhất.
select SUB.subname,SUB.SubId, M.mark as MaxExamScore
from subject SUB join Mark M on SUB.SubId = M.SubId
where M.Mark = (select max(Mark) from mark);

# Tính điểm trung bình các môn học của từng học sinh.
select S.studentname,S.StudentId, S.ClassID, avg(Mark) as DiemTrungBinh
from mark join Student S on mark.StudentId = S.StudentId
group by S.StudentId;

# Hiển thị những bạn học viên có điểm trung bình các môn học nhỏ hơn bằng 70.
select S.studentname,S.StudentId, S.ClassID, avg(Mark) as DiemTrungBinh
from mark join Student S on mark.StudentId = S.StudentId
group by S.StudentId
having DiemTrungBinh <= 70;

# Hiển thị thông tin học viên có điểm trung bình các môn lớn nhất.
select S.* ,avg(M.mark) as DiemTrungBinh
from student S join Mark M on S.StudentId = M.StudentId
group by S.StudentId
having DiemTrungBinh = (select max(DiemTrungBinh)
                        from (
                        select avg(Mark) as DiemTrungBinh
                        from mark group by StudentId
                        ) as avgmark
                        );

# Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên,
# xếp hạng theo thứ tự điểm giảm dần
select S.* ,avg(M.mark) as DiemTrungBinh
from student S join Mark M on S.StudentId = M.StudentId
group by S.StudentId
order by DiemTrungBinh desc ; 

