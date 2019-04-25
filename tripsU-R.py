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

# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Viana do Castelo', 'Braga');\n".format(weekDays[i],Hp3, hp31))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Viana do Castelo', 'Guimarães');\n".format( weekDays[i],Hp3, hp31))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Braga', 'Guimarães');\n".format( weekDays[i],hp31,hp32 ))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Guimarães', 'Braga');\n".format( weekDays[i],hp31,hp32 ))

    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U',  '{}', '{}', 'Guimarães', 'Viana do Castelo');\n".format( weekDays[i],hp32, hp33))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'R',  '{}', '{}', 'Braga', 'Viana do Castelo');\n".format(weekDays[i],hp32, hp33))

# Trás-os-Montes
# 1a viagem
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Régua', 'Vila Real');\n".format(weekDays[i],Hp1, hp11))
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Régua', 'Mirandela');\n".format(weekDays[i],Hp1, hp11))

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
    file.write("INSERT INTO RAILWAY.TRIPS VALUES ('{}', 'U', '{}', '{}', 'Évora', 'Ourique'   );\n".format(weekDays[i],Hp1, hp11))

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

