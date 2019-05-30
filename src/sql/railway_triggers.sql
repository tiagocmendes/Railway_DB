USE p6g10;
GO

CREATE TRIGGER Railway.InsertTripTrigger ON Railway.Trip
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


ALTER TRIGGER Railway.InsertTripInstanceTrigger ON Railway.TripInstance
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
