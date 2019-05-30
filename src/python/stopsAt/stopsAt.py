stopsAt = open('stops_at.sql', 'w', encoding='utf8')
categories = ['UR', 'IC']

for category in categories:
    for i in range(16):
        stopsAt.write("INSERT INTO Railway.StopsAt VALUES ({},'{}');\n".format(i+1,category))

special_station = [1,3,4,9,12,16]
categories = ['AP', 'M']
for category in categories:
    for st in special_station:
        stopsAt.write("INSERT INTO Railway.StopsAt VALUES ({},'{}');\n".format(st,category))
