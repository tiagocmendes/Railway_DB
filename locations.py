import random

# open files for saving SQL insert operations
stations = open('insert_locations.txt', 'w+')

# Numero, Nome, Diretor_Number
stationsList = ["Lisboa", "Lisboa", "Entroncamento", "Santarém", "Caldas da Rainha", "Barreiro" , 
"Setúbal" ,"Porto" , "Porto" , "Gaia" , "Ovar" , "Aveiro" , "Figueira da Foz" , "Coimbra" , "Pombal" , "Tomar" , 
"Abrantes" , "Guarda" , "Covilhã" , "Castelo Branco" , "Elvas" , "Portalegre", "Évora" , "Beja" , "Ourique" , "Lagos" , "Portimão" , 
"Faro" , "Tavira" ,"Viana do Castelo" , "Braga" , "Guimarães" , "Régua" , "Vila Real" , "Mirandela" ]
stationsNumbers = [i for i in range(1, 36)]

for i in range(len(stationsList)):
    stations.write("INSERT INTO RAILWAY.LOCALITY VALUES ('{}', {});\n".format(stationsList[i], stationsNumbers[i]))
