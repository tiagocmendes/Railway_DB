#INSERT INTO RAILWAY.TRIP VALUES (Weekday, Type, H. Partida, H. Chegada, Est. Partida, Chegada);
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
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 30, 31);\n".format(weekDays[i],Hp1, hp11))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 31, 32);\n".format( weekDays[i],hp11,hp12 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 32, 30);\n".format( weekDays[i],hp12, hp13))
    

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 30, 31);\n".format(weekDays[i],Hp2, hp21))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 31, 32);\n".format( weekDays[i],hp21,hp22 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 32, 30);\n".format( weekDays[i],hp22, hp23))
    

    
# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 30, 31);\n".format(weekDays[i],Hp3, hp31))

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 31, 32);\n".format( weekDays[i],hp31,hp32 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 32, 30);\n".format( weekDays[i],hp32, hp33))
    

# Trás-os-Montes
# 1a viagem
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 33, 34);\n".format(weekDays[i],Hp1, hp11))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 34, 35);\n".format( weekDays[i],hp11,hp12 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 35, 33);\n".format( weekDays[i],hp12, hp13))
    

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 33, 34);\n".format(weekDays[i],Hp2, hp21))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 34, 35);\n".format( weekDays[i],hp21,hp22 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}',35, 33);\n".format( weekDays[i],hp22, hp23))
    

# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}',  33, 34);\n".format(weekDays[i],Hp3, hp31))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}',34, 35);\n".format( weekDays[i],hp31,hp32 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}',35, 33);\n".format( weekDays[i],hp32, hp33))
    

# Alentejo
# 1a viagem
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 23, 24         );\n".format(weekDays[i],Hp1, hp11))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 24, 25    );\n".format( weekDays[i],hp11,hp12 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 25, 23  );\n".format( weekDays[i],hp12, hp13))
    

# 2a viagem
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 23, 24       );\n".format(weekDays[i],Hp2, hp21))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 24, 25 );\n".format( weekDays[i],hp21,hp22 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}',25, 23   );\n".format( weekDays[i],hp22, hp23))
    

# 3a viagem
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}',  23, 24       );\n".format(weekDays[i],Hp3, hp31))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}',24, 25 );\n".format( weekDays[i],hp31,hp32 ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}',25, 23   );\n".format( weekDays[i],hp32, hp33))
    

# Algarve   # Faro > Tavira > Lagos > Portimão > Faro || Faro > Portimão > Lagos > Tavira
            # 10:30  10:45   11:00  11:15       11:30     
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 28, 29         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 29, 26    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 26, 27  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 27, 28  );\n".format( weekDays[i],hours[3],hours[4]))
    
# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 28, 29         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 29, 26    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 26, 27  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 27, 28  );\n".format( weekDays[i],hours[3],hours[4]))
    

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 28, 29         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 29, 26    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 26, 27  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 27, 28  );\n".format( weekDays[i],hours[3],hours[4]))
    

# Interior  # Guarda > Covilhã > Castelo Branco > Portalegre > Elvas > Abrantes > Guarda
            # 10:30     10:45       11:00           11:15      11:30    11:45       12:00 
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 18, 19         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 19, 20    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 20, 22  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 22, 21  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 21, 17  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 17, 18  );\n".format( weekDays[i],hours[3],hours[4]))
    

# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30', '15:45', '16:00']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 18, 19         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 19, 20    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 20, 22  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 22, 21  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 21, 17  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 17, 18  );\n".format( weekDays[i],hours[3],hours[4]))
    

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 18, 19         );\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 19, 20    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 20, 22  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 22, 21  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 21, 17  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 17, 18  );\n".format( weekDays[i],hours[3],hours[4]))
    

# Lisboa    # Oriente > Santa Apolónia > Caldas da Rainha > Entroncamento > Santarém >  Setúbal > Barreiro > Oriente
            # 10:30         10:45                11:00           11:15      11:30       11:45       12:00      12:15
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 1,2);\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}',2, 5    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 5, 3  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 3, 4  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 4, 7  );\n".format( weekDays[i],hours[4],hours[5]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 7, 6  );\n".format( weekDays[i],hours[5],hours[6]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 6, 1  );\n".format( weekDays[i],hours[6],hours[7]))
    

# 2a viagem
    hours = ['14:30', '14:45', '15:00', '15:15', '15:30', '15:45', '16:00', '16:15']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 1,2);\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}',2, 5    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 5, 3  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 3, 4  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 4, 7  );\n".format( weekDays[i],hours[4],hours[5]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 7, 6  );\n".format( weekDays[i],hours[5],hours[6]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 6, 1  );\n".format( weekDays[i],hours[6],hours[7]))
    

# 3a viagem
    hours = ['18:30', '18:45', '19:00', '19:15', '19:30', '19:45', '20:00', '20:15']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 1,2);\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}',2, 5    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 5, 3  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 3, 4  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 4, 7  );\n".format( weekDays[i],hours[4],hours[5]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 7, 6  );\n".format( weekDays[i],hours[5],hours[6]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 6, 1  );\n".format( weekDays[i],hours[6],hours[7]))
    


# Litoral   # Porto São Bento > Porto Campanhã > Gaia > Ovar > Aveiro > Figueira da Foz > Tomar > Pombal > Coimbra > Porto São Bento
            #       10:30           10:45       11:00  11:15   11:30       11:45          12:00   12:15     12:30       12:45
# 1a viagem
    hours = ['10:30', '10:45', '11:00', '11:15', '11:30', '11:45', '12:00', '12:15', '12:30', '12:45']
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 9, 8);\n".format(weekDays[i],hours[0], hours[1]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M', '{}', '{}', 8, 10    );\n".format( weekDays[i],hours[1],hours[2] ))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 10, 11  );\n".format( weekDays[i],hours[2],hours[3]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 11, 12  );\n".format( weekDays[i],hours[3],hours[4]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 12, 13  );\n".format( weekDays[i],hours[4],hours[5]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 13, 16  );\n".format( weekDays[i],hours[5],hours[6]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 16, 15  );\n".format( weekDays[i],hours[6],hours[7]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 15, 14  );\n".format( weekDays[i],hours[6],hours[7]))
    

    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'M',  '{}', '{}', 14, 9  );\n".format( weekDays[i],hours[6],hours[7]))
    
