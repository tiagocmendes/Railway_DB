USE p6g10;
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

