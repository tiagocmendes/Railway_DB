
CREATE VIEW Railway.TicketBasicInfo AS
SELECT TOP 1 dep_sta.station_name AS dep_station, arr_sta.station_name AS arr_station, T.dep_timestamp, T.arr_timestamp, T.trip_date, T.passenger_id
FROM Railway.Ticket AS T JOIN Railway.Station AS dep_sta on T.dep_station = dep_sta.station_no
JOIN Railway.Station AS arr_sta on T.arr_station = arr_sta.station_no
ORDER BY T.trip_date;