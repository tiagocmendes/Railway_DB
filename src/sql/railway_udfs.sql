USE p6g10;
GO

ALTER FUNCTION Railway.check_login (@email VARCHAR(50)) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Passenger AS p WHERE p.email = @email)
		RETURN 1;
	RETURN 0;
END
GO

ALTER FUNCTION Railway.check_password (@email VARCHAR(50), @password VARCHAR(50)) RETURNS INT
AS
BEGIN
	IF EXISTS(SELECT * FROM Railway.Passenger AS p WHERE p.email = @email AND p.pw = HASHBYTES('SHA1',@password))
		RETURN 1;
	RETURN 0;
END 
GO


ALTER FUNCTION Railway.return_login (@email VARCHAR(50), @password VARCHAR(50)) RETURNS Table
AS
	RETURN (SELECT * FROM Railway.Person AS person JOIN Railway.Passenger As passenger ON person.id = passenger.passenger_id + 1
		WHERE passenger.email = @email AND passenger.pw = HASHBYTES('SHA1', @password))
GO


--SELECT Railway.check_login ('daenerys_sim�aes@ua.pt');
--SELECT Railway.check_password ('daenerys_sim�es@ua.pt','9N7OhqtvPA39GVx0J05fi');
--select * from Railway.return_login ('daenerys_sim�es@ua.pt','9N7OhqtvPA39GVx0J05fi');

/*
ALTER FUNCTION Railway.trip_price (@dep_station INT, @arr_station INT) RETURNS SMALLMONEY
AS
	BEGIN
		
		DECLARE @dep_zone		AS INT;
		DECLARE @arr_zone		AS INT;
		DECLARE @trip_type		AS VARCHAR(2);

		SELECT 
		@trip_type = trip.trip_type, 
		@dep_zone = dstation.zone_no, 
		@arr_zone = astation.zone_no
		FROM Railway.Trip AS trip 
		JOIN Railway.Station AS dstation ON trip.dep_station = dstation.station_no
		JOIN Railway.Station AS astation ON trip.arr_station = astation.station_no
		WHERE dstation.station_no = @dep_station AND astation.station_no = @arr_station;

		

		IF (@arr_zone < @dep_zone)
			BEGIN
				DECLARE @aux	AS INT;
				SET @aux = @arr_zone;
				SET @arr_zone = @dep_zone;
				SET @dep_zone = @aux;
			END

		DECLARE @price			AS SMALLMONEY;
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
		END;

		IF (@trip_type = 'UR')
			SELECT @price = (@price + priceUR)
			FROM Railway.TripZone
			WHERE zone_no = @arr_zone;

		RETURN @price;
		
	END
GO
*/
