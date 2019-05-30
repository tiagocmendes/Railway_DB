stations = {
    'Viana do Castelo': 1,
    'Braga': 1,
    'Guimarães': 1,
    'Porto - São Bento': 2,
    'Porto - Campanhã': 2,
    'Vila Nova de Gaia': 2,
    'Ovar': 2,
    'Aveiro': 2,
    'Coimbra': 2,
    'Pombal': 2,
    'Figueira da Foz': 2,
    'Entroncamento': 3,
    'Santarém': 3,
    'Caldas da Rainha': 3,
    'Lisboa - Santa Apolónia': 3,
    'Lisboa - Oriente': 3 ,
}

insert_stations = open('insert_stations.sql', 'w', encoding='utf8')

for station in stations:
    insert_stations.write("INSERT INTO Railway.Station VALUES ('{}',{});\n".format(station, stations[station]))
insert_stations.close()