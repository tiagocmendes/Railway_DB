stations = open('insert_tripZone.txt', 'w+')

locList = ["Ribatejo", "Beira Litoral", "Beira Interior", "Alentejo", "Algarve", "Entre-Douro-e-Minho" , 
"Trás-os-Montes"]
prices = [3.5, 4.5, 3, 1.5, 2, 3, 3]

for i in range(len(locList)):
    stations.write("INSERT INTO RAILWAY.TRIP_ZONE VALUES ('{}', {}, {});\n".format(locList[i], 11111, prices[i]))
