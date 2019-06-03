USE p6g10;
GO
/*
ALTER PROC Railway.pr_get_trip (@dep_station INT, @arr_station INT)
AS
	SELECT trip.trip_no, trip.trip_type, trip.dep_timestamp, trip.arr_timestamp, trip.duration,
	dep_station.station_name, arr_station.station_name, dep_station.zone_no, arr_station.zone_no
	FROM Railway.Trip AS trip JOIN Railway.Station AS dep_station ON trip.dep_station = dep_station.station_no
	JOIN Railway.Station AS arr_station ON trip.arr_station = arr_station.station_no
	WHERE dep_station = @dep_station AND arr_station = @arr_station;
GO


EXEC Railway.pr_get_trip 1,2
*/

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

--exec Railway.pr_sign_up 'Tiago', 'Mendes', '1999-01-17', 123456789, 'M', '3515', 'Viseu', 'Portugal',966035286,'tiagocmendes@ua.pt', 'ola';
-- exec Railway.pr_get_stations;