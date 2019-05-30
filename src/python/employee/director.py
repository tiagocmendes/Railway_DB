insert_director = open('insert_director.sql', 'w', encoding='utf8')

for i in range(16):
    insert_director.write("UPDATE Railway.Station SET director_no = {} WHERE station_no = {};\n".format(101+i,1+i))
insert_director.close()