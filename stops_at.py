
file = open ("insert_stopsAt.txt", "w+", encoding="utf8")

ICStops = ["Viana do Castelo", "Braga", "Guimarães", "Vila Real", "Porto São Bento", "Régua", "Aveiro", "Guarda", "Coimbra", 
"Figueira da Foz", "Covilhã", "Castelo Branco", "Pombal", "Tomar", "Abrantes", "Entroncamento", "Caldas da Rainha", "Santarém", "Elvas", "Lisboa Oriente",
 "Barreiro", "Setúbal", "Évora", "Beja", "Lagos", "Portimão", "Faro", "Tavira"]
ICSTOPSnums = [30, 31, 32, 34, 9, 33, 12, 18, 14, 13, 19, 20, 15, 16, 17, 3, 5, 4, 21, 1, 6, 7, 23, 24, 26, 27, 28, 29]

URMStops = ["Lisboa Oriente", "Lisboa Santa Apolónia", "Entroncamento", "Santarém", "Caldas da Rainha", "Barreiro" , 
"Setúbal" ,"Porto Campanhã" , "Porto São Bento" , "Gaia" , "Ovar" , "Aveiro" , "Figueira da Foz" , "Coimbra" , "Pombal" , "Tomar" , 
"Abrantes" , "Guarda" , "Covilhã" , "Castelo Branco" , "Elvas" , "Portalegre", "Évora" , "Beja" , "Ourique" , "Lagos" , "Portimão" , 
"Faro" , "Tavira" ,"Viana do Castelo" , "Braga" , "Guimarães" , "Régua" , "Vila Real" , "Mirandela" ]

APStops = ["Coimbra", "Guarda", "Vila Real", "Viana do Castelo", "Lisboa Oriente", "Beja", "Faro", "Porto São Bento"]
APSTOPSnums = [14, 18, 34, 30, 1, 24, 28, 9]


for i in range(len(ICStops)):
    file.write("INSERT INTO RAILWAY.STOPS_AT VALUES ({}, '{}', 'IC');\n".format(ICSTOPSnums[i] ,ICStops[i] ))

for i in range(len(URMStops)):
    file.write("INSERT INTO RAILWAY.STOPS_AT VALUES ({}, '{}', 'U');\n".format(i+1,URMStops[i]))
    file.write("INSERT INTO RAILWAY.STOPS_AT VALUES ({}, '{}', 'R');\n".format(i+1,URMStops[i]))
    file.write("INSERT INTO RAILWAY.STOPS_AT VALUES ({}, '{}', 'M');\n".format(i+1,URMStops[i]))

for i in range(len(APStops)):
    file.write("INSERT INTO RAILWAY.STOPS_AT VALUES ({}, '{}', 'AP');\n".format( APSTOPSnums[i] , APStops[i] ))

        #Numero, nome estação e categoria
