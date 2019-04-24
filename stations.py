stations = open('insert_stations.txt', 'w+')

stationsList = ["Lisboa Oriente", "Lisboa Santa Apolónia", "Entroncamento", "Santarém", "Caldas da Rainha", "Barreiro" , 
"Setúbal" ,"Porto Campanhã" , "Porto São Bento" , "Gaia" , "Ovar" , "Aveiro" , "Figueira da Foz" , "Coimbra" , "Pombal" , "Tomar" , 
"Abrantes" , "Guarda" , "Covilhã" , "Castelo Branco" , "Elvas" , "Portalegre", "Évora" , "Beja" , "Ourique" , "Lagos" , "Portimão" , 
"Faro" , "Tavira" ,"Viana do Castelo" , "Braga" , "Guimarães" , "Régua" , "Vila Real" , "Mirandela" ]

for i in range(len(stationsList)):
    stations.write("INSERT INTO RAILWAY.STATION VALUES ({}, '{}', {});\n".format(i+1, stationsList[i], 11111))
