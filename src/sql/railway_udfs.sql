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


ALTER FUNCTION Railway.trip_price (@trip_type VARCHAR(2), @dep_station INT, @arr_station INT) RETURNS SMALLMONEY
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
		WHERE trip.trip_type = @trip_type AND dep.station_no = @dep_station AND arr.station_no = @arr_station;

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

SELECT Railway.trip_price ('AP',16,1);

