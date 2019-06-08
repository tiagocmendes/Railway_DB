USE p6g10;
GO

/* Create Railway database tables */

CREATE TABLE Railway.Person (
	id				INT				IDENTITY(100000001,1)	NOT NULL,
	fname			VARCHAR(30)		NOT NULL,
	mname			VARCHAR(30),
	lname			VARCHAR(30)		NOT NULL,
	birthdate		DATE			NOT NULL,
	nif				INT				NOT NULL	CHECK(nif >= 100000000 AND nif <= 999999999),
	gender			CHAR			NOT NULL	CHECK(gender = 'M' OR gender = 'F'),
	postal_code		VARCHAR(50)		NOT NULL,
	city			VARCHAR(30)		NOT NULL,
	country			VARCHAR(30)		NOT NULL,
	phone			INT							CHECK(phone >= 900000000 AND phone <= 999999999),
	PRIMARY KEY(id),
	UNIQUE(nif)
);

CREATE TABLE Railway.Passenger (
	passenger_id	INT				NOT	NULL	CHECK(passenger_id > 100000000),
	email			VARCHAR(50)		NOT NULL	CHECK(email LIKE '%@%' AND email LIKE '%.%'),
	pw				VARCHAR(50)		NOT NULL	CHECK(LEN(pw) > 0),
	PRIMARY KEY(passenger_id),
	UNIQUE(email)
);

CREATE TABLE Railway.Employee (
	emp_no			INT		IDENTITY(101,1)		NOT	NULL	CHECK(emp_no > 0),
	emp_id			INT							NOT NULL	CHECK(emp_id > 0),
	emp_role		VARCHAR(30),
	station_no		INT							NOT	NULL	CHECK(station_no > 0),
	PRIMARY KEY(emp_id),
	UNIQUE(emp_no)
);

CREATE TABLE Railway.Ticket (
	ticket_no			INT			IDENTITY(100,1)	NOT	NULL,
	nif					INT			NOT NULL	CHECK(nif >= 100000000 AND nif < 999999999),
	dep_station			INT			NOT	NULL	CHECK(dep_station > 0),
	arr_station			INT			NOT	NULL	CHECK(arr_station > 0),
	dep_timestamp		TIME		NOT	NULL,
	arr_timestamp		TIME		NOT	NULL,
	train_no			INT			NOT	NULL	CHECK(train_no > 0),
	carriage_no			INT			NOT	NULL	CHECK(carriage_no > 0),
	seat_no				INT			NOT NULL	CHECK(seat_no > 0),
	price				SMALLMONEY	NOT	NULL	CHECK(price > 0),
	trip_no				INT			NOT	NULL	CHECK(trip_no > 0),	
	trip_date			DATE		NOT	NULL,
	passenger_id		INT			NOT NULL	CHECK(passenger_id > 0),
	PRIMARY KEY(ticket_no)
);

CREATE TABLE Railway.Trip (
	trip_no				INT				IDENTITY(1,1)	NOT	NULL	CHECK(trip_no > 0),
	trip_type			VARCHAR(2)		NOT	NULL,
	dep_timestamp		TIME			NOT	NULL,
	arr_timestamp		TIME			NOT	NULL,
	dep_station			INT				NOT	NULL	CHECK(dep_station > 0),
	arr_station			INT				NOT	NULL	CHECK(arr_station > 0),
	duration			TIME,
	PRIMARY KEY(trip_no)
);

CREATE TABLE Railway.TripInstance (
	trip_no				INT			NOT	NULL	CHECK(trip_no > 0),	
	trip_date			DATE		NOT	NULL,
	train_no			INT,
	dep_station			INT,
	arr_station			INT,
	duration			TIME,
	dep_timestamp		TIME,
	arr_timestamp		TIME,
	PRIMARY KEY(trip_no, trip_date)
);

CREATE TABLE Railway.Station (
	station_no		INT				IDENTITY(1,1)		NOT NULL		CHECK(station_no > 0),
	station_name	VARCHAR(30)		NOT	NULL,
	zone_no			INT				NOT NULL,
	-- Add later director_no	INT		NOT NULL	CHECK(director_no > 0),
	PRIMARY KEY(station_no),
	--, UNIQUE(director_no)
);

CREATE TABLE Railway.Train (
	train_no		INT			IDENTITY(1,1)			NOT	NULL	CHECK(train_no > 0),
	no_carriages	INT			NOT	NULL	CHECK(no_carriages > 0),
	total_seats		INT			NOT	NULL	CHECK(total_seats >= 0),
	category		VARCHAR(2)	NOT	NULL,
	PRIMARY	KEY(train_no)
);

CREATE TABLE Railway.Carriage (
	carriage_no		INT		NOT	NULL	CHECK(carriage_no > 0),
	train_no		INT		NOT	NULL	CHECK(train_no	> 0),
	no_seats		INT		NOT	NULL	CHECK(no_seats >= 0),
	class			CHAR	NOT	NULL	CHECK(class = 'C' OR class = 'E' OR class = 'M'),
	PRIMARY KEY(carriage_no, train_no)
);

CREATE TABLE Railway.TrainType (
	category		VARCHAR(2)	NOT NULL,
	designation		VARCHAR(30)	NOT	NULL,
	PRIMARY KEY(category)
);

CREATE TABLE Railway.StopsAt (
	station_no		INT				NOT	NULL,		CHECK(station_no > 0),
	category		VARCHAR(2)		NOT	NULL,
	PRIMARY KEY(station_no, category)
);

CREATE TABLE Railway.ConnectsTo (
	dep_station			INT				NOT	NULL	CHECK(dep_station > 0),
	arr_station			INT				NOT	NULL	CHECK(arr_station > 0),
	PRIMARY KEY(dep_station, arr_station)
);

CREATE TABLE Railway.Locality(
	locality_name		VARCHAR(30)		NOT	NULL,
	station_no			INT				NOT	NULL,		CHECK(station_no > 0),
	PRIMARY	KEY(locality_name, station_no)
);

CREATE TABLE Railway.TripZone (
	zone_no				INT		IDENTITY(1,1)	NOT	NULL,
	zone_name			VARCHAR(30)				NOT	NULL,	
	priceUR				SMALLMONEY				NOT	NULL	CHECK(priceUR >= 0),
	priceIC				SMALLMONEY				NOT	NULL	CHECK(priceIC >= 0),
	priceAP				SMALLMONEY				NOT	NULL	CHECK(priceAP >= 0),
	PRIMARY	KEY (zone_no),
	UNIQUE(zone_name)
);

/* Add foreign keys to the tables */

ALTER TABLE	Railway.Passenger
ADD CONSTRAINT c1	
FOREIGN KEY (passenger_id) REFERENCES Railway.Person(id);

ALTER TABLE Railway.Employee
ADD CONSTRAINT c2
FOREIGN KEY (emp_id) REFERENCES Railway.Person(id);

ALTER TABLE Railway.Employee
ADD CONSTRAINT c3
FOREIGN KEY (station_no) REFERENCES Railway.Station(station_no);

ALTER TABLE Railway.Ticket
ADD CONSTRAINT c4
FOREIGN KEY (passenger_id) REFERENCES Railway.Passenger(passenger_id);

ALTER TABLE Railway.Ticket
ADD CONSTRAINT c5
FOREIGN KEY (trip_no, trip_date) REFERENCES Railway.TripInstance(trip_no, trip_date);

ALTER TABLE Railway.TripInstance
ADD CONSTRAINT c6
FOREIGN KEY (trip_no) REFERENCES Railway.Trip(trip_no);

ALTER TABLE Railway.TripInstance
ADD CONSTRAINT c7
FOREIGN KEY (dep_station) REFERENCES Railway.Station(station_no);

ALTER TABLE Railway.TripInstance
ADD CONSTRAINT c8
FOREIGN KEY (arr_station) REFERENCES Railway.Station(station_no);

ALTER TABLE Railway.TripInstance
ADD CONSTRAINT c9
FOREIGN KEY (train_no) REFERENCES Railway.Train(train_no);

-- Add later

ALTER TABLE Railway.Trip
ADD CONSTRAINT c10
FOREIGN KEY (dep_station) REFERENCES Railway.Station(station_no);

ALTER TABLE Railway.Trip
ADD CONSTRAINT c11
FOREIGN KEY (arr_station) REFERENCES Railway.Station(station_no);

-- Add later
/*
ALTER TABLE Railway.Station
ADD CONSTRAINT c12
FOREIGN KEY (director_no) REFERENCES Railway.Employee(emp_no);
*/

ALTER TABLE Railway.Train
ADD CONSTRAINT c13
FOREIGN KEY (category) REFERENCES Railway.TrainType(category);

ALTER TABLE Railway.Carriage
ADD CONSTRAINT c14
FOREIGN KEY (train_no) REFERENCES Railway.Train(train_no);

ALTER TABLE Railway.StopsAt
ADD CONSTRAINT c15
FOREIGN KEY (station_no) REFERENCES Railway.Station(station_no);

ALTER TABLE Railway.StopsAt
ADD CONSTRAINT c16
FOREIGN KEY (category) REFERENCES Railway.TrainType(category);

ALTER TABLE Railway.Locality
ADD CONSTRAINT c17
FOREIGN KEY (station_no) REFERENCES Railway.Station(station_no);

ALTER TABLE Railway.ConnectsTo
ADD CONSTRAINT c18
FOREIGN KEY (dep_station) REFERENCES Railway.Station(station_no);

ALTER TABLE Railway.ConnectsTo
ADD CONSTRAINT c19
FOREIGN KEY (arr_station) REFERENCES Railway.Station(station_no);

ALTER TABLE Railway.Station
ADD CONSTRAINT c20
FOREIGN KEY (zone_no) REFERENCES Railway.TripZone(zone_no);

CREATE TABLE Railway.ProfilePictures (
	id				INT			IDENTITY(1,1),
	img_base64		VARCHAR(MAX),
	passenger_id	INT,
	PRIMARY KEY (id)
);

ALTER TABLE Railway.ProfilePictures
ADD CONSTRAINT c21
FOREIGN KEY (passenger_id) REFERENCES Railway.Passenger;

CREATE TABLE promocode (
		id INT IDENTITY(1,1), 
		promocode VARCHAR(10),
		discount VARCHAR(4)
		PRIMARY KEY (id), 
		UNIQUE (promocode)
);

