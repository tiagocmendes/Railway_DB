'''
    CREATE TABLE Railway.Trip (
	trip_no				INT				IDENTITY(1,1)	NOT	NULL	CHECK(trip_no > 0),
	trip_type			VARCHAR(2)		NOT	NULL,
	dep_timestamp		TIME			NOT	NULL,
	arr_timestamp		TIME			NOT	NULL,
	dep_station			INT				NOT	NULL	CHECK(dep_station > 0),
	arr_station			INT				NOT	NULL	CHECK(arr_station > 0),
	PRIMARY KEY(trip_no)
);

CREATE TABLE RAILWAY.TripInstance (
	trip_no				INT			IDENTITY(1,1)	NOT	NULL	CHECK(trip_no > 0),	
	trip_date			DATE		NOT	NULL,
	dep_station			INT,
	arr_station			INT,
	duration			TIME,
	dep_timestamp		TIME,
	arr_timestamp		TIME,
	train_no			INT			NOT	NULL	CHECK(train_no > 0),
	PRIMARY KEY(trip_no, trip_date)
);
'''
import math
insert_trips = open('insert_trips.sql', 'w', encoding='utf8')

durations = {
    # Entre-Douros-e-Minho
    (1,2): '01:45',
    (2,3): '01:30',
    (3,4): '01:15',
    # Beira Litoral
    (4,5): '00:05',
    (5,6): '00:07',
    (6,7): '00:36',
    (7,8): '00:23',
    (8,9): '01:00',
    (8,11): '01:30',
    (9,10): '01:00',
    (10,12): '00:45',
    # Ribatejo 
    (12,13): '00:25',
    (13,15): '01:06',
    (15,16): '00:10',
    # Desvio
    (11,14): '02:00',
    (14,15): '01:36'
}

# Reverse durations
new_durations = {}
for duration in durations:
    new_durations[duration] = durations[duration]
    new_durations[(duration[1],duration[0])] = durations[duration]


# Urbanos Entre-Douro-e-Minho
edm = [1,2,3]
for i in range(5):
    for i in range(2):
        for i in range(len(edm) - 1):
            for j in range(i+1, len(edm)):
                insert_trips.write("INSERT INTO Railway.Trip VALUES ('UR','','',{},{});\n".format(edm[i],edm[j]))
        edm.reverse()

# Urbanos 
beira_litoral = [4,5,6,7,8,11,9,10]
for i in range(5):
    for i in range(2):
        for i in range(len(beira_litoral) - 1):
            for j in range(i+1, len(beira_litoral)):
                insert_trips.write("INSERT INTO Railway.Trip VALUES ('UR','','',{},{});\n".format(beira_litoral[i],beira_litoral[j]))
        beira_litoral.reverse()

ribatejo = [12,13,15,14,16]
for i in range(5):
    for i in range(2):
        for i in range(len(ribatejo) - 1):
            for j in range(i+1, len(ribatejo)):
                insert_trips.write("INSERT INTO Railway.Trip VALUES ('UR','','',{},{});\n".format(ribatejo[i],ribatejo[j]))
        ribatejo.reverse()

# inter-cidades
ic = [i for i in range(1,17)]
for i in range(3):
    for i in range(2):
        for i in range(len(ic) - 1):
            for j in range(i+1, len(ic)):
                insert_trips.write("INSERT INTO Railway.Trip VALUES ('IC','','',{},{});\n".format(ic[i],ic[j]))
        ic.reverse()

# alfa-pendular
ap = [1,3,4,9,15,16]
for i in range(2):
    for i in range(2):
        for i in range(len(ap) - 1):
            for j in range(i+1, len(ap)):
                insert_trips.write("INSERT INTO Railway.Trip VALUES ('AP','','',{},{});\n".format(ap[i],ap[j]))
        ap.reverse()

# mercadorias
m = [1,3,4,9,15,16]
for i in range(2):
    for i in range(2):
        for i in range(len(m) - 1):
            for j in range(i+1, len(m)):
                insert_trips.write("INSERT INTO Railway.Trip VALUES ('M','','',{},{});\n".format(m[i],m[j]))
        m.reverse()