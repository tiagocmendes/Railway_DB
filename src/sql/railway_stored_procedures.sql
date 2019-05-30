USE Railway;
GO

ALTER PROC Railway.pr_get_trip (@dep_station INT, @arr_station INT)
AS
	SELECT trip.trip_no, trip.trip_type, trip.dep_timestamp, trip.arr_timestamp, trip.duration,
	dep_station.station_name, arr_station.station_name, dep_station.zone_no, arr_station.zone_no
	FROM Railway.Trip AS trip JOIN Railway.Station AS dep_station ON trip.dep_station = dep_station.station_no
	JOIN Railway.Station AS arr_station ON trip.arr_station = arr_station.station_no
	WHERE dep_station = @dep_station AND arr_station = @arr_station;
GO


EXEC Railway.pr_get_trip 1,2
