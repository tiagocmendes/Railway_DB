#INSERT INTO RAILWAY.TRIPS VALUES (Weekday, Type, H. Partida, H. Chegada, Est. Partida, Chegada);
file = open('insert_tripsM.txt', 'w+', encoding='utf8')

weekDays = ['Segunda-feira', 'Terça-feira','Quarta-feira','Quinta-feira','Sexta-feira', 'Sábado', 'Domingo' ]

Hp1 = '10:30'
hp11 = '10:45'
hp12 = '11:00'
hp13 = '11:15'

Hp2 = '14:30'
hp21 = '14:45'
hp22 = '15:00'
hp23 = '15:15'

Hp3 = '18:30'
hp31 = '18:45'
hp32 = '19:00'
hp33 = '19:15'

# U/R
for i in range(len(weekDays)):
# Entre-Douro-e-Minho
# 1a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Viana do Castelo', 'Braga');\n".format(weekDays[i],Hp1, hp11))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Braga', 'Guimarães');\n".format( weekDays[i],hp11,hp12 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Guimarães', 'Viana do Castelo');\n".format( weekDays[i],hp12, hp13))
    

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Viana do Castelo', 'Braga');\n".format(weekDays[i],Hp2, hp21))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Braga', 'Guimarães');\n".format( weekDays[i],hp21,hp22 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Guimarães', 'Viana do Castelo');\n".format( weekDays[i],hp22, hp23))
    

    
# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Viana do Castelo', 'Braga');\n".format(weekDays[i],Hp3, hp31))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Braga', 'Guimarães');\n".format( weekDays[i],hp31,hp32 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Guimarães', 'Viana do Castelo');\n".format( weekDays[i],hp32, hp33))
    

# Trás-os-Montes
# 1a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Régua', 'Vila Real');\n".format(weekDays[i],Hp1, hp11))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Vila Real', 'Mirandela');\n".format( weekDays[i],hp11,hp12 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Mirandela', 'Régua');\n".format( weekDays[i],hp12, hp13))
    

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Régua', 'Vila Real');\n".format(weekDays[i],Hp2, hp21))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Vila Real', 'Mirandela');\n".format( weekDays[i],hp21,hp22 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}','Mirandela', 'Régua');\n".format( weekDays[i],hp22, hp23))
    

# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}',  'Régua', 'Vila Real');\n".format(weekDays[i],Hp3, hp31))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}','Vila Real', 'Mirandela');\n".format( weekDays[i],hp31,hp32 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}','Mirandela', 'Régua');\n".format( weekDays[i],hp32, hp33))
    

# Alentejo
# 1a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Évora', 'Beja'         );\n".format(weekDays[i],Hp1, hp11))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Beja', 'Ourique'    );\n".format( weekDays[i],hp11,hp12 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Ourique', 'Évora'  );\n".format( weekDays[i],hp12, hp13))
    

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Évora', 'Beja'       );\n".format(weekDays[i],Hp2, hp21))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Beja', 'Ourique' );\n".format( weekDays[i],hp21,hp22 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}','Ourique', 'Évora'   );\n".format( weekDays[i],hp22, hp23))
    

# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}',  'Évora', 'Beja'       );\n".format(weekDays[i],Hp3, hp31))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}','Beja', 'Ourique' );\n".format( weekDays[i],hp31,hp32 ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}','Ourique', 'Évora'   );\n".format( weekDays[i],hp32, hp33))
    

# Algarve   # Faro > Tavira > Lagos > Portimão > Faro || Faro > Portimão > Lagos > Tavira
            # 10:30  10:45   11:00  11:15       11:30     
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Faro', 'Tavira'         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Tavira', 'Lagos'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Lagos', 'Portimão'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Portimão', 'Faro'  );\n".format( weekDays[i],hours[3],hours[4]))
    
# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Faro', 'Tavira'         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Tavira', 'Lagos'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Lagos', 'Portimão'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Portimão', 'Faro'  );\n".format( weekDays[i],hours[3],hours[4]))
    

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Faro', 'Tavira'         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Tavira', 'Lagos'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Lagos', 'Portimão'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Portimão', 'Faro'  );\n".format( weekDays[i],hours[3],hours[4]))
    

# Interior  # Guarda > Covilhã > Castelo Branco > Portalegre > Elvas > Abrantes > Guarda
            # 10:30     10:45       11:00           11:15      11:30    11:45       12:00 
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Guarda', 'Covilhã'         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Covilhã', 'Castelo Branco'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Castelo Branco', 'Portalegre'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Portalegre', 'Elvas'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Elvas', 'Abrantes'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Abrantes', 'Guarda'  );\n".format( weekDays[i],hours[3],hours[4]))
    

# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30', '15:45', '16:00']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Guarda', 'Covilhã'         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Covilhã', 'Castelo Branco'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Castelo Branco', 'Portalegre'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Portalegre', 'Elvas'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Elvas', 'Abrantes'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Abrantes', 'Guarda'  );\n".format( weekDays[i],hours[3],hours[4]))
    

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Guarda', 'Covilhã'         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Covilhã', 'Castelo Branco'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Castelo Branco', 'Portalegre'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Portalegre', 'Elvas'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Elvas', 'Abrantes'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Abrantes', 'Guarda'  );\n".format( weekDays[i],hours[3],hours[4]))
    

# Lisboa    # Oriente > Santa Apolónia > Caldas da Rainha > Entroncamento > Santarém >  Setúbal > Barreiro > Oriente
            # 10:30         10:45                11:00           11:15      11:30       11:45       12:00      12:15
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Lisboa Oriente', 'Lisboa Santa Apolónia');\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Lisboa Santa Apolónia', 'Caldas da Rainha'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Caldas da Rainha', 'Entroncamento'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Entroncamento', 'Santarém'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Santarém', 'Setúbal'  );\n".format( weekDays[i],hours[4],hours[5]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Setúbal', 'Barreiro'  );\n".format( weekDays[i],hours[5],hours[6]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Barreiro', 'Lisboa Oriente'  );\n".format( weekDays[i],hours[6],hours[7]))
    

# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30', '15:45', '16:00', '16:15']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Lisboa Oriente', 'Lisboa Santa Apolónia');\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Lisboa Santa Apolónia', 'Caldas da Rainha'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Caldas da Rainha', 'Entroncamento'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Entroncamento', 'Santarém'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Santarém', 'Setúbal'  );\n".format( weekDays[i],hours[4],hours[5]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Setúbal', 'Barreiro'  );\n".format( weekDays[i],hours[5],hours[6]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Barreiro', 'Lisboa Oriente'  );\n".format( weekDays[i],hours[6],hours[7]))
    

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00', '20:15']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Lisboa Oriente', 'Lisboa Santa Apolónia');\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Lisboa Santa Apolónia', 'Caldas da Rainha'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Caldas da Rainha', 'Entroncamento'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Entroncamento', 'Santarém'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Santarém', 'Setúbal'  );\n".format( weekDays[i],hours[4],hours[5]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Setúbal', 'Barreiro'  );\n".format( weekDays[i],hours[5],hours[6]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Barreiro', 'Lisboa Oriente'  );\n".format( weekDays[i],hours[6],hours[7]))
    


# Litoral   # Porto São Bento > Porto Campanhã > Gaia > Ovar > Aveiro > Figueira da Foz > Tomar > Pombal > Coimbra > Porto São Bento
            #       10:30           10:45       11:00  11:15   11:30       11:45          12:00   12:15     12:30       12:45
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30', '12:45']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Porto São Bento', 'Porto Campanhã');\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M', '{}', '{}', 'Porto Campanhã', 'Gaia'    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Gaia', 'Ovar'  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Ovar', 'Aveiro'  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Aveiro', 'Figueira da Foz'  );\n".format( weekDays[i],hours[4],hours[5]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Figueira da Foz', 'Tomar'  );\n".format( weekDays[i],hours[5],hours[6]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Tomar', 'Pombal'  );\n".format( weekDays[i],hours[6],hours[7]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Pombal', 'Coimbra'  );\n".format( weekDays[i],hours[6],hours[7]))
    

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'M',  '{}', '{}', 'Coimbra', 'Porto São Bento'  );\n".format( weekDays[i],hours[6],hours[7]))
    
