USE [master]
GO
/****** Object:  Database [p6g10]    Script Date: 07/06/2019 22:55:53 ******/
CREATE DATABASE [p6g10]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'p6g10', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\p6g10.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'p6g10_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSERVER\MSSQL\DATA\p6g10_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [p6g10] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [p6g10].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [p6g10] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [p6g10] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [p6g10] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [p6g10] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [p6g10] SET ARITHABORT OFF 
GO
ALTER DATABASE [p6g10] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [p6g10] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [p6g10] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [p6g10] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [p6g10] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [p6g10] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [p6g10] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [p6g10] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [p6g10] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [p6g10] SET  ENABLE_BROKER 
GO
ALTER DATABASE [p6g10] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [p6g10] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [p6g10] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [p6g10] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [p6g10] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [p6g10] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [p6g10] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [p6g10] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [p6g10] SET  MULTI_USER 
GO
ALTER DATABASE [p6g10] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [p6g10] SET DB_CHAINING OFF 
GO
ALTER DATABASE [p6g10] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [p6g10] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [p6g10] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [p6g10] SET QUERY_STORE = OFF
GO
USE [p6g10]
GO
/****** Object:  User [p6g10]    Script Date: 07/06/2019 22:55:54 ******/
CREATE USER [p6g10] FOR LOGIN [p6g10] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [p6g10]
GO
/****** Object:  Schema [Railway]    Script Date: 07/06/2019 22:55:55 ******/
CREATE SCHEMA [Railway]
GO
/****** Object:  UserDefinedFunction [Railway].[f_check_discount]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Railway].[f_check_discount](@promocode VARCHAR(10)) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Discount WHERE promocode = @promocode)
		RETURN 1;
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [Railway].[f_check_login]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Login functions
CREATE FUNCTION [Railway].[f_check_login] (@email VARCHAR(50)) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Passenger AS p WHERE p.email = @email)
		RETURN 1;
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [Railway].[f_check_nif]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Sign up functions
CREATE FUNCTION [Railway].[f_check_nif](@nif INT) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Person AS p WHERE p.nif = @nif)
		RETURN 1;
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [Railway].[f_check_password]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Railway].[f_check_password] (@email VARCHAR(50), @password VARCHAR(50)) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Passenger AS p WHERE p.email = @email AND p.pw = HASHBYTES('SHA1',@password))
		RETURN 1;
	RETURN 0;
END 
GO
/****** Object:  UserDefinedFunction [Railway].[f_check_profile_picture]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Railway].[f_check_profile_picture](@passenger_id INT) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.ProfilePictures WHERE passenger_id = @passenger_id)
		RETURN 1;
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [Railway].[f_get_trips]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Railway].[f_get_trips](@dep_station_name VARCHAR(30), @arr_station_name VARCHAR(30)) RETURNS @table TABLE 
(trip_no INT, trip_type	VARCHAR(2), dep_timestamp TIME, arr_timestamp TIME, duration TIME, price SMALLMONEY)
AS
	BEGIN
		DECLARE @dep_station AS INT;
		DECLARE @arr_station AS INT;
		INSERT @table (t.trip_no, t.trip_type, t.dep_timestamp, t.arr_timestamp, t.duration)
			SELECT t.trip_no, t.trip_type, t.dep_timestamp, t.arr_timestamp, t.duration
			FROM Railway.Trip AS t JOIN Railway.Station AS dep_station ON t.dep_station = dep_station.station_no
			JOIN Railway.Station AS arr_station ON t.arr_station = arr_station.station_no
			WHERE dep_station.station_name = @dep_station_name AND arr_station.station_name = @arr_station_name AND t.trip_type <> 'M';

		DECLARE @hello as int;
		DECLARE @tripType AS VARCHAR(2);
		DECLARE C CURSOR FAST_FORWARD
		FOR SELECT trip_type FROM @table

		OPEN C;
		
		WHILE @@FETCH_STATUS = 0
			BEGIN
				UPDATE @table SET price = (SELECT Railway.trip_price(@tripType, @dep_station_name, @arr_station_name)) WHERE trip_type = @tripType;
				FETCH C INTO @tripType;
			END
		CLOSE C ;
		DEALLOCATE C;

		RETURN;
	END;
GO
/****** Object:  UserDefinedFunction [Railway].[f_insert_trip_instance]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [Railway].[f_insert_trip_instance](@trip_no INT, @trip_date DATE) RETURNS INT
AS
BEGIN
	IF NOT EXISTS(SELECT * FROM Railway.TripInstance AS ti WHERE ti.trip_no = @trip_no AND ti.trip_date = trip_date)
		RETURN 1;
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [Railway].[trip_price]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [Railway].[trip_price] (@trip_type VARCHAR(2), @dep_station VARCHAR(30), @arr_station VARCHAR(30)) RETURNS SMALLMONEY
AS
BEGIN
	DECLARE @dep_zone AS INT;
	DECLARE @arr_zone AS INT;

	SELECT DISTINCT
		@dep_zone = dep.zone_no,
		@arr_zone = arr.zone_no 
		FROM Railway.Trip AS trip 
		JOIN Railway.Station AS dep ON trip.dep_station = dep.station_no
		JOIN Railway.Station AS arr ON trip.arr_station = arr.station_no
		WHERE trip.trip_type = @trip_type AND dep.station_name = @dep_station AND arr.station_name = @arr_station;

	IF (@arr_zone < @dep_zone)
		BEGIN
			DECLARE @aux AS INT;
			SET @aux = @arr_zone;
			SET @arr_zone = @dep_zone;
			SET @dep_zone = @aux;
		END

		DECLARE @price AS SMALLMONEY;
		SET @price = 0;

		DECLARE @loop_cnt INT = @dep_zone;
		WHILE @loop_cnt <= @arr_zone
		BEGIN
			IF (@trip_type = 'UR')
				BEGIN
					SELECT @price = (@price + priceUR)
					FROM Railway.TripZone
					WHERE zone_no = @loop_cnt;
				END
			ELSE IF (@trip_type = 'IC')
				BEGIN
					SELECT @price = (@price + priceIC)
					FROM Railway.TripZone
					WHERE zone_no = @loop_cnt;
				END
			ELSE IF (@trip_type = 'AP')
				BEGIN
					SELECT @price = (@price + priceAP)
					FROM Railway.TripZone
					WHERE zone_no = @loop_cnt;
				END
		
			SET @loop_cnt = @loop_cnt + 1;
		END
		RETURN @price;
END
GO
/****** Object:  Table [Railway].[Ticket]    Script Date: 07/06/2019 22:55:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Ticket](
	[ticket_no] [int] IDENTITY(100,1) NOT NULL,
	[nif] [int] NOT NULL,
	[dep_station] [int] NOT NULL,
	[arr_station] [int] NOT NULL,
	[dep_timestamp] [time](7) NULL,
	[arr_timestamp] [time](7) NULL,
	[train_no] [int] NOT NULL,
	[carriage_no] [int] NOT NULL,
	[seat_no] [int] NOT NULL,
	[price] [smallmoney] NOT NULL,
	[trip_no] [int] NOT NULL,
	[trip_date] [date] NOT NULL,
	[passenger_id] [int] NOT NULL,
	[duration] [time](7) NULL,
	[trip_type] [varchar](2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ticket_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[Station]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Station](
	[station_no] [int] IDENTITY(1,1) NOT NULL,
	[station_name] [varchar](30) NOT NULL,
	[zone_no] [int] NOT NULL,
	[director_no] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[station_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Railway].[TicketBasicInfo]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Railway].[TicketBasicInfo] AS
SELECT dep_sta.station_name AS dep_station, arr_sta.station_name AS arr_station, T.dep_timestamp, T.arr_timestamp, T.trip_date, T.passenger_id
FROM Railway.Ticket AS T JOIN Railway.Station AS dep_sta on T.dep_station = dep_sta.station_no
JOIN Railway.Station AS arr_sta on T.arr_station = arr_sta.station_no;
GO
/****** Object:  Table [Railway].[Person]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Person](
	[id] [int] IDENTITY(100000001,1) NOT NULL,
	[fname] [varchar](30) NOT NULL,
	[mname] [varchar](30) NULL,
	[lname] [varchar](30) NOT NULL,
	[birthdate] [date] NOT NULL,
	[nif] [int] NOT NULL,
	[gender] [char](1) NOT NULL,
	[postal_code] [varchar](50) NOT NULL,
	[city] [varchar](30) NOT NULL,
	[country] [varchar](30) NOT NULL,
	[phone] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[Passenger]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Passenger](
	[passenger_id] [int] NOT NULL,
	[email] [varchar](50) NOT NULL,
	[pw] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[passenger_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [Railway].[f_return_login]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Railway].[f_return_login] (@email VARCHAR(50), @password VARCHAR(50)) RETURNS Table
AS
	RETURN (SELECT * FROM Railway.Person AS person JOIN Railway.Passenger As passenger ON person.id = passenger.passenger_id
		WHERE passenger.email = @email AND passenger.pw = HASHBYTES('SHA1', @password))
GO
/****** Object:  Table [Railway].[Carriage]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Carriage](
	[carriage_no] [int] NOT NULL,
	[train_no] [int] NOT NULL,
	[no_seats] [int] NOT NULL,
	[class] [char](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[carriage_no] ASC,
	[train_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[ConnectsTo]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[ConnectsTo](
	[dep_station] [int] NOT NULL,
	[arr_station] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[dep_station] ASC,
	[arr_station] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[Discount]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Discount](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[promocode] [varchar](10) NULL,
	[discount] [varchar](4) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[Employee]    Script Date: 07/06/2019 22:55:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Employee](
	[emp_no] [int] IDENTITY(101,1) NOT NULL,
	[emp_id] [int] NOT NULL,
	[emp_role] [varchar](30) NULL,
	[station_no] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[emp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[Locality]    Script Date: 07/06/2019 22:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Locality](
	[locality_name] [varchar](30) NOT NULL,
	[station_no] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[locality_name] ASC,
	[station_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[ProfilePictures]    Script Date: 07/06/2019 22:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[ProfilePictures](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[img_base64] [varchar](max) NULL,
	[passenger_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Railway].[StopsAt]    Script Date: 07/06/2019 22:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[StopsAt](
	[station_no] [int] NOT NULL,
	[category] [varchar](2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[station_no] ASC,
	[category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[Train]    Script Date: 07/06/2019 22:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Train](
	[train_no] [int] IDENTITY(1,1) NOT NULL,
	[no_carriages] [int] NOT NULL,
	[total_seats] [int] NOT NULL,
	[category] [varchar](2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[train_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[TrainType]    Script Date: 07/06/2019 22:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[TrainType](
	[category] [varchar](2) NOT NULL,
	[designation] [varchar](30) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[category] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[Trip]    Script Date: 07/06/2019 22:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[Trip](
	[trip_no] [int] IDENTITY(1,1) NOT NULL,
	[trip_type] [varchar](2) NOT NULL,
	[dep_timestamp] [time](7) NOT NULL,
	[arr_timestamp] [time](7) NOT NULL,
	[dep_station] [int] NOT NULL,
	[arr_station] [int] NOT NULL,
	[duration] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[trip_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[TripInstance]    Script Date: 07/06/2019 22:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[TripInstance](
	[trip_no] [int] NOT NULL,
	[trip_date] [date] NOT NULL,
	[train_no] [int] NULL,
	[dep_station] [int] NULL,
	[arr_station] [int] NULL,
	[duration] [time](7) NULL,
	[dep_timestamp] [time](7) NULL,
	[arr_timestamp] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[trip_no] ASC,
	[trip_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Railway].[TripZone]    Script Date: 07/06/2019 22:55:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Railway].[TripZone](
	[zone_no] [int] IDENTITY(1,1) NOT NULL,
	[zone_name] [varchar](30) NOT NULL,
	[priceUR] [smallmoney] NOT NULL,
	[priceIC] [smallmoney] NOT NULL,
	[priceAP] [smallmoney] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[zone_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 1, 32, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 2, 25, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 3, 38, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 4, 36, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 5, 39, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 6, 37, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 7, 31, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 8, 38, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 9, 25, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 10, 29, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 11, 22, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 12, 29, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 13, 40, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 14, 38, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 15, 21, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 16, 39, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 17, 25, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 18, 23, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 19, 39, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 20, 20, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 21, 21, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 22, 25, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 23, 27, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 24, 33, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 25, 20, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 26, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 27, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 28, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 29, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 30, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 31, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 32, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 33, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 34, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (1, 35, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 1, 68, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 2, 59, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 3, 38, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 4, 27, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 5, 67, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 6, 40, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 7, 69, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 8, 39, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 9, 65, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 10, 32, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 11, 55, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 12, 64, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 13, 22, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 14, 21, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 15, 70, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 16, 38, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 17, 28, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 18, 20, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 19, 30, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 20, 24, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 21, 52, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 22, 30, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 23, 65, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 24, 67, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 25, 31, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 26, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 27, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 28, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 29, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 30, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 31, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 32, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 33, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 34, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (2, 35, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 1, 59, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 2, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 3, 60, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 4, 28, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 5, 67, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 6, 33, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 7, 54, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 8, 66, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 9, 55, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 10, 70, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 11, 59, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 12, 68, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 13, 59, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 14, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 15, 70, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 16, 33, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 17, 60, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 18, 20, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 19, 20, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 20, 55, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 21, 62, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 22, 52, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 23, 51, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 24, 55, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 25, 28, N'C')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 26, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 27, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 28, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 29, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 30, 0, N'M')
GO
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 31, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 32, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 33, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 34, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (3, 35, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 1, 67, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 2, 62, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 3, 59, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 4, 63, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 5, 56, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 6, 68, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 7, 53, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 8, 53, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 9, 51, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 10, 60, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 11, 56, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 12, 65, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 13, 52, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 14, 53, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 15, 69, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 16, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 17, 59, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 18, 51, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 19, 56, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 20, 70, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 21, 61, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 22, 58, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 23, 56, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 24, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 25, 58, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 26, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 27, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 28, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 29, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 30, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 31, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 32, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 33, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 34, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (4, 35, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 1, 60, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 3, 60, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 4, 61, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 6, 67, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 7, 65, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 8, 61, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 10, 62, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 11, 65, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 12, 61, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 13, 69, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 14, 66, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 16, 62, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 17, 67, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 18, 56, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 19, 51, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 20, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 22, 56, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 23, 57, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 24, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 25, 56, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 26, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 27, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 28, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 29, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 30, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 31, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 32, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 33, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 34, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (5, 35, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 3, 70, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 4, 59, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 6, 56, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 10, 60, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 11, 54, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 16, 62, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 17, 64, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 18, 67, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 19, 66, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 20, 64, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 22, 55, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 25, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 26, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 27, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 28, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 29, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 30, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 32, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (6, 33, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (7, 3, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (7, 25, 52, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (7, 26, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (7, 29, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (7, 30, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (7, 32, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (7, 33, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (8, 25, 50, N'E')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (8, 32, 0, N'M')
INSERT [Railway].[Carriage] ([carriage_no], [train_no], [no_seats], [class]) VALUES (8, 33, 0, N'M')
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (1, 2)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (2, 1)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (2, 3)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (3, 2)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (3, 4)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (4, 3)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (4, 5)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (5, 4)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (5, 6)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (6, 5)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (6, 7)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (7, 6)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (7, 8)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (8, 7)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (8, 9)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (8, 11)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (9, 8)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (9, 10)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (10, 9)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (10, 12)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (11, 8)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (11, 14)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (12, 10)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (12, 13)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (13, 12)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (13, 15)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (14, 11)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (14, 15)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (15, 13)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (15, 14)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (15, 16)
INSERT [Railway].[ConnectsTo] ([dep_station], [arr_station]) VALUES (16, 15)
SET IDENTITY_INSERT [Railway].[Discount] ON 

INSERT [Railway].[Discount] ([id], [promocode], [discount]) VALUES (1, N'qwertyuiop', N'25')
INSERT [Railway].[Discount] ([id], [promocode], [discount]) VALUES (2, N'tiagotomas', N'30')
INSERT [Railway].[Discount] ([id], [promocode], [discount]) VALUES (3, N'portopenta', N'40')
INSERT [Railway].[Discount] ([id], [promocode], [discount]) VALUES (4, N'pentaporto', N'15')
INSERT [Railway].[Discount] ([id], [promocode], [discount]) VALUES (5, N'cinqdescto', N'50')
SET IDENTITY_INSERT [Railway].[Discount] OFF
SET IDENTITY_INSERT [Railway].[Employee] ON 

INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (101, 100000001, N'Diretor', 1)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (102, 100000002, N'Diretor', 2)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (103, 100000003, N'Diretor', 3)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (104, 100000004, N'Diretor', 4)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (105, 100000005, N'Diretor', 5)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (106, 100000006, N'Diretor', 6)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (107, 100000007, N'Diretor', 7)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (108, 100000008, N'Diretor', 8)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (109, 100000009, N'Diretor', 9)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (110, 100000010, N'Diretor', 10)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (111, 100000011, N'Diretor', 11)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (112, 100000012, N'Diretor', 12)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (113, 100000013, N'Diretor', 13)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (114, 100000014, N'Diretor', 14)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (115, 100000015, N'Diretor', 15)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (116, 100000016, N'Diretor', 16)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (117, 100000017, N'Motorista', 1)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (118, 100000018, N'Motorista', 1)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (119, 100000019, N'Motorista', 2)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (120, 100000020, N'Motorista', 2)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (121, 100000021, N'Motorista', 3)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (122, 100000022, N'Motorista', 3)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (123, 100000023, N'Motorista', 4)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (124, 100000024, N'Motorista', 4)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (125, 100000025, N'Motorista', 5)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (126, 100000026, N'Motorista', 5)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (127, 100000027, N'Motorista', 6)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (128, 100000028, N'Motorista', 6)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (129, 100000029, N'Motorista', 7)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (130, 100000030, N'Motorista', 7)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (131, 100000031, N'Motorista', 8)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (132, 100000032, N'Motorista', 8)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (133, 100000033, N'Motorista', 9)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (134, 100000034, N'Motorista', 9)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (135, 100000035, N'Motorista', 10)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (136, 100000036, N'Motorista', 10)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (137, 100000037, N'Motorista', 11)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (138, 100000038, N'Motorista', 11)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (139, 100000039, N'Motorista', 12)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (140, 100000040, N'Motorista', 12)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (141, 100000041, N'Motorista', 13)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (142, 100000042, N'Motorista', 13)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (143, 100000043, N'Motorista', 14)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (144, 100000044, N'Motorista', 14)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (145, 100000045, N'Motorista', 15)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (146, 100000046, N'Motorista', 15)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (147, 100000047, N'Motorista', 16)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (148, 100000048, N'Motorista', 16)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (149, 100000049, N'Motorista', 1)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (150, 100000050, N'Motorista', 2)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (151, 100000051, N'Motorista', 3)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (152, 100000052, N'Picas', 1)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (153, 100000053, N'Picas', 1)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (154, 100000054, N'Picas', 2)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (155, 100000055, N'Picas', 2)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (156, 100000056, N'Picas', 3)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (157, 100000057, N'Picas', 3)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (158, 100000058, N'Picas', 4)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (159, 100000059, N'Picas', 4)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (160, 100000060, N'Picas', 5)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (161, 100000061, N'Picas', 5)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (162, 100000062, N'Picas', 6)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (163, 100000063, N'Picas', 6)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (164, 100000064, N'Picas', 7)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (165, 100000065, N'Picas', 7)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (166, 100000066, N'Picas', 8)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (167, 100000067, N'Picas', 8)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (168, 100000068, N'Picas', 9)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (169, 100000069, N'Picas', 9)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (170, 100000070, N'Picas', 10)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (171, 100000071, N'Picas', 10)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (172, 100000072, N'Picas', 11)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (173, 100000073, N'Picas', 11)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (174, 100000074, N'Picas', 12)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (175, 100000075, N'Picas', 12)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (176, 100000076, N'Picas', 13)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (177, 100000077, N'Picas', 13)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (178, 100000078, N'Picas', 14)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (179, 100000079, N'Picas', 14)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (180, 100000080, N'Picas', 15)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (181, 100000081, N'Picas', 15)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (182, 100000082, N'Picas', 16)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (183, 100000083, N'Picas', 16)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (184, 100000084, N'Picas', 1)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (185, 100000085, N'Picas', 2)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (186, 100000086, N'Picas', 3)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (187, 100000087, N'Bilheteiro', 1)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (188, 100000088, N'Bilheteiro', 2)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (189, 100000089, N'Bilheteiro', 3)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (190, 100000090, N'Bilheteiro', 4)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (191, 100000091, N'Bilheteiro', 5)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (192, 100000092, N'Bilheteiro', 6)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (193, 100000093, N'Bilheteiro', 7)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (194, 100000094, N'Bilheteiro', 8)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (195, 100000095, N'Bilheteiro', 9)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (196, 100000096, N'Bilheteiro', 10)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (197, 100000097, N'Bilheteiro', 11)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (198, 100000098, N'Bilheteiro', 12)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (199, 100000099, N'Bilheteiro', 13)
GO
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (200, 100000100, N'Bilheteiro', 14)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (201, 100000101, N'Bilheteiro', 15)
INSERT [Railway].[Employee] ([emp_no], [emp_id], [emp_role], [station_no]) VALUES (202, 100000102, N'Bilheteiro', 16)
SET IDENTITY_INSERT [Railway].[Employee] OFF
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Aveiro', 8)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Braga', 2)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Caldas da Rainha', 14)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Coimbra', 9)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Entroncamento', 12)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Figueira da Foz', 11)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Guimarães', 3)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Lisboa', 15)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Lisboa', 16)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Ovar', 7)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Pombal', 10)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Porto', 4)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Porto', 5)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Santarém', 13)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Viana do Castelo', 1)
INSERT [Railway].[Locality] ([locality_name], [station_no]) VALUES (N'Vila Nova de Gaia', 6)
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000103, N'amelia_faria@ua.pt', N'ƒ{Í¸pJC>Ë™;ÚÑ&P')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000104, N'catarina_morais@ua.pt', N'3-#b¸¢Ëea3~•cæË')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000105, N'cremilde_nogueira@ua.pt', N'œé<ä=‡Ûr¦D4¥¥- \')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000106, N'leonor_nogueira@ua.pt', N'<µ5IÇheö;‰ª¥Õ™³+N')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000107, N'lara_machado@ua.pt', N'»gªi®„°YZÎáÁ(RÉ€!¦æ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000108, N'catarina_carneiro@ua.pt', N'Ì*JÞíº0NãjÉRsˆ†ä')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000109, N'irina_andrade@ua.pt', N'\0n¡é+´;''»0B')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000110, N'mariana_paiva@ua.pt', N'F™ ˆ@C‘ïK2õÅuHfeN')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000111, N'cristina_fonseca@ua.pt', N'½j÷—®ÌÈxQ¶o¹â`ÞÑì^')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000112, N'maria_barbosa@ua.pt', N'^×Zä[CÙ/Ý?óË|ß×ÊæË')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000113, N'emilia_vaz@ua.pt', N'Ê|ÂJ“:?î©ß¨‹?\õ\›##')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000114, N'cremilde_simoes@ua.pt', N'›&„ïŸ”Wt$Çð`=n¸')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000115, N'carolina_morais@ua.pt', N'Œ™1g®{m¥[\J*î ¥áÇ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000116, N'emilia_martins@ua.pt', N' xŒÜÊèZOÓÌ‰ü¸¢—')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000117, N'ines_figueiredo@ua.pt', N'ÍMü¯;j”u¯3ÿç}sW}§')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000118, N'daenerys_rocha@ua.pt', N'ÝŸAšÃZ±ªèH?ZqÁø7>')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000119, N'beatriz_lopes@ua.pt', N'MÊçJðOánë{O''Ï4¯Îà')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000120, N'matilde_barros@ua.pt', N'wì‡Éžx¨]nŽ¤À™¨–:&ü')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000121, N'joana_fonseca@ua.pt', N'¾STÑƒ„(S‡¯™dÛ9Žð2Þ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000122, N'sofia_costa@ua.pt', N'ì³Ifov˜ÔoýITÙ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000123, N'mariana_ferreira@ua.pt', N'é.7ƒÇžpa0ÿÓF€åŽM')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000124, N'filipa_freitas@ua.pt', N'¤üÌ
ÛÂC7ù˜ó¿úWÜ<“')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000125, N'emilia_almeida@ua.pt', N'jz]û.Æ@ñ®÷º08ÆÐZá(')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000126, N'matilde_gaspar@ua.pt', N'àâl6,î9jºœ¢N‡„Nòù')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000127, N'ines_pinho@ua.pt', N'èW‚,}I0¹ÄevíXL…†çÙ<ó')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000128, N'daenerys_brito@ua.pt', N'K±Èwb	@-‹{ó²N~‹zú')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000129, N'carolina_domingues@ua.pt', N'Û%(Q%È[oÇ®´ÿœ¾i ŽÔ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000130, N'cristina_correia@ua.pt', N'RHåvùò#¥¾¹êWæ´')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000131, N'ana_monteiro@ua.pt', N'èB©Ì.Ÿr·À÷f{ßyº†§')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000132, N'maria_moreira@ua.pt', N'ê
y³veï4Á;ìªæ¿!Œðo«')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000133, N'carolina_moreira@ua.pt', N'$ˆL¶c	óBÉ¿Ä*¡í ·Ë?+ü')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000134, N'daenerys_lopes@ua.pt', N'ÀM±PˆÙ:6XX¾dX|ÂNí')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000135, N'rafela_lopes@ua.pt', N''' @ù†ž:n–›5/!¸K¬')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000136, N'emilia_correia@ua.pt', N'™#/8EO	}ˆsI}‡æÝýà')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000137, N'idalina_miranda@ua.pt', N'JèæÙóß0ëÛ8OˆŸ6åS')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000138, N'irina_coelho@ua.pt', N'ÞÆ#ð¥%3llAãÍºâ+Y»x')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000139, N'irina_oliveira@ua.pt', N'¯rõŠäYŒí“Î¤Ø€´Ó')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000140, N'amelia_henriques@ua.pt', N'I–"''„KN&ý ÷“øÛöéƒ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000141, N'cristina_figueiredo@ua.pt', N'U3 vo+Ôs1{>ëƒœ[È1"p')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000142, N'ines_reis@ua.pt', N'ƒÇÎ ¡½ê8=g4ß½A$ê')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000143, N'catarina_pinheiro@ua.pt', N'w–fFÇÞí$6{AFiSH‘˜')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000144, N'carolina_campos@ua.pt', N'XÉÆÈ½1."YS“''çíÖ^»')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000145, N'maria_coelho@ua.pt', N'bÎ}8c»Ž${=h$7"0‚q')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000146, N'ana_oliveira@ua.pt', N'KÆYÆs}®…ÒEÞÆüT³')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000147, N'amelia_vicente@ua.pt', N'?1÷G,ƒ¾''7»“Ë~q')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000148, N'lara_nogueira@ua.pt', N'ÇšÜB(iŒ?  ­¤—ì EÖ¢')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000149, N'beatriz_guerreiro@ua.pt', N'·¬Gò¹T°ÜÚAÆ“è%XuGöÎ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000150, N'cremilde_branco@ua.pt', N'¹b7€³V]’{5´ã#›ªâU')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000151, N'daenerys_sim?es@ua.pt', N'ý )J§­n0¸½ÊC‚(Ôÿ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000152, N'emilia_nascimento@ua.pt', N'R½1§B­??Á·¥J/ž 8QÀ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000153, N'cremilde_valente@ua.pt', N'(¬}¢¸ÌäÌ?WÃ~ËÁßóÁZ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000154, N'joana_cardoso@ua.pt', N'Ê^Aò^¼†˜Ìó«Ü‰xkä½')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000155, N'marta_nogueira@ua.pt', N's]øØdwd1Q¹Œ!ýþá·9s')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000156, N'joana_henriques@ua.pt', N'sj_¯“ÁŽhbÊQ|yl¹žêñáõ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000157, N'cristina_ferreira@ua.pt', N'l²pk ­;„›·V ´óÅ[D;')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000158, N'rafela_magalh?es@ua.pt', N'ŠÇã­³H	KZ\Ê”eGƒ}ˆáO')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000159, N'mariana_rodrigues@ua.pt', N' HŒ©` ïP|BNóç')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000160, N'joana_amorim@ua.pt', N'Bk>mmq-¾¤©¬(’­…')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000161, N'emilia_pinto@ua.pt', N'|ŒppÆ}äRêý.Ï’õjàa·Ó')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000162, N'ana_borges@ua.pt', N' ò®š¯þ(fzpØ)ÿ‰æÊÎ¥›')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000163, N'leonor_macedo@ua.pt', N'ãf÷§¯äWeÖ@6€û­Æî”Æõ')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000164, N'sofia_pires@ua.pt', N'ykwÆq]Ü¾T(Y/Dh')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000165, N'irina_araujo@ua.pt', N'_‰Ï¤æOK1Ä†*µ•V”»Øä')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000166, N'ana_pereira@ua.pt', N'×ìR¬j}Têa„ƒ–Ø8SL')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000167, N'maria_nogueira@ua.pt', N'v»i¦Žv£Å61î–i‡4KWËü')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000168, N'daenerys_monteiro@ua.pt', N'2tÇ€K±ÏÆ_D0Ò‰ãP–´')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000169, N'emilia_pinto02@ua.pt', N'a‘+Oy”Ûcrû,«5“‹À')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000170, N'amelia_pinho@ua.pt', N'OˆD„-×·¤™ØBóWrW-')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000171, N'marta_abreu@ua.pt', N'{š™%Xˆzù«Ç¶­œ‚€s^Œ~')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000172, N'carolina_torres@ua.pt', N'šÓ>N’bmÿŸÿQz·dÔñ‰')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000173, N'lara_maia@ua.pt', N'Q“,³À÷˜¦ÐtŒ¸^5%õ¯')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000174, N'irina_correia@ua.pt', N'Ø•;‹évIÂ?ôo(åÁ‘')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000175, N'sofia_faria@ua.pt', N'H|ø¨HÏ­?öðp=/ðZ-Ù‹')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000176, N'sofia_baptista@ua.pt', N'×¬Ù
ïððT-·øyhù$R¼Kò')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000177, N'marta_moura@ua.pt', N'G³-”Ù Ð°!ôhXîày¯¤¸')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000178, N'sofia_batista@ua.pt', N'ä/1ÎºîBÓöJN"ªh[(à')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000179, N'catarina_sim?es@ua.pt', N'™F±•ì½ƒZ½ÑxÂP~€~')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000180, N'lara_marques@ua.pt', N';”ÍýFÒÒ­ØUü˜nÇX^ÈV')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000181, N'mariana_morais@ua.pt', N'¾ ŽööÆ²Ô¸‹¸ pÉ½‡F^')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000182, N'mariana_borges@ua.pt', N'•Œó°d`‡å~B¦‰ }R')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000183, N'maria_neto@ua.pt', N'ÁÖ§bÝöú£ƒRu$U¦V¤AùD£')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000184, N'ines_martins@ua.pt', N'™Ûš4(­|aw#tø^_Ô9Û¬×')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000185, N'rafela_moura@ua.pt', N'÷4bLÑÌ¤@YòÙ¯… ¥›r“')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000186, N'marta_cruz@ua.pt', N'Úuœ°Ò%ûGÑsŒ7(l‚óv')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000187, N'ines_domingues@ua.pt', N'2èy‡K_¤¤Ï;ßdøaTŸJß')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000188, N'mariana_pinho@ua.pt', N'zÃéƒÕ9J*8Ls›£WP»')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000189, N'mariana_matias@ua.pt', N'z¿V>ÛåÆº™ÖsmÌ¬HA¾')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000190, N'cristina_andrade@ua.pt', N'D¨ý«~ÑÂ~ovCß©l“T½')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000191, N'mariana_teixeira@ua.pt', N'‡ÞwØ;ú:	Š5§å·æõTšÂ¨')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000192, N'matilde_branco@ua.pt', N'£?ý™ûVä¶û«Õ»WøD¨')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000193, N'lara_lima@ua.pt', N'oVç€^w% O,å´­Ù#ä ap')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000194, N'filipa_almeida@ua.pt', N'úVÿ¯½Ö1îOº6Y%»ÆOi')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000195, N'irina_anjos@ua.pt', N'øb›sAÕ(Éá8(ÖXN >8Ç')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000196, N'matilde_goncalves@ua.pt', N'7³\tÖ}n9"Ð·¥ã{8wí')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000197, N'matilde_jesus@ua.pt', N'’t3%”ôæp
áîtt¶°W')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000198, N'joana_pinheiro@ua.pt', N'–ô1¨ô•16”c€9¦»$VÄX9')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000199, N'lara_gaspar@ua.pt', N'J“Ã„B#Œ«Yý+ {/]Mq')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000200, N'beatriz_simoes@ua.pt', N'gSÍq¾Ï‡Šäbøìä·‚€ò')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000203, N'tiagocmendes@ua.pt', N'Œ²#}yÊˆÛddêÆ©cEQ9d')
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000204, N'tomasbatista@ua.pt', N'12345')
GO
INSERT [Railway].[Passenger] ([passenger_id], [email], [pw]) VALUES (100000213, N'tiago_tomas@ua.pt', N'Œ²#}yÊˆÛddêÆ©cEQ9d')
SET IDENTITY_INSERT [Railway].[Person] ON 

INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000001, N'Ângelo', NULL, N'Figueiredo', CAST(N'1956-11-06' AS Date), 100000000, N'M', N'6191', N'Castelo Branco', N'Portugal', 900000000)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000002, N'Marcelo', NULL, N'AraÃºjo', CAST(N'1969-10-27' AS Date), 100000001, N'M', N'3879', N'Aveiro', N'Portugal', 900000001)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000003, N'Rui', NULL, N'Santos', CAST(N'1984-07-26' AS Date), 100000002, N'M', N'5010', N'Viseu', N'Portugal', 900000002)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000004, N'Ângelo', NULL, N'Costa', CAST(N'1958-05-19' AS Date), 100000003, N'M', N'4508', N'Setúbal', N'Portugal', 900000003)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000005, N'Ângelo', NULL, N'Matias', CAST(N'1987-07-13' AS Date), 100000004, N'M', N'3834', N'Aveiro', N'Portugal', 900000004)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000006, N'Tomás', NULL, N'Nunes', CAST(N'1994-02-02' AS Date), 100000005, N'M', N'4597', N'Porto', N'Portugal', 900000005)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000007, N'António', NULL, N'Antunes', CAST(N'1951-02-27' AS Date), 100000006, N'M', N'2640', N'Lisboa', N'Portugal', 900000006)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000008, N'Daniel', NULL, N'Carvalho', CAST(N'1995-08-08' AS Date), 100000007, N'M', N'7121', N'Portalegre', N'Portugal', 900000007)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000009, N'Jorge', NULL, N'Valente', CAST(N'1983-11-18' AS Date), 100000008, N'M', N'9536', N'Açores', N'Portugal', 900000008)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000010, N'Ângelo', NULL, N'Torres', CAST(N'1992-07-20' AS Date), 100000009, N'M', N'4670', N'Braga', N'Portugal', 900000009)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000011, N'Rui', NULL, N'Mendes', CAST(N'1979-10-22' AS Date), 100000010, N'M', N'3406', N'Aveiro', N'Portugal', 900000010)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000012, N'Paulo', NULL, N'Leal', CAST(N'1953-07-07' AS Date), 100000011, N'M', N'4931', N'Viana do Castelo', N'Portugal', 900000011)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000013, N'Rafael', NULL, N'Ribeiro', CAST(N'1956-11-06' AS Date), 100000012, N'M', N'5894', N'Guarda', N'Portugal', 900000012)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000014, N'Jon', NULL, N'Pinto', CAST(N'1993-02-02' AS Date), 100000013, N'M', N'8011', N'Faro', N'Portugal', 900000013)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000015, N'Dinis', NULL, N'Garcia', CAST(N'2001-01-26' AS Date), 100000014, N'M', N'7822', N'Beja', N'Portugal', 900000014)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000016, N'Rodrigo', NULL, N'Domingues', CAST(N'1992-07-20' AS Date), 100000015, N'M', N'5320', N'Vila Real', N'Portugal', 900000015)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000017, N'Filipe', NULL, N'Gomes', CAST(N'1953-08-18' AS Date), 100000016, N'M', N'5702', N'Guarda', N'Portugal', 900000016)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000018, N'Jonhy', NULL, N'Mendes', CAST(N'1970-06-11' AS Date), 100000017, N'M', N'5286', N'Bragança', N'Portugal', 900000017)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000019, N'André', NULL, N'Teixeira', CAST(N'1987-07-13' AS Date), 100000018, N'M', N'5327', N'Bragança', N'Portugal', 900000018)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000020, N'Tomás', NULL, N'Pinho', CAST(N'1954-10-05' AS Date), 100000019, N'M', N'5634', N'Setúbal', N'Portugal', 900000019)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000021, N'Dinis', NULL, N'Pinto', CAST(N'1964-10-06' AS Date), 100000020, N'M', N'4685', N'Braga', N'Portugal', 900000020)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000022, N'Dinis', NULL, N'Carneiro', CAST(N'1973-03-30' AS Date), 100000021, N'M', N'3201', N'Aveiro', N'Portugal', 900000021)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000023, N'João', NULL, N'Azevedo', CAST(N'1973-09-06' AS Date), 100000022, N'M', N'9681', N'Açores', N'Portugal', 900000022)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000024, N'Cristiano', NULL, N'Carvalho', CAST(N'1998-09-11' AS Date), 100000023, N'M', N'5730', N'Coimbra', N'Portugal', 900000023)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000025, N'António', NULL, N'Esteves', CAST(N'1994-09-20' AS Date), 100000024, N'M', N'6873', N'Portalegre', N'Portugal', 900000024)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000026, N'Dinis', NULL, N'Matias', CAST(N'1990-09-10' AS Date), 100000025, N'M', N'5506', N'Évora', N'Portugal', 900000025)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000027, N'Jorge', NULL, N'Correia', CAST(N'1960-06-23' AS Date), 100000026, N'M', N'3112', N'Leiria', N'Portugal', 900000026)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000028, N'António', NULL, N'Alves', CAST(N'1973-09-06' AS Date), 100000027, N'M', N'5357', N'Bragança', N'Portugal', 900000027)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000029, N'Mateus', NULL, N'SÃ¡', CAST(N'1959-11-27' AS Date), 100000028, N'M', N'4879', N'Braga', N'Portugal', 900000028)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000030, N'João', NULL, N'Fernandes', CAST(N'1978-12-26' AS Date), 100000029, N'M', N'7700', N'Beja', N'Portugal', 900000029)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000031, N'Luís', NULL, N'Coelho', CAST(N'1985-04-18' AS Date), 100000030, N'M', N'4435', N'Guarda', N'Portugal', 900000030)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000032, N'Dinis', NULL, N'SimÃµes', CAST(N'1955-08-08' AS Date), 100000031, N'M', N'9090', N'Madeira', N'Portugal', 900000031)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000033, N'Dinis', NULL, N'Carneiro', CAST(N'1987-07-08' AS Date), 100000032, N'M', N'5597', N'Guarda', N'Portugal', 900000032)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000034, N'António', NULL, N'Faria', CAST(N'1978-01-13' AS Date), 100000033, N'M', N'7253', N'Beja', N'Portugal', 900000033)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000035, N'Tyrion', NULL, N'Neves', CAST(N'1969-10-27' AS Date), 100000034, N'M', N'7460', N'Beja', N'Portugal', 900000034)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000036, N'Luís', NULL, N'Alves', CAST(N'1971-06-23' AS Date), 100000035, N'M', N'4710', N'Viseu', N'Portugal', 900000035)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000037, N'Marcelo', NULL, N'Valente', CAST(N'1999-03-29' AS Date), 100000036, N'M', N'4555', N'Setúbal', N'Portugal', 900000036)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000038, N'Ângelo', NULL, N'Gaspar', CAST(N'1985-06-05' AS Date), 100000037, N'M', N'5994', N'Guarda', N'Portugal', 900000037)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000039, N'Luís', NULL, N'Pinheiro', CAST(N'2001-01-25' AS Date), 100000038, N'M', N'5077', N'Vila Real', N'Portugal', 900000038)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000040, N'Tyrion', NULL, N'Tavares', CAST(N'1953-06-25' AS Date), 100000039, N'M', N'5215', N'Bragança', N'Portugal', 900000039)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000041, N'Jonhy', NULL, N'Teixeira', CAST(N'1997-12-26' AS Date), 100000040, N'M', N'9798', N'Açores', N'Portugal', 900000040)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000042, N'José', NULL, N'Ferreira', CAST(N'2001-01-26' AS Date), 100000041, N'M', N'3624', N'Aveiro', N'Portugal', 900000041)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000043, N'João', NULL, N'Barbosa', CAST(N'1976-11-04' AS Date), 100000042, N'M', N'9325', N'Madeira', N'Portugal', 900000042)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000044, N'António', NULL, N'Domingues', CAST(N'1961-08-29' AS Date), 100000043, N'M', N'6138', N'Portalegre', N'Portugal', 900000043)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000045, N'Dinis', NULL, N'Pacheco', CAST(N'1960-02-19' AS Date), 100000044, N'M', N'5153', N'Bragança', N'Portugal', 900000044)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000046, N'Jonhy', NULL, N'Gomes', CAST(N'1962-11-23' AS Date), 100000045, N'M', N'5325', N'Vila Real', N'Portugal', 900000045)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000047, N'Rafael', NULL, N'Teixeira', CAST(N'1985-05-24' AS Date), 100000046, N'M', N'4809', N'Viseu', N'Portugal', 900000046)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000048, N'António', NULL, N'Gomes', CAST(N'1962-12-25' AS Date), 100000047, N'M', N'9060', N'Madeira', N'Portugal', 900000047)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000049, N'André', NULL, N'Coelho', CAST(N'1984-07-26' AS Date), 100000048, N'M', N'3239', N'Coimbra', N'Portugal', 900000048)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000050, N'José', NULL, N'Tavares', CAST(N'1981-05-29' AS Date), 100000049, N'M', N'5147', N'Coimbra', N'Portugal', 900000049)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000051, N'Rafael', NULL, N'Torres', CAST(N'1964-08-31' AS Date), 100000050, N'M', N'6181', N'Castelo Branco', N'Portugal', 900000050)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000052, N'Jonhy', NULL, N'Rodrigues', CAST(N'1967-08-24' AS Date), 100000051, N'M', N'4500', N'Aveiro', N'Portugal', 900000051)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000053, N'Paulo', NULL, N'Monteiro', CAST(N'2001-02-28' AS Date), 100000052, N'M', N'6984', N'Setúbal', N'Portugal', 900000052)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000054, N'Rui', NULL, N'Nunes', CAST(N'1971-06-23' AS Date), 100000053, N'M', N'5442', N'Santarém', N'Portugal', 900000053)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000055, N'André', NULL, N'Ferreira', CAST(N'1959-07-21' AS Date), 100000054, N'M', N'5156', N'Bragança', N'Portugal', 900000054)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000056, N'João', NULL, N'Valente', CAST(N'1955-02-08' AS Date), 100000055, N'M', N'3488', N'Aveiro', N'Portugal', 900000055)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000057, N'Rui', NULL, N'Nogueira', CAST(N'1965-06-03' AS Date), 100000056, N'M', N'5337', N'Bragança', N'Portugal', 900000056)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000058, N'Jonhy', NULL, N'Rodrigues', CAST(N'1975-06-02' AS Date), 100000057, N'M', N'4688', N'Braga', N'Portugal', 900000057)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000059, N'Daniel', NULL, N'Ramos', CAST(N'1971-06-23' AS Date), 100000058, N'M', N'2839', N'Setúbal', N'Portugal', 900000058)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000060, N'Dinis', NULL, N'Antunes', CAST(N'1964-10-06' AS Date), 100000059, N'M', N'2780', N'Lisboa', N'Portugal', 900000059)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000061, N'Ângelo', NULL, N'Andrade', CAST(N'1956-12-18' AS Date), 100000060, N'M', N'9898', N'Açores', N'Portugal', 900000060)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000062, N'Luís', NULL, N'Faria', CAST(N'1953-06-25' AS Date), 100000061, N'M', N'3146', N'Leiria', N'Portugal', 900000061)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000063, N'Jorge', NULL, N'Monteiro', CAST(N'1951-02-27' AS Date), 100000062, N'M', N'6466', N'Portalegre', N'Portugal', 900000062)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000064, N'André', NULL, N'SimÃµes', CAST(N'1965-05-19' AS Date), 100000063, N'M', N'6077', N'Coimbra', N'Portugal', 900000063)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000065, N'Dinis', NULL, N'Leal', CAST(N'1994-12-21' AS Date), 100000064, N'M', N'9776', N'Açores', N'Portugal', 900000064)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000066, N'Dinis', NULL, N'Pires', CAST(N'1993-02-02' AS Date), 100000065, N'M', N'4843', N'Viseu', N'Portugal', 900000065)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000067, N'Tyrion', NULL, N'Ramos', CAST(N'1953-07-07' AS Date), 100000066, N'M', N'2171', N'Lisboa', N'Portugal', 900000066)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000068, N'Daniel', NULL, N'Amaral', CAST(N'1997-12-26' AS Date), 100000067, N'M', N'9503', N'Açores', N'Portugal', 900000067)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000069, N'Tomás', NULL, N'Rodrigues', CAST(N'1996-05-06' AS Date), 100000068, N'M', N'1201', N'Lisboa', N'Portugal', 900000068)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000070, N'Marcelo', NULL, N'Amorim', CAST(N'1997-08-26' AS Date), 100000069, N'M', N'5434', N'Santarém', N'Portugal', 900000069)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000071, N'Paulo', NULL, N'Sousa', CAST(N'1965-06-03' AS Date), 100000070, N'M', N'3694', N'Santarém', N'Portugal', 900000070)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000072, N'António', NULL, N'Batista', CAST(N'1964-08-31' AS Date), 100000071, N'M', N'4663', N'Braga', N'Portugal', 900000071)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000073, N'Daniel', NULL, N'Sousa', CAST(N'1987-08-31' AS Date), 100000072, N'M', N'3143', N'Aveiro', N'Portugal', 900000072)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000074, N'Dinis', NULL, N'Ribeiro', CAST(N'1993-02-02' AS Date), 100000073, N'M', N'5972', N'Santarém', N'Portugal', 900000073)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000075, N'Filipe', NULL, N'Leal', CAST(N'1958-05-19' AS Date), 100000074, N'M', N'3175', N'Santarém', N'Portugal', 900000074)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000076, N'Rui', NULL, N'Pacheco', CAST(N'1987-08-31' AS Date), 100000075, N'M', N'7425', N'Beja', N'Portugal', 900000075)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000077, N'Duarte', NULL, N'Monteiro', CAST(N'1994-02-02' AS Date), 100000076, N'M', N'4609', N'Porto', N'Portugal', 900000076)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000078, N'Jorge', NULL, N'Pinto', CAST(N'1985-12-25' AS Date), 100000077, N'M', N'6275', N'Coimbra', N'Portugal', 900000077)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000079, N'Tomás', NULL, N'Moreira', CAST(N'1994-02-02' AS Date), 100000078, N'M', N'6077', N'Portalegre', N'Portugal', 900000078)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000080, N'André', NULL, N'Oliveira', CAST(N'1996-05-06' AS Date), 100000079, N'M', N'4558', N'Viseu', N'Portugal', 900000079)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000081, N'Mateus', NULL, N'Teixeira', CAST(N'2001-09-21' AS Date), 100000080, N'M', N'4929', N'Viana do Castelo', N'Portugal', 900000080)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000082, N'Daniel', NULL, N'Leal', CAST(N'1994-12-14' AS Date), 100000081, N'M', N'4687', N'Braga', N'Portugal', 900000081)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000083, N'Cristiano', NULL, N'Leal', CAST(N'1996-05-06' AS Date), 100000082, N'M', N'8359', N'Faro', N'Portugal', 900000082)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000084, N'Vasco', NULL, N'Mota', CAST(N'1978-01-13' AS Date), 100000083, N'M', N'7814', N'Beja', N'Portugal', 900000083)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000085, N'Filipe', NULL, N'Figueiredo', CAST(N'2001-01-25' AS Date), 100000084, N'M', N'5039', N'Vila Real', N'Portugal', 900000084)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000086, N'Rui', NULL, N'Amaral', CAST(N'1975-04-25' AS Date), 100000085, N'M', N'1748', N'Lisboa', N'Portugal', 900000085)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000087, N'Paulo', NULL, N'Sousa', CAST(N'1994-12-21' AS Date), 100000086, N'M', N'9514', N'Açores', N'Portugal', 900000086)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000088, N'Tiago', NULL, N'Leal', CAST(N'1986-11-28' AS Date), 100000087, N'M', N'4548', N'Porto', N'Portugal', 900000087)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000089, N'Mateus', NULL, N'Pinto', CAST(N'1970-01-29' AS Date), 100000088, N'M', N'7864', N'Beja', N'Portugal', 900000088)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000090, N'Mateus', NULL, N'Teixeira', CAST(N'1961-08-29' AS Date), 100000089, N'M', N'3441', N'Aveiro', N'Portugal', 900000089)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000091, N'Dinis', NULL, N'Ribeiro', CAST(N'1985-05-24' AS Date), 100000090, N'M', N'5161', N'Évora', N'Portugal', 900000090)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000092, N'Jon', NULL, N'Henriques', CAST(N'1984-07-26' AS Date), 100000091, N'M', N'4358', N'Aveiro', N'Portugal', 900000091)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000093, N'Rodrigo', NULL, N'Melo', CAST(N'1989-09-22' AS Date), 100000092, N'M', N'5993', N'Santarém', N'Portugal', 900000092)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000094, N'Vasco', NULL, N'Costa', CAST(N'1952-03-24' AS Date), 100000093, N'M', N'3014', N'Leiria', N'Portugal', 900000093)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000095, N'Dinis', NULL, N'Amorim', CAST(N'1977-10-14' AS Date), 100000094, N'M', N'7903', N'Beja', N'Portugal', 900000094)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000096, N'Ângelo', NULL, N'Pinho', CAST(N'1970-01-29' AS Date), 100000095, N'M', N'9150', N'Madeira', N'Portugal', 900000095)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000097, N'Rafael', NULL, N'Henriques', CAST(N'1951-08-30' AS Date), 100000096, N'M', N'8367', N'Faro', N'Portugal', 900000096)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000098, N'Marcelo', NULL, N'Tavares', CAST(N'1956-11-06' AS Date), 100000097, N'M', N'4069', N'Viseu', N'Portugal', 900000097)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000099, N'Paulo', NULL, N'Nascimento', CAST(N'1977-08-19' AS Date), 100000098, N'M', N'4018', N'Viseu', N'Portugal', 900000098)
GO
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000100, N'André', NULL, N'Guerreiro', CAST(N'1953-06-25' AS Date), 100000099, N'M', N'3176', N'Leiria', N'Portugal', 900000099)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000101, N'Filipa', NULL, N'Maia', CAST(N'1995-08-08' AS Date), 100000100, N'F', N'4938', N'Santarém', N'Portugal', 900000100)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000102, N'Beatriz', NULL, N'Castro', CAST(N'1987-07-08' AS Date), 100000101, N'F', N'6113', N'Castelo Branco', N'Portugal', 900000101)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000103, N'Amélia', NULL, N'Faria', CAST(N'1983-11-18' AS Date), 100000102, N'F', N'5208', N'Bragança', N'Portugal', 900000102)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000104, N'Catarina', NULL, N'Morais', CAST(N'1962-11-23' AS Date), 100000103, N'F', N'8381', N'Faro', N'Portugal', 900000103)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000105, N'Cremilde', NULL, N'Nogueira', CAST(N'1954-12-30' AS Date), 100000104, N'F', N'9875', N'Açores', N'Portugal', 900000104)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000106, N'Leonor', NULL, N'Nogueira', CAST(N'1965-05-19' AS Date), 100000105, N'F', N'3177', N'Santarém', N'Portugal', 900000105)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000107, N'Lara', NULL, N'Machado', CAST(N'1971-06-23' AS Date), 100000106, N'F', N'2412', N'Lisboa', N'Portugal', 900000106)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000108, N'Catarina', NULL, N'Carneiro', CAST(N'1978-01-13' AS Date), 100000107, N'F', N'4491', N'Porto', N'Portugal', 900000107)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000109, N'Irina', NULL, N'Andrade', CAST(N'1995-08-08' AS Date), 100000108, N'F', N'7515', N'Beja', N'Portugal', 900000108)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000110, N'Mariana', NULL, N'Paiva', CAST(N'1971-01-07' AS Date), 100000109, N'F', N'7080', N'Portalegre', N'Portugal', 900000109)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000111, N'Cristina', NULL, N'Fonseca', CAST(N'1961-08-29' AS Date), 100000110, N'F', N'4627', N'Braga', N'Portugal', 900000110)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000112, N'Maria', NULL, N'Barbosa', CAST(N'1998-09-11' AS Date), 100000111, N'F', N'3651', N'Guarda', N'Portugal', 900000111)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000113, N'Emília', NULL, N'Vaz', CAST(N'1997-08-26' AS Date), 100000112, N'F', N'6522', N'Portalegre', N'Portugal', 900000112)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000114, N'Cremilde', NULL, N'SimÃµes', CAST(N'1976-11-04' AS Date), 100000113, N'F', N'6512', N'Évora', N'Portugal', 900000113)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000115, N'Carolina', NULL, N'Morais', CAST(N'1987-06-15' AS Date), 100000114, N'F', N'5189', N'Évora', N'Portugal', 900000114)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000116, N'Emília', NULL, N'Martins', CAST(N'1956-12-18' AS Date), 100000115, N'F', N'7398', N'Évora', N'Portugal', 900000115)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000117, N'Inês', NULL, N'Figueiredo', CAST(N'2001-09-21' AS Date), 100000116, N'F', N'5094', N'Vila Real', N'Portugal', 900000116)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000118, N'Daenerys', NULL, N'Rocha', CAST(N'1971-06-23' AS Date), 100000117, N'F', N'8540', N'Faro', N'Portugal', 900000117)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000119, N'Beatriz', NULL, N'Lopes', CAST(N'1979-02-27' AS Date), 100000118, N'F', N'3945', N'Aveiro', N'Portugal', 900000118)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000120, N'Matilde', NULL, N'Barros', CAST(N'1952-03-24' AS Date), 100000119, N'F', N'9147', N'Madeira', N'Portugal', 900000119)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000121, N'Joana', NULL, N'Fonseca', CAST(N'1987-06-15' AS Date), 100000120, N'F', N'7162', N'Setúbal', N'Portugal', 900000120)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000122, N'Sofia', NULL, N'Costa', CAST(N'1959-07-21' AS Date), 100000121, N'F', N'1754', N'Lisboa', N'Portugal', 900000121)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000123, N'Mariana', NULL, N'Ferreira', CAST(N'1978-12-26' AS Date), 100000122, N'F', N'5433', N'Setúbal', N'Portugal', 900000122)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000124, N'Filipa', NULL, N'Freitas', CAST(N'1960-06-23' AS Date), 100000123, N'F', N'4918', N'Viana do Castelo', N'Portugal', 900000123)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000125, N'Emília', NULL, N'Almeida', CAST(N'1962-11-01' AS Date), 100000124, N'F', N'4190', N'Viseu', N'Portugal', 900000124)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000126, N'Matilde', NULL, N'Gaspar', CAST(N'1985-06-05' AS Date), 100000125, N'F', N'5260', N'Setúbal', N'Portugal', 900000125)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000127, N'Inês', NULL, N'Pinho', CAST(N'1954-10-05' AS Date), 100000126, N'F', N'6066', N'Castelo Branco', N'Portugal', 900000126)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000128, N'Daenerys', NULL, N'Brito', CAST(N'1957-04-02' AS Date), 100000127, N'F', N'3815', N'Guarda', N'Portugal', 900000127)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000129, N'Carolina', NULL, N'Domingues', CAST(N'1994-02-02' AS Date), 100000128, N'F', N'7242', N'Beja', N'Portugal', 900000128)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000130, N'Cristina', NULL, N'Correia', CAST(N'1997-08-26' AS Date), 100000129, N'F', N'3821', N'Coimbra', N'Portugal', 900000129)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000131, N'Ana', NULL, N'Monteiro', CAST(N'1959-11-27' AS Date), 100000130, N'F', N'4860', N'Braga', N'Portugal', 900000130)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000132, N'Maria', NULL, N'Moreira', CAST(N'1984-07-26' AS Date), 100000131, N'F', N'4954', N'Viana do Castelo', N'Portugal', 900000131)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000133, N'Carolina', NULL, N'Moreira', CAST(N'1955-08-08' AS Date), 100000132, N'F', N'2556', N'Leiria', N'Portugal', 900000132)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000134, N'Daenerys', NULL, N'Lopes', CAST(N'1985-12-25' AS Date), 100000133, N'F', N'2630', N'Leiria', N'Portugal', 900000133)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000135, N'Rafela', NULL, N'Lopes', CAST(N'1971-06-23' AS Date), 100000134, N'F', N'5392', N'Vila Real', N'Portugal', 900000134)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000136, N'Emília', NULL, N'Correia', CAST(N'1957-04-02' AS Date), 100000135, N'F', N'3610', N'Viseu', N'Portugal', 900000135)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000137, N'Idalina', NULL, N'Miranda', CAST(N'1987-08-31' AS Date), 100000136, N'F', N'9518', N'Açores', N'Portugal', 900000136)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000138, N'Irina', NULL, N'Coelho', CAST(N'1962-11-23' AS Date), 100000137, N'F', N'5561', N'Guarda', N'Portugal', 900000137)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000139, N'Irina', NULL, N'Oliveira', CAST(N'1985-05-24' AS Date), 100000138, N'F', N'4208', N'Porto', N'Portugal', 900000138)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000140, N'Amélia', NULL, N'Henriques', CAST(N'1990-09-10' AS Date), 100000139, N'F', N'3248', N'Setúbal', N'Portugal', 900000139)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000141, N'Cristina', NULL, N'Figueiredo', CAST(N'1951-07-27' AS Date), 100000140, N'F', N'3113', N'Santarém', N'Portugal', 900000140)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000142, N'Inês', NULL, N'Reis', CAST(N'1965-05-19' AS Date), 100000141, N'F', N'5025', N'Porto', N'Portugal', 900000141)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000143, N'Catarina', NULL, N'Pinheiro', CAST(N'2001-02-28' AS Date), 100000142, N'F', N'4624', N'Porto', N'Portugal', 900000142)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000144, N'Carolina', NULL, N'Campos', CAST(N'2001-02-28' AS Date), 100000143, N'F', N'6184', N'Portalegre', N'Portugal', 900000143)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000145, N'Maria', NULL, N'Coelho', CAST(N'1962-11-23' AS Date), 100000144, N'F', N'5009', N'Vila Real', N'Portugal', 900000144)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000146, N'Ana', NULL, N'Oliveira', CAST(N'1989-09-22' AS Date), 100000145, N'F', N'6274', N'Évora', N'Portugal', 900000145)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000147, N'Amélia', NULL, N'Vicente', CAST(N'1954-10-28' AS Date), 100000146, N'F', N'6776', N'Évora', N'Portugal', 900000146)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000148, N'Lara', NULL, N'Nogueira', CAST(N'1994-09-20' AS Date), 100000147, N'F', N'3264', N'Leiria', N'Portugal', 900000147)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000149, N'Beatriz', NULL, N'Guerreiro', CAST(N'1994-12-21' AS Date), 100000148, N'F', N'8095', N'Faro', N'Portugal', 900000148)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000150, N'Cremilde', NULL, N'Branco', CAST(N'1962-11-01' AS Date), 100000149, N'F', N'4432', N'Porto', N'Portugal', 900000149)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000151, N'Daenerys', NULL, N'SimÃµes', CAST(N'1978-01-13' AS Date), 100000150, N'F', N'4304', N'Évora', N'Portugal', 900000150)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000152, N'Emília', NULL, N'Nascimento', CAST(N'1994-12-14' AS Date), 100000151, N'F', N'9687', N'Açores', N'Portugal', 900000151)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000153, N'Cremilde', NULL, N'Valente', CAST(N'2001-02-28' AS Date), 100000152, N'F', N'7840', N'Beja', N'Portugal', 900000152)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000154, N'Joana', NULL, N'Cardoso', CAST(N'1951-07-27' AS Date), 100000153, N'F', N'6246', N'Castelo Branco', N'Portugal', 900000153)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000155, N'Marta', NULL, N'Nogueira', CAST(N'1987-07-13' AS Date), 100000154, N'F', N'4862', N'Porto', N'Portugal', 900000154)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000156, N'Joana', NULL, N'Henriques', CAST(N'1975-04-25' AS Date), 100000155, N'F', N'6557', N'Portalegre', N'Portugal', 900000155)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000157, N'Cristina', NULL, N'Ferreira', CAST(N'1973-04-30' AS Date), 100000156, N'F', N'5716', N'Setúbal', N'Portugal', 900000156)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000158, N'Rafela', NULL, N'MagalhÃ£es', CAST(N'1964-10-06' AS Date), 100000157, N'F', N'2125', N'Lisboa', N'Portugal', 900000157)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000159, N'Mariana', NULL, N'Rodrigues', CAST(N'1954-10-05' AS Date), 100000158, N'F', N'5284', N'Bragança', N'Portugal', 900000158)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000160, N'Joana', NULL, N'Amorim', CAST(N'1987-07-13' AS Date), 100000159, N'F', N'9773', N'Açores', N'Portugal', 900000159)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000161, N'Emília', NULL, N'Pinto', CAST(N'1959-03-04' AS Date), 100000160, N'F', N'6389', N'Portalegre', N'Portugal', 900000160)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000162, N'Ana', NULL, N'Borges', CAST(N'1979-04-26' AS Date), 100000161, N'F', N'6725', N'Portalegre', N'Portugal', 900000161)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000163, N'Leonor', NULL, N'Macedo', CAST(N'1987-06-15' AS Date), 100000162, N'F', N'5339', N'Bragança', N'Portugal', 900000162)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000164, N'Sofia', NULL, N'Pires', CAST(N'1988-10-27' AS Date), 100000163, N'F', N'5314', N'Coimbra', N'Portugal', 900000163)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000165, N'Irina', NULL, N'AraÃºjo', CAST(N'1983-11-18' AS Date), 100000164, N'F', N'6566', N'Portalegre', N'Portugal', 900000164)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000166, N'Ana', NULL, N'Pereira', CAST(N'1988-06-16' AS Date), 100000165, N'F', N'9845', N'Açores', N'Portugal', 900000165)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000167, N'Maria', NULL, N'Nogueira', CAST(N'1981-05-29' AS Date), 100000166, N'F', N'4509', N'Santarém', N'Portugal', 900000166)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000168, N'Daenerys', NULL, N'Monteiro', CAST(N'1969-10-27' AS Date), 100000167, N'F', N'9005', N'Madeira', N'Portugal', 900000167)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000169, N'Emília', NULL, N'Pinto', CAST(N'1956-11-06' AS Date), 100000168, N'F', N'3307', N'Santarém', N'Portugal', 900000168)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000170, N'Amélia', NULL, N'Pinho', CAST(N'1995-08-08' AS Date), 100000169, N'F', N'5245', N'Évora', N'Portugal', 900000169)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000171, N'Marta', NULL, N'Abreu', CAST(N'1999-03-29' AS Date), 100000170, N'F', N'5676', N'Santarém', N'Portugal', 900000170)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000172, N'Carolina', NULL, N'Torres', CAST(N'1962-11-29' AS Date), 100000171, N'F', N'5543', N'Coimbra', N'Portugal', 900000171)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000173, N'Lara', NULL, N'Maia', CAST(N'1973-03-30' AS Date), 100000172, N'F', N'9862', N'Açores', N'Portugal', 900000172)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000174, N'Irina', NULL, N'Correia', CAST(N'1988-10-27' AS Date), 100000173, N'F', N'4802', N'Braga', N'Portugal', 900000173)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000175, N'Sofia', NULL, N'Faria', CAST(N'1985-05-24' AS Date), 100000174, N'F', N'5392', N'Santarém', N'Portugal', 900000174)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000176, N'Sofia', NULL, N'Baptista', CAST(N'1988-10-27' AS Date), 100000175, N'F', N'7238', N'Évora', N'Portugal', 900000175)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000177, N'Marta', NULL, N'Moura', CAST(N'1952-03-24' AS Date), 100000176, N'F', N'5365', N'Bragança', N'Portugal', 900000176)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000178, N'Sofia', NULL, N'Batista', CAST(N'1994-12-14' AS Date), 100000177, N'F', N'1407', N'Lisboa', N'Portugal', 900000177)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000179, N'Catarina', NULL, N'SimÃµes', CAST(N'1962-12-25' AS Date), 100000178, N'F', N'2096', N'Santarém', N'Portugal', 900000178)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000180, N'Lara', NULL, N'Marques', CAST(N'1956-11-08' AS Date), 100000179, N'F', N'3126', N'Aveiro', N'Portugal', 900000179)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000181, N'Mariana', NULL, N'Morais', CAST(N'1969-04-02' AS Date), 100000180, N'F', N'9631', N'Açores', N'Portugal', 900000180)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000182, N'Mariana', NULL, N'Borges', CAST(N'1970-01-29' AS Date), 100000181, N'F', N'4622', N'Braga', N'Portugal', 900000181)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000183, N'Maria', NULL, N'Neto', CAST(N'1956-12-18' AS Date), 100000182, N'F', N'5301', N'Bragança', N'Portugal', 900000182)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000184, N'Inês', NULL, N'Martins', CAST(N'1987-06-15' AS Date), 100000183, N'F', N'3910', N'Évora', N'Portugal', 900000183)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000185, N'Rafela', NULL, N'Moura', CAST(N'1964-10-06' AS Date), 100000184, N'F', N'7662', N'Beja', N'Portugal', 900000184)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000186, N'Marta', NULL, N'Cruz', CAST(N'1959-02-04' AS Date), 100000185, N'F', N'9539', N'Açores', N'Portugal', 900000185)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000187, N'Inês', NULL, N'Domingues', CAST(N'1959-03-04' AS Date), 100000186, N'F', N'1665', N'Lisboa', N'Portugal', 900000186)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000188, N'Mariana', NULL, N'Pinho', CAST(N'1977-06-02' AS Date), 100000187, N'F', N'5357', N'Bragança', N'Portugal', 900000187)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000189, N'Mariana', NULL, N'Matias', CAST(N'1977-06-02' AS Date), 100000188, N'F', N'4182', N'Porto', N'Portugal', 900000188)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000190, N'Cristina', NULL, N'Andrade', CAST(N'1987-08-31' AS Date), 100000189, N'F', N'5406', N'Évora', N'Portugal', 900000189)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000191, N'Mariana', NULL, N'Teixeira', CAST(N'1985-06-05' AS Date), 100000190, N'F', N'5313', N'Bragança', N'Portugal', 900000190)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000192, N'Matilde', NULL, N'Branco', CAST(N'1971-06-23' AS Date), 100000191, N'F', N'4754', N'Braga', N'Portugal', 900000191)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000193, N'Lara', NULL, N'Lima', CAST(N'1964-08-31' AS Date), 100000192, N'F', N'6252', N'Castelo Branco', N'Portugal', 900000192)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000194, N'Filipa', NULL, N'Almeida', CAST(N'1960-06-23' AS Date), 100000193, N'F', N'2238', N'Santarém', N'Portugal', 900000193)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000195, N'Irina', NULL, N'Anjos', CAST(N'1994-12-14' AS Date), 100000194, N'F', N'5125', N'Guarda', N'Portugal', 900000194)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000196, N'Matilde', NULL, N'GonÃ§alves', CAST(N'1952-03-24' AS Date), 100000195, N'F', N'4185', N'Aveiro', N'Portugal', 900000195)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000197, N'Matilde', NULL, N'Jesus', CAST(N'2001-09-21' AS Date), 100000196, N'F', N'6136', N'Castelo Branco', N'Portugal', 900000196)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000198, N'Joana', NULL, N'Pinheiro', CAST(N'1960-06-23' AS Date), 100000197, N'F', N'3208', N'Aveiro', N'Portugal', 900000197)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000199, N'Lara', NULL, N'Gaspar', CAST(N'1959-11-27' AS Date), 100000198, N'F', N'2392', N'Santarém', N'Portugal', 900000198)
GO
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000200, N'Beatriz', NULL, N'SimÃµes', CAST(N'1979-04-26' AS Date), 100000199, N'F', N'1277', N'Lisboa', N'Portugal', 900000199)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000203, N'Tiago', NULL, N'Mendes', CAST(N'1999-01-17' AS Date), 123456789, N'M', N'3430', N'Viseu', N'Portugal', 955444222)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000204, N'maria', NULL, N'joaquina', CAST(N'1999-01-25' AS Date), 987654321, N'F', N'123', N'Spac', N'Portugal', 999999999)
INSERT [Railway].[Person] ([id], [fname], [mname], [lname], [birthdate], [nif], [gender], [postal_code], [city], [country], [phone]) VALUES (100000213, N'Tiago', NULL, N'Tomas', CAST(N'2019-02-13' AS Date), 999555333, N'M', N'3430', N'Viseu', N'Portugal', 976636092)
SET IDENTITY_INSERT [Railway].[Person] OFF
SET IDENTITY_INSERT [Railway].[ProfilePictures] ON 

INSERT [Railway].[ProfilePictures] ([id], [img_base64], [passenger_id]) VALUES (4, N'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
', NULL)
INSERT [Railway].[ProfilePictures] ([id], [img_base64], [passenger_id]) VALUES (5, N'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
', NULL)
INSERT [Railway].[ProfilePictures] ([id], [img_base64], [passenger_id]) VALUES (9, N'/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCADIAMgDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwCfFGKdRXvnkDcUYp2KMUAMxS4p2KTFIBuKMU7FGKAG4oxTqMUANxRinYoxQA3FGKdijFADcUYp2KMUDGYoxT8UYoAZijFOxRigBuKMU7FGKQDcUbadijFADcUU7FFAEmKMU/FGKYhlFPxRii4DMUYp+KMUXGR4oxUmKTFADMUYp+2jFIBmKMU7bRigBuKMU7FGKAG4oxTsUYoAbikxT8UYoAZijFPxSYoAbijFOxRigBuKMU7FGKAG4opcUUATUU7FGKLgNxRinYoxRcBuKMU7FGKLgNxRinYoxRcBuKMU7FGKLgMoxT8UmKLgNxRinYpcUrgMxRin4oxRcBmKTFSYpMUXAZijFOxRQMbijFOxRikA3FJin4oxQAzFFPxRQBJijFPxRigBmKMVJijFAEeKMVJikwKAGYoxT8UYoAZijFPxRigBmKMU7bTsUAMC04LSsQiMx6AZrzXXviRMxMGkRiMd5nGT+AqJ1IwV2XCnKb0PR3eKLAkkRM9NzAVnT+INGt5Wil1G2V0+8u8EivEbm9utRnae6nklkbqzHJqPy2xgZzXJLGdkdMcJ3Z9AxSRTpvhkV1PdTmlIryDwv4ln0W+VZnZrRjh19PevYUZZI1dSCrDII7iuilVVRXOepScHYZikxUhWm4rUiw2jFOoxQFhuKMU7FGKAsNxRTsUUBYlxRin4oxSuA3FFOooAbijFOxRigBmKMU/FJii4DcUYp2KMUANxSgUuKUUAAXIxXiWq6TbDV7kQsxTzmAz6Zr2u4nW1s5rhs7Yo2c4HYDNeJyX/AJkkkyIxZTuIYVyYtqyR2YVatnY+H/D+l+Uitbh5X45Ga0tf+HMULrcWcIjhMeJNpJw1Yng7W7l7zzHi81UOcRpyK9mWRdR0IvAcebGdueoNeFNyjI92CjOC0PnG/wBEltJD8vynkV6f4Qmlm8N26zffizH+A6fpS614WkNtEokCzM5JAXcW/UDOal8MWz22jqjnO6RmVvVT0P5V6OAq802jzMfRcIKXmaxFJimyuyz26A4EkhVvpsY/zAqTFerza2PKtpcbijFOxRincBuKTFPxRii4DNtFPxRRcB+KMU/FGKm4DKXFO2kYyrLkAjcCMg96XFCdx2G7aNtSAVkal4j07SpJorqTbNGgdY+MyA5xj8QRSckldgk3sam2k21jeFtYl1qylmmxuV8DjHBGcY9v8963ODwCDSjNSXMglFxdmR4pMVIRSYqriGYpQKdilAouAbQylSAQRgg968/0bSdEg1zWbe98qKBpDEiyvgLknGD68V6EBXmnjy1n03Wlv7bci3ChmYHA3LwR/I1y4uLlT0OzBTUampD4digtfFM1vHJtSORkC5yCAcfjXs1pcJ9lCRFSqjjbXkun2E169hfwywsySBmCR8kd+a77TJHhllDghWOa8Os7s9+kraEHiPy74fvBMPsRWVGjX7zntn6H171LEgSJVChcDGB2rQu4vMt2D/dLqwH0ORVYLXo5ZFcrn8jzM1qPmjT6bmRqKyT3Npb4liXz1YSoeowcjPY1qY5AJ5NVb/zkubF0KGITqHUjnJOAR+PX61ka7qstqI/tUMlsqMGWVAXAb147Y6jnjNds6ypttnmxg5JWN9pIk3FpEGwbmyeg9aRpIlj8xpUCYB3E8YPSvMPFs5luVvbWZhDdIFl2t8pPXj24zVzxPfBNPhWGTcr4bHqNxI/n+lZ/W1ZtFewezO+F5bteNaiRTMBnbnn/AD0/Op8VzXhaCWdGu2bM0gxJKRzj0H1/oK6Se4gtwTLIq4GTk9B6n0rWlWU4cz0InTtLlQYoqhb6v9vuxHYWzz26n95dE7Yx/u5+9+HFFbKSexFrGpSEbvl7twMU6srU7u6sr+0mhjV0Uk4Y45rOc+WNyow5nY3ZtO1GKKKa5icxxxLEHzkbQTjI7Hk/Xiq4FaUvjLUbPTrc3ejxSQ3afKBNyQe3Q88is8daww1TmjY1rwtK45RXjXxBtreLxPcPBI2XQO4x9x+459euR617JLCZraSIMyF0KhlOCuR1BrwrxBcXN3q94dRcSXFvIYfNVQudvGePz/Gnipe4FBe8Gna7e6T5ZjkUspYqrEldxXGT2NWtA1S+j1K3e1lkBdgjKvJxkZBzn+VYrQBmWMSjAUMNqnr+I+n513Pw2soJtRmuZQZJYlyhCZUZ757H0rhim5KKZ0SsotnpZFNxUjDmm4r1rnBYbilApwFEjxwRNLNIkcajLM7AAfUmi4WFC1meJdKXVdAubctGjqu9JJDhVI5yT2HUZrF1n4k6Jpisloxv5x0EPCA+7f4Zry/X/Fus6/IxuLlo7Y8C2hJVAPcfxfjWU6sbW3NadKV77G7oXjCXSIHRoRcLE5TdGwx/+r3ruvCHiKHxHfMssbRMg3Bc5BFeI2F49jdLKvK9HU9GFe8eC7LQtRtIruxYWd1t+YoeG+o/wxXmVcMpJyjuerRxLi0pbHRapcw2mmTXUjfu4gWPvjt9a88vPiE1rqk+lS2MdtdQTtA8k0haMEEgk4Ge1dt4Y1Pw54p8Qw6a2qRTrav5qQbGUXMgPHLAAhcZwOv0FeJ/EBlb4i+INn3ft8o/Hcc08K50otE4z2dWSa6HVahc6td3zXNzp4u4EKKk9hI+0HIxtwc85x/Krtp4h0+7h/snVHlmgkG3FwMSxH64GceuAR715fYaje6bcCeyuJIZFYN8p4JByMjoefWtC88S32p5OoeVcMekhjUOp9iMH8OldHO73TOR09LHQXNmIobzS3k3+SfMhJIPynkHis2V2vLC2UnBhZIyCewyKisrtb5PKeYLcgbUdzjcv930q9ZWhmPlhfMkMoyq8HpjrXHNWl5NmqWh2Ola4kemRqrrEg4B6tjuSO7HsOw59KsQ2/n5vNbj8qyRsxxO4w3+0/PzH/Z/nWHpl1DYzXM9xZebNAQttCh3KcjO4nsfWqN/q+q3LJqHnReZnCpwfJ9Noz198fjW3tEmm3tsjPkeyPQLjWoreyNylncNAo+86iIAfRyD+Qoryu+vtSuRi7d3yc4fIH5UV0fWZPoJYaPU9nqKe3iuYTFKu5T74P51JS10XOawBYXsLAKspEcZx5r7sMGKkjPTpT1FC/8AHnaf9c2/9GPTk61FKyjoVO7kQ397HpunT3squ0cKF2CDJNeA6jJ9p1G8uAnyTTM6sowMEkjivSfiF4hls4o7K3c7JA6TeWTnGACD26N0+nTv5wYykRkiG/zFG1WxgDoa5q9VSfKbUoOOpFBaO920dvktgFVAJJ4zXUeD7zVJNQjttKMMUki/OWztxzywz1Gf5VzSKzxrcJsUBQrLnkAccVa0fW30q7FzbbBIh2puBwf5frWCdpJmzV1Y91gjkjtoklffIqgM2ep7mn1j+GNRn1bRxfXLAySOeFGFUDjAraHWvSjNNJo4XFp2IL65TT9OubxxlYImlI9dozXz7q/iHU9euDJf3TyKDlYwcIn0H+TXrHxM1n+zfDJtEOJr5vLHsg5Y/wAh+NeJrkHd6Gs6stbG1KPUlC0rLkEdx0pQRnFOxk5rA3IhCfLPt19q6TwpqUscN5YCby2eF/KbdjBIwcfnn8KwlYqc+owaRCzXivjBzk7R27/WmnZiZY0yeew1eN7e48uaCYGOYfwkHg0a5dyX/iG+vJVCSXE7zMo7FiTj9arhdrs24Zyfxp18Q11FJ/fiVifejSzHci6SfWlx1FIw5FSY7+tSMaexq5bald26bI5mCD+E1TP3PpSZ2BT2JwaTSe4GzJqs14VDmQ56Lu4+goN06DG1sHOQAMiqdnJtDRHYxYYCuMrk8fgR1zV2S0aFxHMpVs/ITjGMdD7jiueUUnYtNsnt4Jb11WC5JP8AcY8/h2NFU2maJ1Ys6SKcqycj6+tFT73QZ71RUC3McqxvG4AJ/iHbBqfNepGalqjilBxdpIchzZ2v+43/AKMemXU5trKedRkxxswG0noPQc0+P/j0tv8Adb/0Y9R3cnlWNxINnyxsfn+7wO/tSg/dCS1PAdV1I6rqU97LIw8995jPIUnjA9sAVGzslsY+T3GCenPNVEYx3HEasQ3TGc1ajeMEqnTn/gI69/yrinudCLEEhj2MRhcFi1OsTbfalM9ossYbdtVsFvbPOBSEF4F8sEMrYxnt/hToY5Ip1by3Qsu7cRxx6Gsk+qGe46RBaW+lW62UKRRFAdqkHnHOSOpq+OtZWgmD+wrMW6hYhHhRn35/HNaYNenF6I5WtTx34q6gbnxLHZj7trCAf95vmP6ba4qJdyketb/j2TzPG2pH0dV/JFFYUIycDrWMnqbxWhEW2sB6cVOrhhUFwRvzjBPUU1WKnipKLVSQMiTKZlJXGDg9j1/TNRId1PZARg9DSYyxfWEtrPNEQo2AsDu/hxkVFeoEWyP96BTRcXE0tuUkkLBVA59unNNvZlkezjH/ACyt0U/Xr/WnC/K7hNpy90Yeop46U3vTu1SA09x61FN/qlHqakkONp96jk5lRew5oAkD4mNdU13He6ehdPmABHXr0P8An0Irko1Z5DgEnrWoskgS3jUkRqCWUdye5qZQUmm+hUXYlikjJfeoCxP8pOTjH9Paio1glIl+Q4c5BopOCKTPTp9citvD6XKAFg+1UznOBjn86w28U6jMSFlEfBb5V55+v0rKvJHl09sPiNOdvZTxyP0rOtZnkIAbcSdox3rmipRjoXWqe0lqenQ+J49PXSYL+J3W4tlleRDgrmSTd2welVfGHiTS5/CN8dMvZkuvNVRHMqjzIzww/WsTXdotdIjcFWGngD1U+ZJ/hXKaihbTXR2JZTuBAyBjrVKrNStfQxcY7mChUXG7Z8vpzx+VWoWQT7tm1mGfYjvVONgq52nryQccVb2LhHjY/LggE81tMkvEGKInJOBw2e+cVoaWLe+uVsp1md5SNhhOWVuB908fXvxWbGVH2dWJILHt1NS2l9HpurLfcFkdmXJ4Y/h2zWMPiH0PbLO3i0rToLXzSY4gI1aQgE84A4x9KbcajFaT7HDklQflA/xrzfUtaubvwvaapLfO0jXoGwMAq43EHGPari62dSaSe/EaTwrsjCNhnDccDua6aldqPudB0aKc/wB5scT4tmS58WajLHna03GevSs2HiQUl25lv5nO7LSMfmOT1708DBBqru2ona+hBecXDYGKhBqxe/69T6gGoKa2EyWNyrDuKufeGRWdyOlW4Jd3B4NJgPuOISfwNUk/1mc5q7cf8e5+tUo/9ZTWwF3tS0g6UtSMZJ90fWoyf3pPtipH6gVFjMueoXtQBr6f9nSDMm1X3c7ucjtir8c0IX58ICcADvWHZvG02yVCN3Qg8ZrqZdIa203TtQdlaO5klVFB5G3Gc/nUyj5jTKE0yMAtu/zA8gjtRV210qR9Vt4JYjAbmQbXZeqk9aKznaO7KTbLF3ps50+JYQGbASSPjgZPQ59AKsFJ47vz4bJIyi4TZjr0z+XNdB/Zt8DysP8A32f8Kjn0m+nhKBkjJ7q3P8qhOr2Ru4Yfu/6+Rl+IY1k07S5PtDJdpp5xGATv/ev36D+LmuDK3MjspyxP+1Xpuo+HpL+y01fOZVitjGwUjnEr0y08Px2SfLAXb+9gZ/U09VqkQoU29XY8vntLmzCvLEVV+m7vVm1tpZ4WnjBx0CjrwK9AuPDcU87STJcS7xjadmF+nNMsfCYt7VoikgBkLDkZxxjJ/DP4mm5Sa1QnCF9HocZJYXw04SLBtK/xbhkDrWSwl2jzY2AHTK16xHoDIu0hnXAzuYdhipxo6gf6uP8AFa0p2S1M6iV/dPJR9quIBEF/dqcgbQKlb7csRXk8cEL/APWr1X+yiP8Aljbn6jH9KP7Mb/n1tD/wL/7GtLxM7SPGk5kyalL44qS5hNtf3MTLjy5WTGemCRUYVWOdvy+poY0Q3HLKR6VHT5dvmEL0FMprYCRfmXjqKenX3qJH2mpwFb5hQwHzN/o7VViH7ypZj8gHvUcH3s0dALdGaTNITipGNdgMnPQVHCuWz949cUyTcz/7OePerMJ3nGAM/oaYEwRPvBSrDkEV3V9IP+EE0OQsMpdTDntlVP8ASuZ0jTZ9TuxBBGXI5f8A2R9a7U6VeHTl097JZLZJDKqvg7SRjjkVnO+g0jA0CXVr2+0+5u9z2cNwkUcuBhBuBxx/vd6K3o9KvIIVjhtnjVZRLtVuCwx2LeworOacilodirZPESfif/rU75gP9Un5/wD1qpLNnuMeuTUcs0rHEOz6sT/KqGXoWb7LEPLTgydT/wBNHpTPHj/lh/31WHN5y2UJe6RV+fIY9/MfPGKbZweblpVZh2GwKD+PX9KEgN0TIc48g8dA1QjUA7FY0iwDgszbR+tZ7WNxJkD7Kif3VH/1qhOjSE8vbD6L/wDWp2QG0JdzAAwkntuFPIkP8EVUbezt7ZABtd+7bcVLuC9Fx9DSAsbJB/BHS7JAdxVfpVcScZw/4NS+ZyMxS89t4/xoA8R8R7v+En1MEDP2qTgf7xqsMgYIJA96t+JlaLxRqWVIJuGbDdcE5/rVFCXXBbAPatuhmVpM+axJzSjaR6GpLqPbNx0IGKhCk9DVIQ4oaEYo39KFDipxF5secYIpANnIMaketNtgWbCgknoB3qJ1dTggj2re8LS6xYaiZNNtRKzrtdJU+Ur+NJuyLiruxJZeF9cv+YNNnwedzrsH5tiszUNL1TTpit7YXEIU/wAcZAP49DXrumXWvandxxX721jCT/qbfln+p7fhXdiFDAI2QEYwcjNcjxDi9UdqwkZLRnzLGFkUEdv0qcRDO4dRXW+MtN0rS7y/8m3ZLr7aoQxtiMIybiCvsSMYxWBZWrXd3HCpALtgsegHrXRGXMrnFKDjJo7HwfbPp1o95JDcBrjG1kj3DYP15P8ASuk/tW13Ya5KH0cBD+tRRTWkEEcSzJtRQo4PYVKL2HYV8yMg9QQaW40rE6TpIMpIzj1BU0VmyDS3fLQwhvWNCp/NcUUWQak00dvCuZBjH1Gf1qNFNwmILdouf9a7Nn8Bnmiil0AsraRRom4s7ICAzAcZJJ/UmgxvgsrN+v8AjRRSGCiU4HlEn/ePNSASZxtbJH948UUUALnd6gD1Y80FQOuef9o0UUAIdoOBu4/2zUqKhQnB4I/iNFFAHlvxCsfs3iEXA+5cxBs+44P8h+dcumehOBRRWy2M+o2eRmk+btwKavpiiiq6CJM/UetSq2AcDiiipYx9jHdS3DeQY85A3O2AtdJpNrc2l3HJNqUcAk+Viig4H4/4UUVlVdtDpox0udxa2IjkjureS7u5AOJHJK/oMV2Yu41s/PmcRoikuzHAGOtFFcMtWejHRHg3jXxFHr3iGeazTZb7VjBxgybf4j/noK3PBVvDNPPczMNsQCbCAQxPPf6UUV6CSjGyPIlJyk2zrpba0xu8vPfC8foKasNps2hSPq7cUUUInqL5FunQv+EjD+tFFFAH/9k=', 100000203)
INSERT [Railway].[ProfilePictures] ([id], [img_base64], [passenger_id]) VALUES (14, N'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', 100000213)
SET IDENTITY_INSERT [Railway].[ProfilePictures] OFF
SET IDENTITY_INSERT [Railway].[Station] ON 

INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (1, N'Viana do Castelo', 1, 101)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (2, N'Braga', 1, 102)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (3, N'Guimarães', 1, 103)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (4, N'Porto - São Bento', 2, 104)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (5, N'Porto - Campanhã', 2, 105)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (6, N'Vila Nova de Gaia', 2, 106)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (7, N'Ovar', 2, 107)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (8, N'Aveiro', 2, 108)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (9, N'Coimbra', 2, 109)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (10, N'Pombal', 2, 110)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (11, N'Figueira da Foz', 2, 111)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (12, N'Entroncamento', 3, 112)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (13, N'Santarém', 3, 113)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (14, N'Caldas da Rainha', 3, 114)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (15, N'Lisboa - Santa Apolónia', 3, 115)
INSERT [Railway].[Station] ([station_no], [station_name], [zone_no], [director_no]) VALUES (16, N'Lisboa - Oriente', 3, 116)
SET IDENTITY_INSERT [Railway].[Station] OFF
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (1, N'AP')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (1, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (1, N'M')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (1, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (2, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (2, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (3, N'AP')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (3, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (3, N'M')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (3, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (4, N'AP')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (4, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (4, N'M')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (4, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (5, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (5, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (6, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (6, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (7, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (7, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (8, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (8, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (9, N'AP')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (9, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (9, N'M')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (9, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (10, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (10, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (11, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (11, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (12, N'AP')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (12, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (12, N'M')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (12, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (13, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (13, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (14, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (14, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (15, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (15, N'UR')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (16, N'AP')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (16, N'IC')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (16, N'M')
INSERT [Railway].[StopsAt] ([station_no], [category]) VALUES (16, N'UR')
SET IDENTITY_INSERT [Railway].[Ticket] ON 

INSERT [Railway].[Ticket] ([ticket_no], [nif], [dep_station], [arr_station], [dep_timestamp], [arr_timestamp], [train_no], [carriage_no], [seat_no], [price], [trip_no], [trip_date], [passenger_id], [duration], [trip_type]) VALUES (157, 123456789, 2, 9, CAST(N'11:45:00' AS Time), CAST(N'16:41:00' AS Time), 14, 2, 4, 9.5000, 744, CAST(N'2019-06-05' AS Date), 100000203, CAST(N'04:56:00' AS Time), N'IC')
INSERT [Railway].[Ticket] ([ticket_no], [nif], [dep_station], [arr_station], [dep_timestamp], [arr_timestamp], [train_no], [carriage_no], [seat_no], [price], [trip_no], [trip_date], [passenger_id], [duration], [trip_type]) VALUES (158, 123456789, 2, 9, CAST(N'11:45:00' AS Time), CAST(N'16:41:00' AS Time), 14, 2, 6, 9.5000, 744, CAST(N'2019-06-05' AS Date), 100000203, CAST(N'04:56:00' AS Time), N'IC')
SET IDENTITY_INSERT [Railway].[Ticket] OFF
SET IDENTITY_INSERT [Railway].[Train] ON 

INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (1, 5, 286, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (2, 4, 196, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (3, 7, 375, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (4, 6, 274, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (5, 4, 229, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (6, 6, 301, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (7, 5, 272, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (8, 5, 257, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (9, 4, 196, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (10, 6, 313, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (11, 6, 311, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (12, 5, 287, N'UR')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (13, 5, 242, N'IC')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (14, 5, 228, N'IC')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (15, 4, 230, N'IC')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (16, 6, 284, N'IC')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (17, 6, 303, N'IC')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (18, 6, 237, N'IC')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (19, 6, 262, N'IC')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (20, 6, 283, N'IC')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (21, 4, 196, N'AP')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (22, 6, 276, N'AP')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (23, 5, 256, N'AP')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (24, 5, 255, N'AP')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (25, 8, 345, N'AP')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (26, 7, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (27, 6, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (28, 6, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (29, 7, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (30, 7, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (31, 5, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (32, 8, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (33, 8, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (34, 5, 0, N'M')
INSERT [Railway].[Train] ([train_no], [no_carriages], [total_seats], [category]) VALUES (35, 5, 0, N'M')
SET IDENTITY_INSERT [Railway].[Train] OFF
INSERT [Railway].[TrainType] ([category], [designation]) VALUES (N'AP', N'Alfa-pendular')
INSERT [Railway].[TrainType] ([category], [designation]) VALUES (N'IC', N'Intercidades')
INSERT [Railway].[TrainType] ([category], [designation]) VALUES (N'M', N'Mercadorias')
INSERT [Railway].[TrainType] ([category], [designation]) VALUES (N'UR', N'Urbano/Regional')
SET IDENTITY_INSERT [Railway].[Trip] ON 

INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1, N'UR', CAST(N'05:00:00' AS Time), CAST(N'06:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (2, N'UR', CAST(N'05:00:00' AS Time), CAST(N'08:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (3, N'UR', CAST(N'06:45:00' AS Time), CAST(N'08:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (4, N'UR', CAST(N'05:00:00' AS Time), CAST(N'06:30:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (5, N'UR', CAST(N'05:00:00' AS Time), CAST(N'08:15:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (6, N'UR', CAST(N'06:30:00' AS Time), CAST(N'08:15:00' AS Time), 2, 1, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (7, N'UR', CAST(N'05:00:00' AS Time), CAST(N'05:05:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (8, N'UR', CAST(N'05:00:00' AS Time), CAST(N'05:12:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (9, N'UR', CAST(N'05:00:00' AS Time), CAST(N'05:48:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (10, N'UR', CAST(N'05:00:00' AS Time), CAST(N'06:11:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (11, N'UR', CAST(N'05:00:00' AS Time), CAST(N'07:21:00' AS Time), 4, 11, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (12, N'UR', CAST(N'05:00:00' AS Time), CAST(N'09:31:00' AS Time), 4, 9, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (13, N'UR', CAST(N'05:00:00' AS Time), CAST(N'10:31:00' AS Time), 4, 10, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (14, N'UR', CAST(N'05:05:00' AS Time), CAST(N'05:12:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (15, N'UR', CAST(N'05:05:00' AS Time), CAST(N'05:48:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (16, N'UR', CAST(N'05:05:00' AS Time), CAST(N'06:11:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (17, N'UR', CAST(N'05:05:00' AS Time), CAST(N'07:21:00' AS Time), 5, 11, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (18, N'UR', CAST(N'05:05:00' AS Time), CAST(N'09:31:00' AS Time), 5, 9, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (19, N'UR', CAST(N'05:05:00' AS Time), CAST(N'10:31:00' AS Time), 5, 10, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (20, N'UR', CAST(N'05:12:00' AS Time), CAST(N'05:48:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (21, N'UR', CAST(N'05:12:00' AS Time), CAST(N'06:11:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (22, N'UR', CAST(N'05:12:00' AS Time), CAST(N'07:21:00' AS Time), 6, 11, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (23, N'UR', CAST(N'05:12:00' AS Time), CAST(N'09:31:00' AS Time), 6, 9, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (24, N'UR', CAST(N'05:12:00' AS Time), CAST(N'10:31:00' AS Time), 6, 10, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (25, N'UR', CAST(N'05:48:00' AS Time), CAST(N'06:11:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (26, N'UR', CAST(N'05:48:00' AS Time), CAST(N'07:21:00' AS Time), 7, 11, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (27, N'UR', CAST(N'05:48:00' AS Time), CAST(N'09:31:00' AS Time), 7, 9, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (28, N'UR', CAST(N'05:48:00' AS Time), CAST(N'10:31:00' AS Time), 7, 10, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (29, N'UR', CAST(N'06:11:00' AS Time), CAST(N'07:21:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (30, N'UR', CAST(N'06:11:00' AS Time), CAST(N'09:31:00' AS Time), 8, 9, CAST(N'03:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (31, N'UR', CAST(N'06:11:00' AS Time), CAST(N'10:31:00' AS Time), 8, 10, CAST(N'04:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (32, N'UR', CAST(N'07:21:00' AS Time), CAST(N'09:31:00' AS Time), 11, 9, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (33, N'UR', CAST(N'07:21:00' AS Time), CAST(N'10:31:00' AS Time), 11, 10, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (34, N'UR', CAST(N'09:31:00' AS Time), CAST(N'10:31:00' AS Time), 9, 10, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (35, N'UR', CAST(N'05:00:00' AS Time), CAST(N'06:00:00' AS Time), 10, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (36, N'UR', CAST(N'05:00:00' AS Time), CAST(N'08:10:00' AS Time), 10, 11, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (37, N'UR', CAST(N'05:00:00' AS Time), CAST(N'07:00:00' AS Time), 10, 8, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (38, N'UR', CAST(N'05:00:00' AS Time), CAST(N'09:43:00' AS Time), 10, 7, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (39, N'UR', CAST(N'05:00:00' AS Time), CAST(N'10:19:00' AS Time), 10, 6, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (40, N'UR', CAST(N'05:00:00' AS Time), CAST(N'10:26:00' AS Time), 10, 5, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (41, N'UR', CAST(N'05:00:00' AS Time), CAST(N'10:31:00' AS Time), 10, 4, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (42, N'UR', CAST(N'06:00:00' AS Time), CAST(N'08:10:00' AS Time), 9, 11, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (43, N'UR', CAST(N'06:00:00' AS Time), CAST(N'07:00:00' AS Time), 9, 8, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (44, N'UR', CAST(N'06:00:00' AS Time), CAST(N'09:43:00' AS Time), 9, 7, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (45, N'UR', CAST(N'06:00:00' AS Time), CAST(N'10:19:00' AS Time), 9, 6, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (46, N'UR', CAST(N'06:00:00' AS Time), CAST(N'10:26:00' AS Time), 9, 5, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (47, N'UR', CAST(N'06:00:00' AS Time), CAST(N'10:31:00' AS Time), 9, 4, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (48, N'UR', CAST(N'07:00:00' AS Time), CAST(N'08:10:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (49, N'UR', CAST(N'07:00:00' AS Time), CAST(N'09:43:00' AS Time), 8, 7, CAST(N'02:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (50, N'UR', CAST(N'07:00:00' AS Time), CAST(N'10:19:00' AS Time), 8, 6, CAST(N'03:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (51, N'UR', CAST(N'07:00:00' AS Time), CAST(N'10:26:00' AS Time), 8, 5, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (52, N'UR', CAST(N'07:00:00' AS Time), CAST(N'10:31:00' AS Time), 8, 4, CAST(N'03:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (53, N'UR', CAST(N'08:10:00' AS Time), CAST(N'09:43:00' AS Time), 11, 7, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (54, N'UR', CAST(N'08:10:00' AS Time), CAST(N'10:19:00' AS Time), 11, 6, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (55, N'UR', CAST(N'08:10:00' AS Time), CAST(N'10:26:00' AS Time), 11, 5, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (56, N'UR', CAST(N'08:10:00' AS Time), CAST(N'10:31:00' AS Time), 11, 4, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (57, N'UR', CAST(N'09:43:00' AS Time), CAST(N'10:19:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (58, N'UR', CAST(N'09:43:00' AS Time), CAST(N'10:26:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (59, N'UR', CAST(N'09:43:00' AS Time), CAST(N'10:31:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (60, N'UR', CAST(N'10:19:00' AS Time), CAST(N'10:26:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (61, N'UR', CAST(N'10:19:00' AS Time), CAST(N'10:31:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (62, N'UR', CAST(N'10:26:00' AS Time), CAST(N'10:31:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (63, N'UR', CAST(N'05:00:00' AS Time), CAST(N'05:25:00' AS Time), 12, 13, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (64, N'UR', CAST(N'05:00:00' AS Time), CAST(N'06:31:00' AS Time), 12, 15, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (65, N'UR', CAST(N'05:00:00' AS Time), CAST(N'08:07:00' AS Time), 12, 14, CAST(N'03:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (66, N'UR', CAST(N'05:00:00' AS Time), CAST(N'09:53:00' AS Time), 12, 16, CAST(N'04:53:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (67, N'UR', CAST(N'05:25:00' AS Time), CAST(N'06:31:00' AS Time), 13, 15, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (68, N'UR', CAST(N'05:25:00' AS Time), CAST(N'08:07:00' AS Time), 13, 14, CAST(N'02:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (69, N'UR', CAST(N'05:25:00' AS Time), CAST(N'09:53:00' AS Time), 13, 16, CAST(N'04:28:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (70, N'UR', CAST(N'06:31:00' AS Time), CAST(N'08:07:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (71, N'UR', CAST(N'06:31:00' AS Time), CAST(N'09:53:00' AS Time), 15, 16, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (72, N'UR', CAST(N'08:07:00' AS Time), CAST(N'09:53:00' AS Time), 14, 16, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (73, N'UR', CAST(N'05:00:00' AS Time), CAST(N'06:46:00' AS Time), 16, 14, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (74, N'UR', CAST(N'05:00:00' AS Time), CAST(N'05:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (75, N'UR', CAST(N'05:00:00' AS Time), CAST(N'08:22:00' AS Time), 16, 13, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (76, N'UR', CAST(N'05:00:00' AS Time), CAST(N'08:47:00' AS Time), 16, 12, CAST(N'03:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (77, N'UR', CAST(N'05:10:00' AS Time), CAST(N'06:46:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (78, N'UR', CAST(N'05:10:00' AS Time), CAST(N'08:22:00' AS Time), 15, 13, CAST(N'03:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (79, N'UR', CAST(N'05:10:00' AS Time), CAST(N'08:47:00' AS Time), 15, 12, CAST(N'03:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (80, N'UR', CAST(N'06:46:00' AS Time), CAST(N'08:22:00' AS Time), 14, 13, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (81, N'UR', CAST(N'06:46:00' AS Time), CAST(N'08:47:00' AS Time), 14, 12, CAST(N'02:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (82, N'UR', CAST(N'08:22:00' AS Time), CAST(N'08:47:00' AS Time), 13, 12, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (83, N'UR', CAST(N'10:00:00' AS Time), CAST(N'11:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (84, N'UR', CAST(N'10:00:00' AS Time), CAST(N'13:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (85, N'UR', CAST(N'11:45:00' AS Time), CAST(N'13:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (86, N'UR', CAST(N'10:00:00' AS Time), CAST(N'11:30:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (87, N'UR', CAST(N'10:00:00' AS Time), CAST(N'13:15:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (88, N'UR', CAST(N'11:30:00' AS Time), CAST(N'13:15:00' AS Time), 2, 1, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (89, N'UR', CAST(N'10:00:00' AS Time), CAST(N'10:05:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (90, N'UR', CAST(N'10:00:00' AS Time), CAST(N'10:12:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (91, N'UR', CAST(N'10:00:00' AS Time), CAST(N'10:48:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (92, N'UR', CAST(N'10:00:00' AS Time), CAST(N'11:11:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (93, N'UR', CAST(N'10:00:00' AS Time), CAST(N'12:21:00' AS Time), 4, 11, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (94, N'UR', CAST(N'10:00:00' AS Time), CAST(N'14:31:00' AS Time), 4, 9, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (95, N'UR', CAST(N'10:00:00' AS Time), CAST(N'15:31:00' AS Time), 4, 10, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (96, N'UR', CAST(N'10:05:00' AS Time), CAST(N'10:12:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (97, N'UR', CAST(N'10:05:00' AS Time), CAST(N'10:48:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (98, N'UR', CAST(N'10:05:00' AS Time), CAST(N'11:11:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (99, N'UR', CAST(N'10:05:00' AS Time), CAST(N'12:21:00' AS Time), 5, 11, CAST(N'02:16:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (100, N'UR', CAST(N'10:05:00' AS Time), CAST(N'14:31:00' AS Time), 5, 9, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (101, N'UR', CAST(N'10:05:00' AS Time), CAST(N'15:31:00' AS Time), 5, 10, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (102, N'UR', CAST(N'10:12:00' AS Time), CAST(N'10:48:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (103, N'UR', CAST(N'10:12:00' AS Time), CAST(N'11:11:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (104, N'UR', CAST(N'10:12:00' AS Time), CAST(N'12:21:00' AS Time), 6, 11, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (105, N'UR', CAST(N'10:12:00' AS Time), CAST(N'14:31:00' AS Time), 6, 9, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (106, N'UR', CAST(N'10:12:00' AS Time), CAST(N'15:31:00' AS Time), 6, 10, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (107, N'UR', CAST(N'10:48:00' AS Time), CAST(N'11:11:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (108, N'UR', CAST(N'10:48:00' AS Time), CAST(N'12:21:00' AS Time), 7, 11, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (109, N'UR', CAST(N'10:48:00' AS Time), CAST(N'14:31:00' AS Time), 7, 9, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (110, N'UR', CAST(N'10:48:00' AS Time), CAST(N'15:31:00' AS Time), 7, 10, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (111, N'UR', CAST(N'11:11:00' AS Time), CAST(N'12:21:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (112, N'UR', CAST(N'11:11:00' AS Time), CAST(N'14:31:00' AS Time), 8, 9, CAST(N'03:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (113, N'UR', CAST(N'11:11:00' AS Time), CAST(N'15:31:00' AS Time), 8, 10, CAST(N'04:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (114, N'UR', CAST(N'12:21:00' AS Time), CAST(N'14:31:00' AS Time), 11, 9, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (115, N'UR', CAST(N'12:21:00' AS Time), CAST(N'15:31:00' AS Time), 11, 10, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (116, N'UR', CAST(N'14:31:00' AS Time), CAST(N'15:31:00' AS Time), 9, 10, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (117, N'UR', CAST(N'10:00:00' AS Time), CAST(N'11:00:00' AS Time), 10, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (118, N'UR', CAST(N'10:00:00' AS Time), CAST(N'13:10:00' AS Time), 10, 11, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (119, N'UR', CAST(N'10:00:00' AS Time), CAST(N'12:00:00' AS Time), 10, 8, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (120, N'UR', CAST(N'10:00:00' AS Time), CAST(N'14:43:00' AS Time), 10, 7, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (121, N'UR', CAST(N'10:00:00' AS Time), CAST(N'15:19:00' AS Time), 10, 6, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (122, N'UR', CAST(N'10:00:00' AS Time), CAST(N'15:26:00' AS Time), 10, 5, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (123, N'UR', CAST(N'10:00:00' AS Time), CAST(N'15:31:00' AS Time), 10, 4, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (124, N'UR', CAST(N'11:00:00' AS Time), CAST(N'13:10:00' AS Time), 9, 11, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (125, N'UR', CAST(N'11:00:00' AS Time), CAST(N'12:00:00' AS Time), 9, 8, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (126, N'UR', CAST(N'11:00:00' AS Time), CAST(N'14:43:00' AS Time), 9, 7, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (127, N'UR', CAST(N'11:00:00' AS Time), CAST(N'15:19:00' AS Time), 9, 6, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (128, N'UR', CAST(N'11:00:00' AS Time), CAST(N'15:26:00' AS Time), 9, 5, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (129, N'UR', CAST(N'11:00:00' AS Time), CAST(N'15:31:00' AS Time), 9, 4, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (130, N'UR', CAST(N'12:00:00' AS Time), CAST(N'13:10:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (131, N'UR', CAST(N'12:00:00' AS Time), CAST(N'14:43:00' AS Time), 8, 7, CAST(N'02:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (132, N'UR', CAST(N'12:00:00' AS Time), CAST(N'15:19:00' AS Time), 8, 6, CAST(N'03:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (133, N'UR', CAST(N'12:00:00' AS Time), CAST(N'15:26:00' AS Time), 8, 5, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (134, N'UR', CAST(N'12:00:00' AS Time), CAST(N'15:31:00' AS Time), 8, 4, CAST(N'03:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (135, N'UR', CAST(N'13:10:00' AS Time), CAST(N'14:43:00' AS Time), 11, 7, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (136, N'UR', CAST(N'13:10:00' AS Time), CAST(N'15:19:00' AS Time), 11, 6, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (137, N'UR', CAST(N'13:10:00' AS Time), CAST(N'15:26:00' AS Time), 11, 5, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (138, N'UR', CAST(N'13:10:00' AS Time), CAST(N'15:31:00' AS Time), 11, 4, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (139, N'UR', CAST(N'14:43:00' AS Time), CAST(N'15:19:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (140, N'UR', CAST(N'14:43:00' AS Time), CAST(N'15:26:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (141, N'UR', CAST(N'14:43:00' AS Time), CAST(N'15:31:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (142, N'UR', CAST(N'15:19:00' AS Time), CAST(N'15:26:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (143, N'UR', CAST(N'15:19:00' AS Time), CAST(N'15:31:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (144, N'UR', CAST(N'15:26:00' AS Time), CAST(N'15:31:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (145, N'UR', CAST(N'10:00:00' AS Time), CAST(N'10:25:00' AS Time), 12, 13, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (146, N'UR', CAST(N'10:00:00' AS Time), CAST(N'11:31:00' AS Time), 12, 15, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (147, N'UR', CAST(N'10:00:00' AS Time), CAST(N'13:07:00' AS Time), 12, 14, CAST(N'03:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (148, N'UR', CAST(N'10:00:00' AS Time), CAST(N'14:53:00' AS Time), 12, 16, CAST(N'04:53:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (149, N'UR', CAST(N'10:25:00' AS Time), CAST(N'11:31:00' AS Time), 13, 15, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (150, N'UR', CAST(N'10:25:00' AS Time), CAST(N'13:07:00' AS Time), 13, 14, CAST(N'02:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (151, N'UR', CAST(N'10:25:00' AS Time), CAST(N'14:53:00' AS Time), 13, 16, CAST(N'04:28:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (152, N'UR', CAST(N'11:31:00' AS Time), CAST(N'13:07:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (153, N'UR', CAST(N'11:31:00' AS Time), CAST(N'14:53:00' AS Time), 15, 16, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (154, N'UR', CAST(N'13:07:00' AS Time), CAST(N'14:53:00' AS Time), 14, 16, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (155, N'UR', CAST(N'10:00:00' AS Time), CAST(N'11:46:00' AS Time), 16, 14, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (156, N'UR', CAST(N'10:00:00' AS Time), CAST(N'10:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (157, N'UR', CAST(N'10:00:00' AS Time), CAST(N'13:22:00' AS Time), 16, 13, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (158, N'UR', CAST(N'10:00:00' AS Time), CAST(N'13:47:00' AS Time), 16, 12, CAST(N'03:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (159, N'UR', CAST(N'10:10:00' AS Time), CAST(N'11:46:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (160, N'UR', CAST(N'10:10:00' AS Time), CAST(N'13:22:00' AS Time), 15, 13, CAST(N'03:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (161, N'UR', CAST(N'10:10:00' AS Time), CAST(N'13:47:00' AS Time), 15, 12, CAST(N'03:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (162, N'UR', CAST(N'11:46:00' AS Time), CAST(N'13:22:00' AS Time), 14, 13, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (163, N'UR', CAST(N'11:46:00' AS Time), CAST(N'13:47:00' AS Time), 14, 12, CAST(N'02:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (164, N'UR', CAST(N'13:22:00' AS Time), CAST(N'13:47:00' AS Time), 13, 12, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (165, N'UR', CAST(N'15:00:00' AS Time), CAST(N'16:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (166, N'UR', CAST(N'15:00:00' AS Time), CAST(N'18:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (167, N'UR', CAST(N'16:45:00' AS Time), CAST(N'18:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (168, N'UR', CAST(N'15:00:00' AS Time), CAST(N'16:30:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (169, N'UR', CAST(N'15:00:00' AS Time), CAST(N'18:15:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (170, N'UR', CAST(N'16:30:00' AS Time), CAST(N'18:15:00' AS Time), 2, 1, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (171, N'UR', CAST(N'15:00:00' AS Time), CAST(N'15:05:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (172, N'UR', CAST(N'15:00:00' AS Time), CAST(N'15:12:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (173, N'UR', CAST(N'15:00:00' AS Time), CAST(N'15:48:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (174, N'UR', CAST(N'15:00:00' AS Time), CAST(N'16:11:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (175, N'UR', CAST(N'15:00:00' AS Time), CAST(N'17:21:00' AS Time), 4, 11, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (176, N'UR', CAST(N'15:00:00' AS Time), CAST(N'19:31:00' AS Time), 4, 9, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (177, N'UR', CAST(N'15:00:00' AS Time), CAST(N'20:31:00' AS Time), 4, 10, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (178, N'UR', CAST(N'15:05:00' AS Time), CAST(N'15:12:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (179, N'UR', CAST(N'15:05:00' AS Time), CAST(N'15:48:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (180, N'UR', CAST(N'15:05:00' AS Time), CAST(N'16:11:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (181, N'UR', CAST(N'15:05:00' AS Time), CAST(N'17:21:00' AS Time), 5, 11, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (182, N'UR', CAST(N'15:05:00' AS Time), CAST(N'19:31:00' AS Time), 5, 9, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (183, N'UR', CAST(N'15:05:00' AS Time), CAST(N'20:31:00' AS Time), 5, 10, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (184, N'UR', CAST(N'15:12:00' AS Time), CAST(N'15:48:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (185, N'UR', CAST(N'15:12:00' AS Time), CAST(N'16:11:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (186, N'UR', CAST(N'15:12:00' AS Time), CAST(N'17:21:00' AS Time), 6, 11, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (187, N'UR', CAST(N'15:12:00' AS Time), CAST(N'19:31:00' AS Time), 6, 9, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (188, N'UR', CAST(N'15:12:00' AS Time), CAST(N'20:31:00' AS Time), 6, 10, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (189, N'UR', CAST(N'15:48:00' AS Time), CAST(N'16:11:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (190, N'UR', CAST(N'15:48:00' AS Time), CAST(N'17:21:00' AS Time), 7, 11, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (191, N'UR', CAST(N'15:48:00' AS Time), CAST(N'19:31:00' AS Time), 7, 9, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (192, N'UR', CAST(N'15:48:00' AS Time), CAST(N'20:31:00' AS Time), 7, 10, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (193, N'UR', CAST(N'16:11:00' AS Time), CAST(N'17:21:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (194, N'UR', CAST(N'16:11:00' AS Time), CAST(N'19:31:00' AS Time), 8, 9, CAST(N'03:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (195, N'UR', CAST(N'16:11:00' AS Time), CAST(N'20:31:00' AS Time), 8, 10, CAST(N'04:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (196, N'UR', CAST(N'17:21:00' AS Time), CAST(N'19:31:00' AS Time), 11, 9, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (197, N'UR', CAST(N'17:21:00' AS Time), CAST(N'20:31:00' AS Time), 11, 10, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (198, N'UR', CAST(N'19:31:00' AS Time), CAST(N'20:31:00' AS Time), 9, 10, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (199, N'UR', CAST(N'15:00:00' AS Time), CAST(N'16:00:00' AS Time), 10, 9, CAST(N'01:00:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (200, N'UR', CAST(N'15:00:00' AS Time), CAST(N'18:10:00' AS Time), 10, 11, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (201, N'UR', CAST(N'15:00:00' AS Time), CAST(N'17:00:00' AS Time), 10, 8, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (202, N'UR', CAST(N'15:00:00' AS Time), CAST(N'19:43:00' AS Time), 10, 7, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (203, N'UR', CAST(N'15:00:00' AS Time), CAST(N'20:19:00' AS Time), 10, 6, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (204, N'UR', CAST(N'15:00:00' AS Time), CAST(N'20:26:00' AS Time), 10, 5, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (205, N'UR', CAST(N'15:00:00' AS Time), CAST(N'20:31:00' AS Time), 10, 4, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (206, N'UR', CAST(N'16:00:00' AS Time), CAST(N'18:10:00' AS Time), 9, 11, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (207, N'UR', CAST(N'16:00:00' AS Time), CAST(N'17:00:00' AS Time), 9, 8, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (208, N'UR', CAST(N'16:00:00' AS Time), CAST(N'19:43:00' AS Time), 9, 7, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (209, N'UR', CAST(N'16:00:00' AS Time), CAST(N'20:19:00' AS Time), 9, 6, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (210, N'UR', CAST(N'16:00:00' AS Time), CAST(N'20:26:00' AS Time), 9, 5, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (211, N'UR', CAST(N'16:00:00' AS Time), CAST(N'20:31:00' AS Time), 9, 4, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (212, N'UR', CAST(N'17:00:00' AS Time), CAST(N'18:10:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (213, N'UR', CAST(N'17:00:00' AS Time), CAST(N'19:43:00' AS Time), 8, 7, CAST(N'02:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (214, N'UR', CAST(N'17:00:00' AS Time), CAST(N'20:19:00' AS Time), 8, 6, CAST(N'03:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (215, N'UR', CAST(N'17:00:00' AS Time), CAST(N'20:26:00' AS Time), 8, 5, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (216, N'UR', CAST(N'17:00:00' AS Time), CAST(N'20:31:00' AS Time), 8, 4, CAST(N'03:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (217, N'UR', CAST(N'18:10:00' AS Time), CAST(N'19:43:00' AS Time), 11, 7, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (218, N'UR', CAST(N'18:10:00' AS Time), CAST(N'20:19:00' AS Time), 11, 6, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (219, N'UR', CAST(N'18:10:00' AS Time), CAST(N'20:26:00' AS Time), 11, 5, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (220, N'UR', CAST(N'18:10:00' AS Time), CAST(N'20:31:00' AS Time), 11, 4, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (221, N'UR', CAST(N'19:43:00' AS Time), CAST(N'20:19:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (222, N'UR', CAST(N'19:43:00' AS Time), CAST(N'20:26:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (223, N'UR', CAST(N'19:43:00' AS Time), CAST(N'20:31:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (224, N'UR', CAST(N'20:19:00' AS Time), CAST(N'20:26:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (225, N'UR', CAST(N'20:19:00' AS Time), CAST(N'20:31:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (226, N'UR', CAST(N'20:26:00' AS Time), CAST(N'20:31:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (227, N'UR', CAST(N'15:00:00' AS Time), CAST(N'15:25:00' AS Time), 12, 13, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (228, N'UR', CAST(N'15:00:00' AS Time), CAST(N'16:31:00' AS Time), 12, 15, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (229, N'UR', CAST(N'15:00:00' AS Time), CAST(N'18:07:00' AS Time), 12, 14, CAST(N'03:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (230, N'UR', CAST(N'15:00:00' AS Time), CAST(N'19:53:00' AS Time), 12, 16, CAST(N'04:53:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (231, N'UR', CAST(N'15:25:00' AS Time), CAST(N'16:31:00' AS Time), 13, 15, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (232, N'UR', CAST(N'15:25:00' AS Time), CAST(N'18:07:00' AS Time), 13, 14, CAST(N'02:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (233, N'UR', CAST(N'15:25:00' AS Time), CAST(N'19:53:00' AS Time), 13, 16, CAST(N'04:28:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (234, N'UR', CAST(N'16:31:00' AS Time), CAST(N'18:07:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (235, N'UR', CAST(N'16:31:00' AS Time), CAST(N'19:53:00' AS Time), 15, 16, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (236, N'UR', CAST(N'18:07:00' AS Time), CAST(N'19:53:00' AS Time), 14, 16, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (237, N'UR', CAST(N'15:00:00' AS Time), CAST(N'16:46:00' AS Time), 16, 14, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (238, N'UR', CAST(N'15:00:00' AS Time), CAST(N'15:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (239, N'UR', CAST(N'15:00:00' AS Time), CAST(N'18:22:00' AS Time), 16, 13, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (240, N'UR', CAST(N'15:00:00' AS Time), CAST(N'18:47:00' AS Time), 16, 12, CAST(N'03:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (241, N'UR', CAST(N'15:10:00' AS Time), CAST(N'16:46:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (242, N'UR', CAST(N'15:10:00' AS Time), CAST(N'18:22:00' AS Time), 15, 13, CAST(N'03:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (243, N'UR', CAST(N'15:10:00' AS Time), CAST(N'18:47:00' AS Time), 15, 12, CAST(N'03:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (244, N'UR', CAST(N'16:46:00' AS Time), CAST(N'18:22:00' AS Time), 14, 13, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (245, N'UR', CAST(N'16:46:00' AS Time), CAST(N'18:47:00' AS Time), 14, 12, CAST(N'02:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (246, N'UR', CAST(N'18:22:00' AS Time), CAST(N'18:47:00' AS Time), 13, 12, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (247, N'UR', CAST(N'19:00:00' AS Time), CAST(N'20:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (248, N'UR', CAST(N'19:00:00' AS Time), CAST(N'22:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (249, N'UR', CAST(N'20:45:00' AS Time), CAST(N'22:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (250, N'UR', CAST(N'19:00:00' AS Time), CAST(N'20:30:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (251, N'UR', CAST(N'19:00:00' AS Time), CAST(N'22:15:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (252, N'UR', CAST(N'20:30:00' AS Time), CAST(N'22:15:00' AS Time), 2, 1, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (253, N'UR', CAST(N'19:00:00' AS Time), CAST(N'19:05:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (254, N'UR', CAST(N'19:00:00' AS Time), CAST(N'19:12:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (255, N'UR', CAST(N'19:00:00' AS Time), CAST(N'19:48:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (256, N'UR', CAST(N'19:00:00' AS Time), CAST(N'20:11:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (257, N'UR', CAST(N'19:00:00' AS Time), CAST(N'21:21:00' AS Time), 4, 11, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (258, N'UR', CAST(N'19:00:00' AS Time), CAST(N'23:31:00' AS Time), 4, 9, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (259, N'UR', CAST(N'19:00:00' AS Time), CAST(N'00:31:00' AS Time), 4, 10, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (260, N'UR', CAST(N'19:05:00' AS Time), CAST(N'19:12:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (261, N'UR', CAST(N'19:05:00' AS Time), CAST(N'19:48:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (262, N'UR', CAST(N'19:05:00' AS Time), CAST(N'20:11:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (263, N'UR', CAST(N'19:05:00' AS Time), CAST(N'21:21:00' AS Time), 5, 11, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (264, N'UR', CAST(N'19:05:00' AS Time), CAST(N'23:31:00' AS Time), 5, 9, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (265, N'UR', CAST(N'19:05:00' AS Time), CAST(N'00:31:00' AS Time), 5, 10, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (266, N'UR', CAST(N'19:12:00' AS Time), CAST(N'19:48:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (267, N'UR', CAST(N'19:12:00' AS Time), CAST(N'20:11:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (268, N'UR', CAST(N'19:12:00' AS Time), CAST(N'21:21:00' AS Time), 6, 11, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (269, N'UR', CAST(N'19:12:00' AS Time), CAST(N'23:31:00' AS Time), 6, 9, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (270, N'UR', CAST(N'19:12:00' AS Time), CAST(N'00:31:00' AS Time), 6, 10, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (271, N'UR', CAST(N'19:48:00' AS Time), CAST(N'20:11:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (272, N'UR', CAST(N'19:48:00' AS Time), CAST(N'21:21:00' AS Time), 7, 11, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (273, N'UR', CAST(N'19:48:00' AS Time), CAST(N'23:31:00' AS Time), 7, 9, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (274, N'UR', CAST(N'19:48:00' AS Time), CAST(N'00:31:00' AS Time), 7, 10, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (275, N'UR', CAST(N'20:11:00' AS Time), CAST(N'21:21:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (276, N'UR', CAST(N'20:11:00' AS Time), CAST(N'23:31:00' AS Time), 8, 9, CAST(N'03:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (277, N'UR', CAST(N'20:11:00' AS Time), CAST(N'00:31:00' AS Time), 8, 10, CAST(N'04:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (278, N'UR', CAST(N'21:21:00' AS Time), CAST(N'23:31:00' AS Time), 11, 9, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (279, N'UR', CAST(N'21:21:00' AS Time), CAST(N'00:31:00' AS Time), 11, 10, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (280, N'UR', CAST(N'23:31:00' AS Time), CAST(N'00:31:00' AS Time), 9, 10, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (281, N'UR', CAST(N'19:00:00' AS Time), CAST(N'20:00:00' AS Time), 10, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (282, N'UR', CAST(N'19:00:00' AS Time), CAST(N'22:10:00' AS Time), 10, 11, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (283, N'UR', CAST(N'19:00:00' AS Time), CAST(N'21:00:00' AS Time), 10, 8, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (284, N'UR', CAST(N'19:00:00' AS Time), CAST(N'23:43:00' AS Time), 10, 7, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (285, N'UR', CAST(N'19:00:00' AS Time), CAST(N'00:19:00' AS Time), 10, 6, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (286, N'UR', CAST(N'19:00:00' AS Time), CAST(N'00:26:00' AS Time), 10, 5, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (287, N'UR', CAST(N'19:00:00' AS Time), CAST(N'00:31:00' AS Time), 10, 4, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (288, N'UR', CAST(N'20:00:00' AS Time), CAST(N'22:10:00' AS Time), 9, 11, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (289, N'UR', CAST(N'20:00:00' AS Time), CAST(N'21:00:00' AS Time), 9, 8, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (290, N'UR', CAST(N'20:00:00' AS Time), CAST(N'23:43:00' AS Time), 9, 7, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (291, N'UR', CAST(N'20:00:00' AS Time), CAST(N'00:19:00' AS Time), 9, 6, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (292, N'UR', CAST(N'20:00:00' AS Time), CAST(N'00:26:00' AS Time), 9, 5, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (293, N'UR', CAST(N'20:00:00' AS Time), CAST(N'00:31:00' AS Time), 9, 4, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (294, N'UR', CAST(N'21:00:00' AS Time), CAST(N'22:10:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (295, N'UR', CAST(N'21:00:00' AS Time), CAST(N'23:43:00' AS Time), 8, 7, CAST(N'02:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (296, N'UR', CAST(N'21:00:00' AS Time), CAST(N'00:19:00' AS Time), 8, 6, CAST(N'03:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (297, N'UR', CAST(N'21:00:00' AS Time), CAST(N'00:26:00' AS Time), 8, 5, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (298, N'UR', CAST(N'21:00:00' AS Time), CAST(N'00:31:00' AS Time), 8, 4, CAST(N'03:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (299, N'UR', CAST(N'22:10:00' AS Time), CAST(N'23:43:00' AS Time), 11, 7, CAST(N'01:33:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (300, N'UR', CAST(N'22:10:00' AS Time), CAST(N'00:19:00' AS Time), 11, 6, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (301, N'UR', CAST(N'22:10:00' AS Time), CAST(N'00:26:00' AS Time), 11, 5, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (302, N'UR', CAST(N'22:10:00' AS Time), CAST(N'00:31:00' AS Time), 11, 4, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (303, N'UR', CAST(N'23:43:00' AS Time), CAST(N'00:19:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (304, N'UR', CAST(N'23:43:00' AS Time), CAST(N'00:26:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (305, N'UR', CAST(N'23:43:00' AS Time), CAST(N'00:31:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (306, N'UR', CAST(N'00:19:00' AS Time), CAST(N'00:26:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (307, N'UR', CAST(N'00:19:00' AS Time), CAST(N'00:31:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (308, N'UR', CAST(N'00:26:00' AS Time), CAST(N'00:31:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (309, N'UR', CAST(N'19:00:00' AS Time), CAST(N'19:25:00' AS Time), 12, 13, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (310, N'UR', CAST(N'19:00:00' AS Time), CAST(N'20:31:00' AS Time), 12, 15, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (311, N'UR', CAST(N'19:00:00' AS Time), CAST(N'22:07:00' AS Time), 12, 14, CAST(N'03:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (312, N'UR', CAST(N'19:00:00' AS Time), CAST(N'23:53:00' AS Time), 12, 16, CAST(N'04:53:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (313, N'UR', CAST(N'19:25:00' AS Time), CAST(N'20:31:00' AS Time), 13, 15, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (314, N'UR', CAST(N'19:25:00' AS Time), CAST(N'22:07:00' AS Time), 13, 14, CAST(N'02:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (315, N'UR', CAST(N'19:25:00' AS Time), CAST(N'23:53:00' AS Time), 13, 16, CAST(N'04:28:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (316, N'UR', CAST(N'20:31:00' AS Time), CAST(N'22:07:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (317, N'UR', CAST(N'20:31:00' AS Time), CAST(N'23:53:00' AS Time), 15, 16, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (318, N'UR', CAST(N'22:07:00' AS Time), CAST(N'23:53:00' AS Time), 14, 16, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (319, N'UR', CAST(N'19:00:00' AS Time), CAST(N'20:46:00' AS Time), 16, 14, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (320, N'UR', CAST(N'19:00:00' AS Time), CAST(N'19:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (321, N'UR', CAST(N'19:00:00' AS Time), CAST(N'22:22:00' AS Time), 16, 13, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (322, N'UR', CAST(N'19:00:00' AS Time), CAST(N'22:47:00' AS Time), 16, 12, CAST(N'03:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (323, N'UR', CAST(N'19:10:00' AS Time), CAST(N'20:46:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (324, N'UR', CAST(N'19:10:00' AS Time), CAST(N'22:22:00' AS Time), 15, 13, CAST(N'03:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (325, N'UR', CAST(N'19:10:00' AS Time), CAST(N'22:47:00' AS Time), 15, 12, CAST(N'03:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (326, N'UR', CAST(N'20:46:00' AS Time), CAST(N'22:22:00' AS Time), 14, 13, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (327, N'UR', CAST(N'20:46:00' AS Time), CAST(N'22:47:00' AS Time), 14, 12, CAST(N'02:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (328, N'UR', CAST(N'22:22:00' AS Time), CAST(N'22:47:00' AS Time), 13, 12, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (329, N'UR', CAST(N'23:00:00' AS Time), CAST(N'00:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (330, N'UR', CAST(N'23:00:00' AS Time), CAST(N'02:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (331, N'UR', CAST(N'00:45:00' AS Time), CAST(N'02:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (332, N'UR', CAST(N'23:00:00' AS Time), CAST(N'00:30:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (333, N'UR', CAST(N'23:00:00' AS Time), CAST(N'02:15:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (334, N'UR', CAST(N'00:30:00' AS Time), CAST(N'02:15:00' AS Time), 2, 1, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (335, N'UR', CAST(N'23:00:00' AS Time), CAST(N'23:05:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (336, N'UR', CAST(N'23:00:00' AS Time), CAST(N'23:12:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (337, N'UR', CAST(N'23:00:00' AS Time), CAST(N'23:48:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (338, N'UR', CAST(N'23:00:00' AS Time), CAST(N'00:11:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (339, N'UR', CAST(N'23:00:00' AS Time), CAST(N'01:21:00' AS Time), 4, 11, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (340, N'UR', CAST(N'23:00:00' AS Time), CAST(N'03:31:00' AS Time), 4, 9, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (341, N'UR', CAST(N'23:00:00' AS Time), CAST(N'04:31:00' AS Time), 4, 10, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (342, N'UR', CAST(N'23:05:00' AS Time), CAST(N'23:12:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (343, N'UR', CAST(N'23:05:00' AS Time), CAST(N'23:48:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (344, N'UR', CAST(N'23:05:00' AS Time), CAST(N'00:11:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (345, N'UR', CAST(N'23:05:00' AS Time), CAST(N'01:21:00' AS Time), 5, 11, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (346, N'UR', CAST(N'23:05:00' AS Time), CAST(N'03:31:00' AS Time), 5, 9, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (347, N'UR', CAST(N'23:05:00' AS Time), CAST(N'04:31:00' AS Time), 5, 10, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (348, N'UR', CAST(N'23:12:00' AS Time), CAST(N'23:48:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (349, N'UR', CAST(N'23:12:00' AS Time), CAST(N'00:11:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (350, N'UR', CAST(N'23:12:00' AS Time), CAST(N'01:21:00' AS Time), 6, 11, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (351, N'UR', CAST(N'23:12:00' AS Time), CAST(N'03:31:00' AS Time), 6, 9, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (352, N'UR', CAST(N'23:12:00' AS Time), CAST(N'04:31:00' AS Time), 6, 10, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (353, N'UR', CAST(N'23:48:00' AS Time), CAST(N'00:11:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (354, N'UR', CAST(N'23:48:00' AS Time), CAST(N'01:21:00' AS Time), 7, 11, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (355, N'UR', CAST(N'23:48:00' AS Time), CAST(N'03:31:00' AS Time), 7, 9, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (356, N'UR', CAST(N'23:48:00' AS Time), CAST(N'04:31:00' AS Time), 7, 10, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (357, N'UR', CAST(N'00:11:00' AS Time), CAST(N'01:21:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (358, N'UR', CAST(N'00:11:00' AS Time), CAST(N'03:31:00' AS Time), 8, 9, CAST(N'03:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (359, N'UR', CAST(N'00:11:00' AS Time), CAST(N'04:31:00' AS Time), 8, 10, CAST(N'04:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (360, N'UR', CAST(N'01:21:00' AS Time), CAST(N'03:31:00' AS Time), 11, 9, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (361, N'UR', CAST(N'01:21:00' AS Time), CAST(N'04:31:00' AS Time), 11, 10, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (362, N'UR', CAST(N'03:31:00' AS Time), CAST(N'04:31:00' AS Time), 9, 10, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (363, N'UR', CAST(N'23:00:00' AS Time), CAST(N'00:00:00' AS Time), 10, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (364, N'UR', CAST(N'23:00:00' AS Time), CAST(N'02:10:00' AS Time), 10, 11, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (365, N'UR', CAST(N'23:00:00' AS Time), CAST(N'01:00:00' AS Time), 10, 8, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (366, N'UR', CAST(N'23:00:00' AS Time), CAST(N'03:43:00' AS Time), 10, 7, CAST(N'04:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (367, N'UR', CAST(N'23:00:00' AS Time), CAST(N'04:19:00' AS Time), 10, 6, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (368, N'UR', CAST(N'23:00:00' AS Time), CAST(N'04:26:00' AS Time), 10, 5, CAST(N'05:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (369, N'UR', CAST(N'23:00:00' AS Time), CAST(N'04:31:00' AS Time), 10, 4, CAST(N'05:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (370, N'UR', CAST(N'00:00:00' AS Time), CAST(N'02:10:00' AS Time), 9, 11, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (371, N'UR', CAST(N'00:00:00' AS Time), CAST(N'01:00:00' AS Time), 9, 8, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (372, N'UR', CAST(N'00:00:00' AS Time), CAST(N'03:43:00' AS Time), 9, 7, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (373, N'UR', CAST(N'00:00:00' AS Time), CAST(N'04:19:00' AS Time), 9, 6, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (374, N'UR', CAST(N'00:00:00' AS Time), CAST(N'04:26:00' AS Time), 9, 5, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (375, N'UR', CAST(N'00:00:00' AS Time), CAST(N'04:31:00' AS Time), 9, 4, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (376, N'UR', CAST(N'01:00:00' AS Time), CAST(N'02:10:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (377, N'UR', CAST(N'01:00:00' AS Time), CAST(N'03:43:00' AS Time), 8, 7, CAST(N'02:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (378, N'UR', CAST(N'01:00:00' AS Time), CAST(N'04:19:00' AS Time), 8, 6, CAST(N'03:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (379, N'UR', CAST(N'01:00:00' AS Time), CAST(N'04:26:00' AS Time), 8, 5, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (380, N'UR', CAST(N'01:00:00' AS Time), CAST(N'04:31:00' AS Time), 8, 4, CAST(N'03:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (381, N'UR', CAST(N'02:10:00' AS Time), CAST(N'03:43:00' AS Time), 11, 7, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (382, N'UR', CAST(N'02:10:00' AS Time), CAST(N'04:19:00' AS Time), 11, 6, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (383, N'UR', CAST(N'02:10:00' AS Time), CAST(N'04:26:00' AS Time), 11, 5, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (384, N'UR', CAST(N'02:10:00' AS Time), CAST(N'04:31:00' AS Time), 11, 4, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (385, N'UR', CAST(N'03:43:00' AS Time), CAST(N'04:19:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (386, N'UR', CAST(N'03:43:00' AS Time), CAST(N'04:26:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (387, N'UR', CAST(N'03:43:00' AS Time), CAST(N'04:31:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (388, N'UR', CAST(N'04:19:00' AS Time), CAST(N'04:26:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (389, N'UR', CAST(N'04:19:00' AS Time), CAST(N'04:31:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (390, N'UR', CAST(N'04:26:00' AS Time), CAST(N'04:31:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (391, N'UR', CAST(N'23:00:00' AS Time), CAST(N'23:25:00' AS Time), 12, 13, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (392, N'UR', CAST(N'23:00:00' AS Time), CAST(N'00:31:00' AS Time), 12, 15, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (393, N'UR', CAST(N'23:00:00' AS Time), CAST(N'02:07:00' AS Time), 12, 14, CAST(N'03:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (394, N'UR', CAST(N'23:00:00' AS Time), CAST(N'03:53:00' AS Time), 12, 16, CAST(N'04:53:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (395, N'UR', CAST(N'23:25:00' AS Time), CAST(N'00:31:00' AS Time), 13, 15, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (396, N'UR', CAST(N'23:25:00' AS Time), CAST(N'02:07:00' AS Time), 13, 14, CAST(N'02:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (397, N'UR', CAST(N'23:25:00' AS Time), CAST(N'03:53:00' AS Time), 13, 16, CAST(N'04:28:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (398, N'UR', CAST(N'00:31:00' AS Time), CAST(N'02:07:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (399, N'UR', CAST(N'00:31:00' AS Time), CAST(N'03:53:00' AS Time), 15, 16, CAST(N'03:22:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (400, N'UR', CAST(N'02:07:00' AS Time), CAST(N'03:53:00' AS Time), 14, 16, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (401, N'UR', CAST(N'23:00:00' AS Time), CAST(N'00:46:00' AS Time), 16, 14, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (402, N'UR', CAST(N'23:00:00' AS Time), CAST(N'23:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (403, N'UR', CAST(N'23:00:00' AS Time), CAST(N'02:22:00' AS Time), 16, 13, CAST(N'03:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (404, N'UR', CAST(N'23:00:00' AS Time), CAST(N'02:47:00' AS Time), 16, 12, CAST(N'03:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (405, N'UR', CAST(N'23:10:00' AS Time), CAST(N'00:46:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (406, N'UR', CAST(N'23:10:00' AS Time), CAST(N'02:22:00' AS Time), 15, 13, CAST(N'03:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (407, N'UR', CAST(N'23:10:00' AS Time), CAST(N'02:47:00' AS Time), 15, 12, CAST(N'03:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (408, N'UR', CAST(N'00:46:00' AS Time), CAST(N'02:22:00' AS Time), 14, 13, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (409, N'UR', CAST(N'00:46:00' AS Time), CAST(N'02:47:00' AS Time), 14, 12, CAST(N'02:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (410, N'UR', CAST(N'02:22:00' AS Time), CAST(N'02:47:00' AS Time), 13, 12, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (411, N'IC', CAST(N'05:00:00' AS Time), CAST(N'06:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (412, N'IC', CAST(N'05:00:00' AS Time), CAST(N'08:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (413, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (414, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:35:00' AS Time), 1, 5, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (415, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:42:00' AS Time), 1, 6, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (416, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:18:00' AS Time), 1, 7, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (417, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:41:00' AS Time), 1, 8, CAST(N'05:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (418, N'IC', CAST(N'05:00:00' AS Time), CAST(N'11:41:00' AS Time), 1, 9, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (419, N'IC', CAST(N'05:00:00' AS Time), CAST(N'12:41:00' AS Time), 1, 10, CAST(N'07:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (420, N'IC', CAST(N'05:00:00' AS Time), CAST(N'13:26:00' AS Time), 1, 12, CAST(N'08:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (421, N'IC', CAST(N'05:00:00' AS Time), CAST(N'13:51:00' AS Time), 1, 13, CAST(N'08:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (422, N'IC', CAST(N'05:00:00' AS Time), CAST(N'14:57:00' AS Time), 1, 15, CAST(N'09:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (423, N'IC', CAST(N'05:00:00' AS Time), CAST(N'15:07:00' AS Time), 1, 16, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (424, N'IC', CAST(N'06:45:00' AS Time), CAST(N'08:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (425, N'IC', CAST(N'06:45:00' AS Time), CAST(N'09:30:00' AS Time), 2, 4, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (426, N'IC', CAST(N'06:45:00' AS Time), CAST(N'09:35:00' AS Time), 2, 5, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (427, N'IC', CAST(N'06:45:00' AS Time), CAST(N'09:42:00' AS Time), 2, 6, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (428, N'IC', CAST(N'06:45:00' AS Time), CAST(N'10:18:00' AS Time), 2, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (429, N'IC', CAST(N'06:45:00' AS Time), CAST(N'10:41:00' AS Time), 2, 8, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (430, N'IC', CAST(N'06:45:00' AS Time), CAST(N'11:41:00' AS Time), 2, 9, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (431, N'IC', CAST(N'06:45:00' AS Time), CAST(N'12:41:00' AS Time), 2, 10, CAST(N'05:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (432, N'IC', CAST(N'06:45:00' AS Time), CAST(N'13:26:00' AS Time), 2, 12, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (433, N'IC', CAST(N'06:45:00' AS Time), CAST(N'13:51:00' AS Time), 2, 13, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (434, N'IC', CAST(N'06:45:00' AS Time), CAST(N'14:57:00' AS Time), 2, 15, CAST(N'08:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (435, N'IC', CAST(N'06:45:00' AS Time), CAST(N'15:07:00' AS Time), 2, 16, CAST(N'08:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (436, N'IC', CAST(N'08:15:00' AS Time), CAST(N'09:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (437, N'IC', CAST(N'08:15:00' AS Time), CAST(N'09:35:00' AS Time), 3, 5, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (438, N'IC', CAST(N'08:15:00' AS Time), CAST(N'09:42:00' AS Time), 3, 6, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (439, N'IC', CAST(N'08:15:00' AS Time), CAST(N'10:18:00' AS Time), 3, 7, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (440, N'IC', CAST(N'08:15:00' AS Time), CAST(N'10:41:00' AS Time), 3, 8, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (441, N'IC', CAST(N'08:15:00' AS Time), CAST(N'11:41:00' AS Time), 3, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (442, N'IC', CAST(N'08:15:00' AS Time), CAST(N'12:41:00' AS Time), 3, 10, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (443, N'IC', CAST(N'08:15:00' AS Time), CAST(N'13:26:00' AS Time), 3, 12, CAST(N'05:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (444, N'IC', CAST(N'08:15:00' AS Time), CAST(N'13:51:00' AS Time), 3, 13, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (445, N'IC', CAST(N'08:15:00' AS Time), CAST(N'14:57:00' AS Time), 3, 15, CAST(N'06:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (446, N'IC', CAST(N'08:15:00' AS Time), CAST(N'15:07:00' AS Time), 3, 16, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (447, N'IC', CAST(N'09:30:00' AS Time), CAST(N'09:35:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (448, N'IC', CAST(N'09:30:00' AS Time), CAST(N'09:42:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (449, N'IC', CAST(N'09:30:00' AS Time), CAST(N'10:18:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (450, N'IC', CAST(N'09:30:00' AS Time), CAST(N'10:41:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (451, N'IC', CAST(N'09:30:00' AS Time), CAST(N'11:41:00' AS Time), 4, 9, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (452, N'IC', CAST(N'09:30:00' AS Time), CAST(N'12:41:00' AS Time), 4, 10, CAST(N'03:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (453, N'IC', CAST(N'09:30:00' AS Time), CAST(N'13:26:00' AS Time), 4, 12, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (454, N'IC', CAST(N'09:30:00' AS Time), CAST(N'13:51:00' AS Time), 4, 13, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (455, N'IC', CAST(N'09:30:00' AS Time), CAST(N'14:57:00' AS Time), 4, 15, CAST(N'05:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (456, N'IC', CAST(N'09:30:00' AS Time), CAST(N'15:07:00' AS Time), 4, 16, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (457, N'IC', CAST(N'09:35:00' AS Time), CAST(N'09:42:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (458, N'IC', CAST(N'09:35:00' AS Time), CAST(N'10:18:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (459, N'IC', CAST(N'09:35:00' AS Time), CAST(N'10:41:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (460, N'IC', CAST(N'09:35:00' AS Time), CAST(N'11:41:00' AS Time), 5, 9, CAST(N'02:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (461, N'IC', CAST(N'09:35:00' AS Time), CAST(N'12:41:00' AS Time), 5, 10, CAST(N'03:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (462, N'IC', CAST(N'09:35:00' AS Time), CAST(N'13:26:00' AS Time), 5, 12, CAST(N'03:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (463, N'IC', CAST(N'09:35:00' AS Time), CAST(N'13:51:00' AS Time), 5, 13, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (464, N'IC', CAST(N'09:35:00' AS Time), CAST(N'14:57:00' AS Time), 5, 15, CAST(N'05:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (465, N'IC', CAST(N'09:35:00' AS Time), CAST(N'15:07:00' AS Time), 5, 16, CAST(N'05:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (466, N'IC', CAST(N'09:42:00' AS Time), CAST(N'10:18:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (467, N'IC', CAST(N'09:42:00' AS Time), CAST(N'10:41:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (468, N'IC', CAST(N'09:42:00' AS Time), CAST(N'11:41:00' AS Time), 6, 9, CAST(N'01:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (469, N'IC', CAST(N'09:42:00' AS Time), CAST(N'12:41:00' AS Time), 6, 10, CAST(N'02:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (470, N'IC', CAST(N'09:42:00' AS Time), CAST(N'13:26:00' AS Time), 6, 12, CAST(N'03:44:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (471, N'IC', CAST(N'09:42:00' AS Time), CAST(N'13:51:00' AS Time), 6, 13, CAST(N'04:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (472, N'IC', CAST(N'09:42:00' AS Time), CAST(N'14:57:00' AS Time), 6, 15, CAST(N'05:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (473, N'IC', CAST(N'09:42:00' AS Time), CAST(N'15:07:00' AS Time), 6, 16, CAST(N'05:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (474, N'IC', CAST(N'10:18:00' AS Time), CAST(N'10:41:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (475, N'IC', CAST(N'10:18:00' AS Time), CAST(N'11:41:00' AS Time), 7, 9, CAST(N'01:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (476, N'IC', CAST(N'10:18:00' AS Time), CAST(N'12:41:00' AS Time), 7, 10, CAST(N'02:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (477, N'IC', CAST(N'10:18:00' AS Time), CAST(N'13:26:00' AS Time), 7, 12, CAST(N'03:08:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (478, N'IC', CAST(N'10:18:00' AS Time), CAST(N'13:51:00' AS Time), 7, 13, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (479, N'IC', CAST(N'10:18:00' AS Time), CAST(N'14:57:00' AS Time), 7, 15, CAST(N'04:39:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (480, N'IC', CAST(N'10:18:00' AS Time), CAST(N'15:07:00' AS Time), 7, 16, CAST(N'04:49:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (481, N'IC', CAST(N'10:41:00' AS Time), CAST(N'11:41:00' AS Time), 8, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (482, N'IC', CAST(N'10:41:00' AS Time), CAST(N'12:41:00' AS Time), 8, 10, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (483, N'IC', CAST(N'10:41:00' AS Time), CAST(N'13:26:00' AS Time), 8, 12, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (484, N'IC', CAST(N'10:41:00' AS Time), CAST(N'13:51:00' AS Time), 8, 13, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (485, N'IC', CAST(N'10:41:00' AS Time), CAST(N'14:57:00' AS Time), 8, 15, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (486, N'IC', CAST(N'10:41:00' AS Time), CAST(N'15:07:00' AS Time), 8, 16, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (487, N'IC', CAST(N'11:41:00' AS Time), CAST(N'12:41:00' AS Time), 9, 10, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (488, N'IC', CAST(N'11:41:00' AS Time), CAST(N'13:26:00' AS Time), 9, 12, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (489, N'IC', CAST(N'11:41:00' AS Time), CAST(N'13:51:00' AS Time), 9, 13, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (490, N'IC', CAST(N'11:41:00' AS Time), CAST(N'14:57:00' AS Time), 9, 15, CAST(N'03:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (491, N'IC', CAST(N'11:41:00' AS Time), CAST(N'15:07:00' AS Time), 9, 16, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (492, N'IC', CAST(N'12:41:00' AS Time), CAST(N'13:26:00' AS Time), 10, 12, CAST(N'00:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (493, N'IC', CAST(N'12:41:00' AS Time), CAST(N'13:51:00' AS Time), 10, 13, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (494, N'IC', CAST(N'12:41:00' AS Time), CAST(N'14:57:00' AS Time), 10, 15, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (495, N'IC', CAST(N'12:41:00' AS Time), CAST(N'15:07:00' AS Time), 10, 16, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (496, N'IC', CAST(N'13:26:00' AS Time), CAST(N'13:51:00' AS Time), 12, 13, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (497, N'IC', CAST(N'13:26:00' AS Time), CAST(N'14:57:00' AS Time), 12, 15, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (498, N'IC', CAST(N'13:26:00' AS Time), CAST(N'15:07:00' AS Time), 12, 16, CAST(N'01:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (499, N'IC', CAST(N'13:51:00' AS Time), CAST(N'14:57:00' AS Time), 13, 15, CAST(N'01:06:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (500, N'IC', CAST(N'13:51:00' AS Time), CAST(N'15:07:00' AS Time), 13, 16, CAST(N'01:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (501, N'IC', CAST(N'14:57:00' AS Time), CAST(N'15:07:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (502, N'IC', CAST(N'05:00:00' AS Time), CAST(N'05:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (503, N'IC', CAST(N'05:00:00' AS Time), CAST(N'06:16:00' AS Time), 16, 13, CAST(N'01:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (504, N'IC', CAST(N'05:00:00' AS Time), CAST(N'06:41:00' AS Time), 16, 12, CAST(N'01:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (505, N'IC', CAST(N'05:00:00' AS Time), CAST(N'07:36:00' AS Time), 16, 10, CAST(N'02:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (506, N'IC', CAST(N'05:00:00' AS Time), CAST(N'08:36:00' AS Time), 16, 9, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (507, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:36:00' AS Time), 16, 8, CAST(N'04:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (508, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:59:00' AS Time), 16, 7, CAST(N'04:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (509, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:35:00' AS Time), 16, 6, CAST(N'05:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (510, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:42:00' AS Time), 16, 5, CAST(N'05:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (511, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:47:00' AS Time), 16, 4, CAST(N'05:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (512, N'IC', CAST(N'05:00:00' AS Time), CAST(N'12:02:00' AS Time), 16, 3, CAST(N'07:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (513, N'IC', CAST(N'05:00:00' AS Time), CAST(N'13:32:00' AS Time), 16, 2, CAST(N'08:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (514, N'IC', CAST(N'05:00:00' AS Time), CAST(N'15:17:00' AS Time), 16, 1, CAST(N'10:17:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (515, N'IC', CAST(N'05:10:00' AS Time), CAST(N'06:16:00' AS Time), 15, 13, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (516, N'IC', CAST(N'05:10:00' AS Time), CAST(N'06:41:00' AS Time), 15, 12, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (517, N'IC', CAST(N'05:10:00' AS Time), CAST(N'07:36:00' AS Time), 15, 10, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (518, N'IC', CAST(N'05:10:00' AS Time), CAST(N'08:36:00' AS Time), 15, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (519, N'IC', CAST(N'05:10:00' AS Time), CAST(N'09:36:00' AS Time), 15, 8, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (520, N'IC', CAST(N'05:10:00' AS Time), CAST(N'09:59:00' AS Time), 15, 7, CAST(N'04:49:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (521, N'IC', CAST(N'05:10:00' AS Time), CAST(N'10:35:00' AS Time), 15, 6, CAST(N'05:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (522, N'IC', CAST(N'05:10:00' AS Time), CAST(N'10:42:00' AS Time), 15, 5, CAST(N'05:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (523, N'IC', CAST(N'05:10:00' AS Time), CAST(N'10:47:00' AS Time), 15, 4, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (524, N'IC', CAST(N'05:10:00' AS Time), CAST(N'12:02:00' AS Time), 15, 3, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (525, N'IC', CAST(N'05:10:00' AS Time), CAST(N'13:32:00' AS Time), 15, 2, CAST(N'08:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (526, N'IC', CAST(N'05:10:00' AS Time), CAST(N'15:17:00' AS Time), 15, 1, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (527, N'IC', CAST(N'06:16:00' AS Time), CAST(N'06:41:00' AS Time), 13, 12, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (528, N'IC', CAST(N'06:16:00' AS Time), CAST(N'07:36:00' AS Time), 13, 10, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (529, N'IC', CAST(N'06:16:00' AS Time), CAST(N'08:36:00' AS Time), 13, 9, CAST(N'02:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (530, N'IC', CAST(N'06:16:00' AS Time), CAST(N'09:36:00' AS Time), 13, 8, CAST(N'03:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (531, N'IC', CAST(N'06:16:00' AS Time), CAST(N'09:59:00' AS Time), 13, 7, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (532, N'IC', CAST(N'06:16:00' AS Time), CAST(N'10:35:00' AS Time), 13, 6, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (533, N'IC', CAST(N'06:16:00' AS Time), CAST(N'10:42:00' AS Time), 13, 5, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (534, N'IC', CAST(N'06:16:00' AS Time), CAST(N'10:47:00' AS Time), 13, 4, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (535, N'IC', CAST(N'06:16:00' AS Time), CAST(N'12:02:00' AS Time), 13, 3, CAST(N'05:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (536, N'IC', CAST(N'06:16:00' AS Time), CAST(N'13:32:00' AS Time), 13, 2, CAST(N'07:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (537, N'IC', CAST(N'06:16:00' AS Time), CAST(N'15:17:00' AS Time), 13, 1, CAST(N'09:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (538, N'IC', CAST(N'06:41:00' AS Time), CAST(N'07:36:00' AS Time), 12, 10, CAST(N'00:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (539, N'IC', CAST(N'06:41:00' AS Time), CAST(N'08:36:00' AS Time), 12, 9, CAST(N'01:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (540, N'IC', CAST(N'06:41:00' AS Time), CAST(N'09:36:00' AS Time), 12, 8, CAST(N'02:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (541, N'IC', CAST(N'06:41:00' AS Time), CAST(N'09:59:00' AS Time), 12, 7, CAST(N'03:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (542, N'IC', CAST(N'06:41:00' AS Time), CAST(N'10:35:00' AS Time), 12, 6, CAST(N'03:54:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (543, N'IC', CAST(N'06:41:00' AS Time), CAST(N'10:42:00' AS Time), 12, 5, CAST(N'04:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (544, N'IC', CAST(N'06:41:00' AS Time), CAST(N'10:47:00' AS Time), 12, 4, CAST(N'04:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (545, N'IC', CAST(N'06:41:00' AS Time), CAST(N'12:02:00' AS Time), 12, 3, CAST(N'05:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (546, N'IC', CAST(N'06:41:00' AS Time), CAST(N'13:32:00' AS Time), 12, 2, CAST(N'06:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (547, N'IC', CAST(N'06:41:00' AS Time), CAST(N'15:17:00' AS Time), 12, 1, CAST(N'08:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (548, N'IC', CAST(N'07:36:00' AS Time), CAST(N'08:36:00' AS Time), 10, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (549, N'IC', CAST(N'07:36:00' AS Time), CAST(N'09:36:00' AS Time), 10, 8, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (550, N'IC', CAST(N'07:36:00' AS Time), CAST(N'09:59:00' AS Time), 10, 7, CAST(N'02:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (551, N'IC', CAST(N'07:36:00' AS Time), CAST(N'10:35:00' AS Time), 10, 6, CAST(N'02:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (552, N'IC', CAST(N'07:36:00' AS Time), CAST(N'10:42:00' AS Time), 10, 5, CAST(N'03:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (553, N'IC', CAST(N'07:36:00' AS Time), CAST(N'10:47:00' AS Time), 10, 4, CAST(N'03:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (554, N'IC', CAST(N'07:36:00' AS Time), CAST(N'12:02:00' AS Time), 10, 3, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (555, N'IC', CAST(N'07:36:00' AS Time), CAST(N'13:32:00' AS Time), 10, 2, CAST(N'05:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (556, N'IC', CAST(N'07:36:00' AS Time), CAST(N'15:17:00' AS Time), 10, 1, CAST(N'07:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (557, N'IC', CAST(N'08:36:00' AS Time), CAST(N'09:36:00' AS Time), 9, 8, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (558, N'IC', CAST(N'08:36:00' AS Time), CAST(N'09:59:00' AS Time), 9, 7, CAST(N'01:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (559, N'IC', CAST(N'08:36:00' AS Time), CAST(N'10:35:00' AS Time), 9, 6, CAST(N'01:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (560, N'IC', CAST(N'08:36:00' AS Time), CAST(N'10:42:00' AS Time), 9, 5, CAST(N'02:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (561, N'IC', CAST(N'08:36:00' AS Time), CAST(N'10:47:00' AS Time), 9, 4, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (562, N'IC', CAST(N'08:36:00' AS Time), CAST(N'12:02:00' AS Time), 9, 3, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (563, N'IC', CAST(N'08:36:00' AS Time), CAST(N'13:32:00' AS Time), 9, 2, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (564, N'IC', CAST(N'08:36:00' AS Time), CAST(N'15:17:00' AS Time), 9, 1, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (565, N'IC', CAST(N'09:36:00' AS Time), CAST(N'09:59:00' AS Time), 8, 7, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (566, N'IC', CAST(N'09:36:00' AS Time), CAST(N'10:35:00' AS Time), 8, 6, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (567, N'IC', CAST(N'09:36:00' AS Time), CAST(N'10:42:00' AS Time), 8, 5, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (568, N'IC', CAST(N'09:36:00' AS Time), CAST(N'10:47:00' AS Time), 8, 4, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (569, N'IC', CAST(N'09:36:00' AS Time), CAST(N'12:02:00' AS Time), 8, 3, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (570, N'IC', CAST(N'09:36:00' AS Time), CAST(N'13:32:00' AS Time), 8, 2, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (571, N'IC', CAST(N'09:36:00' AS Time), CAST(N'15:17:00' AS Time), 8, 1, CAST(N'05:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (572, N'IC', CAST(N'09:59:00' AS Time), CAST(N'10:35:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (573, N'IC', CAST(N'09:59:00' AS Time), CAST(N'10:42:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (574, N'IC', CAST(N'09:59:00' AS Time), CAST(N'10:47:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (575, N'IC', CAST(N'09:59:00' AS Time), CAST(N'12:02:00' AS Time), 7, 3, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (576, N'IC', CAST(N'09:59:00' AS Time), CAST(N'13:32:00' AS Time), 7, 2, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (577, N'IC', CAST(N'09:59:00' AS Time), CAST(N'15:17:00' AS Time), 7, 1, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (578, N'IC', CAST(N'10:35:00' AS Time), CAST(N'10:42:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (579, N'IC', CAST(N'10:35:00' AS Time), CAST(N'10:47:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (580, N'IC', CAST(N'10:35:00' AS Time), CAST(N'12:02:00' AS Time), 6, 3, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (581, N'IC', CAST(N'10:35:00' AS Time), CAST(N'13:32:00' AS Time), 6, 2, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (582, N'IC', CAST(N'10:35:00' AS Time), CAST(N'15:17:00' AS Time), 6, 1, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (583, N'IC', CAST(N'10:42:00' AS Time), CAST(N'10:47:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (584, N'IC', CAST(N'10:42:00' AS Time), CAST(N'12:02:00' AS Time), 5, 3, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (585, N'IC', CAST(N'10:42:00' AS Time), CAST(N'13:32:00' AS Time), 5, 2, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (586, N'IC', CAST(N'10:42:00' AS Time), CAST(N'15:17:00' AS Time), 5, 1, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (587, N'IC', CAST(N'10:47:00' AS Time), CAST(N'12:02:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (588, N'IC', CAST(N'10:47:00' AS Time), CAST(N'13:32:00' AS Time), 4, 2, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (589, N'IC', CAST(N'10:47:00' AS Time), CAST(N'15:17:00' AS Time), 4, 1, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (590, N'IC', CAST(N'12:02:00' AS Time), CAST(N'13:32:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (591, N'IC', CAST(N'12:02:00' AS Time), CAST(N'15:17:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (592, N'IC', CAST(N'13:32:00' AS Time), CAST(N'15:17:00' AS Time), 2, 1, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (593, N'IC', CAST(N'05:00:00' AS Time), CAST(N'05:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (594, N'IC', CAST(N'05:00:00' AS Time), CAST(N'06:46:00' AS Time), 16, 14, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (595, N'IC', CAST(N'05:00:00' AS Time), CAST(N'08:46:00' AS Time), 16, 11, CAST(N'03:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (596, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:56:00' AS Time), 16, 8, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (597, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:19:00' AS Time), 16, 7, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (598, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:55:00' AS Time), 16, 6, CAST(N'05:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (599, N'IC', CAST(N'05:00:00' AS Time), CAST(N'11:02:00' AS Time), 16, 5, CAST(N'06:02:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (600, N'IC', CAST(N'05:00:00' AS Time), CAST(N'11:07:00' AS Time), 16, 4, CAST(N'06:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (601, N'IC', CAST(N'05:00:00' AS Time), CAST(N'12:22:00' AS Time), 16, 3, CAST(N'07:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (602, N'IC', CAST(N'05:00:00' AS Time), CAST(N'13:52:00' AS Time), 16, 2, CAST(N'08:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (603, N'IC', CAST(N'05:00:00' AS Time), CAST(N'14:37:00' AS Time), 16, 1, CAST(N'09:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (604, N'IC', CAST(N'05:10:00' AS Time), CAST(N'06:46:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (605, N'IC', CAST(N'05:10:00' AS Time), CAST(N'08:46:00' AS Time), 15, 11, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (606, N'IC', CAST(N'05:10:00' AS Time), CAST(N'09:56:00' AS Time), 15, 8, CAST(N'04:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (607, N'IC', CAST(N'05:10:00' AS Time), CAST(N'10:19:00' AS Time), 15, 7, CAST(N'05:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (608, N'IC', CAST(N'05:10:00' AS Time), CAST(N'10:55:00' AS Time), 15, 6, CAST(N'05:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (609, N'IC', CAST(N'05:10:00' AS Time), CAST(N'11:02:00' AS Time), 15, 5, CAST(N'05:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (610, N'IC', CAST(N'05:10:00' AS Time), CAST(N'11:07:00' AS Time), 15, 4, CAST(N'05:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (611, N'IC', CAST(N'05:10:00' AS Time), CAST(N'12:22:00' AS Time), 15, 3, CAST(N'07:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (612, N'IC', CAST(N'05:10:00' AS Time), CAST(N'13:52:00' AS Time), 15, 2, CAST(N'08:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (613, N'IC', CAST(N'05:10:00' AS Time), CAST(N'14:37:00' AS Time), 15, 1, CAST(N'09:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (614, N'IC', CAST(N'06:46:00' AS Time), CAST(N'08:46:00' AS Time), 14, 11, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (615, N'IC', CAST(N'06:46:00' AS Time), CAST(N'09:56:00' AS Time), 14, 8, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (616, N'IC', CAST(N'06:46:00' AS Time), CAST(N'10:19:00' AS Time), 14, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (617, N'IC', CAST(N'06:46:00' AS Time), CAST(N'10:55:00' AS Time), 14, 6, CAST(N'04:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (618, N'IC', CAST(N'06:46:00' AS Time), CAST(N'11:02:00' AS Time), 14, 5, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (619, N'IC', CAST(N'06:46:00' AS Time), CAST(N'11:07:00' AS Time), 14, 4, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (620, N'IC', CAST(N'06:46:00' AS Time), CAST(N'12:22:00' AS Time), 14, 3, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (621, N'IC', CAST(N'06:46:00' AS Time), CAST(N'13:52:00' AS Time), 14, 2, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (622, N'IC', CAST(N'06:46:00' AS Time), CAST(N'14:37:00' AS Time), 14, 1, CAST(N'07:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (623, N'IC', CAST(N'08:46:00' AS Time), CAST(N'09:56:00' AS Time), 11, 8, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (624, N'IC', CAST(N'08:46:00' AS Time), CAST(N'10:19:00' AS Time), 11, 7, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (625, N'IC', CAST(N'08:46:00' AS Time), CAST(N'10:55:00' AS Time), 11, 6, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (626, N'IC', CAST(N'08:46:00' AS Time), CAST(N'11:02:00' AS Time), 11, 5, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (627, N'IC', CAST(N'08:46:00' AS Time), CAST(N'11:07:00' AS Time), 11, 4, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (628, N'IC', CAST(N'08:46:00' AS Time), CAST(N'12:22:00' AS Time), 11, 3, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (629, N'IC', CAST(N'08:46:00' AS Time), CAST(N'13:52:00' AS Time), 11, 2, CAST(N'05:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (630, N'IC', CAST(N'08:46:00' AS Time), CAST(N'14:37:00' AS Time), 11, 1, CAST(N'05:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (631, N'IC', CAST(N'09:56:00' AS Time), CAST(N'10:19:00' AS Time), 8, 7, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (632, N'IC', CAST(N'09:56:00' AS Time), CAST(N'10:55:00' AS Time), 8, 6, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (633, N'IC', CAST(N'09:56:00' AS Time), CAST(N'11:02:00' AS Time), 8, 5, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (634, N'IC', CAST(N'09:56:00' AS Time), CAST(N'11:07:00' AS Time), 8, 4, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (635, N'IC', CAST(N'09:56:00' AS Time), CAST(N'12:22:00' AS Time), 8, 3, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (636, N'IC', CAST(N'09:56:00' AS Time), CAST(N'13:52:00' AS Time), 8, 2, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (637, N'IC', CAST(N'09:56:00' AS Time), CAST(N'14:37:00' AS Time), 8, 1, CAST(N'04:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (638, N'IC', CAST(N'10:19:00' AS Time), CAST(N'10:55:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (639, N'IC', CAST(N'10:19:00' AS Time), CAST(N'11:02:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (640, N'IC', CAST(N'10:19:00' AS Time), CAST(N'11:07:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (641, N'IC', CAST(N'10:19:00' AS Time), CAST(N'12:22:00' AS Time), 7, 3, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (642, N'IC', CAST(N'10:19:00' AS Time), CAST(N'13:52:00' AS Time), 7, 2, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (643, N'IC', CAST(N'10:19:00' AS Time), CAST(N'14:37:00' AS Time), 7, 1, CAST(N'04:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (644, N'IC', CAST(N'10:55:00' AS Time), CAST(N'11:02:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (645, N'IC', CAST(N'10:55:00' AS Time), CAST(N'11:07:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (646, N'IC', CAST(N'10:55:00' AS Time), CAST(N'12:22:00' AS Time), 6, 3, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (647, N'IC', CAST(N'10:55:00' AS Time), CAST(N'13:52:00' AS Time), 6, 2, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (648, N'IC', CAST(N'10:55:00' AS Time), CAST(N'14:37:00' AS Time), 6, 1, CAST(N'03:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (649, N'IC', CAST(N'11:02:00' AS Time), CAST(N'11:07:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (650, N'IC', CAST(N'11:02:00' AS Time), CAST(N'12:22:00' AS Time), 5, 3, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (651, N'IC', CAST(N'11:02:00' AS Time), CAST(N'13:52:00' AS Time), 5, 2, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (652, N'IC', CAST(N'11:02:00' AS Time), CAST(N'14:37:00' AS Time), 5, 1, CAST(N'03:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (653, N'IC', CAST(N'11:07:00' AS Time), CAST(N'12:22:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (654, N'IC', CAST(N'11:07:00' AS Time), CAST(N'13:52:00' AS Time), 4, 2, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (655, N'IC', CAST(N'11:07:00' AS Time), CAST(N'14:37:00' AS Time), 4, 1, CAST(N'03:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (656, N'IC', CAST(N'12:22:00' AS Time), CAST(N'13:52:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (657, N'IC', CAST(N'12:22:00' AS Time), CAST(N'14:37:00' AS Time), 3, 1, CAST(N'02:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (658, N'IC', CAST(N'13:52:00' AS Time), CAST(N'14:37:00' AS Time), 2, 1, CAST(N'00:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (659, N'IC', CAST(N'05:00:00' AS Time), CAST(N'06:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (660, N'IC', CAST(N'05:00:00' AS Time), CAST(N'08:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (661, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (662, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:35:00' AS Time), 1, 5, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (663, N'IC', CAST(N'05:00:00' AS Time), CAST(N'09:42:00' AS Time), 1, 6, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (664, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:18:00' AS Time), 1, 7, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (665, N'IC', CAST(N'05:00:00' AS Time), CAST(N'10:41:00' AS Time), 1, 8, CAST(N'05:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (666, N'IC', CAST(N'05:00:00' AS Time), CAST(N'11:51:00' AS Time), 1, 11, CAST(N'06:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (667, N'IC', CAST(N'05:00:00' AS Time), CAST(N'13:51:00' AS Time), 1, 14, CAST(N'08:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (668, N'IC', CAST(N'05:00:00' AS Time), CAST(N'15:27:00' AS Time), 1, 15, CAST(N'10:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (669, N'IC', CAST(N'05:00:00' AS Time), CAST(N'15:37:00' AS Time), 1, 16, CAST(N'10:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (670, N'IC', CAST(N'06:45:00' AS Time), CAST(N'08:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (671, N'IC', CAST(N'06:45:00' AS Time), CAST(N'09:30:00' AS Time), 2, 4, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (672, N'IC', CAST(N'06:45:00' AS Time), CAST(N'09:35:00' AS Time), 2, 5, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (673, N'IC', CAST(N'06:45:00' AS Time), CAST(N'09:42:00' AS Time), 2, 6, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (674, N'IC', CAST(N'06:45:00' AS Time), CAST(N'10:18:00' AS Time), 2, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (675, N'IC', CAST(N'06:45:00' AS Time), CAST(N'10:41:00' AS Time), 2, 8, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (676, N'IC', CAST(N'06:45:00' AS Time), CAST(N'11:51:00' AS Time), 2, 11, CAST(N'05:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (677, N'IC', CAST(N'06:45:00' AS Time), CAST(N'13:51:00' AS Time), 2, 14, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (678, N'IC', CAST(N'06:45:00' AS Time), CAST(N'15:27:00' AS Time), 2, 15, CAST(N'08:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (679, N'IC', CAST(N'06:45:00' AS Time), CAST(N'15:37:00' AS Time), 2, 16, CAST(N'08:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (680, N'IC', CAST(N'08:15:00' AS Time), CAST(N'09:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (681, N'IC', CAST(N'08:15:00' AS Time), CAST(N'09:35:00' AS Time), 3, 5, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (682, N'IC', CAST(N'08:15:00' AS Time), CAST(N'09:42:00' AS Time), 3, 6, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (683, N'IC', CAST(N'08:15:00' AS Time), CAST(N'10:18:00' AS Time), 3, 7, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (684, N'IC', CAST(N'08:15:00' AS Time), CAST(N'10:41:00' AS Time), 3, 8, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (685, N'IC', CAST(N'08:15:00' AS Time), CAST(N'11:51:00' AS Time), 3, 11, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (686, N'IC', CAST(N'08:15:00' AS Time), CAST(N'13:51:00' AS Time), 3, 14, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (687, N'IC', CAST(N'08:15:00' AS Time), CAST(N'15:27:00' AS Time), 3, 15, CAST(N'07:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (688, N'IC', CAST(N'08:15:00' AS Time), CAST(N'15:37:00' AS Time), 3, 16, CAST(N'07:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (689, N'IC', CAST(N'09:30:00' AS Time), CAST(N'09:35:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (690, N'IC', CAST(N'09:30:00' AS Time), CAST(N'09:42:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (691, N'IC', CAST(N'09:30:00' AS Time), CAST(N'10:18:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (692, N'IC', CAST(N'09:30:00' AS Time), CAST(N'10:41:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (693, N'IC', CAST(N'09:30:00' AS Time), CAST(N'11:51:00' AS Time), 4, 11, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (694, N'IC', CAST(N'09:30:00' AS Time), CAST(N'13:51:00' AS Time), 4, 14, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (695, N'IC', CAST(N'09:30:00' AS Time), CAST(N'15:27:00' AS Time), 4, 15, CAST(N'05:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (696, N'IC', CAST(N'09:30:00' AS Time), CAST(N'15:37:00' AS Time), 4, 16, CAST(N'06:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (697, N'IC', CAST(N'09:35:00' AS Time), CAST(N'09:42:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (698, N'IC', CAST(N'09:35:00' AS Time), CAST(N'10:18:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (699, N'IC', CAST(N'09:35:00' AS Time), CAST(N'10:41:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (700, N'IC', CAST(N'09:35:00' AS Time), CAST(N'11:51:00' AS Time), 5, 11, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (701, N'IC', CAST(N'09:35:00' AS Time), CAST(N'13:51:00' AS Time), 5, 14, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (702, N'IC', CAST(N'09:35:00' AS Time), CAST(N'15:27:00' AS Time), 5, 15, CAST(N'05:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (703, N'IC', CAST(N'09:35:00' AS Time), CAST(N'15:37:00' AS Time), 5, 16, CAST(N'06:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (704, N'IC', CAST(N'09:42:00' AS Time), CAST(N'10:18:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (705, N'IC', CAST(N'09:42:00' AS Time), CAST(N'10:41:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (706, N'IC', CAST(N'09:42:00' AS Time), CAST(N'11:51:00' AS Time), 6, 11, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (707, N'IC', CAST(N'09:42:00' AS Time), CAST(N'13:51:00' AS Time), 6, 14, CAST(N'04:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (708, N'IC', CAST(N'09:42:00' AS Time), CAST(N'15:27:00' AS Time), 6, 15, CAST(N'05:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (709, N'IC', CAST(N'09:42:00' AS Time), CAST(N'15:37:00' AS Time), 6, 16, CAST(N'05:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (710, N'IC', CAST(N'10:18:00' AS Time), CAST(N'10:41:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (711, N'IC', CAST(N'10:18:00' AS Time), CAST(N'11:51:00' AS Time), 7, 11, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (712, N'IC', CAST(N'10:18:00' AS Time), CAST(N'13:51:00' AS Time), 7, 14, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (713, N'IC', CAST(N'10:18:00' AS Time), CAST(N'15:27:00' AS Time), 7, 15, CAST(N'05:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (714, N'IC', CAST(N'10:18:00' AS Time), CAST(N'15:37:00' AS Time), 7, 16, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (715, N'IC', CAST(N'10:41:00' AS Time), CAST(N'11:51:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (716, N'IC', CAST(N'10:41:00' AS Time), CAST(N'13:51:00' AS Time), 8, 14, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (717, N'IC', CAST(N'10:41:00' AS Time), CAST(N'15:27:00' AS Time), 8, 15, CAST(N'04:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (718, N'IC', CAST(N'10:41:00' AS Time), CAST(N'15:37:00' AS Time), 8, 16, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (719, N'IC', CAST(N'11:51:00' AS Time), CAST(N'13:51:00' AS Time), 11, 14, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (720, N'IC', CAST(N'11:51:00' AS Time), CAST(N'15:27:00' AS Time), 11, 15, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (721, N'IC', CAST(N'11:51:00' AS Time), CAST(N'15:37:00' AS Time), 11, 16, CAST(N'03:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (722, N'IC', CAST(N'13:51:00' AS Time), CAST(N'15:27:00' AS Time), 14, 15, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (723, N'IC', CAST(N'13:51:00' AS Time), CAST(N'15:37:00' AS Time), 14, 16, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (724, N'IC', CAST(N'15:27:00' AS Time), CAST(N'15:37:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (725, N'IC', CAST(N'10:00:00' AS Time), CAST(N'11:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (726, N'IC', CAST(N'10:00:00' AS Time), CAST(N'13:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (727, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (728, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:35:00' AS Time), 1, 5, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (729, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:42:00' AS Time), 1, 6, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (730, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:18:00' AS Time), 1, 7, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (731, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:41:00' AS Time), 1, 8, CAST(N'05:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (732, N'IC', CAST(N'10:00:00' AS Time), CAST(N'16:41:00' AS Time), 1, 9, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (733, N'IC', CAST(N'10:00:00' AS Time), CAST(N'17:41:00' AS Time), 1, 10, CAST(N'07:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (734, N'IC', CAST(N'10:00:00' AS Time), CAST(N'18:26:00' AS Time), 1, 12, CAST(N'08:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (735, N'IC', CAST(N'10:00:00' AS Time), CAST(N'18:51:00' AS Time), 1, 13, CAST(N'08:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (736, N'IC', CAST(N'10:00:00' AS Time), CAST(N'19:57:00' AS Time), 1, 15, CAST(N'09:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (737, N'IC', CAST(N'10:00:00' AS Time), CAST(N'20:07:00' AS Time), 1, 16, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (738, N'IC', CAST(N'11:45:00' AS Time), CAST(N'13:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (739, N'IC', CAST(N'11:45:00' AS Time), CAST(N'14:30:00' AS Time), 2, 4, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (740, N'IC', CAST(N'11:45:00' AS Time), CAST(N'14:35:00' AS Time), 2, 5, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (741, N'IC', CAST(N'11:45:00' AS Time), CAST(N'14:42:00' AS Time), 2, 6, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (742, N'IC', CAST(N'11:45:00' AS Time), CAST(N'15:18:00' AS Time), 2, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (743, N'IC', CAST(N'11:45:00' AS Time), CAST(N'15:41:00' AS Time), 2, 8, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (744, N'IC', CAST(N'11:45:00' AS Time), CAST(N'16:41:00' AS Time), 2, 9, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (745, N'IC', CAST(N'11:45:00' AS Time), CAST(N'17:41:00' AS Time), 2, 10, CAST(N'05:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (746, N'IC', CAST(N'11:45:00' AS Time), CAST(N'18:26:00' AS Time), 2, 12, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (747, N'IC', CAST(N'11:45:00' AS Time), CAST(N'18:51:00' AS Time), 2, 13, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (748, N'IC', CAST(N'11:45:00' AS Time), CAST(N'19:57:00' AS Time), 2, 15, CAST(N'08:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (749, N'IC', CAST(N'11:45:00' AS Time), CAST(N'20:07:00' AS Time), 2, 16, CAST(N'08:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (750, N'IC', CAST(N'13:15:00' AS Time), CAST(N'14:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (751, N'IC', CAST(N'13:15:00' AS Time), CAST(N'14:35:00' AS Time), 3, 5, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (752, N'IC', CAST(N'13:15:00' AS Time), CAST(N'14:42:00' AS Time), 3, 6, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (753, N'IC', CAST(N'13:15:00' AS Time), CAST(N'15:18:00' AS Time), 3, 7, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (754, N'IC', CAST(N'13:15:00' AS Time), CAST(N'15:41:00' AS Time), 3, 8, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (755, N'IC', CAST(N'13:15:00' AS Time), CAST(N'16:41:00' AS Time), 3, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (756, N'IC', CAST(N'13:15:00' AS Time), CAST(N'17:41:00' AS Time), 3, 10, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (757, N'IC', CAST(N'13:15:00' AS Time), CAST(N'18:26:00' AS Time), 3, 12, CAST(N'05:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (758, N'IC', CAST(N'13:15:00' AS Time), CAST(N'18:51:00' AS Time), 3, 13, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (759, N'IC', CAST(N'13:15:00' AS Time), CAST(N'19:57:00' AS Time), 3, 15, CAST(N'06:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (760, N'IC', CAST(N'13:15:00' AS Time), CAST(N'20:07:00' AS Time), 3, 16, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (761, N'IC', CAST(N'14:30:00' AS Time), CAST(N'14:35:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (762, N'IC', CAST(N'14:30:00' AS Time), CAST(N'14:42:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (763, N'IC', CAST(N'14:30:00' AS Time), CAST(N'15:18:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (764, N'IC', CAST(N'14:30:00' AS Time), CAST(N'15:41:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (765, N'IC', CAST(N'14:30:00' AS Time), CAST(N'16:41:00' AS Time), 4, 9, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (766, N'IC', CAST(N'14:30:00' AS Time), CAST(N'17:41:00' AS Time), 4, 10, CAST(N'03:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (767, N'IC', CAST(N'14:30:00' AS Time), CAST(N'18:26:00' AS Time), 4, 12, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (768, N'IC', CAST(N'14:30:00' AS Time), CAST(N'18:51:00' AS Time), 4, 13, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (769, N'IC', CAST(N'14:30:00' AS Time), CAST(N'19:57:00' AS Time), 4, 15, CAST(N'05:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (770, N'IC', CAST(N'14:30:00' AS Time), CAST(N'20:07:00' AS Time), 4, 16, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (771, N'IC', CAST(N'14:35:00' AS Time), CAST(N'14:42:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (772, N'IC', CAST(N'14:35:00' AS Time), CAST(N'15:18:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (773, N'IC', CAST(N'14:35:00' AS Time), CAST(N'15:41:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (774, N'IC', CAST(N'14:35:00' AS Time), CAST(N'16:41:00' AS Time), 5, 9, CAST(N'02:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (775, N'IC', CAST(N'14:35:00' AS Time), CAST(N'17:41:00' AS Time), 5, 10, CAST(N'03:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (776, N'IC', CAST(N'14:35:00' AS Time), CAST(N'18:26:00' AS Time), 5, 12, CAST(N'03:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (777, N'IC', CAST(N'14:35:00' AS Time), CAST(N'18:51:00' AS Time), 5, 13, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (778, N'IC', CAST(N'14:35:00' AS Time), CAST(N'19:57:00' AS Time), 5, 15, CAST(N'05:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (779, N'IC', CAST(N'14:35:00' AS Time), CAST(N'20:07:00' AS Time), 5, 16, CAST(N'05:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (780, N'IC', CAST(N'14:42:00' AS Time), CAST(N'15:18:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (781, N'IC', CAST(N'14:42:00' AS Time), CAST(N'15:41:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (782, N'IC', CAST(N'14:42:00' AS Time), CAST(N'16:41:00' AS Time), 6, 9, CAST(N'01:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (783, N'IC', CAST(N'14:42:00' AS Time), CAST(N'17:41:00' AS Time), 6, 10, CAST(N'02:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (784, N'IC', CAST(N'14:42:00' AS Time), CAST(N'18:26:00' AS Time), 6, 12, CAST(N'03:44:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (785, N'IC', CAST(N'14:42:00' AS Time), CAST(N'18:51:00' AS Time), 6, 13, CAST(N'04:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (786, N'IC', CAST(N'14:42:00' AS Time), CAST(N'19:57:00' AS Time), 6, 15, CAST(N'05:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (787, N'IC', CAST(N'14:42:00' AS Time), CAST(N'20:07:00' AS Time), 6, 16, CAST(N'05:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (788, N'IC', CAST(N'15:18:00' AS Time), CAST(N'15:41:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (789, N'IC', CAST(N'15:18:00' AS Time), CAST(N'16:41:00' AS Time), 7, 9, CAST(N'01:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (790, N'IC', CAST(N'15:18:00' AS Time), CAST(N'17:41:00' AS Time), 7, 10, CAST(N'02:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (791, N'IC', CAST(N'15:18:00' AS Time), CAST(N'18:26:00' AS Time), 7, 12, CAST(N'03:08:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (792, N'IC', CAST(N'15:18:00' AS Time), CAST(N'18:51:00' AS Time), 7, 13, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (793, N'IC', CAST(N'15:18:00' AS Time), CAST(N'19:57:00' AS Time), 7, 15, CAST(N'04:39:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (794, N'IC', CAST(N'15:18:00' AS Time), CAST(N'20:07:00' AS Time), 7, 16, CAST(N'04:49:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (795, N'IC', CAST(N'15:41:00' AS Time), CAST(N'16:41:00' AS Time), 8, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (796, N'IC', CAST(N'15:41:00' AS Time), CAST(N'17:41:00' AS Time), 8, 10, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (797, N'IC', CAST(N'15:41:00' AS Time), CAST(N'18:26:00' AS Time), 8, 12, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (798, N'IC', CAST(N'15:41:00' AS Time), CAST(N'18:51:00' AS Time), 8, 13, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (799, N'IC', CAST(N'15:41:00' AS Time), CAST(N'19:57:00' AS Time), 8, 15, CAST(N'04:16:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (800, N'IC', CAST(N'15:41:00' AS Time), CAST(N'20:07:00' AS Time), 8, 16, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (801, N'IC', CAST(N'16:41:00' AS Time), CAST(N'17:41:00' AS Time), 9, 10, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (802, N'IC', CAST(N'16:41:00' AS Time), CAST(N'18:26:00' AS Time), 9, 12, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (803, N'IC', CAST(N'16:41:00' AS Time), CAST(N'18:51:00' AS Time), 9, 13, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (804, N'IC', CAST(N'16:41:00' AS Time), CAST(N'19:57:00' AS Time), 9, 15, CAST(N'03:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (805, N'IC', CAST(N'16:41:00' AS Time), CAST(N'20:07:00' AS Time), 9, 16, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (806, N'IC', CAST(N'17:41:00' AS Time), CAST(N'18:26:00' AS Time), 10, 12, CAST(N'00:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (807, N'IC', CAST(N'17:41:00' AS Time), CAST(N'18:51:00' AS Time), 10, 13, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (808, N'IC', CAST(N'17:41:00' AS Time), CAST(N'19:57:00' AS Time), 10, 15, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (809, N'IC', CAST(N'17:41:00' AS Time), CAST(N'20:07:00' AS Time), 10, 16, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (810, N'IC', CAST(N'18:26:00' AS Time), CAST(N'18:51:00' AS Time), 12, 13, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (811, N'IC', CAST(N'18:26:00' AS Time), CAST(N'19:57:00' AS Time), 12, 15, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (812, N'IC', CAST(N'18:26:00' AS Time), CAST(N'20:07:00' AS Time), 12, 16, CAST(N'01:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (813, N'IC', CAST(N'18:51:00' AS Time), CAST(N'19:57:00' AS Time), 13, 15, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (814, N'IC', CAST(N'18:51:00' AS Time), CAST(N'20:07:00' AS Time), 13, 16, CAST(N'01:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (815, N'IC', CAST(N'19:57:00' AS Time), CAST(N'20:07:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (816, N'IC', CAST(N'10:00:00' AS Time), CAST(N'10:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (817, N'IC', CAST(N'10:00:00' AS Time), CAST(N'11:16:00' AS Time), 16, 13, CAST(N'01:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (818, N'IC', CAST(N'10:00:00' AS Time), CAST(N'11:41:00' AS Time), 16, 12, CAST(N'01:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (819, N'IC', CAST(N'10:00:00' AS Time), CAST(N'12:36:00' AS Time), 16, 10, CAST(N'02:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (820, N'IC', CAST(N'10:00:00' AS Time), CAST(N'13:36:00' AS Time), 16, 9, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (821, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:36:00' AS Time), 16, 8, CAST(N'04:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (822, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:59:00' AS Time), 16, 7, CAST(N'04:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (823, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:35:00' AS Time), 16, 6, CAST(N'05:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (824, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:42:00' AS Time), 16, 5, CAST(N'05:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (825, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:47:00' AS Time), 16, 4, CAST(N'05:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (826, N'IC', CAST(N'10:00:00' AS Time), CAST(N'17:02:00' AS Time), 16, 3, CAST(N'07:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (827, N'IC', CAST(N'10:00:00' AS Time), CAST(N'18:32:00' AS Time), 16, 2, CAST(N'08:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (828, N'IC', CAST(N'10:00:00' AS Time), CAST(N'20:17:00' AS Time), 16, 1, CAST(N'10:17:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (829, N'IC', CAST(N'10:10:00' AS Time), CAST(N'11:16:00' AS Time), 15, 13, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (830, N'IC', CAST(N'10:10:00' AS Time), CAST(N'11:41:00' AS Time), 15, 12, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (831, N'IC', CAST(N'10:10:00' AS Time), CAST(N'12:36:00' AS Time), 15, 10, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (832, N'IC', CAST(N'10:10:00' AS Time), CAST(N'13:36:00' AS Time), 15, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (833, N'IC', CAST(N'10:10:00' AS Time), CAST(N'14:36:00' AS Time), 15, 8, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (834, N'IC', CAST(N'10:10:00' AS Time), CAST(N'14:59:00' AS Time), 15, 7, CAST(N'04:49:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (835, N'IC', CAST(N'10:10:00' AS Time), CAST(N'15:35:00' AS Time), 15, 6, CAST(N'05:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (836, N'IC', CAST(N'10:10:00' AS Time), CAST(N'15:42:00' AS Time), 15, 5, CAST(N'05:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (837, N'IC', CAST(N'10:10:00' AS Time), CAST(N'15:47:00' AS Time), 15, 4, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (838, N'IC', CAST(N'10:10:00' AS Time), CAST(N'17:02:00' AS Time), 15, 3, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (839, N'IC', CAST(N'10:10:00' AS Time), CAST(N'18:32:00' AS Time), 15, 2, CAST(N'08:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (840, N'IC', CAST(N'10:10:00' AS Time), CAST(N'20:17:00' AS Time), 15, 1, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (841, N'IC', CAST(N'11:16:00' AS Time), CAST(N'11:41:00' AS Time), 13, 12, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (842, N'IC', CAST(N'11:16:00' AS Time), CAST(N'12:36:00' AS Time), 13, 10, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (843, N'IC', CAST(N'11:16:00' AS Time), CAST(N'13:36:00' AS Time), 13, 9, CAST(N'02:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (844, N'IC', CAST(N'11:16:00' AS Time), CAST(N'14:36:00' AS Time), 13, 8, CAST(N'03:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (845, N'IC', CAST(N'11:16:00' AS Time), CAST(N'14:59:00' AS Time), 13, 7, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (846, N'IC', CAST(N'11:16:00' AS Time), CAST(N'15:35:00' AS Time), 13, 6, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (847, N'IC', CAST(N'11:16:00' AS Time), CAST(N'15:42:00' AS Time), 13, 5, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (848, N'IC', CAST(N'11:16:00' AS Time), CAST(N'15:47:00' AS Time), 13, 4, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (849, N'IC', CAST(N'11:16:00' AS Time), CAST(N'17:02:00' AS Time), 13, 3, CAST(N'05:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (850, N'IC', CAST(N'11:16:00' AS Time), CAST(N'18:32:00' AS Time), 13, 2, CAST(N'07:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (851, N'IC', CAST(N'11:16:00' AS Time), CAST(N'20:17:00' AS Time), 13, 1, CAST(N'09:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (852, N'IC', CAST(N'11:41:00' AS Time), CAST(N'12:36:00' AS Time), 12, 10, CAST(N'00:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (853, N'IC', CAST(N'11:41:00' AS Time), CAST(N'13:36:00' AS Time), 12, 9, CAST(N'01:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (854, N'IC', CAST(N'11:41:00' AS Time), CAST(N'14:36:00' AS Time), 12, 8, CAST(N'02:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (855, N'IC', CAST(N'11:41:00' AS Time), CAST(N'14:59:00' AS Time), 12, 7, CAST(N'03:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (856, N'IC', CAST(N'11:41:00' AS Time), CAST(N'15:35:00' AS Time), 12, 6, CAST(N'03:54:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (857, N'IC', CAST(N'11:41:00' AS Time), CAST(N'15:42:00' AS Time), 12, 5, CAST(N'04:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (858, N'IC', CAST(N'11:41:00' AS Time), CAST(N'15:47:00' AS Time), 12, 4, CAST(N'04:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (859, N'IC', CAST(N'11:41:00' AS Time), CAST(N'17:02:00' AS Time), 12, 3, CAST(N'05:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (860, N'IC', CAST(N'11:41:00' AS Time), CAST(N'18:32:00' AS Time), 12, 2, CAST(N'06:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (861, N'IC', CAST(N'11:41:00' AS Time), CAST(N'20:17:00' AS Time), 12, 1, CAST(N'08:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (862, N'IC', CAST(N'12:36:00' AS Time), CAST(N'13:36:00' AS Time), 10, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (863, N'IC', CAST(N'12:36:00' AS Time), CAST(N'14:36:00' AS Time), 10, 8, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (864, N'IC', CAST(N'12:36:00' AS Time), CAST(N'14:59:00' AS Time), 10, 7, CAST(N'02:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (865, N'IC', CAST(N'12:36:00' AS Time), CAST(N'15:35:00' AS Time), 10, 6, CAST(N'02:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (866, N'IC', CAST(N'12:36:00' AS Time), CAST(N'15:42:00' AS Time), 10, 5, CAST(N'03:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (867, N'IC', CAST(N'12:36:00' AS Time), CAST(N'15:47:00' AS Time), 10, 4, CAST(N'03:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (868, N'IC', CAST(N'12:36:00' AS Time), CAST(N'17:02:00' AS Time), 10, 3, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (869, N'IC', CAST(N'12:36:00' AS Time), CAST(N'18:32:00' AS Time), 10, 2, CAST(N'05:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (870, N'IC', CAST(N'12:36:00' AS Time), CAST(N'20:17:00' AS Time), 10, 1, CAST(N'07:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (871, N'IC', CAST(N'13:36:00' AS Time), CAST(N'14:36:00' AS Time), 9, 8, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (872, N'IC', CAST(N'13:36:00' AS Time), CAST(N'14:59:00' AS Time), 9, 7, CAST(N'01:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (873, N'IC', CAST(N'13:36:00' AS Time), CAST(N'15:35:00' AS Time), 9, 6, CAST(N'01:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (874, N'IC', CAST(N'13:36:00' AS Time), CAST(N'15:42:00' AS Time), 9, 5, CAST(N'02:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (875, N'IC', CAST(N'13:36:00' AS Time), CAST(N'15:47:00' AS Time), 9, 4, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (876, N'IC', CAST(N'13:36:00' AS Time), CAST(N'17:02:00' AS Time), 9, 3, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (877, N'IC', CAST(N'13:36:00' AS Time), CAST(N'18:32:00' AS Time), 9, 2, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (878, N'IC', CAST(N'13:36:00' AS Time), CAST(N'20:17:00' AS Time), 9, 1, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (879, N'IC', CAST(N'14:36:00' AS Time), CAST(N'14:59:00' AS Time), 8, 7, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (880, N'IC', CAST(N'14:36:00' AS Time), CAST(N'15:35:00' AS Time), 8, 6, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (881, N'IC', CAST(N'14:36:00' AS Time), CAST(N'15:42:00' AS Time), 8, 5, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (882, N'IC', CAST(N'14:36:00' AS Time), CAST(N'15:47:00' AS Time), 8, 4, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (883, N'IC', CAST(N'14:36:00' AS Time), CAST(N'17:02:00' AS Time), 8, 3, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (884, N'IC', CAST(N'14:36:00' AS Time), CAST(N'18:32:00' AS Time), 8, 2, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (885, N'IC', CAST(N'14:36:00' AS Time), CAST(N'20:17:00' AS Time), 8, 1, CAST(N'05:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (886, N'IC', CAST(N'14:59:00' AS Time), CAST(N'15:35:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (887, N'IC', CAST(N'14:59:00' AS Time), CAST(N'15:42:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (888, N'IC', CAST(N'14:59:00' AS Time), CAST(N'15:47:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (889, N'IC', CAST(N'14:59:00' AS Time), CAST(N'17:02:00' AS Time), 7, 3, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (890, N'IC', CAST(N'14:59:00' AS Time), CAST(N'18:32:00' AS Time), 7, 2, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (891, N'IC', CAST(N'14:59:00' AS Time), CAST(N'20:17:00' AS Time), 7, 1, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (892, N'IC', CAST(N'15:35:00' AS Time), CAST(N'15:42:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (893, N'IC', CAST(N'15:35:00' AS Time), CAST(N'15:47:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (894, N'IC', CAST(N'15:35:00' AS Time), CAST(N'17:02:00' AS Time), 6, 3, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (895, N'IC', CAST(N'15:35:00' AS Time), CAST(N'18:32:00' AS Time), 6, 2, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (896, N'IC', CAST(N'15:35:00' AS Time), CAST(N'20:17:00' AS Time), 6, 1, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (897, N'IC', CAST(N'15:42:00' AS Time), CAST(N'15:47:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (898, N'IC', CAST(N'15:42:00' AS Time), CAST(N'17:02:00' AS Time), 5, 3, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (899, N'IC', CAST(N'15:42:00' AS Time), CAST(N'18:32:00' AS Time), 5, 2, CAST(N'02:50:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (900, N'IC', CAST(N'15:42:00' AS Time), CAST(N'20:17:00' AS Time), 5, 1, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (901, N'IC', CAST(N'15:47:00' AS Time), CAST(N'17:02:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (902, N'IC', CAST(N'15:47:00' AS Time), CAST(N'18:32:00' AS Time), 4, 2, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (903, N'IC', CAST(N'15:47:00' AS Time), CAST(N'20:17:00' AS Time), 4, 1, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (904, N'IC', CAST(N'17:02:00' AS Time), CAST(N'18:32:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (905, N'IC', CAST(N'17:02:00' AS Time), CAST(N'20:17:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (906, N'IC', CAST(N'18:32:00' AS Time), CAST(N'20:17:00' AS Time), 2, 1, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (907, N'IC', CAST(N'10:00:00' AS Time), CAST(N'10:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (908, N'IC', CAST(N'10:00:00' AS Time), CAST(N'11:46:00' AS Time), 16, 14, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (909, N'IC', CAST(N'10:00:00' AS Time), CAST(N'13:46:00' AS Time), 16, 11, CAST(N'03:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (910, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:56:00' AS Time), 16, 8, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (911, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:19:00' AS Time), 16, 7, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (912, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:55:00' AS Time), 16, 6, CAST(N'05:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (913, N'IC', CAST(N'10:00:00' AS Time), CAST(N'16:02:00' AS Time), 16, 5, CAST(N'06:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (914, N'IC', CAST(N'10:00:00' AS Time), CAST(N'16:07:00' AS Time), 16, 4, CAST(N'06:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (915, N'IC', CAST(N'10:00:00' AS Time), CAST(N'17:22:00' AS Time), 16, 3, CAST(N'07:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (916, N'IC', CAST(N'10:00:00' AS Time), CAST(N'18:52:00' AS Time), 16, 2, CAST(N'08:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (917, N'IC', CAST(N'10:00:00' AS Time), CAST(N'19:37:00' AS Time), 16, 1, CAST(N'09:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (918, N'IC', CAST(N'10:10:00' AS Time), CAST(N'11:46:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (919, N'IC', CAST(N'10:10:00' AS Time), CAST(N'13:46:00' AS Time), 15, 11, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (920, N'IC', CAST(N'10:10:00' AS Time), CAST(N'14:56:00' AS Time), 15, 8, CAST(N'04:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (921, N'IC', CAST(N'10:10:00' AS Time), CAST(N'15:19:00' AS Time), 15, 7, CAST(N'05:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (922, N'IC', CAST(N'10:10:00' AS Time), CAST(N'15:55:00' AS Time), 15, 6, CAST(N'05:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (923, N'IC', CAST(N'10:10:00' AS Time), CAST(N'16:02:00' AS Time), 15, 5, CAST(N'05:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (924, N'IC', CAST(N'10:10:00' AS Time), CAST(N'16:07:00' AS Time), 15, 4, CAST(N'05:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (925, N'IC', CAST(N'10:10:00' AS Time), CAST(N'17:22:00' AS Time), 15, 3, CAST(N'07:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (926, N'IC', CAST(N'10:10:00' AS Time), CAST(N'18:52:00' AS Time), 15, 2, CAST(N'08:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (927, N'IC', CAST(N'10:10:00' AS Time), CAST(N'19:37:00' AS Time), 15, 1, CAST(N'09:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (928, N'IC', CAST(N'11:46:00' AS Time), CAST(N'13:46:00' AS Time), 14, 11, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (929, N'IC', CAST(N'11:46:00' AS Time), CAST(N'14:56:00' AS Time), 14, 8, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (930, N'IC', CAST(N'11:46:00' AS Time), CAST(N'15:19:00' AS Time), 14, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (931, N'IC', CAST(N'11:46:00' AS Time), CAST(N'15:55:00' AS Time), 14, 6, CAST(N'04:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (932, N'IC', CAST(N'11:46:00' AS Time), CAST(N'16:02:00' AS Time), 14, 5, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (933, N'IC', CAST(N'11:46:00' AS Time), CAST(N'16:07:00' AS Time), 14, 4, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (934, N'IC', CAST(N'11:46:00' AS Time), CAST(N'17:22:00' AS Time), 14, 3, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (935, N'IC', CAST(N'11:46:00' AS Time), CAST(N'18:52:00' AS Time), 14, 2, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (936, N'IC', CAST(N'11:46:00' AS Time), CAST(N'19:37:00' AS Time), 14, 1, CAST(N'07:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (937, N'IC', CAST(N'13:46:00' AS Time), CAST(N'14:56:00' AS Time), 11, 8, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (938, N'IC', CAST(N'13:46:00' AS Time), CAST(N'15:19:00' AS Time), 11, 7, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (939, N'IC', CAST(N'13:46:00' AS Time), CAST(N'15:55:00' AS Time), 11, 6, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (940, N'IC', CAST(N'13:46:00' AS Time), CAST(N'16:02:00' AS Time), 11, 5, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (941, N'IC', CAST(N'13:46:00' AS Time), CAST(N'16:07:00' AS Time), 11, 4, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (942, N'IC', CAST(N'13:46:00' AS Time), CAST(N'17:22:00' AS Time), 11, 3, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (943, N'IC', CAST(N'13:46:00' AS Time), CAST(N'18:52:00' AS Time), 11, 2, CAST(N'05:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (944, N'IC', CAST(N'13:46:00' AS Time), CAST(N'19:37:00' AS Time), 11, 1, CAST(N'05:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (945, N'IC', CAST(N'14:56:00' AS Time), CAST(N'15:19:00' AS Time), 8, 7, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (946, N'IC', CAST(N'14:56:00' AS Time), CAST(N'15:55:00' AS Time), 8, 6, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (947, N'IC', CAST(N'14:56:00' AS Time), CAST(N'16:02:00' AS Time), 8, 5, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (948, N'IC', CAST(N'14:56:00' AS Time), CAST(N'16:07:00' AS Time), 8, 4, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (949, N'IC', CAST(N'14:56:00' AS Time), CAST(N'17:22:00' AS Time), 8, 3, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (950, N'IC', CAST(N'14:56:00' AS Time), CAST(N'18:52:00' AS Time), 8, 2, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (951, N'IC', CAST(N'14:56:00' AS Time), CAST(N'19:37:00' AS Time), 8, 1, CAST(N'04:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (952, N'IC', CAST(N'15:19:00' AS Time), CAST(N'15:55:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (953, N'IC', CAST(N'15:19:00' AS Time), CAST(N'16:02:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (954, N'IC', CAST(N'15:19:00' AS Time), CAST(N'16:07:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (955, N'IC', CAST(N'15:19:00' AS Time), CAST(N'17:22:00' AS Time), 7, 3, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (956, N'IC', CAST(N'15:19:00' AS Time), CAST(N'18:52:00' AS Time), 7, 2, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (957, N'IC', CAST(N'15:19:00' AS Time), CAST(N'19:37:00' AS Time), 7, 1, CAST(N'04:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (958, N'IC', CAST(N'15:55:00' AS Time), CAST(N'16:02:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (959, N'IC', CAST(N'15:55:00' AS Time), CAST(N'16:07:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (960, N'IC', CAST(N'15:55:00' AS Time), CAST(N'17:22:00' AS Time), 6, 3, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (961, N'IC', CAST(N'15:55:00' AS Time), CAST(N'18:52:00' AS Time), 6, 2, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (962, N'IC', CAST(N'15:55:00' AS Time), CAST(N'19:37:00' AS Time), 6, 1, CAST(N'03:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (963, N'IC', CAST(N'16:02:00' AS Time), CAST(N'16:07:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (964, N'IC', CAST(N'16:02:00' AS Time), CAST(N'17:22:00' AS Time), 5, 3, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (965, N'IC', CAST(N'16:02:00' AS Time), CAST(N'18:52:00' AS Time), 5, 2, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (966, N'IC', CAST(N'16:02:00' AS Time), CAST(N'19:37:00' AS Time), 5, 1, CAST(N'03:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (967, N'IC', CAST(N'16:07:00' AS Time), CAST(N'17:22:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (968, N'IC', CAST(N'16:07:00' AS Time), CAST(N'18:52:00' AS Time), 4, 2, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (969, N'IC', CAST(N'16:07:00' AS Time), CAST(N'19:37:00' AS Time), 4, 1, CAST(N'03:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (970, N'IC', CAST(N'17:22:00' AS Time), CAST(N'18:52:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (971, N'IC', CAST(N'17:22:00' AS Time), CAST(N'19:37:00' AS Time), 3, 1, CAST(N'02:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (972, N'IC', CAST(N'18:52:00' AS Time), CAST(N'19:37:00' AS Time), 2, 1, CAST(N'00:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (973, N'IC', CAST(N'10:00:00' AS Time), CAST(N'11:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (974, N'IC', CAST(N'10:00:00' AS Time), CAST(N'13:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (975, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (976, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:35:00' AS Time), 1, 5, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (977, N'IC', CAST(N'10:00:00' AS Time), CAST(N'14:42:00' AS Time), 1, 6, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (978, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:18:00' AS Time), 1, 7, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (979, N'IC', CAST(N'10:00:00' AS Time), CAST(N'15:41:00' AS Time), 1, 8, CAST(N'05:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (980, N'IC', CAST(N'10:00:00' AS Time), CAST(N'16:51:00' AS Time), 1, 11, CAST(N'06:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (981, N'IC', CAST(N'10:00:00' AS Time), CAST(N'18:51:00' AS Time), 1, 14, CAST(N'08:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (982, N'IC', CAST(N'10:00:00' AS Time), CAST(N'20:27:00' AS Time), 1, 15, CAST(N'10:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (983, N'IC', CAST(N'10:00:00' AS Time), CAST(N'20:37:00' AS Time), 1, 16, CAST(N'10:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (984, N'IC', CAST(N'11:45:00' AS Time), CAST(N'13:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (985, N'IC', CAST(N'11:45:00' AS Time), CAST(N'14:30:00' AS Time), 2, 4, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (986, N'IC', CAST(N'11:45:00' AS Time), CAST(N'14:35:00' AS Time), 2, 5, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (987, N'IC', CAST(N'11:45:00' AS Time), CAST(N'14:42:00' AS Time), 2, 6, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (988, N'IC', CAST(N'11:45:00' AS Time), CAST(N'15:18:00' AS Time), 2, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (989, N'IC', CAST(N'11:45:00' AS Time), CAST(N'15:41:00' AS Time), 2, 8, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (990, N'IC', CAST(N'11:45:00' AS Time), CAST(N'16:51:00' AS Time), 2, 11, CAST(N'05:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (991, N'IC', CAST(N'11:45:00' AS Time), CAST(N'18:51:00' AS Time), 2, 14, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (992, N'IC', CAST(N'11:45:00' AS Time), CAST(N'20:27:00' AS Time), 2, 15, CAST(N'08:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (993, N'IC', CAST(N'11:45:00' AS Time), CAST(N'20:37:00' AS Time), 2, 16, CAST(N'08:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (994, N'IC', CAST(N'13:15:00' AS Time), CAST(N'14:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (995, N'IC', CAST(N'13:15:00' AS Time), CAST(N'14:35:00' AS Time), 3, 5, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (996, N'IC', CAST(N'13:15:00' AS Time), CAST(N'14:42:00' AS Time), 3, 6, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (997, N'IC', CAST(N'13:15:00' AS Time), CAST(N'15:18:00' AS Time), 3, 7, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (998, N'IC', CAST(N'13:15:00' AS Time), CAST(N'15:41:00' AS Time), 3, 8, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (999, N'IC', CAST(N'13:15:00' AS Time), CAST(N'16:51:00' AS Time), 3, 11, CAST(N'03:36:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1000, N'IC', CAST(N'13:15:00' AS Time), CAST(N'18:51:00' AS Time), 3, 14, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1001, N'IC', CAST(N'13:15:00' AS Time), CAST(N'20:27:00' AS Time), 3, 15, CAST(N'07:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1002, N'IC', CAST(N'13:15:00' AS Time), CAST(N'20:37:00' AS Time), 3, 16, CAST(N'07:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1003, N'IC', CAST(N'14:30:00' AS Time), CAST(N'14:35:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1004, N'IC', CAST(N'14:30:00' AS Time), CAST(N'14:42:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1005, N'IC', CAST(N'14:30:00' AS Time), CAST(N'15:18:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1006, N'IC', CAST(N'14:30:00' AS Time), CAST(N'15:41:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1007, N'IC', CAST(N'14:30:00' AS Time), CAST(N'16:51:00' AS Time), 4, 11, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1008, N'IC', CAST(N'14:30:00' AS Time), CAST(N'18:51:00' AS Time), 4, 14, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1009, N'IC', CAST(N'14:30:00' AS Time), CAST(N'20:27:00' AS Time), 4, 15, CAST(N'05:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1010, N'IC', CAST(N'14:30:00' AS Time), CAST(N'20:37:00' AS Time), 4, 16, CAST(N'06:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1011, N'IC', CAST(N'14:35:00' AS Time), CAST(N'14:42:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1012, N'IC', CAST(N'14:35:00' AS Time), CAST(N'15:18:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1013, N'IC', CAST(N'14:35:00' AS Time), CAST(N'15:41:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1014, N'IC', CAST(N'14:35:00' AS Time), CAST(N'16:51:00' AS Time), 5, 11, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1015, N'IC', CAST(N'14:35:00' AS Time), CAST(N'18:51:00' AS Time), 5, 14, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1016, N'IC', CAST(N'14:35:00' AS Time), CAST(N'20:27:00' AS Time), 5, 15, CAST(N'05:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1017, N'IC', CAST(N'14:35:00' AS Time), CAST(N'20:37:00' AS Time), 5, 16, CAST(N'06:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1018, N'IC', CAST(N'14:42:00' AS Time), CAST(N'15:18:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1019, N'IC', CAST(N'14:42:00' AS Time), CAST(N'15:41:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1020, N'IC', CAST(N'14:42:00' AS Time), CAST(N'16:51:00' AS Time), 6, 11, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1021, N'IC', CAST(N'14:42:00' AS Time), CAST(N'18:51:00' AS Time), 6, 14, CAST(N'04:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1022, N'IC', CAST(N'14:42:00' AS Time), CAST(N'20:27:00' AS Time), 6, 15, CAST(N'05:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1023, N'IC', CAST(N'14:42:00' AS Time), CAST(N'20:37:00' AS Time), 6, 16, CAST(N'05:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1024, N'IC', CAST(N'15:18:00' AS Time), CAST(N'15:41:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1025, N'IC', CAST(N'15:18:00' AS Time), CAST(N'16:51:00' AS Time), 7, 11, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1026, N'IC', CAST(N'15:18:00' AS Time), CAST(N'18:51:00' AS Time), 7, 14, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1027, N'IC', CAST(N'15:18:00' AS Time), CAST(N'20:27:00' AS Time), 7, 15, CAST(N'05:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1028, N'IC', CAST(N'15:18:00' AS Time), CAST(N'20:37:00' AS Time), 7, 16, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1029, N'IC', CAST(N'15:41:00' AS Time), CAST(N'16:51:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1030, N'IC', CAST(N'15:41:00' AS Time), CAST(N'18:51:00' AS Time), 8, 14, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1031, N'IC', CAST(N'15:41:00' AS Time), CAST(N'20:27:00' AS Time), 8, 15, CAST(N'04:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1032, N'IC', CAST(N'15:41:00' AS Time), CAST(N'20:37:00' AS Time), 8, 16, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1033, N'IC', CAST(N'16:51:00' AS Time), CAST(N'18:51:00' AS Time), 11, 14, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1034, N'IC', CAST(N'16:51:00' AS Time), CAST(N'20:27:00' AS Time), 11, 15, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1035, N'IC', CAST(N'16:51:00' AS Time), CAST(N'20:37:00' AS Time), 11, 16, CAST(N'03:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1036, N'IC', CAST(N'18:51:00' AS Time), CAST(N'20:27:00' AS Time), 14, 15, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1037, N'IC', CAST(N'18:51:00' AS Time), CAST(N'20:37:00' AS Time), 14, 16, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1038, N'IC', CAST(N'20:27:00' AS Time), CAST(N'20:37:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1039, N'IC', CAST(N'15:00:00' AS Time), CAST(N'16:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1040, N'IC', CAST(N'15:00:00' AS Time), CAST(N'18:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1041, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1042, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:35:00' AS Time), 1, 5, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1043, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:42:00' AS Time), 1, 6, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1044, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:18:00' AS Time), 1, 7, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1045, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:41:00' AS Time), 1, 8, CAST(N'05:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1046, N'IC', CAST(N'15:00:00' AS Time), CAST(N'21:41:00' AS Time), 1, 9, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1047, N'IC', CAST(N'15:00:00' AS Time), CAST(N'22:41:00' AS Time), 1, 10, CAST(N'07:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1048, N'IC', CAST(N'15:00:00' AS Time), CAST(N'23:26:00' AS Time), 1, 12, CAST(N'08:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1049, N'IC', CAST(N'15:00:00' AS Time), CAST(N'23:51:00' AS Time), 1, 13, CAST(N'08:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1050, N'IC', CAST(N'15:00:00' AS Time), CAST(N'00:57:00' AS Time), 1, 15, CAST(N'09:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1051, N'IC', CAST(N'15:00:00' AS Time), CAST(N'01:07:00' AS Time), 1, 16, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1052, N'IC', CAST(N'16:45:00' AS Time), CAST(N'18:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1053, N'IC', CAST(N'16:45:00' AS Time), CAST(N'19:30:00' AS Time), 2, 4, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1054, N'IC', CAST(N'16:45:00' AS Time), CAST(N'19:35:00' AS Time), 2, 5, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1055, N'IC', CAST(N'16:45:00' AS Time), CAST(N'19:42:00' AS Time), 2, 6, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1056, N'IC', CAST(N'16:45:00' AS Time), CAST(N'20:18:00' AS Time), 2, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1057, N'IC', CAST(N'16:45:00' AS Time), CAST(N'20:41:00' AS Time), 2, 8, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1058, N'IC', CAST(N'16:45:00' AS Time), CAST(N'21:41:00' AS Time), 2, 9, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1059, N'IC', CAST(N'16:45:00' AS Time), CAST(N'22:41:00' AS Time), 2, 10, CAST(N'05:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1060, N'IC', CAST(N'16:45:00' AS Time), CAST(N'23:26:00' AS Time), 2, 12, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1061, N'IC', CAST(N'16:45:00' AS Time), CAST(N'23:51:00' AS Time), 2, 13, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1062, N'IC', CAST(N'16:45:00' AS Time), CAST(N'00:57:00' AS Time), 2, 15, CAST(N'08:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1063, N'IC', CAST(N'16:45:00' AS Time), CAST(N'01:07:00' AS Time), 2, 16, CAST(N'08:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1064, N'IC', CAST(N'18:15:00' AS Time), CAST(N'19:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1065, N'IC', CAST(N'18:15:00' AS Time), CAST(N'19:35:00' AS Time), 3, 5, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1066, N'IC', CAST(N'18:15:00' AS Time), CAST(N'19:42:00' AS Time), 3, 6, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1067, N'IC', CAST(N'18:15:00' AS Time), CAST(N'20:18:00' AS Time), 3, 7, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1068, N'IC', CAST(N'18:15:00' AS Time), CAST(N'20:41:00' AS Time), 3, 8, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1069, N'IC', CAST(N'18:15:00' AS Time), CAST(N'21:41:00' AS Time), 3, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1070, N'IC', CAST(N'18:15:00' AS Time), CAST(N'22:41:00' AS Time), 3, 10, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1071, N'IC', CAST(N'18:15:00' AS Time), CAST(N'23:26:00' AS Time), 3, 12, CAST(N'05:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1072, N'IC', CAST(N'18:15:00' AS Time), CAST(N'23:51:00' AS Time), 3, 13, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1073, N'IC', CAST(N'18:15:00' AS Time), CAST(N'00:57:00' AS Time), 3, 15, CAST(N'06:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1074, N'IC', CAST(N'18:15:00' AS Time), CAST(N'01:07:00' AS Time), 3, 16, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1075, N'IC', CAST(N'19:30:00' AS Time), CAST(N'19:35:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1076, N'IC', CAST(N'19:30:00' AS Time), CAST(N'19:42:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1077, N'IC', CAST(N'19:30:00' AS Time), CAST(N'20:18:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1078, N'IC', CAST(N'19:30:00' AS Time), CAST(N'20:41:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1079, N'IC', CAST(N'19:30:00' AS Time), CAST(N'21:41:00' AS Time), 4, 9, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1080, N'IC', CAST(N'19:30:00' AS Time), CAST(N'22:41:00' AS Time), 4, 10, CAST(N'03:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1081, N'IC', CAST(N'19:30:00' AS Time), CAST(N'23:26:00' AS Time), 4, 12, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1082, N'IC', CAST(N'19:30:00' AS Time), CAST(N'23:51:00' AS Time), 4, 13, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1083, N'IC', CAST(N'19:30:00' AS Time), CAST(N'00:57:00' AS Time), 4, 15, CAST(N'05:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1084, N'IC', CAST(N'19:30:00' AS Time), CAST(N'01:07:00' AS Time), 4, 16, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1085, N'IC', CAST(N'19:35:00' AS Time), CAST(N'19:42:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1086, N'IC', CAST(N'19:35:00' AS Time), CAST(N'20:18:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1087, N'IC', CAST(N'19:35:00' AS Time), CAST(N'20:41:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1088, N'IC', CAST(N'19:35:00' AS Time), CAST(N'21:41:00' AS Time), 5, 9, CAST(N'02:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1089, N'IC', CAST(N'19:35:00' AS Time), CAST(N'22:41:00' AS Time), 5, 10, CAST(N'03:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1090, N'IC', CAST(N'19:35:00' AS Time), CAST(N'23:26:00' AS Time), 5, 12, CAST(N'03:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1091, N'IC', CAST(N'19:35:00' AS Time), CAST(N'23:51:00' AS Time), 5, 13, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1092, N'IC', CAST(N'19:35:00' AS Time), CAST(N'00:57:00' AS Time), 5, 15, CAST(N'05:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1093, N'IC', CAST(N'19:35:00' AS Time), CAST(N'01:07:00' AS Time), 5, 16, CAST(N'05:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1094, N'IC', CAST(N'19:42:00' AS Time), CAST(N'20:18:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1095, N'IC', CAST(N'19:42:00' AS Time), CAST(N'20:41:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1096, N'IC', CAST(N'19:42:00' AS Time), CAST(N'21:41:00' AS Time), 6, 9, CAST(N'01:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1097, N'IC', CAST(N'19:42:00' AS Time), CAST(N'22:41:00' AS Time), 6, 10, CAST(N'02:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1098, N'IC', CAST(N'19:42:00' AS Time), CAST(N'23:26:00' AS Time), 6, 12, CAST(N'03:44:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1099, N'IC', CAST(N'19:42:00' AS Time), CAST(N'23:51:00' AS Time), 6, 13, CAST(N'04:09:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1100, N'IC', CAST(N'19:42:00' AS Time), CAST(N'00:57:00' AS Time), 6, 15, CAST(N'05:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1101, N'IC', CAST(N'19:42:00' AS Time), CAST(N'01:07:00' AS Time), 6, 16, CAST(N'05:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1102, N'IC', CAST(N'20:18:00' AS Time), CAST(N'20:41:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1103, N'IC', CAST(N'20:18:00' AS Time), CAST(N'21:41:00' AS Time), 7, 9, CAST(N'01:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1104, N'IC', CAST(N'20:18:00' AS Time), CAST(N'22:41:00' AS Time), 7, 10, CAST(N'02:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1105, N'IC', CAST(N'20:18:00' AS Time), CAST(N'23:26:00' AS Time), 7, 12, CAST(N'03:08:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1106, N'IC', CAST(N'20:18:00' AS Time), CAST(N'23:51:00' AS Time), 7, 13, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1107, N'IC', CAST(N'20:18:00' AS Time), CAST(N'00:57:00' AS Time), 7, 15, CAST(N'04:39:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1108, N'IC', CAST(N'20:18:00' AS Time), CAST(N'01:07:00' AS Time), 7, 16, CAST(N'04:49:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1109, N'IC', CAST(N'20:41:00' AS Time), CAST(N'21:41:00' AS Time), 8, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1110, N'IC', CAST(N'20:41:00' AS Time), CAST(N'22:41:00' AS Time), 8, 10, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1111, N'IC', CAST(N'20:41:00' AS Time), CAST(N'23:26:00' AS Time), 8, 12, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1112, N'IC', CAST(N'20:41:00' AS Time), CAST(N'23:51:00' AS Time), 8, 13, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1113, N'IC', CAST(N'20:41:00' AS Time), CAST(N'00:57:00' AS Time), 8, 15, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1114, N'IC', CAST(N'20:41:00' AS Time), CAST(N'01:07:00' AS Time), 8, 16, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1115, N'IC', CAST(N'21:41:00' AS Time), CAST(N'22:41:00' AS Time), 9, 10, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1116, N'IC', CAST(N'21:41:00' AS Time), CAST(N'23:26:00' AS Time), 9, 12, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1117, N'IC', CAST(N'21:41:00' AS Time), CAST(N'23:51:00' AS Time), 9, 13, CAST(N'02:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1118, N'IC', CAST(N'21:41:00' AS Time), CAST(N'00:57:00' AS Time), 9, 15, CAST(N'03:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1119, N'IC', CAST(N'21:41:00' AS Time), CAST(N'01:07:00' AS Time), 9, 16, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1120, N'IC', CAST(N'22:41:00' AS Time), CAST(N'23:26:00' AS Time), 10, 12, CAST(N'00:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1121, N'IC', CAST(N'22:41:00' AS Time), CAST(N'23:51:00' AS Time), 10, 13, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1122, N'IC', CAST(N'22:41:00' AS Time), CAST(N'00:57:00' AS Time), 10, 15, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1123, N'IC', CAST(N'22:41:00' AS Time), CAST(N'01:07:00' AS Time), 10, 16, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1124, N'IC', CAST(N'23:26:00' AS Time), CAST(N'23:51:00' AS Time), 12, 13, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1125, N'IC', CAST(N'23:26:00' AS Time), CAST(N'00:57:00' AS Time), 12, 15, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1126, N'IC', CAST(N'23:26:00' AS Time), CAST(N'01:07:00' AS Time), 12, 16, CAST(N'01:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1127, N'IC', CAST(N'23:51:00' AS Time), CAST(N'00:57:00' AS Time), 13, 15, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1128, N'IC', CAST(N'23:51:00' AS Time), CAST(N'01:07:00' AS Time), 13, 16, CAST(N'01:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1129, N'IC', CAST(N'00:57:00' AS Time), CAST(N'01:07:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1130, N'IC', CAST(N'15:00:00' AS Time), CAST(N'15:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1131, N'IC', CAST(N'15:00:00' AS Time), CAST(N'16:16:00' AS Time), 16, 13, CAST(N'01:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1132, N'IC', CAST(N'15:00:00' AS Time), CAST(N'16:41:00' AS Time), 16, 12, CAST(N'01:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1133, N'IC', CAST(N'15:00:00' AS Time), CAST(N'17:36:00' AS Time), 16, 10, CAST(N'02:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1134, N'IC', CAST(N'15:00:00' AS Time), CAST(N'18:36:00' AS Time), 16, 9, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1135, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:36:00' AS Time), 16, 8, CAST(N'04:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1136, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:59:00' AS Time), 16, 7, CAST(N'04:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1137, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:35:00' AS Time), 16, 6, CAST(N'05:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1138, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:42:00' AS Time), 16, 5, CAST(N'05:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1139, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:47:00' AS Time), 16, 4, CAST(N'05:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1140, N'IC', CAST(N'15:00:00' AS Time), CAST(N'22:02:00' AS Time), 16, 3, CAST(N'07:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1141, N'IC', CAST(N'15:00:00' AS Time), CAST(N'23:32:00' AS Time), 16, 2, CAST(N'08:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1142, N'IC', CAST(N'15:00:00' AS Time), CAST(N'01:17:00' AS Time), 16, 1, CAST(N'10:17:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1143, N'IC', CAST(N'15:10:00' AS Time), CAST(N'16:16:00' AS Time), 15, 13, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1144, N'IC', CAST(N'15:10:00' AS Time), CAST(N'16:41:00' AS Time), 15, 12, CAST(N'01:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1145, N'IC', CAST(N'15:10:00' AS Time), CAST(N'17:36:00' AS Time), 15, 10, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1146, N'IC', CAST(N'15:10:00' AS Time), CAST(N'18:36:00' AS Time), 15, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1147, N'IC', CAST(N'15:10:00' AS Time), CAST(N'19:36:00' AS Time), 15, 8, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1148, N'IC', CAST(N'15:10:00' AS Time), CAST(N'19:59:00' AS Time), 15, 7, CAST(N'04:49:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1149, N'IC', CAST(N'15:10:00' AS Time), CAST(N'20:35:00' AS Time), 15, 6, CAST(N'05:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1150, N'IC', CAST(N'15:10:00' AS Time), CAST(N'20:42:00' AS Time), 15, 5, CAST(N'05:32:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1151, N'IC', CAST(N'15:10:00' AS Time), CAST(N'20:47:00' AS Time), 15, 4, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1152, N'IC', CAST(N'15:10:00' AS Time), CAST(N'22:02:00' AS Time), 15, 3, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1153, N'IC', CAST(N'15:10:00' AS Time), CAST(N'23:32:00' AS Time), 15, 2, CAST(N'08:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1154, N'IC', CAST(N'15:10:00' AS Time), CAST(N'01:17:00' AS Time), 15, 1, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1155, N'IC', CAST(N'16:16:00' AS Time), CAST(N'16:41:00' AS Time), 13, 12, CAST(N'00:25:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1156, N'IC', CAST(N'16:16:00' AS Time), CAST(N'17:36:00' AS Time), 13, 10, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1157, N'IC', CAST(N'16:16:00' AS Time), CAST(N'18:36:00' AS Time), 13, 9, CAST(N'02:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1158, N'IC', CAST(N'16:16:00' AS Time), CAST(N'19:36:00' AS Time), 13, 8, CAST(N'03:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1159, N'IC', CAST(N'16:16:00' AS Time), CAST(N'19:59:00' AS Time), 13, 7, CAST(N'03:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1160, N'IC', CAST(N'16:16:00' AS Time), CAST(N'20:35:00' AS Time), 13, 6, CAST(N'04:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1161, N'IC', CAST(N'16:16:00' AS Time), CAST(N'20:42:00' AS Time), 13, 5, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1162, N'IC', CAST(N'16:16:00' AS Time), CAST(N'20:47:00' AS Time), 13, 4, CAST(N'04:31:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1163, N'IC', CAST(N'16:16:00' AS Time), CAST(N'22:02:00' AS Time), 13, 3, CAST(N'05:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1164, N'IC', CAST(N'16:16:00' AS Time), CAST(N'23:32:00' AS Time), 13, 2, CAST(N'07:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1165, N'IC', CAST(N'16:16:00' AS Time), CAST(N'01:17:00' AS Time), 13, 1, CAST(N'09:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1166, N'IC', CAST(N'16:41:00' AS Time), CAST(N'17:36:00' AS Time), 12, 10, CAST(N'00:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1167, N'IC', CAST(N'16:41:00' AS Time), CAST(N'18:36:00' AS Time), 12, 9, CAST(N'01:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1168, N'IC', CAST(N'16:41:00' AS Time), CAST(N'19:36:00' AS Time), 12, 8, CAST(N'02:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1169, N'IC', CAST(N'16:41:00' AS Time), CAST(N'19:59:00' AS Time), 12, 7, CAST(N'03:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1170, N'IC', CAST(N'16:41:00' AS Time), CAST(N'20:35:00' AS Time), 12, 6, CAST(N'03:54:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1171, N'IC', CAST(N'16:41:00' AS Time), CAST(N'20:42:00' AS Time), 12, 5, CAST(N'04:01:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1172, N'IC', CAST(N'16:41:00' AS Time), CAST(N'20:47:00' AS Time), 12, 4, CAST(N'04:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1173, N'IC', CAST(N'16:41:00' AS Time), CAST(N'22:02:00' AS Time), 12, 3, CAST(N'05:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1174, N'IC', CAST(N'16:41:00' AS Time), CAST(N'23:32:00' AS Time), 12, 2, CAST(N'06:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1175, N'IC', CAST(N'16:41:00' AS Time), CAST(N'01:17:00' AS Time), 12, 1, CAST(N'08:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1176, N'IC', CAST(N'17:36:00' AS Time), CAST(N'18:36:00' AS Time), 10, 9, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1177, N'IC', CAST(N'17:36:00' AS Time), CAST(N'19:36:00' AS Time), 10, 8, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1178, N'IC', CAST(N'17:36:00' AS Time), CAST(N'19:59:00' AS Time), 10, 7, CAST(N'02:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1179, N'IC', CAST(N'17:36:00' AS Time), CAST(N'20:35:00' AS Time), 10, 6, CAST(N'02:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1180, N'IC', CAST(N'17:36:00' AS Time), CAST(N'20:42:00' AS Time), 10, 5, CAST(N'03:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1181, N'IC', CAST(N'17:36:00' AS Time), CAST(N'20:47:00' AS Time), 10, 4, CAST(N'03:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1182, N'IC', CAST(N'17:36:00' AS Time), CAST(N'22:02:00' AS Time), 10, 3, CAST(N'04:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1183, N'IC', CAST(N'17:36:00' AS Time), CAST(N'23:32:00' AS Time), 10, 2, CAST(N'05:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1184, N'IC', CAST(N'17:36:00' AS Time), CAST(N'01:17:00' AS Time), 10, 1, CAST(N'07:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1185, N'IC', CAST(N'18:36:00' AS Time), CAST(N'19:36:00' AS Time), 9, 8, CAST(N'01:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1186, N'IC', CAST(N'18:36:00' AS Time), CAST(N'19:59:00' AS Time), 9, 7, CAST(N'01:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1187, N'IC', CAST(N'18:36:00' AS Time), CAST(N'20:35:00' AS Time), 9, 6, CAST(N'01:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1188, N'IC', CAST(N'18:36:00' AS Time), CAST(N'20:42:00' AS Time), 9, 5, CAST(N'02:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1189, N'IC', CAST(N'18:36:00' AS Time), CAST(N'20:47:00' AS Time), 9, 4, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1190, N'IC', CAST(N'18:36:00' AS Time), CAST(N'22:02:00' AS Time), 9, 3, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1191, N'IC', CAST(N'18:36:00' AS Time), CAST(N'23:32:00' AS Time), 9, 2, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1192, N'IC', CAST(N'18:36:00' AS Time), CAST(N'01:17:00' AS Time), 9, 1, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1193, N'IC', CAST(N'19:36:00' AS Time), CAST(N'19:59:00' AS Time), 8, 7, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1194, N'IC', CAST(N'19:36:00' AS Time), CAST(N'20:35:00' AS Time), 8, 6, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1195, N'IC', CAST(N'19:36:00' AS Time), CAST(N'20:42:00' AS Time), 8, 5, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1196, N'IC', CAST(N'19:36:00' AS Time), CAST(N'20:47:00' AS Time), 8, 4, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1197, N'IC', CAST(N'19:36:00' AS Time), CAST(N'22:02:00' AS Time), 8, 3, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1198, N'IC', CAST(N'19:36:00' AS Time), CAST(N'23:32:00' AS Time), 8, 2, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1199, N'IC', CAST(N'19:36:00' AS Time), CAST(N'01:17:00' AS Time), 8, 1, CAST(N'05:41:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1200, N'IC', CAST(N'19:59:00' AS Time), CAST(N'20:35:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1201, N'IC', CAST(N'19:59:00' AS Time), CAST(N'20:42:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1202, N'IC', CAST(N'19:59:00' AS Time), CAST(N'20:47:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1203, N'IC', CAST(N'19:59:00' AS Time), CAST(N'22:02:00' AS Time), 7, 3, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1204, N'IC', CAST(N'19:59:00' AS Time), CAST(N'23:32:00' AS Time), 7, 2, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1205, N'IC', CAST(N'19:59:00' AS Time), CAST(N'01:17:00' AS Time), 7, 1, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1206, N'IC', CAST(N'20:35:00' AS Time), CAST(N'20:42:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1207, N'IC', CAST(N'20:35:00' AS Time), CAST(N'20:47:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1208, N'IC', CAST(N'20:35:00' AS Time), CAST(N'22:02:00' AS Time), 6, 3, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1209, N'IC', CAST(N'20:35:00' AS Time), CAST(N'23:32:00' AS Time), 6, 2, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1210, N'IC', CAST(N'20:35:00' AS Time), CAST(N'01:17:00' AS Time), 6, 1, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1211, N'IC', CAST(N'20:42:00' AS Time), CAST(N'20:47:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1212, N'IC', CAST(N'20:42:00' AS Time), CAST(N'22:02:00' AS Time), 5, 3, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1213, N'IC', CAST(N'20:42:00' AS Time), CAST(N'23:32:00' AS Time), 5, 2, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1214, N'IC', CAST(N'20:42:00' AS Time), CAST(N'01:17:00' AS Time), 5, 1, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1215, N'IC', CAST(N'20:47:00' AS Time), CAST(N'22:02:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1216, N'IC', CAST(N'20:47:00' AS Time), CAST(N'23:32:00' AS Time), 4, 2, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1217, N'IC', CAST(N'20:47:00' AS Time), CAST(N'01:17:00' AS Time), 4, 1, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1218, N'IC', CAST(N'22:02:00' AS Time), CAST(N'23:32:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1219, N'IC', CAST(N'22:02:00' AS Time), CAST(N'01:17:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1220, N'IC', CAST(N'23:32:00' AS Time), CAST(N'01:17:00' AS Time), 2, 1, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1221, N'IC', CAST(N'15:00:00' AS Time), CAST(N'15:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1222, N'IC', CAST(N'15:00:00' AS Time), CAST(N'16:46:00' AS Time), 16, 14, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1223, N'IC', CAST(N'15:00:00' AS Time), CAST(N'18:46:00' AS Time), 16, 11, CAST(N'03:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1224, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:56:00' AS Time), 16, 8, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1225, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:19:00' AS Time), 16, 7, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1226, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:55:00' AS Time), 16, 6, CAST(N'05:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1227, N'IC', CAST(N'15:00:00' AS Time), CAST(N'21:02:00' AS Time), 16, 5, CAST(N'06:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1228, N'IC', CAST(N'15:00:00' AS Time), CAST(N'21:07:00' AS Time), 16, 4, CAST(N'06:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1229, N'IC', CAST(N'15:00:00' AS Time), CAST(N'22:22:00' AS Time), 16, 3, CAST(N'07:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1230, N'IC', CAST(N'15:00:00' AS Time), CAST(N'23:52:00' AS Time), 16, 2, CAST(N'08:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1231, N'IC', CAST(N'15:00:00' AS Time), CAST(N'00:37:00' AS Time), 16, 1, CAST(N'09:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1232, N'IC', CAST(N'15:10:00' AS Time), CAST(N'16:46:00' AS Time), 15, 14, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1233, N'IC', CAST(N'15:10:00' AS Time), CAST(N'18:46:00' AS Time), 15, 11, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1234, N'IC', CAST(N'15:10:00' AS Time), CAST(N'19:56:00' AS Time), 15, 8, CAST(N'04:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1235, N'IC', CAST(N'15:10:00' AS Time), CAST(N'20:19:00' AS Time), 15, 7, CAST(N'05:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1236, N'IC', CAST(N'15:10:00' AS Time), CAST(N'20:55:00' AS Time), 15, 6, CAST(N'05:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1237, N'IC', CAST(N'15:10:00' AS Time), CAST(N'21:02:00' AS Time), 15, 5, CAST(N'05:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1238, N'IC', CAST(N'15:10:00' AS Time), CAST(N'21:07:00' AS Time), 15, 4, CAST(N'05:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1239, N'IC', CAST(N'15:10:00' AS Time), CAST(N'22:22:00' AS Time), 15, 3, CAST(N'07:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1240, N'IC', CAST(N'15:10:00' AS Time), CAST(N'23:52:00' AS Time), 15, 2, CAST(N'08:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1241, N'IC', CAST(N'15:10:00' AS Time), CAST(N'00:37:00' AS Time), 15, 1, CAST(N'09:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1242, N'IC', CAST(N'16:46:00' AS Time), CAST(N'18:46:00' AS Time), 14, 11, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1243, N'IC', CAST(N'16:46:00' AS Time), CAST(N'19:56:00' AS Time), 14, 8, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1244, N'IC', CAST(N'16:46:00' AS Time), CAST(N'20:19:00' AS Time), 14, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1245, N'IC', CAST(N'16:46:00' AS Time), CAST(N'20:55:00' AS Time), 14, 6, CAST(N'04:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1246, N'IC', CAST(N'16:46:00' AS Time), CAST(N'21:02:00' AS Time), 14, 5, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1247, N'IC', CAST(N'16:46:00' AS Time), CAST(N'21:07:00' AS Time), 14, 4, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1248, N'IC', CAST(N'16:46:00' AS Time), CAST(N'22:22:00' AS Time), 14, 3, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1249, N'IC', CAST(N'16:46:00' AS Time), CAST(N'23:52:00' AS Time), 14, 2, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1250, N'IC', CAST(N'16:46:00' AS Time), CAST(N'00:37:00' AS Time), 14, 1, CAST(N'07:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1251, N'IC', CAST(N'18:46:00' AS Time), CAST(N'19:56:00' AS Time), 11, 8, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1252, N'IC', CAST(N'18:46:00' AS Time), CAST(N'20:19:00' AS Time), 11, 7, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1253, N'IC', CAST(N'18:46:00' AS Time), CAST(N'20:55:00' AS Time), 11, 6, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1254, N'IC', CAST(N'18:46:00' AS Time), CAST(N'21:02:00' AS Time), 11, 5, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1255, N'IC', CAST(N'18:46:00' AS Time), CAST(N'21:07:00' AS Time), 11, 4, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1256, N'IC', CAST(N'18:46:00' AS Time), CAST(N'22:22:00' AS Time), 11, 3, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1257, N'IC', CAST(N'18:46:00' AS Time), CAST(N'23:52:00' AS Time), 11, 2, CAST(N'05:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1258, N'IC', CAST(N'18:46:00' AS Time), CAST(N'00:37:00' AS Time), 11, 1, CAST(N'05:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1259, N'IC', CAST(N'19:56:00' AS Time), CAST(N'20:19:00' AS Time), 8, 7, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1260, N'IC', CAST(N'19:56:00' AS Time), CAST(N'20:55:00' AS Time), 8, 6, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1261, N'IC', CAST(N'19:56:00' AS Time), CAST(N'21:02:00' AS Time), 8, 5, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1262, N'IC', CAST(N'19:56:00' AS Time), CAST(N'21:07:00' AS Time), 8, 4, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1263, N'IC', CAST(N'19:56:00' AS Time), CAST(N'22:22:00' AS Time), 8, 3, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1264, N'IC', CAST(N'19:56:00' AS Time), CAST(N'23:52:00' AS Time), 8, 2, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1265, N'IC', CAST(N'19:56:00' AS Time), CAST(N'00:37:00' AS Time), 8, 1, CAST(N'04:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1266, N'IC', CAST(N'20:19:00' AS Time), CAST(N'20:55:00' AS Time), 7, 6, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1267, N'IC', CAST(N'20:19:00' AS Time), CAST(N'21:02:00' AS Time), 7, 5, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1268, N'IC', CAST(N'20:19:00' AS Time), CAST(N'21:07:00' AS Time), 7, 4, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1269, N'IC', CAST(N'20:19:00' AS Time), CAST(N'22:22:00' AS Time), 7, 3, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1270, N'IC', CAST(N'20:19:00' AS Time), CAST(N'23:52:00' AS Time), 7, 2, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1271, N'IC', CAST(N'20:19:00' AS Time), CAST(N'00:37:00' AS Time), 7, 1, CAST(N'04:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1272, N'IC', CAST(N'20:55:00' AS Time), CAST(N'21:02:00' AS Time), 6, 5, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1273, N'IC', CAST(N'20:55:00' AS Time), CAST(N'21:07:00' AS Time), 6, 4, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1274, N'IC', CAST(N'20:55:00' AS Time), CAST(N'22:22:00' AS Time), 6, 3, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1275, N'IC', CAST(N'20:55:00' AS Time), CAST(N'23:52:00' AS Time), 6, 2, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1276, N'IC', CAST(N'20:55:00' AS Time), CAST(N'00:37:00' AS Time), 6, 1, CAST(N'03:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1277, N'IC', CAST(N'21:02:00' AS Time), CAST(N'21:07:00' AS Time), 5, 4, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1278, N'IC', CAST(N'21:02:00' AS Time), CAST(N'22:22:00' AS Time), 5, 3, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1279, N'IC', CAST(N'21:02:00' AS Time), CAST(N'23:52:00' AS Time), 5, 2, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1280, N'IC', CAST(N'21:02:00' AS Time), CAST(N'00:37:00' AS Time), 5, 1, CAST(N'03:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1281, N'IC', CAST(N'21:07:00' AS Time), CAST(N'22:22:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1282, N'IC', CAST(N'21:07:00' AS Time), CAST(N'23:52:00' AS Time), 4, 2, CAST(N'02:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1283, N'IC', CAST(N'21:07:00' AS Time), CAST(N'00:37:00' AS Time), 4, 1, CAST(N'03:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1284, N'IC', CAST(N'22:22:00' AS Time), CAST(N'23:52:00' AS Time), 3, 2, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1285, N'IC', CAST(N'22:22:00' AS Time), CAST(N'00:37:00' AS Time), 3, 1, CAST(N'02:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1286, N'IC', CAST(N'23:52:00' AS Time), CAST(N'00:37:00' AS Time), 2, 1, CAST(N'00:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1287, N'IC', CAST(N'15:00:00' AS Time), CAST(N'16:45:00' AS Time), 1, 2, CAST(N'01:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1288, N'IC', CAST(N'15:00:00' AS Time), CAST(N'18:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1289, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1290, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:35:00' AS Time), 1, 5, CAST(N'04:35:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1291, N'IC', CAST(N'15:00:00' AS Time), CAST(N'19:42:00' AS Time), 1, 6, CAST(N'04:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1292, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:18:00' AS Time), 1, 7, CAST(N'05:18:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1293, N'IC', CAST(N'15:00:00' AS Time), CAST(N'20:41:00' AS Time), 1, 8, CAST(N'05:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1294, N'IC', CAST(N'15:00:00' AS Time), CAST(N'21:51:00' AS Time), 1, 11, CAST(N'06:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1295, N'IC', CAST(N'15:00:00' AS Time), CAST(N'23:51:00' AS Time), 1, 14, CAST(N'08:51:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1296, N'IC', CAST(N'15:00:00' AS Time), CAST(N'01:27:00' AS Time), 1, 15, CAST(N'10:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1297, N'IC', CAST(N'15:00:00' AS Time), CAST(N'01:37:00' AS Time), 1, 16, CAST(N'10:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1298, N'IC', CAST(N'16:45:00' AS Time), CAST(N'18:15:00' AS Time), 2, 3, CAST(N'01:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1299, N'IC', CAST(N'16:45:00' AS Time), CAST(N'19:30:00' AS Time), 2, 4, CAST(N'02:45:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1300, N'IC', CAST(N'16:45:00' AS Time), CAST(N'19:35:00' AS Time), 2, 5, CAST(N'02:50:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1301, N'IC', CAST(N'16:45:00' AS Time), CAST(N'19:42:00' AS Time), 2, 6, CAST(N'02:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1302, N'IC', CAST(N'16:45:00' AS Time), CAST(N'20:18:00' AS Time), 2, 7, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1303, N'IC', CAST(N'16:45:00' AS Time), CAST(N'20:41:00' AS Time), 2, 8, CAST(N'03:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1304, N'IC', CAST(N'16:45:00' AS Time), CAST(N'21:51:00' AS Time), 2, 11, CAST(N'05:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1305, N'IC', CAST(N'16:45:00' AS Time), CAST(N'23:51:00' AS Time), 2, 14, CAST(N'07:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1306, N'IC', CAST(N'16:45:00' AS Time), CAST(N'01:27:00' AS Time), 2, 15, CAST(N'08:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1307, N'IC', CAST(N'16:45:00' AS Time), CAST(N'01:37:00' AS Time), 2, 16, CAST(N'08:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1308, N'IC', CAST(N'18:15:00' AS Time), CAST(N'19:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1309, N'IC', CAST(N'18:15:00' AS Time), CAST(N'19:35:00' AS Time), 3, 5, CAST(N'01:20:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1310, N'IC', CAST(N'18:15:00' AS Time), CAST(N'19:42:00' AS Time), 3, 6, CAST(N'01:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1311, N'IC', CAST(N'18:15:00' AS Time), CAST(N'20:18:00' AS Time), 3, 7, CAST(N'02:03:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1312, N'IC', CAST(N'18:15:00' AS Time), CAST(N'20:41:00' AS Time), 3, 8, CAST(N'02:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1313, N'IC', CAST(N'18:15:00' AS Time), CAST(N'21:51:00' AS Time), 3, 11, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1314, N'IC', CAST(N'18:15:00' AS Time), CAST(N'23:51:00' AS Time), 3, 14, CAST(N'05:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1315, N'IC', CAST(N'18:15:00' AS Time), CAST(N'01:27:00' AS Time), 3, 15, CAST(N'07:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1316, N'IC', CAST(N'18:15:00' AS Time), CAST(N'01:37:00' AS Time), 3, 16, CAST(N'07:22:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1317, N'IC', CAST(N'19:30:00' AS Time), CAST(N'19:35:00' AS Time), 4, 5, CAST(N'00:05:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1318, N'IC', CAST(N'19:30:00' AS Time), CAST(N'19:42:00' AS Time), 4, 6, CAST(N'00:12:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1319, N'IC', CAST(N'19:30:00' AS Time), CAST(N'20:18:00' AS Time), 4, 7, CAST(N'00:48:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1320, N'IC', CAST(N'19:30:00' AS Time), CAST(N'20:41:00' AS Time), 4, 8, CAST(N'01:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1321, N'IC', CAST(N'19:30:00' AS Time), CAST(N'21:51:00' AS Time), 4, 11, CAST(N'02:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1322, N'IC', CAST(N'19:30:00' AS Time), CAST(N'23:51:00' AS Time), 4, 14, CAST(N'04:21:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1323, N'IC', CAST(N'19:30:00' AS Time), CAST(N'01:27:00' AS Time), 4, 15, CAST(N'05:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1324, N'IC', CAST(N'19:30:00' AS Time), CAST(N'01:37:00' AS Time), 4, 16, CAST(N'06:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1325, N'IC', CAST(N'19:35:00' AS Time), CAST(N'19:42:00' AS Time), 5, 6, CAST(N'00:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1326, N'IC', CAST(N'19:35:00' AS Time), CAST(N'20:18:00' AS Time), 5, 7, CAST(N'00:43:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1327, N'IC', CAST(N'19:35:00' AS Time), CAST(N'20:41:00' AS Time), 5, 8, CAST(N'01:06:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1328, N'IC', CAST(N'19:35:00' AS Time), CAST(N'21:51:00' AS Time), 5, 11, CAST(N'02:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1329, N'IC', CAST(N'19:35:00' AS Time), CAST(N'23:51:00' AS Time), 5, 14, CAST(N'04:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1330, N'IC', CAST(N'19:35:00' AS Time), CAST(N'01:27:00' AS Time), 5, 15, CAST(N'05:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1331, N'IC', CAST(N'19:35:00' AS Time), CAST(N'01:37:00' AS Time), 5, 16, CAST(N'06:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1332, N'IC', CAST(N'19:42:00' AS Time), CAST(N'20:18:00' AS Time), 6, 7, CAST(N'00:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1333, N'IC', CAST(N'19:42:00' AS Time), CAST(N'20:41:00' AS Time), 6, 8, CAST(N'00:59:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1334, N'IC', CAST(N'19:42:00' AS Time), CAST(N'21:51:00' AS Time), 6, 11, CAST(N'02:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1335, N'IC', CAST(N'19:42:00' AS Time), CAST(N'23:51:00' AS Time), 6, 14, CAST(N'04:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1336, N'IC', CAST(N'19:42:00' AS Time), CAST(N'01:27:00' AS Time), 6, 15, CAST(N'05:45:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1337, N'IC', CAST(N'19:42:00' AS Time), CAST(N'01:37:00' AS Time), 6, 16, CAST(N'05:55:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1338, N'IC', CAST(N'20:18:00' AS Time), CAST(N'20:41:00' AS Time), 7, 8, CAST(N'00:23:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1339, N'IC', CAST(N'20:18:00' AS Time), CAST(N'21:51:00' AS Time), 7, 11, CAST(N'01:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1340, N'IC', CAST(N'20:18:00' AS Time), CAST(N'23:51:00' AS Time), 7, 14, CAST(N'03:33:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1341, N'IC', CAST(N'20:18:00' AS Time), CAST(N'01:27:00' AS Time), 7, 15, CAST(N'05:09:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1342, N'IC', CAST(N'20:18:00' AS Time), CAST(N'01:37:00' AS Time), 7, 16, CAST(N'05:19:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1343, N'IC', CAST(N'20:41:00' AS Time), CAST(N'21:51:00' AS Time), 8, 11, CAST(N'01:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1344, N'IC', CAST(N'20:41:00' AS Time), CAST(N'23:51:00' AS Time), 8, 14, CAST(N'03:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1345, N'IC', CAST(N'20:41:00' AS Time), CAST(N'01:27:00' AS Time), 8, 15, CAST(N'04:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1346, N'IC', CAST(N'20:41:00' AS Time), CAST(N'01:37:00' AS Time), 8, 16, CAST(N'04:56:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1347, N'IC', CAST(N'21:51:00' AS Time), CAST(N'23:51:00' AS Time), 11, 14, CAST(N'02:00:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1348, N'IC', CAST(N'21:51:00' AS Time), CAST(N'01:27:00' AS Time), 11, 15, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1349, N'IC', CAST(N'21:51:00' AS Time), CAST(N'01:37:00' AS Time), 11, 16, CAST(N'03:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1350, N'IC', CAST(N'23:51:00' AS Time), CAST(N'01:27:00' AS Time), 14, 15, CAST(N'01:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1351, N'IC', CAST(N'23:51:00' AS Time), CAST(N'01:37:00' AS Time), 14, 16, CAST(N'01:46:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1352, N'IC', CAST(N'01:27:00' AS Time), CAST(N'01:37:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1353, N'AP', CAST(N'05:00:00' AS Time), CAST(N'08:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1354, N'AP', CAST(N'05:00:00' AS Time), CAST(N'09:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1355, N'AP', CAST(N'05:00:00' AS Time), CAST(N'11:41:00' AS Time), 1, 9, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1356, N'AP', CAST(N'05:00:00' AS Time), CAST(N'14:57:00' AS Time), 1, 15, CAST(N'09:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1357, N'AP', CAST(N'05:00:00' AS Time), CAST(N'15:07:00' AS Time), 1, 16, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1358, N'AP', CAST(N'08:15:00' AS Time), CAST(N'09:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1359, N'AP', CAST(N'08:15:00' AS Time), CAST(N'11:41:00' AS Time), 3, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1360, N'AP', CAST(N'08:15:00' AS Time), CAST(N'14:57:00' AS Time), 3, 15, CAST(N'06:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1361, N'AP', CAST(N'08:15:00' AS Time), CAST(N'15:07:00' AS Time), 3, 16, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1362, N'AP', CAST(N'09:30:00' AS Time), CAST(N'11:41:00' AS Time), 4, 9, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1363, N'AP', CAST(N'09:30:00' AS Time), CAST(N'14:57:00' AS Time), 4, 15, CAST(N'05:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1364, N'AP', CAST(N'09:30:00' AS Time), CAST(N'15:07:00' AS Time), 4, 16, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1365, N'AP', CAST(N'11:41:00' AS Time), CAST(N'14:57:00' AS Time), 9, 15, CAST(N'03:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1366, N'AP', CAST(N'11:41:00' AS Time), CAST(N'15:07:00' AS Time), 9, 16, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1367, N'AP', CAST(N'14:57:00' AS Time), CAST(N'15:07:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1368, N'AP', CAST(N'05:00:00' AS Time), CAST(N'05:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1369, N'AP', CAST(N'05:00:00' AS Time), CAST(N'08:36:00' AS Time), 16, 9, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1370, N'AP', CAST(N'05:00:00' AS Time), CAST(N'10:47:00' AS Time), 16, 4, CAST(N'05:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1371, N'AP', CAST(N'05:00:00' AS Time), CAST(N'12:02:00' AS Time), 16, 3, CAST(N'07:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1372, N'AP', CAST(N'05:00:00' AS Time), CAST(N'15:17:00' AS Time), 16, 1, CAST(N'10:17:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1373, N'AP', CAST(N'05:10:00' AS Time), CAST(N'08:36:00' AS Time), 15, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1374, N'AP', CAST(N'05:10:00' AS Time), CAST(N'10:47:00' AS Time), 15, 4, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1375, N'AP', CAST(N'05:10:00' AS Time), CAST(N'12:02:00' AS Time), 15, 3, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1376, N'AP', CAST(N'05:10:00' AS Time), CAST(N'15:17:00' AS Time), 15, 1, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1377, N'AP', CAST(N'08:36:00' AS Time), CAST(N'10:47:00' AS Time), 9, 4, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1378, N'AP', CAST(N'08:36:00' AS Time), CAST(N'12:02:00' AS Time), 9, 3, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1379, N'AP', CAST(N'08:36:00' AS Time), CAST(N'15:17:00' AS Time), 9, 1, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1380, N'AP', CAST(N'10:47:00' AS Time), CAST(N'12:02:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1381, N'AP', CAST(N'10:47:00' AS Time), CAST(N'15:17:00' AS Time), 4, 1, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1382, N'AP', CAST(N'12:02:00' AS Time), CAST(N'15:17:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1383, N'AP', CAST(N'13:00:00' AS Time), CAST(N'16:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1384, N'AP', CAST(N'13:00:00' AS Time), CAST(N'17:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1385, N'AP', CAST(N'13:00:00' AS Time), CAST(N'19:41:00' AS Time), 1, 9, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1386, N'AP', CAST(N'13:00:00' AS Time), CAST(N'22:57:00' AS Time), 1, 15, CAST(N'09:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1387, N'AP', CAST(N'13:00:00' AS Time), CAST(N'23:07:00' AS Time), 1, 16, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1388, N'AP', CAST(N'16:15:00' AS Time), CAST(N'17:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1389, N'AP', CAST(N'16:15:00' AS Time), CAST(N'19:41:00' AS Time), 3, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1390, N'AP', CAST(N'16:15:00' AS Time), CAST(N'22:57:00' AS Time), 3, 15, CAST(N'06:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1391, N'AP', CAST(N'16:15:00' AS Time), CAST(N'23:07:00' AS Time), 3, 16, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1392, N'AP', CAST(N'17:30:00' AS Time), CAST(N'19:41:00' AS Time), 4, 9, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1393, N'AP', CAST(N'17:30:00' AS Time), CAST(N'22:57:00' AS Time), 4, 15, CAST(N'05:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1394, N'AP', CAST(N'17:30:00' AS Time), CAST(N'23:07:00' AS Time), 4, 16, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1395, N'AP', CAST(N'19:41:00' AS Time), CAST(N'22:57:00' AS Time), 9, 15, CAST(N'03:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1396, N'AP', CAST(N'19:41:00' AS Time), CAST(N'23:07:00' AS Time), 9, 16, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1397, N'AP', CAST(N'22:57:00' AS Time), CAST(N'23:07:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1398, N'AP', CAST(N'13:00:00' AS Time), CAST(N'13:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1399, N'AP', CAST(N'13:00:00' AS Time), CAST(N'16:36:00' AS Time), 16, 9, CAST(N'03:36:00' AS Time))
GO
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1400, N'AP', CAST(N'13:00:00' AS Time), CAST(N'18:47:00' AS Time), 16, 4, CAST(N'05:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1401, N'AP', CAST(N'13:00:00' AS Time), CAST(N'20:02:00' AS Time), 16, 3, CAST(N'07:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1402, N'AP', CAST(N'13:00:00' AS Time), CAST(N'23:17:00' AS Time), 16, 1, CAST(N'10:17:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1403, N'AP', CAST(N'13:10:00' AS Time), CAST(N'16:36:00' AS Time), 15, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1404, N'AP', CAST(N'13:10:00' AS Time), CAST(N'18:47:00' AS Time), 15, 4, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1405, N'AP', CAST(N'13:10:00' AS Time), CAST(N'20:02:00' AS Time), 15, 3, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1406, N'AP', CAST(N'13:10:00' AS Time), CAST(N'23:17:00' AS Time), 15, 1, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1407, N'AP', CAST(N'16:36:00' AS Time), CAST(N'18:47:00' AS Time), 9, 4, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1408, N'AP', CAST(N'16:36:00' AS Time), CAST(N'20:02:00' AS Time), 9, 3, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1409, N'AP', CAST(N'16:36:00' AS Time), CAST(N'23:17:00' AS Time), 9, 1, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1410, N'AP', CAST(N'18:47:00' AS Time), CAST(N'20:02:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1411, N'AP', CAST(N'18:47:00' AS Time), CAST(N'23:17:00' AS Time), 4, 1, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1412, N'AP', CAST(N'20:02:00' AS Time), CAST(N'23:17:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1413, N'M', CAST(N'05:00:00' AS Time), CAST(N'08:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1414, N'M', CAST(N'05:00:00' AS Time), CAST(N'09:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1415, N'M', CAST(N'05:00:00' AS Time), CAST(N'11:41:00' AS Time), 1, 9, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1416, N'M', CAST(N'05:00:00' AS Time), CAST(N'14:57:00' AS Time), 1, 15, CAST(N'09:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1417, N'M', CAST(N'05:00:00' AS Time), CAST(N'15:07:00' AS Time), 1, 16, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1418, N'M', CAST(N'08:15:00' AS Time), CAST(N'09:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1419, N'M', CAST(N'08:15:00' AS Time), CAST(N'11:41:00' AS Time), 3, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1420, N'M', CAST(N'08:15:00' AS Time), CAST(N'14:57:00' AS Time), 3, 15, CAST(N'06:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1421, N'M', CAST(N'08:15:00' AS Time), CAST(N'15:07:00' AS Time), 3, 16, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1422, N'M', CAST(N'09:30:00' AS Time), CAST(N'11:41:00' AS Time), 4, 9, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1423, N'M', CAST(N'09:30:00' AS Time), CAST(N'14:57:00' AS Time), 4, 15, CAST(N'05:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1424, N'M', CAST(N'09:30:00' AS Time), CAST(N'15:07:00' AS Time), 4, 16, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1425, N'M', CAST(N'11:41:00' AS Time), CAST(N'14:57:00' AS Time), 9, 15, CAST(N'03:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1426, N'M', CAST(N'11:41:00' AS Time), CAST(N'15:07:00' AS Time), 9, 16, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1427, N'M', CAST(N'14:57:00' AS Time), CAST(N'15:07:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1428, N'M', CAST(N'05:00:00' AS Time), CAST(N'05:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1429, N'M', CAST(N'05:00:00' AS Time), CAST(N'08:36:00' AS Time), 16, 9, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1430, N'M', CAST(N'05:00:00' AS Time), CAST(N'10:47:00' AS Time), 16, 4, CAST(N'05:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1431, N'M', CAST(N'05:00:00' AS Time), CAST(N'12:02:00' AS Time), 16, 3, CAST(N'07:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1432, N'M', CAST(N'05:00:00' AS Time), CAST(N'15:17:00' AS Time), 16, 1, CAST(N'10:17:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1433, N'M', CAST(N'05:10:00' AS Time), CAST(N'08:36:00' AS Time), 15, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1434, N'M', CAST(N'05:10:00' AS Time), CAST(N'10:47:00' AS Time), 15, 4, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1435, N'M', CAST(N'05:10:00' AS Time), CAST(N'12:02:00' AS Time), 15, 3, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1436, N'M', CAST(N'05:10:00' AS Time), CAST(N'15:17:00' AS Time), 15, 1, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1437, N'M', CAST(N'08:36:00' AS Time), CAST(N'10:47:00' AS Time), 9, 4, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1438, N'M', CAST(N'08:36:00' AS Time), CAST(N'12:02:00' AS Time), 9, 3, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1439, N'M', CAST(N'08:36:00' AS Time), CAST(N'15:17:00' AS Time), 9, 1, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1440, N'M', CAST(N'10:47:00' AS Time), CAST(N'12:02:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1441, N'M', CAST(N'10:47:00' AS Time), CAST(N'15:17:00' AS Time), 4, 1, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1442, N'M', CAST(N'12:02:00' AS Time), CAST(N'15:17:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1443, N'M', CAST(N'13:00:00' AS Time), CAST(N'16:15:00' AS Time), 1, 3, CAST(N'03:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1444, N'M', CAST(N'13:00:00' AS Time), CAST(N'17:30:00' AS Time), 1, 4, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1445, N'M', CAST(N'13:00:00' AS Time), CAST(N'19:41:00' AS Time), 1, 9, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1446, N'M', CAST(N'13:00:00' AS Time), CAST(N'22:57:00' AS Time), 1, 15, CAST(N'09:57:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1447, N'M', CAST(N'13:00:00' AS Time), CAST(N'23:07:00' AS Time), 1, 16, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1448, N'M', CAST(N'16:15:00' AS Time), CAST(N'17:30:00' AS Time), 3, 4, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1449, N'M', CAST(N'16:15:00' AS Time), CAST(N'19:41:00' AS Time), 3, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1450, N'M', CAST(N'16:15:00' AS Time), CAST(N'22:57:00' AS Time), 3, 15, CAST(N'06:42:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1451, N'M', CAST(N'16:15:00' AS Time), CAST(N'23:07:00' AS Time), 3, 16, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1452, N'M', CAST(N'17:30:00' AS Time), CAST(N'19:41:00' AS Time), 4, 9, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1453, N'M', CAST(N'17:30:00' AS Time), CAST(N'22:57:00' AS Time), 4, 15, CAST(N'05:27:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1454, N'M', CAST(N'17:30:00' AS Time), CAST(N'23:07:00' AS Time), 4, 16, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1455, N'M', CAST(N'19:41:00' AS Time), CAST(N'22:57:00' AS Time), 9, 15, CAST(N'03:16:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1456, N'M', CAST(N'19:41:00' AS Time), CAST(N'23:07:00' AS Time), 9, 16, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1457, N'M', CAST(N'22:57:00' AS Time), CAST(N'23:07:00' AS Time), 15, 16, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1458, N'M', CAST(N'13:00:00' AS Time), CAST(N'13:10:00' AS Time), 16, 15, CAST(N'00:10:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1459, N'M', CAST(N'13:00:00' AS Time), CAST(N'16:36:00' AS Time), 16, 9, CAST(N'03:36:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1460, N'M', CAST(N'13:00:00' AS Time), CAST(N'18:47:00' AS Time), 16, 4, CAST(N'05:47:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1461, N'M', CAST(N'13:00:00' AS Time), CAST(N'20:02:00' AS Time), 16, 3, CAST(N'07:02:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1462, N'M', CAST(N'13:00:00' AS Time), CAST(N'23:17:00' AS Time), 16, 1, CAST(N'10:17:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1463, N'M', CAST(N'13:10:00' AS Time), CAST(N'16:36:00' AS Time), 15, 9, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1464, N'M', CAST(N'13:10:00' AS Time), CAST(N'18:47:00' AS Time), 15, 4, CAST(N'05:37:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1465, N'M', CAST(N'13:10:00' AS Time), CAST(N'20:02:00' AS Time), 15, 3, CAST(N'06:52:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1466, N'M', CAST(N'13:10:00' AS Time), CAST(N'23:17:00' AS Time), 15, 1, CAST(N'10:07:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1467, N'M', CAST(N'16:36:00' AS Time), CAST(N'18:47:00' AS Time), 9, 4, CAST(N'02:11:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1468, N'M', CAST(N'16:36:00' AS Time), CAST(N'20:02:00' AS Time), 9, 3, CAST(N'03:26:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1469, N'M', CAST(N'16:36:00' AS Time), CAST(N'23:17:00' AS Time), 9, 1, CAST(N'06:41:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1470, N'M', CAST(N'18:47:00' AS Time), CAST(N'20:02:00' AS Time), 4, 3, CAST(N'01:15:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1471, N'M', CAST(N'18:47:00' AS Time), CAST(N'23:17:00' AS Time), 4, 1, CAST(N'04:30:00' AS Time))
INSERT [Railway].[Trip] ([trip_no], [trip_type], [dep_timestamp], [arr_timestamp], [dep_station], [arr_station], [duration]) VALUES (1472, N'M', CAST(N'20:02:00' AS Time), CAST(N'23:17:00' AS Time), 3, 1, CAST(N'03:15:00' AS Time))
SET IDENTITY_INSERT [Railway].[Trip] OFF
INSERT [Railway].[TripInstance] ([trip_no], [trip_date], [train_no], [dep_station], [arr_station], [duration], [dep_timestamp], [arr_timestamp]) VALUES (61, CAST(N'2019-06-06' AS Date), 4, 6, 4, CAST(N'00:12:00' AS Time), CAST(N'10:19:00' AS Time), CAST(N'10:31:00' AS Time))
INSERT [Railway].[TripInstance] ([trip_no], [trip_date], [train_no], [dep_station], [arr_station], [duration], [dep_timestamp], [arr_timestamp]) VALUES (256, CAST(N'2019-06-07' AS Date), 4, 4, 8, CAST(N'01:11:00' AS Time), CAST(N'19:00:00' AS Time), CAST(N'20:11:00' AS Time))
INSERT [Railway].[TripInstance] ([trip_no], [trip_date], [train_no], [dep_station], [arr_station], [duration], [dep_timestamp], [arr_timestamp]) VALUES (744, CAST(N'2019-06-05' AS Date), 14, 2, 9, CAST(N'04:56:00' AS Time), CAST(N'11:45:00' AS Time), CAST(N'16:41:00' AS Time))
SET IDENTITY_INSERT [Railway].[TripZone] ON 

INSERT [Railway].[TripZone] ([zone_no], [zone_name], [priceUR], [priceIC], [priceAP]) VALUES (1, N'Entre-Douro-e-Minho', 3.0000, 4.0000, 5.0000)
INSERT [Railway].[TripZone] ([zone_no], [zone_name], [priceUR], [priceIC], [priceAP]) VALUES (2, N'Beira Litoral', 4.5000, 5.5000, 6.5000)
INSERT [Railway].[TripZone] ([zone_no], [zone_name], [priceUR], [priceIC], [priceAP]) VALUES (3, N'Ribatejo', 3.5000, 4.5000, 5.5000)
SET IDENTITY_INSERT [Railway].[TripZone] OFF
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Discount__F911BBFFF6A89131]    Script Date: 07/06/2019 22:56:00 ******/
ALTER TABLE [Railway].[Discount] ADD UNIQUE NONCLUSTERED 
(
	[promocode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Employee__129850FBFAFF7EA4]    Script Date: 07/06/2019 22:56:00 ******/
ALTER TABLE [Railway].[Employee] ADD UNIQUE NONCLUSTERED 
(
	[emp_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Passenge__AB6E6164080C7E13]    Script Date: 07/06/2019 22:56:00 ******/
ALTER TABLE [Railway].[Passenger] ADD UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [UQ__Person__DF97D0F2367E313A]    Script Date: 07/06/2019 22:56:00 ******/
ALTER TABLE [Railway].[Person] ADD UNIQUE NONCLUSTERED 
(
	[nif] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__TripZone__AFAE7D9D3228BDD2]    Script Date: 07/06/2019 22:56:00 ******/
ALTER TABLE [Railway].[TripZone] ADD UNIQUE NONCLUSTERED 
(
	[zone_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [Railway].[Carriage]  WITH CHECK ADD  CONSTRAINT [c14] FOREIGN KEY([train_no])
REFERENCES [Railway].[Train] ([train_no])
GO
ALTER TABLE [Railway].[Carriage] CHECK CONSTRAINT [c14]
GO
ALTER TABLE [Railway].[ConnectsTo]  WITH CHECK ADD  CONSTRAINT [c18] FOREIGN KEY([dep_station])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[ConnectsTo] CHECK CONSTRAINT [c18]
GO
ALTER TABLE [Railway].[ConnectsTo]  WITH CHECK ADD  CONSTRAINT [c19] FOREIGN KEY([arr_station])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[ConnectsTo] CHECK CONSTRAINT [c19]
GO
ALTER TABLE [Railway].[Employee]  WITH CHECK ADD  CONSTRAINT [c2] FOREIGN KEY([emp_id])
REFERENCES [Railway].[Person] ([id])
GO
ALTER TABLE [Railway].[Employee] CHECK CONSTRAINT [c2]
GO
ALTER TABLE [Railway].[Employee]  WITH CHECK ADD  CONSTRAINT [c3] FOREIGN KEY([station_no])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[Employee] CHECK CONSTRAINT [c3]
GO
ALTER TABLE [Railway].[Locality]  WITH CHECK ADD  CONSTRAINT [c17] FOREIGN KEY([station_no])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[Locality] CHECK CONSTRAINT [c17]
GO
ALTER TABLE [Railway].[Passenger]  WITH CHECK ADD  CONSTRAINT [c1] FOREIGN KEY([passenger_id])
REFERENCES [Railway].[Person] ([id])
GO
ALTER TABLE [Railway].[Passenger] CHECK CONSTRAINT [c1]
GO
ALTER TABLE [Railway].[ProfilePictures]  WITH CHECK ADD  CONSTRAINT [c21] FOREIGN KEY([passenger_id])
REFERENCES [Railway].[Passenger] ([passenger_id])
GO
ALTER TABLE [Railway].[ProfilePictures] CHECK CONSTRAINT [c21]
GO
ALTER TABLE [Railway].[Station]  WITH CHECK ADD  CONSTRAINT [c12] FOREIGN KEY([director_no])
REFERENCES [Railway].[Employee] ([emp_no])
GO
ALTER TABLE [Railway].[Station] CHECK CONSTRAINT [c12]
GO
ALTER TABLE [Railway].[Station]  WITH CHECK ADD  CONSTRAINT [c20] FOREIGN KEY([zone_no])
REFERENCES [Railway].[TripZone] ([zone_no])
GO
ALTER TABLE [Railway].[Station] CHECK CONSTRAINT [c20]
GO
ALTER TABLE [Railway].[StopsAt]  WITH CHECK ADD  CONSTRAINT [c15] FOREIGN KEY([station_no])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[StopsAt] CHECK CONSTRAINT [c15]
GO
ALTER TABLE [Railway].[StopsAt]  WITH CHECK ADD  CONSTRAINT [c16] FOREIGN KEY([category])
REFERENCES [Railway].[TrainType] ([category])
GO
ALTER TABLE [Railway].[StopsAt] CHECK CONSTRAINT [c16]
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD  CONSTRAINT [c4] FOREIGN KEY([passenger_id])
REFERENCES [Railway].[Passenger] ([passenger_id])
GO
ALTER TABLE [Railway].[Ticket] CHECK CONSTRAINT [c4]
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD  CONSTRAINT [c5] FOREIGN KEY([trip_no], [trip_date])
REFERENCES [Railway].[TripInstance] ([trip_no], [trip_date])
GO
ALTER TABLE [Railway].[Ticket] CHECK CONSTRAINT [c5]
GO
ALTER TABLE [Railway].[Train]  WITH CHECK ADD  CONSTRAINT [c13] FOREIGN KEY([category])
REFERENCES [Railway].[TrainType] ([category])
GO
ALTER TABLE [Railway].[Train] CHECK CONSTRAINT [c13]
GO
ALTER TABLE [Railway].[Trip]  WITH CHECK ADD  CONSTRAINT [c10] FOREIGN KEY([dep_station])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[Trip] CHECK CONSTRAINT [c10]
GO
ALTER TABLE [Railway].[Trip]  WITH CHECK ADD  CONSTRAINT [c11] FOREIGN KEY([arr_station])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[Trip] CHECK CONSTRAINT [c11]
GO
ALTER TABLE [Railway].[TripInstance]  WITH CHECK ADD  CONSTRAINT [c6] FOREIGN KEY([trip_no])
REFERENCES [Railway].[Trip] ([trip_no])
GO
ALTER TABLE [Railway].[TripInstance] CHECK CONSTRAINT [c6]
GO
ALTER TABLE [Railway].[TripInstance]  WITH CHECK ADD  CONSTRAINT [c7] FOREIGN KEY([dep_station])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[TripInstance] CHECK CONSTRAINT [c7]
GO
ALTER TABLE [Railway].[TripInstance]  WITH CHECK ADD  CONSTRAINT [c8] FOREIGN KEY([arr_station])
REFERENCES [Railway].[Station] ([station_no])
GO
ALTER TABLE [Railway].[TripInstance] CHECK CONSTRAINT [c8]
GO
ALTER TABLE [Railway].[TripInstance]  WITH CHECK ADD  CONSTRAINT [c9] FOREIGN KEY([train_no])
REFERENCES [Railway].[Train] ([train_no])
GO
ALTER TABLE [Railway].[TripInstance] CHECK CONSTRAINT [c9]
GO
ALTER TABLE [Railway].[Carriage]  WITH CHECK ADD CHECK  (([carriage_no]>(0)))
GO
ALTER TABLE [Railway].[Carriage]  WITH CHECK ADD CHECK  (([class]='C' OR [class]='E' OR [class]='M'))
GO
ALTER TABLE [Railway].[Carriage]  WITH CHECK ADD CHECK  (([no_seats]>=(0)))
GO
ALTER TABLE [Railway].[Carriage]  WITH CHECK ADD CHECK  (([train_no]>(0)))
GO
ALTER TABLE [Railway].[ConnectsTo]  WITH CHECK ADD CHECK  (([arr_station]>(0)))
GO
ALTER TABLE [Railway].[ConnectsTo]  WITH CHECK ADD CHECK  (([dep_station]>(0)))
GO
ALTER TABLE [Railway].[Employee]  WITH CHECK ADD CHECK  (([emp_id]>(0)))
GO
ALTER TABLE [Railway].[Employee]  WITH CHECK ADD CHECK  (([emp_no]>(0)))
GO
ALTER TABLE [Railway].[Employee]  WITH CHECK ADD CHECK  (([station_no]>(0)))
GO
ALTER TABLE [Railway].[Locality]  WITH CHECK ADD CHECK  (([station_no]>(0)))
GO
ALTER TABLE [Railway].[Passenger]  WITH CHECK ADD CHECK  (([email] like '%@%' AND [email] like '%.%'))
GO
ALTER TABLE [Railway].[Passenger]  WITH CHECK ADD CHECK  (([passenger_id]>(100000000)))
GO
ALTER TABLE [Railway].[Passenger]  WITH CHECK ADD CHECK  ((len([pw])>(0)))
GO
ALTER TABLE [Railway].[Person]  WITH CHECK ADD CHECK  (([gender]='M' OR [gender]='F'))
GO
ALTER TABLE [Railway].[Person]  WITH CHECK ADD CHECK  (([nif]>=(100000000) AND [nif]<=(999999999)))
GO
ALTER TABLE [Railway].[Person]  WITH CHECK ADD CHECK  (([phone]>=(900000000) AND [phone]<=(999999999)))
GO
ALTER TABLE [Railway].[Station]  WITH CHECK ADD CHECK  (([station_no]>(0)))
GO
ALTER TABLE [Railway].[StopsAt]  WITH CHECK ADD CHECK  (([station_no]>(0)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([arr_station]>(0)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([carriage_no]>(0)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([dep_station]>(0)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([nif]>=(100000000) AND [nif]<(999999999)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([passenger_id]>(0)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([price]>(0)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([seat_no]>(0)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([train_no]>(0)))
GO
ALTER TABLE [Railway].[Ticket]  WITH CHECK ADD CHECK  (([trip_no]>(0)))
GO
ALTER TABLE [Railway].[Train]  WITH CHECK ADD CHECK  (([no_carriages]>(0)))
GO
ALTER TABLE [Railway].[Train]  WITH CHECK ADD CHECK  (([total_seats]>=(0)))
GO
ALTER TABLE [Railway].[Train]  WITH CHECK ADD CHECK  (([train_no]>(0)))
GO
ALTER TABLE [Railway].[Trip]  WITH CHECK ADD CHECK  (([arr_station]>(0)))
GO
ALTER TABLE [Railway].[Trip]  WITH CHECK ADD CHECK  (([dep_station]>(0)))
GO
ALTER TABLE [Railway].[Trip]  WITH CHECK ADD CHECK  (([trip_no]>(0)))
GO
ALTER TABLE [Railway].[TripInstance]  WITH CHECK ADD CHECK  (([trip_no]>(0)))
GO
ALTER TABLE [Railway].[TripZone]  WITH CHECK ADD CHECK  (([priceAP]>=(0)))
GO
ALTER TABLE [Railway].[TripZone]  WITH CHECK ADD CHECK  (([priceIC]>=(0)))
GO
ALTER TABLE [Railway].[TripZone]  WITH CHECK ADD CHECK  (([priceUR]>=(0)))
GO
/****** Object:  StoredProcedure [Railway].[get_next_ticket_no]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[get_next_ticket_no]
AS
	SELECT IDENT_CURRENT ('Railway.Ticket'); 
GO
/****** Object:  StoredProcedure [Railway].[pr_buy_ticket]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_buy_ticket](
		@nif					INT,		
		@dep_station			INT,			
		@arr_station			INT,			
		@dep_timestamp			TIME,		
		@arr_timestamp			TIME,		
		@train_no				INT,			
		@carriage_no			INT,			
		@seat_no				INT,			
		@price					SMALLMONEY,	
		@trip_no				INT,			
		@trip_date				DATE,		
		@passenger_id			INT,
		@duration				TIME,
		@trip_type				VARCHAR(2)
)
AS
	INSERT INTO Railway.Ticket VALUES (@nif, @dep_station, @arr_station, @dep_timestamp, @arr_timestamp, @train_no, @carriage_no, @seat_no, @price, @trip_no, @trip_date, @passenger_id, @duration, @trip_type);
GO
/****** Object:  StoredProcedure [Railway].[pr_delete_image]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_delete_image](@passenger_id INT)
AS
	DELETE FROM Railway.ProfilePictures WHERE passenger_id = @passenger_id;
GO
/****** Object:  StoredProcedure [Railway].[pr_delete_profile]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Railway].[pr_delete_profile] (	@user_id INT,
										@nif INT)
AS
BEGIN
	DELETE FROM Railway.Ticket WHERE nif = @nif;
	DELETE FROM Railway.Passenger WHERE passenger_id = @user_id;
	DELETE FROM Railway.Person WHERE id = @user_id;
END
GO
/****** Object:  StoredProcedure [Railway].[pr_edit_profile]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [Railway].[pr_edit_profile]	@email VARCHAR(50), 
									@nif INT, 
									@fname VARCHAR(30), 
									@lname VARCHAR(30), 
									--@bdate DATE, 
									@gender CHAR, 
									@postal_code VARCHAR(50), 
									@city VARCHAR(50), 
									@country VARCHAR(50), 
									@phone INT,
									@new_password VARCHAR(50)
AS
BEGIN
	-- Change fname
	IF NOT (@fname LIKE '%NULL%')
		UPDATE Railway.Person SET fname = @fname WHERE nif = @nif;
	-- Change lname
	IF NOT (@lname LIKE '%NULL%')
		UPDATE Railway.Person SET lname = @lname WHERE nif = @nif;
	-- Change gender
	IF NOT (@gender LIKE '%N%')
		UPDATE Railway.Person SET gender = @gender WHERE nif = @nif;
	-- Change postal code
	IF NOT (@postal_code LIKE '%NULL%')
		UPDATE Railway.Person SET postal_code = @postal_code WHERE nif = @nif;
	-- Change city
	IF NOT (@city LIKE '%NULL%')
		UPDATE Railway.Person SET city = @city WHERE nif = @nif;
	-- Change country
	IF NOT (@country LIKE '%NULL%')
		UPDATE Railway.Person SET country = @country WHERE nif = @nif;
	-- Change phone
	IF NOT (@phone = 0)
		UPDATE Railway.Person SET phone = @phone WHERE nif = @nif;
	-- Change password
	IF NOT (@new_password LIKE '%NULL%')
		UPDATE Railway.Passenger SET pw = HASHBYTES('SHA1', @new_password) WHERE email = @email;
END
GO
/****** Object:  StoredProcedure [Railway].[pr_forgot_password]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Railway].[pr_forgot_password] (@email VARCHAR(50),
										@password VARCHAR(50))
AS
BEGIN
	UPDATE Railway.Passenger SET email = @email WHERE email = @email;
	UPDATE Railway.Passenger SET pw = HASHBYTES('SHA1', @password) WHERE email = @email;
END
GO
/****** Object:  StoredProcedure [Railway].[pr_get_default_picture]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_default_picture](@id INT)
AS
	SELECT img_base64 FROM Railway.ProfilePictures WHERE id = @id;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_discount]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_discount](@promocode VARCHAR(10))
AS
	SELECT discount FROM Railway.Discount WHERE promocode = @promocode;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_passenger_tickets]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_passenger_tickets](@passenger_id INT)
AS
	SELECT T.ticket_no, dep_station.station_name AS dep_station, arr_station.station_name AS arr_station, T.dep_timestamp, T.arr_timestamp, T.train_no, T.carriage_no, T.seat_no, T.price, T.trip_date, T.duration, T.trip_type
	FROM Railway.Ticket AS T JOIN Railway.Station AS dep_station ON T.dep_station = dep_station.station_no
	JOIN Railway.Station AS arr_station ON T.arr_station = arr_station.station_no 
	WHERE T.passenger_id = @passenger_id;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_profile_picture]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_profile_picture](@passenger_id INT)
AS
	SELECT img_base64 FROM Railway.ProfilePictures WHERE passenger_id = @passenger_id;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_reserved_seats]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_reserved_seats](@trip_no INT, @trip_date DATE, @carriage_no INT)
AS
	SELECT seat_no FROM Railway.Ticket AS T WHERE T.trip_no = @trip_no AND T.trip_date = @trip_date AND T.carriage_no = @carriage_no;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_seats_no]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_seats_no](@train_no INT, @carriage_no INT)
AS
	SELECT no_seats FROM Railway.Carriage WHERE train_no = @train_no AND carriage_no = @carriage_no;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_station_no]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_station_no](@station_name VARCHAR(30))
AS
	SELECT station_no FROM Railway.Station WHERE station_name = @station_name;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_stations]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_stations]
AS
	SELECT station_name FROM Railway.Station;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_ticket_basic_info]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_ticket_basic_info](@passenger_id INT)
AS
	SELECT TOP 1 * FROM Railway.TicketBasicInfo WHERE passenger_id = @passenger_id ORDER BY trip_date;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_train_carriages]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_train_carriages](@train_no INT, @class CHAR)
AS
	SELECT carriage_no FROM Railway.Carriage WHERE train_no = @train_no AND class = @class;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_train_classes]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_train_classes](@train_no INT)
AS
	SELECT DISTINCT C.class FROM Railway.Train AS T JOIN Railway.Carriage AS C ON T.train_no = C.train_no WHERE T.train_no = @train_no;
GO
/****** Object:  StoredProcedure [Railway].[pr_get_train_no]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_get_train_no](@trip_no INT)
AS
	SELECT train_no FROM Railway.TripInstance WHERE trip_no = @trip_no;
GO
/****** Object:  StoredProcedure [Railway].[pr_insert_image]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [Railway].[pr_insert_image](@passenger_id INT, @img_base64 VARCHAR(MAX))
AS
	IF EXISTS(SELECT * FROM Railway.ProfilePictures WHERE passenger_id = @passenger_id)
		UPDATE Railway.ProfilePictures SET img_base64 = @img_base64 WHERE passenger_id = @passenger_id;
	ELSE
		INSERT INTO Railway.ProfilePictures VALUES (@img_base64, @passenger_id);
GO
/****** Object:  StoredProcedure [Railway].[pr_insert_trip_instance]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_insert_trip_instance](@trip_no INT, @trip_date DATE)
AS
	INSERT INTO Railway.TripInstance VALUES (@trip_no, @trip_date, NULL, NULL, NULL, NULL, NULL, NULL);
GO
/****** Object:  StoredProcedure [Railway].[pr_search_station]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Railway].[pr_search_station] (@station_name VARCHAR(50))
AS
BEGIN
	SELECT  tz.zone_no, tz.zone_name, st.station_name, l.locality_name, p.fname, p.lname FROM Railway.Station as st 
	JOIN Railway.TripZone AS tz ON st.zone_no = tz.zone_no
	JOIN Railway.Locality AS l ON st.station_no = l.station_no
	JOIN Railway.Employee AS emp ON st.director_no = emp.emp_no
	JOIN Railway.Person AS p ON emp.emp_id = p.id
	WHERE station_name LIKE CONCAT('%', @station_name, '%');
END
GO
/****** Object:  StoredProcedure [Railway].[pr_sign_up]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Railway].[pr_sign_up](
	@fname			VARCHAR(30),
	@lname			VARCHAR(30), 
	@birthdate		DATE, 
	@nif			INT, 
	@gender			CHAR, 
	@postal_code	VARCHAR(50),
	@city			VARCHAR(30),
	@country		VARCHAR(30),
	@phone			INT,
	@email VARCHAR(50), @pw VARCHAR(50))
AS
	INSERT INTO Railway.Person VALUES (@fname, NULL, @lname, @birthdate, @nif, @gender, @postal_code, @city, @country, @phone);
	DECLARE @passenger_id	AS INT;
	SELECT @passenger_id = p.id FROM Railway.Person As p WHERE p.nif = @nif;
	INSERT INTO Railway.Passenger VALUES (@passenger_id, @email, HASHBYTES('SHA1', @pw));
GO
/****** Object:  Trigger [Railway].[InsertTripTrigger]    Script Date: 07/06/2019 22:56:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [Railway].[InsertTripTrigger] ON [Railway].[Trip]
INSTEAD OF INSERT
AS
	BEGIN 
		IF(SELECT COUNT(*) FROM inserted) = 1
			BEGIN
				DECLARE @trip_no		AS INT;
				DECLARE @trip_type		AS VARCHAR(2);
				DECLARE @dep_timestamp	AS TIME;
				DECLARE @arr_timestamp	AS TIME;
				DECLARE @dep_station	AS INT;
				DECLARE @arr_station	AS INT;
				DECLARE @duration		AS VARCHAR(30);
				
				-- retrieve info about the inserted tuple
				SELECT 
				@trip_no = trip_no, 
				@trip_type = trip_type, 
				@dep_timestamp = dep_timestamp,
				@arr_timestamp = arr_timestamp,
				@dep_station = dep_station,
				@arr_station = arr_station
				FROM inserted;

				-- compute trip duration
				SET @duration = CONVERT(VARCHAR(5), DATEADD(MINUTE, DATEDIFF(MINUTE, @dep_timestamp, @arr_timestamp), 0), 114);
				
				-- insert the tuple in Railway.Trip table
				INSERT INTO Railway.Trip VALUES (@trip_type,@dep_timestamp,@arr_timestamp,@dep_station,@arr_station,@duration);
			END
	END
GO
ALTER TABLE [Railway].[Trip] ENABLE TRIGGER [InsertTripTrigger]
GO
/****** Object:  Trigger [Railway].[InsertTripInstanceTrigger]    Script Date: 07/06/2019 22:56:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [Railway].[InsertTripInstanceTrigger] ON [Railway].[TripInstance]
INSTEAD OF INSERT
AS
	BEGIN
		IF(SELECT COUNT(*) FROM inserted) = 1
			BEGIN
				DECLARE @trip_no		AS INT;
				DECLARE @trip_date		AS DATE;
				DECLARE @train_no		AS INT;
				DECLARE @dep_station	AS INT;
				DECLARE @arr_station	AS INT;
				DECLARE	@duration		AS TIME;
				DECLARE @dep_timestamp	AS TIME;
				DECLARE @arr_timestamp	AS TIME;
				
				-- retrieve info about the inserted tuple
				SELECT 
				@trip_no = trip_no,
				@trip_date = trip_date
				FROM inserted;

				SELECT 
				@dep_station = dep_station,
				@arr_station = arr_station,
				@duration = duration,
				@dep_timestamp = dep_timestamp,
				@arr_timestamp = arr_timestamp
				FROM Railway.Trip WHERE trip_no = @trip_no;

				-- assign the train to the trip

				-- urbano/regional
				IF (1 <= @trip_no AND @trip_no <= 3) OR (86 <= @trip_no AND @trip_no <= 88) 
				OR (165 <= @trip_no AND @trip_no <= 167) OR (250 <= @trip_no AND @trip_no <= 252) 
				OR (329 <= @trip_no AND @trip_no <= 331) 
					BEGIN 
						SET @train_no = 1;
					END

				ELSE IF (4 <= @trip_no AND @trip_no <= 6) OR (83 <= @trip_no AND @trip_no <= 85) 
				OR (168 <= @trip_no AND @trip_no <= 170) OR (247 <= @trip_no AND @trip_no <= 249)
				OR (332 <= @trip_no AND @trip_no <= 334) 
					BEGIN
						SET @train_no = 2;
					END

				ELSE IF (7 <= @trip_no AND @trip_no <= 34) OR (117 <= @trip_no AND @trip_no <= 144) 
				OR (171 <= @trip_no AND @trip_no <= 198) OR (281 <= @trip_no AND @trip_no <= 308)
				OR (335 <= @trip_no AND @trip_no <= 362) 
					BEGIN
						SET @train_no = 3;
					END

				ELSE IF (35 <= @trip_no AND @trip_no <= 62) OR (89 <= @trip_no AND @trip_no <= 116) 
				OR (199 <= @trip_no AND @trip_no <= 226) OR (253 <= @trip_no AND @trip_no <= 280)
				OR (363 <= @trip_no AND @trip_no <= 390) 
					BEGIN
						SET @train_no = 4;
					END

				ELSE IF (63 <= @trip_no AND @trip_no <= 72) OR (155 <= @trip_no AND @trip_no <= 164) 
				OR (227 <= @trip_no AND @trip_no <= 236) OR (319 <= @trip_no AND @trip_no <= 328)
				OR (391 <= @trip_no AND @trip_no <= 400) 
					BEGIN
						SET @train_no = 5;
					END

				ELSE IF (73 <= @trip_no AND @trip_no <= 82) OR (145 <= @trip_no AND @trip_no <= 154) 
				OR (237 <= @trip_no AND @trip_no <= 246) OR (309 <= @trip_no AND @trip_no <= 318)
				OR (401 <= @trip_no AND @trip_no <= 410) 
					BEGIN
						SET @train_no = 6;
					END
				
				-- intercidades
				ELSE IF (411 <= @trip_no AND @trip_no <= 501) OR (816 <= @trip_no AND @trip_no <= 906) 
				OR (1039 <= @trip_no AND @trip_no <= 1129)
					BEGIN
						SET @train_no = 13;
					END

				ELSE IF (502 <= @trip_no AND @trip_no <= 592) OR (725 <= @trip_no AND @trip_no <= 815) 
				OR (1130 <= @trip_no AND @trip_no <= 1220)
					BEGIN
						SET @train_no = 14;
					END

				ELSE IF (593 <= @trip_no AND @trip_no <= 658) OR (973 <= @trip_no AND @trip_no <= 1038) 
				OR (1221 <= @trip_no AND @trip_no <= 1286)
					BEGIN
						SET @train_no = 15;
					END

				ELSE IF (659 <= @trip_no AND @trip_no <= 724) OR (907 <= @trip_no AND @trip_no <= 972) 
				OR (1287 <= @trip_no AND @trip_no <= 1352)
					BEGIN
						SET @train_no = 16;
					END

				-- alfa-pendular
				ELSE IF (1353 <= @trip_no AND @trip_no <= 1367) SET @train_no = 21;
				ELSE IF (1368 <= @trip_no AND @trip_no <= 1382) SET @train_no = 22;
				ELSE IF (1383 <= @trip_no AND @trip_no <= 1397) SET @train_no = 23;
				ELSE IF (1398 <= @trip_no AND @trip_no <= 1412) SET @train_no = 24;

				-- mercadorias
				ELSE IF (1413 <= @trip_no AND @trip_no <= 1427) SET @train_no = 26;
				ELSE IF (1428 <= @trip_no AND @trip_no <= 1442) SET @train_no = 27;
				ELSE IF (1443 <= @trip_no AND @trip_no <= 1457) SET @train_no = 28;
				ELSE IF (1458 <= @trip_no AND @trip_no <= 1475) SET @train_no = 29;

				INSERT INTO Railway.TripInstance VALUES (@trip_no, @trip_date, @train_no, @dep_station, @arr_station, @duration, @dep_timestamp, @arr_timestamp);
			END
	END
GO
ALTER TABLE [Railway].[TripInstance] ENABLE TRIGGER [InsertTripInstanceTrigger]
GO
USE [master]
GO
ALTER DATABASE [p6g10] SET  READ_WRITE 
GO
