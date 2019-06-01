USE Railway;
GO

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

SELECT Railway.trip_price(1,5);