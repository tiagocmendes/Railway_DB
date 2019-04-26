#INSERT INTO RAILWAY.TRIPS VALUES (Weekday, Type, H. Partida, H. Chegada, Est. Partida, Chegada);
file = open('insert_tripsU-R.txt', 'w+', encoding='utf8')

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
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Viana do Castelo', 'Braga');\n".format(weekDays[i],Hp1, hp11))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Viana do Castelo', 'Guimarães');\n".format( weekDays[i],Hp1, hp11))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Braga', 'Guimarães');\n".format( weekDays[i],hp11,hp12 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Guimarães', 'Braga');\n".format( weekDays[i],hp11,hp12 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Guimarães', 'Viana do Castelo');\n".format( weekDays[i],hp12, hp13))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Braga', 'Viana do Castelo');\n".format(weekDays[i],hp12, hp13))

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Viana do Castelo', 'Braga');\n".format(weekDays[i],Hp2, hp21))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Viana do Castelo', 'Guimarães');\n".format( weekDays[i],Hp2, hp21))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Braga', 'Guimarães');\n".format( weekDays[i],hp21,hp22 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Guimarães', 'Braga');\n".format( weekDays[i],hp21,hp22 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Guimarães', 'Viana do Castelo');\n".format( weekDays[i],hp22, hp23))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Braga', 'Viana do Castelo');\n".format(weekDays[i],hp22, hp23))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Viana do Castelo', 'Guimarães');\n".format( weekDays[i],Hp3, hp31))
# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Viana do Castelo', 'Braga');\n".format(weekDays[i],Hp3, hp31))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Braga', 'Guimarães');\n".format( weekDays[i],hp31,hp32 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Guimarães', 'Braga');\n".format( weekDays[i],hp31,hp32 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Guimarães', 'Viana do Castelo');\n".format( weekDays[i],hp32, hp33))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Braga', 'Viana do Castelo');\n".format(weekDays[i],hp32, hp33))

# Trás-os-Montes
# 1a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Régua', 'Vila Real');\n".format(weekDays[i],Hp1, hp11))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Régua', 'Mirandela');\n".format(weekDays[i],Hp1, hp11))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Vila Real', 'Mirandela');\n".format( weekDays[i],hp11,hp12 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Mirandela', 'Vila Real');\n".format( weekDays[i],hp11,hp12 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Mirandela', 'Régua');\n".format( weekDays[i],hp12, hp13))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Vila Real', 'Régua');\n".format(weekDays[i],hp12, hp13))

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Régua', 'Vila Real');\n".format(weekDays[i],Hp2, hp21))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Régua', 'Mirandela');\n".format( weekDays[i],Hp2, hp21))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Vila Real', 'Mirandela');\n".format( weekDays[i],hp21,hp22 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}',  'Mirandela', 'Vila Real');\n".format( weekDays[i],hp21,hp22 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}','Mirandela', 'Régua');\n".format( weekDays[i],hp22, hp23))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}','Vila Real', 'Régua');\n".format(weekDays[i],hp22, hp23))

# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}',  'Régua', 'Vila Real');\n".format(weekDays[i],Hp3, hp31))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Régua', 'Mirandela');\n".format( weekDays[i],Hp3, hp31))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}','Vila Real', 'Mirandela');\n".format( weekDays[i],hp31,hp32 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Mirandela', 'Vila Real');\n".format( weekDays[i],hp31,hp32 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}','Mirandela', 'Régua');\n".format( weekDays[i],hp32, hp33))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}','Vila Real', 'Régua');\n".format(weekDays[i],hp32, hp33))

# Alentejo
# 1a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Évora', 'Beja'         );\n".format(weekDays[i],Hp1, hp11))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Évora', 'Ourique'   );\n".format(weekDays[i],Hp1, hp11))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Beja', 'Ourique'    );\n".format( weekDays[i],hp11,hp12 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Ourique', 'Beja'   );\n".format( weekDays[i],hp11,hp12 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Ourique', 'Évora'  );\n".format( weekDays[i],hp12, hp13))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Beja', 'Évora'   );\n".format(weekDays[i],hp12, hp13))

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Évora', 'Beja'       );\n".format(weekDays[i],Hp2, hp21))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Évora', 'Mirandela'  );\n".format( weekDays[i],Hp2, hp21))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Beja', 'Ourique' );\n".format( weekDays[i],hp21,hp22 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Ourique', 'Beja' );\n".format( weekDays[i],hp21,hp22 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}','Ourique', 'Évora'   );\n".format( weekDays[i],hp22, hp23))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}','Beja', 'Évora'      );\n".format(weekDays[i],hp22, hp23))

# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}',  'Évora', 'Beja'       );\n".format(weekDays[i],Hp3, hp31))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Évora', 'Mirandela'  );\n".format( weekDays[i],Hp3, hp31))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}','Beja', 'Ourique' );\n".format( weekDays[i],hp31,hp32 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}','Ourique', 'Beja' );\n".format( weekDays[i],hp31,hp32 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}','Ourique', 'Évora'   );\n".format( weekDays[i],hp32, hp33))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}','Beja', 'Évora'      );\n".format(weekDays[i],hp32, hp33))

# Algarve   # Faro > Tavira > Lagos > Portimão > Faro || Faro > Portimão > Lagos > Tavira
            # 10:30  10:45   11:00  11:15       11:30     
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Faro', 'Tavira'         );\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Faro', 'Portimão'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Tavira', 'Lagos'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Portimão', 'Lagos'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Lagos', 'Portimão'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Lagos', 'Tavira'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Portimão', 'Faro'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Tavira', 'Faro'   );\n".format(weekDays[i],hours[3], hours[4]))
# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Faro', 'Tavira'         );\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Faro', 'Portimão'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Tavira', 'Lagos'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Portimão', 'Lagos'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Lagos', 'Portimão'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Lagos', 'Tavira'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Portimão', 'Faro'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Tavira', 'Faro'   );\n".format(weekDays[i],hours[3], hours[4]))

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Faro', 'Tavira'         );\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Faro', 'Portimão'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Tavira', 'Lagos'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Portimão', 'Lagos'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Lagos', 'Portimão'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Lagos', 'Tavira'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Portimão', 'Faro'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Tavira', 'Faro'   );\n".format(weekDays[i],hours[3], hours[4]))

# Interior  # Guarda > Covilhã > Castelo Branco > Portalegre > Elvas > Abrantes > Guarda
            # 10:30     10:45       11:00           11:15      11:30    11:45       12:00 
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Guarda', 'Covilhã'         );\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Guarda', 'Abrantes'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Covilhã', 'Castelo Branco'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Abrantes', 'Elvas'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Castelo Branco', 'Portalegre'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Elvas', 'Portalegre'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Portalegre', 'Elvas'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Portalegre', 'Castelo Branco'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Elvas', 'Abrantes'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Castelo Branco', 'Covilhã'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Abrantes', 'Guarda'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Covilhã', 'Guarda'   );\n".format(weekDays[i],hours[3], hours[4]))

# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30', '15:45', '16:00']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Guarda', 'Covilhã'         );\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Guarda', 'Abrantes'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Covilhã', 'Castelo Branco'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Abrantes', 'Elvas'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Castelo Branco', 'Portalegre'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Elvas', 'Portalegre'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Portalegre', 'Elvas'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Portalegre', 'Castelo Branco'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Elvas', 'Abrantes'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Castelo Branco', 'Covilhã'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Abrantes', 'Guarda'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Covilhã', 'Guarda'   );\n".format(weekDays[i],hours[3], hours[4]))

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Guarda', 'Covilhã'         );\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Guarda', 'Abrantes'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Covilhã', 'Castelo Branco'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Abrantes', 'Elvas'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Castelo Branco', 'Portalegre'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Elvas', 'Portalegre'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Portalegre', 'Elvas'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Portalegre', 'Castelo Branco'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Elvas', 'Abrantes'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Castelo Branco', 'Covilhã'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Abrantes', 'Guarda'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Covilhã', 'Guarda'   );\n".format(weekDays[i],hours[3], hours[4]))

# Lisboa    # Oriente > Santa Apolónia > Caldas da Rainha > Entroncamento > Santarém >  Setúbal > Barreiro > Oriente
            # 10:30         10:45                11:00           11:15      11:30       11:45       12:00      12:15
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Lisboa Oriente', 'Lisboa Santa Apolónia');\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Lisboa Oriente', 'Barreiro'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Lisboa Santa Apolónia', 'Caldas da Rainha'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Barreiro', 'Setúbal'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Caldas da Rainha', 'Entroncamento'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Setúbal', 'Santarém'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Entroncamento', 'Santarém'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Santarém', 'Entroncamento'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Santarém', 'Setúbal'  );\n".format( weekDays[i],hours[4],hours[5]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Entroncamento', 'Caldas da Rainha'   );\n".format(weekDays[i],hours[4], hours[5]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Setúbal', 'Barreiro'  );\n".format( weekDays[i],hours[5],hours[6]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Caldas da Rainha', 'Lisboa Santa Apolónia'   );\n".format(weekDays[i],hours[5], hours[6]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Barreiro', 'Lisboa Oriente'  );\n".format( weekDays[i],hours[6],hours[7]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Lisboa Santa Apolónia', 'Lisboa Oriente'   );\n".format(weekDays[i],hours[6], hours[7]))

# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30', '15:45', '16:00', '16:15']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Lisboa Oriente', 'Lisboa Santa Apolónia');\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Lisboa Oriente', 'Barreiro'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Lisboa Santa Apolónia', 'Caldas da Rainha'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Barreiro', 'Setúbal'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Caldas da Rainha', 'Entroncamento'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Setúbal', 'Santarém'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Entroncamento', 'Santarém'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Santarém', 'Entroncamento'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Santarém', 'Setúbal'  );\n".format( weekDays[i],hours[4],hours[5]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Entroncamento', 'Caldas da Rainha'   );\n".format(weekDays[i],hours[4], hours[5]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Setúbal', 'Barreiro'  );\n".format( weekDays[i],hours[5],hours[6]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Caldas da Rainha', 'Lisboa Santa Apolónia'   );\n".format(weekDays[i],hours[5], hours[6]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Barreiro', 'Lisboa Oriente'  );\n".format( weekDays[i],hours[6],hours[7]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Caldas da Rainha', 'Lisboa Santa Apolónia'   );\n".format(weekDays[i],hours[6], hours[7]))

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00', '20:15']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Lisboa Oriente', 'Lisboa Santa Apolónia');\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Lisboa Oriente', 'Barreiro'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Lisboa Santa Apolónia', 'Caldas da Rainha'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Barreiro', 'Setúbal'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Caldas da Rainha', 'Entroncamento'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Setúbal', 'Santarém'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Entroncamento', 'Santarém'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Santarém', 'Entroncamento'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Santarém', 'Setúbal'  );\n".format( weekDays[i],hours[4],hours[5]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Entroncamento', 'Caldas da Rainha'   );\n".format(weekDays[i],hours[4], hours[5]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Setúbal', 'Barreiro'  );\n".format( weekDays[i],hours[5],hours[6]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Caldas da Rainha', 'Lisboa Santa Apolónia'   );\n".format(weekDays[i],hours[5], hours[6]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Barreiro', 'Lisboa Oriente'  );\n".format( weekDays[i],hours[6],hours[7]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Caldas da Rainha', 'Lisboa Santa Apolónia'   );\n".format(weekDays[i],hours[6], hours[7]))


# Litoral   # Porto São Bento > Porto Campanhã > Gaia > Ovar > Aveiro > Figueira da Foz > Tomar > Pombal > Coimbra > Porto São Bento
            #       10:30           10:45       11:00  11:15   11:30       11:45          12:00   12:15     12:30       12:45
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30', '12:45']
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Porto São Bento', 'Porto Campanhã');\n".format(weekDays[i],hours[0], hours[1]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Porto São Bento', 'Coimbra'   );\n".format(weekDays[i],hours[0], hours[1]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Porto Campanhã', 'Gaia'    );\n".format( weekDays[i],hours[1],hours[2] ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R', '{}', '{}', 'Coimbra', 'Pombal'   );\n".format( weekDays[i],hours[1],hours[2] ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Gaia', 'Ovar'  );\n".format( weekDays[i],hours[2],hours[3]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Pombal', 'Tomar'   );\n".format(weekDays[i],hours[2], hours[3]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Ovar', 'Aveiro'  );\n".format( weekDays[i],hours[3],hours[4]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Tomar', 'Figueira da Foz'   );\n".format(weekDays[i],hours[3], hours[4]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Aveiro', 'Figueira da Foz'  );\n".format( weekDays[i],hours[4],hours[5]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Figueira da Foz', 'Aveiro'   );\n".format(weekDays[i],hours[4], hours[5]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Figueira da Foz', 'Tomar'  );\n".format( weekDays[i],hours[5],hours[6]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Aveiro', 'Ovar'   );\n".format(weekDays[i],hours[5], hours[6]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Tomar', 'Pombal'  );\n".format( weekDays[i],hours[6],hours[7]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Ovar', 'Gaia'   );\n".format(weekDays[i],hours[6], hours[7]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Pombal', 'Coimbra'  );\n".format( weekDays[i],hours[6],hours[7]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Gaia', 'Porto Campanhã'   );\n".format(weekDays[i],hours[6], hours[7]))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Coimbra', 'Porto São Bento'  );\n".format( weekDays[i],hours[6],hours[7]))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Porto Campanhã', 'Porto São Bento'   );\n".format(weekDays[i],hours[6], hours[7]))
