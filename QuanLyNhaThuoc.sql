USE [master]
GO
/****** Object:  Database [BanThuoc]    Script Date: 8/29/2024 23:44:17 ******/
CREATE DATABASE [BanThuoc]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BanThuoc_Data', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BanThuoc.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BanThuoc_Log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\BanThuoc.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BanThuoc] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BanThuoc].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BanThuoc] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BanThuoc] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BanThuoc] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BanThuoc] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BanThuoc] SET ARITHABORT OFF 
GO
ALTER DATABASE [BanThuoc] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BanThuoc] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BanThuoc] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BanThuoc] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BanThuoc] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BanThuoc] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BanThuoc] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BanThuoc] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BanThuoc] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BanThuoc] SET  ENABLE_BROKER 
GO
ALTER DATABASE [BanThuoc] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BanThuoc] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BanThuoc] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BanThuoc] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BanThuoc] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BanThuoc] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BanThuoc] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BanThuoc] SET RECOVERY FULL 
GO
ALTER DATABASE [BanThuoc] SET  MULTI_USER 
GO
ALTER DATABASE [BanThuoc] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BanThuoc] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BanThuoc] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BanThuoc] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [BanThuoc] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BanThuoc] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [BanThuoc] SET QUERY_STORE = ON
GO
ALTER DATABASE [BanThuoc] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BanThuoc]
GO
/****** Object:  UserDefinedFunction [dbo].[FC_CHECKSL]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FC_CHECKSL](@MALO NVARCHAR(50), @MATHUOC NVARCHAR(50), @SOLUONG INT)
RETURNS int	
AS
BEGIN 
    DECLARE @check int

    IF (SELECT SoLuongTon FROM LOTHUOC WHERE MaLo = @MALO AND MaLoaiThuoc = (SELECT MaLoaiThuoc FROM THUOC WHERE MaThuoc= @MATHUOC)) < @SOLUONG
    BEGIN
        set @check=-1
    END
	else
		set @check =0
    RETURN @check;
END
GO
/****** Object:  UserDefinedFunction [dbo].[LAYSOTON]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LAYSOTON](@MALO VARCHAR(50), @MATHUOC VARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @SL INT

    IF (
        SELECT SoLuongTon
        FROM LOTHUOC
        WHERE MaLo = @MALO
          AND MaLoaiThuoc = (
              SELECT MaLoaiThuoc
              FROM THUOC
              WHERE MaThuoc = @MATHUOC
          )
    ) > 0
    BEGIN
        SET @SL = (
            SELECT SoLuongTon
            FROM LOTHUOC
            WHERE MaLo = @MALO
              AND MaLoaiThuoc = (
                  SELECT MaLoaiThuoc
                  FROM THUOC
                  WHERE MaThuoc = @MATHUOC
              )
        )
    END
    ELSE
        SET @SL = -1

    RETURN @SL
END
GO
/****** Object:  Table [dbo].[CHITIETHD]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETHD](
	[MaHD] [varchar](10) NOT NULL,
	[MaThuoc] [varchar](10) NOT NULL,
	[SoLuong] [int] NULL,
	[DonGia] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHITIETPHIEUNHAP]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHITIETPHIEUNHAP](
	[MaPN] [varchar](10) NOT NULL,
	[MaThuoc] [varchar](10) NOT NULL,
	[SoLuong] [int] NULL,
	[DonGiaNhap] [decimal](10, 2) NULL,
	[MaLo] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPN] ASC,
	[MaThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HOADON]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HOADON](
	[MaHD] [varchar](10) NOT NULL,
	[NgayLap] [date] NULL,
	[TongTien] [decimal](10, 2) NULL,
	[MaKH] [varchar](10) NULL,
	[MaNV] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[MaKH] [varchar](10) NOT NULL,
	[TenKH] [nvarchar](200) NULL,
	[GioiTinh] [varchar](10) NULL,
	[Tuoi] [int] NULL,
	[SDT] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOAITHUOC]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAITHUOC](
	[MaLoaiThuoc] [varchar](10) NOT NULL,
	[TenLoaiThuoc] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLoaiThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LOTHUOC]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOTHUOC](
	[MaLo] [varchar](10) NOT NULL,
	[SoLo] [int] NULL,
	[SoLuongTon] [int] NULL,
	[NgayHetHan] [datetime] NULL,
	[MaLoaiThuoc] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaLo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHACUNGCAP]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHACUNGCAP](
	[MaNCC] [varchar](10) NOT NULL,
	[TenNCC] [nvarchar](100) NULL,
	[DiaChi] [nvarchar](100) NULL,
	[SDT] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHANVIEN]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHANVIEN](
	[MaNV] [varchar](10) NOT NULL,
	[TenNV] [nvarchar](50) NULL,
	[Email] [varchar](100) NULL,
	[SDT] [varchar](20) NULL,
	[ChucVu] [nvarchar](50) NULL,
	[TaiKhoan] [varchar](50) NULL,
	[MatKhau] [varchar](50) NULL,
	[NgaySinh] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NHOMTHUOC]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NHOMTHUOC](
	[MaNhomThuoc] [varchar](10) NOT NULL,
	[TenNhomThuoc] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaNhomThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PHIEUNHAP]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PHIEUNHAP](
	[MaPN] [varchar](10) NOT NULL,
	[NgayNhap] [date] NULL,
	[NguoiGiao] [varchar](50) NULL,
	[TongTien] [decimal](10, 2) NULL,
	[MaNV] [varchar](10) NULL,
	[MaNCC] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaPN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[THUOC]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[THUOC](
	[MaThuoc] [varchar](10) NOT NULL,
	[MaNhomThuoc] [varchar](10) NULL,
	[TenThuoc] [nvarchar](50) NULL,
	[MaLoaiThuoc] [varchar](10) NULL,
	[DVT] [varchar](20) NULL,
	[GiaBan] [decimal](10, 2) NULL,
	[HanSuDung] [date] NULL,
	[MoTa] [nvarchar](100) NULL,
	[GiaNhap] [decimal](10, 2) NULL,
	[HinhAnh] [varchar](100) NULL,
	[TacDungPhu] [nvarchar](100) NULL,
	[XuatXu] [nvarchar](50) NULL,
	[MaNCC] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[MaThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD001', N'T001', 5, CAST(5.00 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD001', N'T0013', 2, CAST(5.40 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD001', N'T002', 8, CAST(7.50 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD002', N'T001', 7, CAST(5.00 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD002', N'T0013', 2, CAST(5.40 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD002', N'T003', 10, CAST(6.00 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD002', N'T005', 2, CAST(2.50 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD002', N'T008', 21, CAST(2.50 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD003', N'T002', 6, CAST(7.50 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD003', N'T003', 9, CAST(6.00 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD004', N'T0115', 5, CAST(3.20 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD1112001', N'T006', 2, CAST(4.75 AS Decimal(10, 2)))
INSERT [dbo].[CHITIETHD] ([MaHD], [MaThuoc], [SoLuong], [DonGia]) VALUES (N'HD1112002', N'T010', 4, CAST(3.20 AS Decimal(10, 2)))
GO
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN001', N'T001', 50, CAST(3.00 AS Decimal(10, 2)), N'L001')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN001', N'T002', 30, CAST(5.00 AS Decimal(10, 2)), N'L002')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN0010', N'T008', 180, CAST(2.75 AS Decimal(10, 2)), N'L008')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN0011', N'T009', 200, CAST(5.00 AS Decimal(10, 2)), N'L003')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN002', N'T001', 20, CAST(3.00 AS Decimal(10, 2)), N'L001')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN002', N'T003', 40, CAST(4.50 AS Decimal(10, 2)), N'L003')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN003', N'T001', 100, CAST(2.50 AS Decimal(10, 2)), N'L001')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN003', N'T002', 35, CAST(7.50 AS Decimal(10, 2)), N'L002')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN003', N'T003', 25, CAST(6.00 AS Decimal(10, 2)), N'L003')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN004', N'T002', 50, CAST(3.75 AS Decimal(10, 2)), N'L002')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN005', N'T003', 75, CAST(1.80 AS Decimal(10, 2)), N'L003')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN006', N'T004', 120, CAST(4.25 AS Decimal(10, 2)), N'L004')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN007', N'T005', 90, CAST(5.50 AS Decimal(10, 2)), N'L005')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN008', N'T006', 150, CAST(4.50 AS Decimal(10, 2)), N'L006')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN009', N'T007', 120, CAST(6.25 AS Decimal(10, 2)), N'L007')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN012', N'T010', 100, CAST(3.20 AS Decimal(10, 2)), N'L001')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN013', N'T006', 130, CAST(4.75 AS Decimal(10, 2)), N'L003')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN014', N'T0115', 160, CAST(6.90 AS Decimal(10, 2)), N'L005')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN015', N'T0011', 140, CAST(3.50 AS Decimal(10, 2)), N'L002')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN016', N'T0012', 170, CAST(5.40 AS Decimal(10, 2)), N'L007')
INSERT [dbo].[CHITIETPHIEUNHAP] ([MaPN], [MaThuoc], [SoLuong], [DonGiaNhap], [MaLo]) VALUES (N'PN017', N'T0013', 110, CAST(4.00 AS Decimal(10, 2)), N'L003')
GO
INSERT [dbo].[HOADON] ([MaHD], [NgayLap], [TongTien], [MaKH], [MaNV]) VALUES (N'HD001', CAST(N'2023-12-10' AS Date), CAST(74.30 AS Decimal(10, 2)), NULL, N'NV002')
INSERT [dbo].[HOADON] ([MaHD], [NgayLap], [TongTien], [MaKH], [MaNV]) VALUES (N'HD002', CAST(N'2023-12-10' AS Date), CAST(110.80 AS Decimal(10, 2)), NULL, N'NV002')
INSERT [dbo].[HOADON] ([MaHD], [NgayLap], [TongTien], [MaKH], [MaNV]) VALUES (N'HD003', CAST(N'2023-12-07' AS Date), CAST(50.70 AS Decimal(10, 2)), NULL, N'NV002')
INSERT [dbo].[HOADON] ([MaHD], [NgayLap], [TongTien], [MaKH], [MaNV]) VALUES (N'HD004', CAST(N'2023-12-05' AS Date), CAST(16.00 AS Decimal(10, 2)), NULL, NULL)
INSERT [dbo].[HOADON] ([MaHD], [NgayLap], [TongTien], [MaKH], [MaNV]) VALUES (N'HD1112001', CAST(N'2023-12-11' AS Date), CAST(9.50 AS Decimal(10, 2)), NULL, N'NV002')
INSERT [dbo].[HOADON] ([MaHD], [NgayLap], [TongTien], [MaKH], [MaNV]) VALUES (N'HD1112002', CAST(N'2023-12-11' AS Date), CAST(12.80 AS Decimal(10, 2)), NULL, N'NV002')
GO
INSERT [dbo].[KHACHHANG] ([MaKH], [TenKH], [GioiTinh], [Tuoi], [SDT]) VALUES (N'KH001', N'Khách Hàng 1', N'Nam', 25, N'0123456789')
INSERT [dbo].[KHACHHANG] ([MaKH], [TenKH], [GioiTinh], [Tuoi], [SDT]) VALUES (N'KH002', N'Khách Hàng 2', N'N?', 30, N'0987654321')
INSERT [dbo].[KHACHHANG] ([MaKH], [TenKH], [GioiTinh], [Tuoi], [SDT]) VALUES (N'KH003', N'Khách Hàng 3', N'Nam', 22, N'0369852147')
GO
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT001', N'Đau Đầu')
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT002', N'Đau Bụng')
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT003', N'Thuốc Sốt')
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT004', N'Thuốc Ho')
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT005', N'Thuốc Tiêu Hóa')
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT006', N'Thuốc Trị Dị Ứng')
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT01', N'Lo?i Thu?c 1')
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT02', N'Lo?i Thu?c 2')
INSERT [dbo].[LOAITHUOC] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (N'LT03', N'Lo?i Thu?c 3')
GO
INSERT [dbo].[LOTHUOC] ([MaLo], [SoLo], [SoLuongTon], [NgayHetHan], [MaLoaiThuoc]) VALUES (N'L001', 1, 4, CAST(N'2023-02-01T00:00:00.000' AS DateTime), N'LT001')
INSERT [dbo].[LOTHUOC] ([MaLo], [SoLo], [SoLuongTon], [NgayHetHan], [MaLoaiThuoc]) VALUES (N'L002', 2, 0, NULL, N'LT002')
INSERT [dbo].[LOTHUOC] ([MaLo], [SoLo], [SoLuongTon], [NgayHetHan], [MaLoaiThuoc]) VALUES (N'L003', 1, 10, CAST(N'2023-02-03T00:00:00.000' AS DateTime), N'LT001')
INSERT [dbo].[LOTHUOC] ([MaLo], [SoLo], [SoLuongTon], [NgayHetHan], [MaLoaiThuoc]) VALUES (N'L004', 1, 10, CAST(N'2024-01-01T00:00:00.000' AS DateTime), N'LT001')
INSERT [dbo].[LOTHUOC] ([MaLo], [SoLo], [SoLuongTon], [NgayHetHan], [MaLoaiThuoc]) VALUES (N'L005', 2, 7, CAST(N'2023-12-01T00:00:00.000' AS DateTime), N'LT002')
INSERT [dbo].[LOTHUOC] ([MaLo], [SoLo], [SoLuongTon], [NgayHetHan], [MaLoaiThuoc]) VALUES (N'L006', 3, 8, CAST(N'2023-11-01T00:00:00.000' AS DateTime), N'LT003')
INSERT [dbo].[LOTHUOC] ([MaLo], [SoLo], [SoLuongTon], [NgayHetHan], [MaLoaiThuoc]) VALUES (N'L007', 4, 10, CAST(N'2023-10-01T00:00:00.000' AS DateTime), N'LT002')
INSERT [dbo].[LOTHUOC] ([MaLo], [SoLo], [SoLuongTon], [NgayHetHan], [MaLoaiThuoc]) VALUES (N'L008', 5, 10, CAST(N'2023-09-01T00:00:00.000' AS DateTime), N'LT001')
GO
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC001', N'Toan thang', N'219 ngo quyen', N'032455555')
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC002', N'Nhà Cung Cấp Công Thương', N'Địa chỉ 1', N'0123456789')
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC003', N'Nhà Cung Cấp Công Nghiệp', N'Địa chỉ 2', N'0987654321')
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC004', N'Nhà Cung Cấp Kinh Đô', N'Địa chỉ 3', N'0369852147')
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC005', N'Nhà Cung Cấp ABC', N'Địa chỉ 4', N'0123456789')
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC006', N'Nhà Cung Cấp BBQ', N'Địa chỉ 5', N'0987654321')
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC01', N'Nhà Cung C?p 1', N'Ð?a ch? 1', N'0123456789')
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC02', N'Nhà Cung C?p 2', N'Ð?a ch? 2', N'0987654321')
INSERT [dbo].[NHACUNGCAP] ([MaNCC], [TenNCC], [DiaChi], [SDT]) VALUES (N'NCC03', N'Nhà Cung C?p 3', N'Ð?a ch? 3', N'0369852147')
GO
INSERT [dbo].[NHANVIEN] ([MaNV], [TenNV], [Email], [SDT], [ChucVu], [TaiKhoan], [MatKhau], [NgaySinh]) VALUES (N'NV001', N'NguyenMinhHoang', N'nguyenminhhoang7503@gmail.com', N'0899787933', N'Admin', N'MinhHoang', N'123', N'2003-05-07')
INSERT [dbo].[NHANVIEN] ([MaNV], [TenNV], [Email], [SDT], [ChucVu], [TaiKhoan], [MatKhau], [NgaySinh]) VALUES (N'NV002', N'nguyenminhhoang', N'nguyenminhhoang7503@gmail.com', N'7222222222', N'User', N'minhHoang', N'123', N'24/12/2020')
INSERT [dbo].[NHANVIEN] ([MaNV], [TenNV], [Email], [SDT], [ChucVu], [TaiKhoan], [MatKhau], [NgaySinh]) VALUES (N'NV003', N'Người Dùng 1', N'nguoidung1@example.com', N'0123456789', N'User', N'user1', N'password1', N'1990-01-01')
INSERT [dbo].[NHANVIEN] ([MaNV], [TenNV], [Email], [SDT], [ChucVu], [TaiKhoan], [MatKhau], [NgaySinh]) VALUES (N'NV004', N'Người Dùng 2', N'nguoidung2@example.com', N'0899787933', N'User', N'user2', N'password2', N'1995-05-15')
INSERT [dbo].[NHANVIEN] ([MaNV], [TenNV], [Email], [SDT], [ChucVu], [TaiKhoan], [MatKhau], [NgaySinh]) VALUES (N'NV005', N'Người Dùng 3', N'nguoidung3@example.com', N'0351518846', N'User', N'user3', N'password3', N'1988-12-10')
INSERT [dbo].[NHANVIEN] ([MaNV], [TenNV], [Email], [SDT], [ChucVu], [TaiKhoan], [MatKhau], [NgaySinh]) VALUES (N'NV006', N'Người Dùng 4', N'nguoidung4@example.com', N'0351548868', N'User', N'user4', N'password4', N'1993-08-20')
INSERT [dbo].[NHANVIEN] ([MaNV], [TenNV], [Email], [SDT], [ChucVu], [TaiKhoan], [MatKhau], [NgaySinh]) VALUES (N'NV007', N'Người Dùng 5', N'nguoidung5@example.com', N'0565168448', N'User', N'user5', N'password5', N'1997-03-25')
INSERT [dbo].[NHANVIEN] ([MaNV], [TenNV], [Email], [SDT], [ChucVu], [TaiKhoan], [MatKhau], [NgaySinh]) VALUES (N'NV008', N'John Doe', N'john.doe@example.com', N'123456789', N'Manager', N'john_doe', N'password123', N'1990-01-01')
GO
INSERT [dbo].[NHOMTHUOC] ([MaNhomThuoc], [TenNhomThuoc]) VALUES (N'NT001', N'Có đơn')
INSERT [dbo].[NHOMTHUOC] ([MaNhomThuoc], [TenNhomThuoc]) VALUES (N'NT002', N'Không đơn')
GO
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN001', CAST(N'2023-10-02' AS Date), N'minhHoang', CAST(22222.00 AS Decimal(10, 2)), N'NV001', N'NCC001')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN0010', CAST(N'2023-08-25' AS Date), N'Ngu?i Giao 8', CAST(950.75 AS Decimal(10, 2)), N'NV003', N'NCC003')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN0011', CAST(N'2023-09-30' AS Date), N'Ngu?i Giao 9', CAST(1350.25 AS Decimal(10, 2)), N'NV004', N'NCC004')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN002', CAST(N'2023-10-02' AS Date), N'minhHoang', CAST(22222.00 AS Decimal(10, 2)), N'NV001', N'NCC001')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN003', CAST(N'2023-01-10' AS Date), N'Nguyen Van A', CAST(500.00 AS Decimal(10, 2)), N'NV001', N'NCC001')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN004', CAST(N'2023-02-15' AS Date), N'Nguyen Van B', CAST(750.50 AS Decimal(10, 2)), N'NV002', N'NCC002')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN005', CAST(N'2023-03-20' AS Date), N'Nguyen Van C', CAST(1200.75 AS Decimal(10, 2)), N'NV003', N'NCC003')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN006', CAST(N'2023-04-25' AS Date), N'Nguyen Van D', CAST(980.25 AS Decimal(10, 2)), N'NV004', N'NCC004')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN007', CAST(N'2023-05-30' AS Date), N'Nguyen Van K', CAST(1500.00 AS Decimal(10, 2)), N'NV005', N'NCC005')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN008', CAST(N'2023-06-15' AS Date), N'Ngu?i Giao 6', CAST(800.00 AS Decimal(10, 2)), N'NV001', N'NCC001')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN009', CAST(N'2023-07-20' AS Date), N'Ngu?i Giao 7', CAST(1200.50 AS Decimal(10, 2)), N'NV002', N'NCC002')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN012', CAST(N'2023-10-05' AS Date), N'Ngu?i Giao 10', CAST(1600.00 AS Decimal(10, 2)), N'NV005', N'NCC005')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN013', CAST(N'2023-11-10' AS Date), N'Ngu?i Giao 11', CAST(1800.50 AS Decimal(10, 2)), N'NV001', N'NCC001')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN014', CAST(N'2023-12-15' AS Date), N'Ngu?i Giao 12', CAST(2000.75 AS Decimal(10, 2)), N'NV002', N'NCC002')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN015', CAST(N'2024-01-20' AS Date), N'Ngu?i Giao 13', CAST(2200.25 AS Decimal(10, 2)), N'NV003', N'NCC003')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN016', CAST(N'2024-02-25' AS Date), N'Ngu?i Giao 14', CAST(2400.00 AS Decimal(10, 2)), N'NV004', N'NCC004')
INSERT [dbo].[PHIEUNHAP] ([MaPN], [NgayNhap], [NguoiGiao], [TongTien], [MaNV], [MaNCC]) VALUES (N'PN017', CAST(N'2024-03-01' AS Date), N'Ngu?i Giao 15', CAST(2600.50 AS Decimal(10, 2)), N'NV005', N'NCC005')
GO
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T001', N'NT001', N'ViTaMin A', N'LT001', N'Viên', CAST(3.50 AS Decimal(10, 2)), CAST(N'2023-12-31' AS Date), N'Kháng viêm', CAST(2.50 AS Decimal(10, 2)), N'thuoc1.jpg', N'Gây mất ngủ', N'Việt Nam', N'NCC001')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T0011', N'NT001', N'Gabapentin', N'LT001', N'Viên', CAST(4.75 AS Decimal(10, 2)), CAST(N'2023-07-31' AS Date), N'Mô tả cho Thuốc 6', CAST(3.50 AS Decimal(10, 2)), N'thuoc6.jpg', N'Tác dụng phụ cho Thuốc 6', N'Nhật Bản', N'NCC001')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T0012', N'NT002', N'Topiramate', N'LT002', N'Chai', CAST(6.90 AS Decimal(10, 2)), CAST(N'2023-06-30' AS Date), N'Mô tả cho Thuốc 7', CAST(5.25 AS Decimal(10, 2)), N'thuoc7.jpg', N'Tác dụng phụ cho Thuốc 7', N'Úc', N'NCC002')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T0013', N'NT002', N'Clopidogrel', N'LT002', N'H?p', CAST(5.40 AS Decimal(10, 2)), CAST(N'2023-04-30' AS Date), N'Mô tả cho Thuốc 9', CAST(4.80 AS Decimal(10, 2)), N'thuoc9.jpg', N'Tác dụng phụ cho Thuốc 9', N'Pháp', N'NCC004')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T002', N'NT002', N'Tiotropium', N'LT002', N'Chai', CAST(5.75 AS Decimal(10, 2)), CAST(N'2023-11-30' AS Date), N'Nhức đầu', CAST(4.20 AS Decimal(10, 2)), N'thuoc2.jpg', N'Gây biếng ăn', N'Pháp', N'NCC002')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T003', N'NT001', N'Folic Acid', N'LT003', N'Gói', CAST(1.80 AS Decimal(10, 2)), CAST(N'2023-10-31' AS Date), N'Xương cốt', CAST(1.50 AS Decimal(10, 2)), N'thuoc3.jpg', N'đau đầu', N'Đức', N'NCC003')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T004', N'NT002', N'Ticagrelor', N'LT002', N'Gói', CAST(4.25 AS Decimal(10, 2)), CAST(N'2023-09-30' AS Date), N'Đau Mắt', CAST(3.80 AS Decimal(10, 2)), N'thuoc4.jpg', N'Buồn Ngủ', N'Mỹ', N'NCC004')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T005', N'NT001', N'Temazepam', N'LT001', N'Chai', CAST(2.50 AS Decimal(10, 2)), CAST(N'2023-08-31' AS Date), N'Đau Lưng', CAST(2.20 AS Decimal(10, 2)), N'thuoc5.jpg', N'Nôn', N'Hàn Quốc', N'NCC005')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T006', N'NT001', N'Levothyroxine', N'LT001', N'Viên', CAST(4.75 AS Decimal(10, 2)), CAST(N'2023-07-31' AS Date), N'Mô tả cho Thuốc 6', CAST(3.50 AS Decimal(10, 2)), N'thuoc6.jpg', N'Tác dụng phụ cho Thuốc 6', N'Nhật Bản', N'NCC001')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T007', N'NT002', N'Memantine', N'LT002', N'Chai', CAST(6.90 AS Decimal(10, 2)), CAST(N'2023-06-30' AS Date), N'Mô tả cho Thuốc 7', CAST(5.25 AS Decimal(10, 2)), N'thuoc7.jpg', N'Tác dụng phụ cho Thuốc 7', N'Úc', N'NCC002')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T008', N'NT001', N'Donepezi', N'LT003', N'Gói', CAST(2.50 AS Decimal(10, 2)), CAST(N'2023-05-31' AS Date), N'Mô tả cho Thuốc 8', CAST(2.00 AS Decimal(10, 2)), N'thuoc8.jpg', N'Tác dụng phụ cho Thuốc 8', N'Anh', N'NCC003')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T009', N'NT002', N'Zolpidem', N'LT002', N'H?p', CAST(5.40 AS Decimal(10, 2)), CAST(N'2023-04-30' AS Date), N'Mô tả cho Thuốc 9', CAST(4.80 AS Decimal(10, 2)), N'thuoc9.jpg', N'Tác dụng phụ cho Thuốc 9', N'Pháp', N'NCC004')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T010', N'NT001', N'Eszopiclone', N'LT001', N'?ng', CAST(3.20 AS Decimal(10, 2)), CAST(N'2023-03-31' AS Date), N'Mô tả cho Thuốc 10', CAST(2.80 AS Decimal(10, 2)), N'thuoc10.jpg', N'Tác dụng phụ cho Thuốc 10', N'Hàn Quốc', N'NCC005')
INSERT [dbo].[THUOC] ([MaThuoc], [MaNhomThuoc], [TenThuoc], [MaLoaiThuoc], [DVT], [GiaBan], [HanSuDung], [MoTa], [GiaNhap], [HinhAnh], [TacDungPhu], [XuatXu], [MaNCC]) VALUES (N'T0115', N'NT001', N'Risperidone', N'LT001', N'?ng', CAST(3.20 AS Decimal(10, 2)), CAST(N'2023-03-31' AS Date), N'Mô tả cho Thuốc 10', CAST(2.80 AS Decimal(10, 2)), N'thuoc10.jpg', N'Tác dụng phụ cho Thuốc 10', N'Hàn Quốc', N'NCC005')
GO
ALTER TABLE [dbo].[CHITIETHD]  WITH CHECK ADD FOREIGN KEY([MaHD])
REFERENCES [dbo].[HOADON] ([MaHD])
GO
ALTER TABLE [dbo].[CHITIETHD]  WITH CHECK ADD FOREIGN KEY([MaThuoc])
REFERENCES [dbo].[THUOC] ([MaThuoc])
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MaThuoc])
REFERENCES [dbo].[THUOC] ([MaThuoc])
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MaLo])
REFERENCES [dbo].[LOTHUOC] ([MaLo])
GO
ALTER TABLE [dbo].[CHITIETPHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MaPN])
REFERENCES [dbo].[PHIEUNHAP] ([MaPN])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([MaKH])
REFERENCES [dbo].[KHACHHANG] ([MaKH])
GO
ALTER TABLE [dbo].[HOADON]  WITH CHECK ADD FOREIGN KEY([MaNV])
REFERENCES [dbo].[NHANVIEN] ([MaNV])
GO
ALTER TABLE [dbo].[PHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MaNCC])
REFERENCES [dbo].[NHACUNGCAP] ([MaNCC])
GO
ALTER TABLE [dbo].[PHIEUNHAP]  WITH CHECK ADD FOREIGN KEY([MaNV])
REFERENCES [dbo].[NHANVIEN] ([MaNV])
GO
ALTER TABLE [dbo].[THUOC]  WITH CHECK ADD FOREIGN KEY([MaLoaiThuoc])
REFERENCES [dbo].[LOAITHUOC] ([MaLoaiThuoc])
GO
ALTER TABLE [dbo].[THUOC]  WITH CHECK ADD FOREIGN KEY([MaNCC])
REFERENCES [dbo].[NHACUNGCAP] ([MaNCC])
GO
ALTER TABLE [dbo].[THUOC]  WITH CHECK ADD FOREIGN KEY([MaNhomThuoc])
REFERENCES [dbo].[NHOMTHUOC] ([MaNhomThuoc])
GO
/****** Object:  StoredProcedure [dbo].[AddEmployee]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddEmployee](
  @TenNV NVARCHAR(50),
  @Email VARCHAR(100),
  @SDT VARCHAR(20),
  @ChucVu NVARCHAR(50),
  @TaiKhoan VARCHAR(50),
  @MatKhau VARCHAR(50),
  @NgaySinh VARCHAR(50)
) AS
BEGIN
  DECLARE @MaNV VARCHAR(10);

  -- Find the next available code
  SELECT TOP 1 @MaNV = 'NV' + RIGHT('000' + CAST(ISNULL(SUBSTRING(MaNV, 3, 3), 0) + 1 AS VARCHAR(3)), 3)
  FROM NHANVIEN
  WHERE MaNV LIKE 'NV%'
  ORDER BY MaNV DESC;

  -- Insert new employee with generated code
  INSERT INTO NHANVIEN (
    MaNV,
    TenNV,
    Email,
    SDT,
    ChucVu,
    TaiKhoan,
    MatKhau,
    NgaySinh
  )
  VALUES (
    @MaNV,
    @TenNV,
    @Email,
    @SDT,
    @ChucVu,
    @TaiKhoan,
    @MatKhau,
    @NgaySinh
  );
END;
GO
/****** Object:  StoredProcedure [dbo].[CAPNHATSL]    Script Date: 8/29/2024 23:44:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CAPNHATSL] 
@MALO NVARCHAR(50),
@MATHUOC NVARCHAR(50),
@SOLUONG INT
AS
BEGIN 
	UPDATE LOTHUOC
	SET SoLuongTon =@SOLUONG
	WHERE  MaLo = @MALO AND MaLoaiThuoc = (SELECT MaLoaiThuoc FROM THUOC WHERE MaThuoc= @MATHUOC)
END
GO
USE [master]
GO
ALTER DATABASE [BanThuoc] SET  READ_WRITE 
GO
