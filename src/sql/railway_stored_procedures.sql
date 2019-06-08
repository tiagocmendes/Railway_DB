USE p6g10;
GO

ALTER PROC Railway.pr_sign_up(
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

ALTER PROC Railway.pr_get_stations
AS
	SELECT station_name FROM Railway.Station;
GO

ALTER PROC Railway.pr_insert_trip_instance(@trip_no INT, @trip_date DATE)
AS
	INSERT INTO Railway.TripInstance VALUES (@trip_no, @trip_date, NULL, NULL, NULL, NULL, NULL, NULL);
GO

ALTER PROC Railway.pr_get_train_no(@trip_no INT)
AS
	SELECT train_no FROM Railway.TripInstance WHERE trip_no = @trip_no;
GO

ALTER PROC Railway.pr_get_train_classes(@train_no INT)
AS
	SELECT DISTINCT C.class FROM Railway.Train AS T JOIN Railway.Carriage AS C ON T.train_no = C.train_no WHERE T.train_no = @train_no;
GO

ALTER PROC Railway.pr_get_train_carriages(@train_no INT, @class CHAR)
AS
	SELECT carriage_no FROM Railway.Carriage WHERE train_no = @train_no AND class = @class;
GO

ALTER PROC Railway.pr_get_seats_no(@train_no INT, @carriage_no INT)
AS
	SELECT no_seats FROM Railway.Carriage WHERE train_no = @train_no AND carriage_no = @carriage_no;
GO

ALTER PROC Railway.pr_get_reserved_seats(@trip_no INT, @trip_date DATE, @carriage_no INT)
AS
	SELECT seat_no FROM Railway.Ticket AS T WHERE T.trip_no = @trip_no AND T.trip_date = @trip_date AND T.carriage_no = @carriage_no;
GO

ALTER PROC Railway.pr_get_discount(@promocode VARCHAR(10))
AS
	SELECT discount FROM Railway.Discount WHERE promocode = @promocode;
GO

ALTER PROC Railway.pr_get_station_no(@station_name VARCHAR(30))
AS
	SELECT station_no FROM Railway.Station WHERE station_name = @station_name;
GO

ALTER PROC Railway.get_next_ticket_no
AS
	SELECT IDENT_CURRENT ('Railway.Ticket'); 
GO

ALTER PROC Railway.pr_buy_ticket(
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

ALTER PROC Railway.pr_get_ticket_basic_info(@passenger_id INT)
AS
	SELECT * FROM Railway.TicketBasicInfo WHERE passenger_id = @passenger_id;
GO

ALTER PROC Railway.pr_get_passenger_tickets(@passenger_id INT)
AS
	SELECT T.ticket_no, dep_station.station_name AS dep_station, arr_station.station_name AS arr_station, T.dep_timestamp, T.arr_timestamp, T.train_no, T.carriage_no, T.seat_no, T.price, T.trip_date, T.duration, T.trip_type
	FROM Railway.Ticket AS T JOIN Railway.Station AS dep_station ON T.dep_station = dep_station.station_no
	JOIN Railway.Station AS arr_station ON T.arr_station = arr_station.station_no 
	WHERE T.passenger_id = @passenger_id;
GO

ALTER PROC Railway.pr_get_default_picture(@id INT)
AS
	SELECT img_base64 FROM Railway.ProfilePictures WHERE id = @id;
GO

ALTER PROC Railway.pr_get_profile_picture(@passenger_id INT)
AS
	SELECT img_base64 FROM Railway.ProfilePictures WHERE passenger_id = @passenger_id;
GO


ALTER PROC Railway.pr_insert_image(@passenger_id INT, @img_base64 VARCHAR(MAX))
AS
	IF EXISTS(SELECT * FROM Railway.ProfilePictures WHERE passenger_id = @passenger_id)
		UPDATE Railway.ProfilePictures SET img_base64 = @img_base64 WHERE passenger_id = @passenger_id;
	ELSE
		INSERT INTO Railway.ProfilePictures VALUES (@img_base64, @passenger_id);
GO

ALTER PROC Railway.pr_delete_profile (	@user_id INT,
										@nif INT)
AS
BEGIN
	DELETE FROM Railway.Ticket WHERE nif = @nif;
	DELETE FROM Railway.Passenger WHERE passenger_id = @user_id;
	DELETE FROM Railway.Person WHERE id = @user_id;
END
GO

ALTER PROC Railway.pr_edit_profile	@email VARCHAR(50), 
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
	IF NOT (@fname LIKE 'NULL')
		UPDATE Railway.Person SET fname = @fname WHERE nif = @nif;
	-- Change lname
	IF NOT (@lname LIKE 'NULL')
		UPDATE Railway.Person SET lname = @lname WHERE nif = @nif;
	-- Change gender
	IF NOT (@gender LIKE 'N')
		UPDATE Railway.Person SET gender = @gender WHERE nif = @nif;
	-- Change postal code
	IF NOT (@postal_code LIKE 'NULL')
		UPDATE Railway.Person SET postal_code = @postal_code WHERE nif = @nif;
	-- Change city
	IF NOT (@city LIKE 'NULL')
		UPDATE Railway.Person SET city = @city WHERE nif = @nif;
	-- Change country
	IF NOT (@country LIKE 'NULL')
		UPDATE Railway.Person SET country = @country WHERE nif = @nif;
	-- Change phone
	IF NOT (@phone = 0)
		UPDATE Railway.Person SET phone = @phone WHERE nif = @nif;
	-- Change password
	IF NOT (@new_password LIKE 'NULL')
		UPDATE Railway.Passenger SET pw = HASHBYTES('SHA1', @new_password) WHERE email = @email;
END
GO

ALTER PROC Railway.pr_forgot_password (@email VARCHAR(50),
										@password VARCHAR(50))
AS
BEGIN
	UPDATE Railway.Passenger SET email = @email WHERE email = @email;
	UPDATE Railway.Passenger SET pw = HASHBYTES('SHA1', @password) WHERE email = @email;
END
GO

ALTER PROC Railway.pr_search_station (@station_name VARCHAR(50))
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



