Create Database QuanLyVatTu;
use QuanLyVatTu;
create table VatTu(
	maVT int primary key not null unique, 
    tenVT varchar(255) not null unique
);
create table PhieuXuatChiTiet(
	soPx int primary key not null unique,
    maVT int,
    donGiaXuat int
);