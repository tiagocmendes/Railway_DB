USE Railway;
GO

CREATE TABLE RAILWAY.PERSON (
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

CREATE TABLE RAILWAY.PASSENGER(
	passenger_id	INT				NOT	NULL	CHECK(passenger_id > 0),
	email			VARCHAR(30)		NOT NULL	CHECK(email LIKE '%@%' AND email LIKE '%.%'),
	pw				VARCHAR(30)		NOT NULL	CHECK(LEN(pw) > 0),
	PRIMARY KEY(passenger_id),
	UNIQUE(email)
);

CREATE TABLE RAILWAY.EMPLOYEE(
	emp_no			INT		IDENTITY(101,1)		NOT	NULL	CHECK(emp_no > 0),
	emp_id			INT							NOT NULL	CHECK(emp_id > 0),
	emp_role		VARCHAR(30),
	station_no		INT							NOT	NULL	CHECK(station_no > 0),
	PRIMARY KEY(emp_id),
	UNIQUE(emp_no)
);

CREATE TABLE RAILWAY.TICKET(
	ticket_no			INT			IDENTITY(100,1)	NOT	NULL,
	nif					INT			NOT NULL	CHECK(nif >= 100000000 AND nif < 999999999),
	dep_station			INT			NOT	NULL	CHECK(dep_station > 0),
	arr_station			INT			NOT	NULL	CHECK(arr_station > 0),
	dep_timestamp		DATETIME	NOT	NULL,
	arr_timestamp		DATETIME	NOT	NULL,
	train_no			INT			NOT	NULL	CHECK(train_no > 0),
	carriage_no			INT			NOT	NULL	CHECK(carriage_no > 0),
	seat_no				INT			NOT NULL	CHECK(seat_no > 0),
	price				SMALLMONEY	NOT	NULL	CHECK(price > 0),
	trip_no				INT			NOT	NULL	CHECK(trip_no > 0),	
	trip_date			DATE		NOT	NULL,
	passenger_id		INT			NOT NULL	CHECK(passenger_id > 0),
	PRIMARY KEY(ticket_no)
);

CREATE TABLE RAILWAY.TRIP_INSTANCE(
	trip_no				INT			IDENTITY(1,1)	NOT	NULL	CHECK(trip_no > 0),	
	trip_date			DATE		NOT	NULL,
	dep_station			INT			NOT	NULL	CHECK(dep_station > 0),
	arr_station			INT			NOT	NULL	CHECK(arr_station > 0),
	dep_timestamp		DATETIME	NOT	NULL,
	arr_timestamp		DATETIME	NOT	NULL,
	train_no			INT			NOT	NULL	CHECK(train_no > 0),
	PRIMARY KEY(trip_no, trip_date)
);

CREATE TABLE RAILWAY.TRIP(
	trip_no				INT				IDENTITY(1,1)	NOT	NULL	CHECK(trip_no > 0),
	[weekday]			VARCHAR(15)		NOT	NULL,
	trip_type			VARCHAR(2)		NOT	NULL,
	dep_timestamp		TIME			NOT	NULL,
	arr_timestamp		TIME			NOT	NULL,
	dep_station			INT				NOT	NULL	CHECK(dep_station > 0),
	arr_station			INT				NOT	NULL	CHECK(arr_station > 0),
	PRIMARY KEY(trip_no)
);

CREATE TABLE RAILWAY.STATION(
	station_no		INT				NOT	NULL,		CHECK(station_no > 0),
	station_name	VARCHAR(30)		NOT	NULL,
	zone_name		VARCHAR(30)		NOT NULL,
	-- ADD LATER
	-- director_no		INT				NOT NULL		CHECK(director_no > 0),
	PRIMARY	KEY(station_no),
	UNIQUE(station_name),
	-- UNIQUE(director_no)
);

CREATE TABLE RAILWAY.TRAIN(
	train_no		INT			IDENTITY(1,1)			NOT	NULL	CHECK(train_no > 0),
	no_carriages	INT			NOT	NULL	CHECK(no_carriages > 0),
	total_seats		INT			NOT	NULL	CHECK(total_seats >= 0),
	category		VARCHAR(2)	NOT	NULL,
	PRIMARY	KEY(train_no)
);

CREATE TABLE RAILWAY.CARRIAGE(
	carriage_no		INT		NOT	NULL	CHECK(carriage_no > 0),
	train_no		INT		NOT	NULL	CHECK(train_no	> 0),
	no_seats		INT		NOT	NULL	CHECK(no_seats >= 0),
	class			CHAR	NOT	NULL	CHECK(class = 'C' OR class = 'E' OR class = 'M'),
	PRIMARY KEY(carriage_no, train_no)
);

CREATE TABLE RAILWAY.TRAIN_TYPE(
	category	VARCHAR(2)	NOT	NULL,
	designation	VARCHAR(30)	NOT NULL,
	PRIMARY KEY(category)
);

CREATE TABLE RAILWAY.STOPS_AT(
	station_no		INT				NOT	NULL,		CHECK(station_no > 0),
	station_name	VARCHAR(30)		NOT NULL,
	category		VARCHAR(2)		NOT	NULL,
	PRIMARY KEY(station_no, category)
);

CREATE TABLE RAILWAY.LOCALITY(
	locality_name		VARCHAR(30)		NOT	NULL,
	station_no			INT				NOT	NULL,		CHECK(station_no > 0),
	PRIMARY	KEY(locality_name, station_no)
);

CREATE TABLE RAILWAY.CONNECTS_TO(
	dep_station			INT				NOT	NULL	CHECK(dep_station > 0),
	arr_station			INT				NOT	NULL	CHECK(arr_station > 0),
	dep_name			VARCHAR(30)		NOT NULL,
	arr_name			VARCHAR(30)		NOT NULL,
	PRIMARY KEY(dep_station, arr_station)
);

CREATE TABLE RAILWAY.TRIP_ZONE(
	zone_no				INT		IDENTITY(1,1)	NOT	NULL,
	zone_name			VARCHAR(30)				NOT	NULL,	
	priceUR				SMALLMONEY				NOT	NULL	CHECK(priceUR >= 0),
	priceIC				SMALLMONEY				NOT	NULL	CHECK(priceIC >= 0),
	priceAP				SMALLMONEY				NOT	NULL	CHECK(priceAP >= 0),
	PRIMARY	KEY (zone_no),
	UNIQUE(zone_name)
);

ALTER TABLE	RAILWAY.PASSENGER
ADD CONSTRAINT c1	
FOREIGN KEY (passenger_id) REFERENCES RAILWAY.PERSON(id);

ALTER TABLE RAILWAY.EMPLOYEE
ADD CONSTRAINT c2
FOREIGN KEY (emp_id) REFERENCES RAILWAY.PERSON(id);

ALTER TABLE RAILWAY.EMPLOYEE
ADD CONSTRAINT c3
FOREIGN KEY (station_no) REFERENCES RAILWAY.STATION(station_no);

ALTER TABLE RAILWAY.TICKET
ADD CONSTRAINT c4
FOREIGN KEY (passenger_id) REFERENCES RAILWAY.PASSENGER(passenger_id);

ALTER TABLE RAILWAY.TICKET
ADD CONSTRAINT c5
FOREIGN KEY (trip_no,trip_date) REFERENCES RAILWAY.TRIP_INSTANCE(trip_no,trip_date);

ALTER TABLE RAILWAY.TRIP_INSTANCE
ADD CONSTRAINT c7
FOREIGN KEY (trip_no) REFERENCES RAILWAY.TRIP(trip_no);

ALTER TABLE RAILWAY.TRIP_INSTANCE
ADD CONSTRAINT c8
FOREIGN KEY (dep_station) REFERENCES RAILWAY.STATION(station_no);

ALTER TABLE RAILWAY.TRIP_INSTANCE
ADD CONSTRAINT c9
FOREIGN KEY (arr_station) REFERENCES RAILWAY.STATION(station_no);

ALTER TABLE RAILWAY.TRIP_INSTANCE
ADD CONSTRAINT c10
FOREIGN KEY (train_no) REFERENCES RAILWAY.TRAIN(train_no);

ALTER TABLE RAILWAY.TRIP
ADD CONSTRAINT c11
FOREIGN KEY (dep_station) REFERENCES RAILWAY.STATION(station_no);

ALTER TABLE RAILWAY.TRIP
ADD CONSTRAINT c12
FOREIGN KEY (arr_station) REFERENCES RAILWAY.STATION(station_no);

/* ADD LATER
ALTER TABLE RAILWAY.STATION
ADD CONSTRAINT c13
FOREIGN KEY (director_no) REFERENCES RAILWAY.EMPLOYEE(emp_no);
*/

ALTER TABLE RAILWAY.TRAIN
ADD CONSTRAINT c14
FOREIGN KEY (category) REFERENCES RAILWAY.TRAIN_TYPE(category);

ALTER TABLE RAILWAY.CARRIAGE
ADD CONSTRAINT c15
FOREIGN KEY (train_no) REFERENCES RAILWAY.TRAIN(train_no);

ALTER TABLE RAILWAY.STOPS_AT
ADD CONSTRAINT c16
FOREIGN KEY (station_no) REFERENCES RAILWAY.STATION(station_no);

ALTER TABLE RAILWAY.STOPS_AT
ADD CONSTRAINT c17
FOREIGN KEY (category) REFERENCES RAILWAY.TRAIN_TYPE(category);

ALTER TABLE RAILWAY.LOCALITY
ADD CONSTRAINT c18
FOREIGN KEY (station_no) REFERENCES RAILWAY.STATION(station_no);

ALTER TABLE RAILWAY.CONNECTS_TO
ADD CONSTRAINT c19
FOREIGN KEY (dep_station) REFERENCES RAILWAY.STATION(station_no);

ALTER TABLE RAILWAY.CONNECTS_TO
ADD CONSTRAINT c20
FOREIGN KEY (arr_station) REFERENCES RAILWAY.STATION(station_no);

ALTER TABLE RAILWAY.STATION
ADD CONSTRAINT c21
FOREIGN KEY (zone_name) REFERENCES RAILWAY.TRIP_ZONE(zone_name);
