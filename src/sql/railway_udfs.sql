USE p6g10;
GO

-- Login functions
ALTER FUNCTION Railway.f_check_login (@email VARCHAR(50)) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Passenger AS p WHERE p.email = @email)
		RETURN 1;
	RETURN 0;
END
GO

ALTER FUNCTION Railway.f_check_password (@email VARCHAR(50), @password VARCHAR(50)) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Passenger AS p WHERE p.email = @email AND p.pw = HASHBYTES('SHA1',@password))
		RETURN 1;
	RETURN 0;
END 
GO

ALTER FUNCTION Railway.f_return_login (@email VARCHAR(50), @password VARCHAR(50)) RETURNS Table
AS
	RETURN (SELECT * FROM Railway.Person AS person JOIN Railway.Passenger As passenger ON person.id = passenger.passenger_id
		WHERE passenger.email = @email AND passenger.pw = HASHBYTES('SHA1', @password))
GO

-- Sign up functions
ALTER FUNCTION Railway.f_check_nif(@nif INT) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Person AS p WHERE p.nif = @nif)
		RETURN 1;
	RETURN 0;
END
GO


ALTER FUNCTION Railway.trip_price (@trip_type VARCHAR(2), @dep_station VARCHAR(30), @arr_station VARCHAR(30)) RETURNS SMALLMONEY
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

ALTER FUNCTION Railway.f_get_trips(@dep_station_name VARCHAR(30), @arr_station_name VARCHAR(30)) RETURNS @table TABLE 
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


SELECT * FROM Railway.f_get_trips('Viana do Castelo', 'Porto - São Bento');


