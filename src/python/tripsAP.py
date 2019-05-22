# AP	Coimbra, Guarda, Vila Real, Viana do Castelo, Lisboa Oriente, Beja, Faro
#   Viana do Castelo > Vila Real > Guarda > Coimbra > Lisboa Oriente > Beja > Faro
#   Faro > Beja > Lisboa Oriente > Coimbra > Guarda > Vila Real > Viana do Castelo
# 9 > 11 > 15 > 18 > 21 
file = open('insert_tripsAP.txt', 'w+', encoding='utf8')


hours1 = ['9:00', '9:20', '9:40', '10:00', '10:20', '10:40', '11:00']
hours2 = ['11:00', '11:20', '11:40', '12:00', '12:20', '12:40', '13:00']
hours3 = ['15:00', '15:20', '15:40', '16:00', '16:20', '16:40', '17:00']
hours4 = ['18:00', '18:20', '18:40', '19:00', '19:20', '19:40', '20:00']
hours5 = ['21:00', '21:20', '21:40', '22:00', '22:20', '22:40', '23:00']

cities = ['Viana do Castelo', 'Vila Real', 'Guarda', 'Coimbra', 'Lisboa Oriente', 'Beja', 'Faro']
citiesReverse = ['Faro', 'Beja', 'Lisboa Oriente', 'Coimbra', 'Guarda', 'Vila Real', 'Viana do Castelo']

weekDays = ['Segunda-feira', 'Terça-feira','Quarta-feira','Quinta-feira','Sexta-feira', 'Sábado', 'Domingo' ]

for i in range(len(weekDays)):
    #1a viagem dia    
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[0] ,hours1[1] , cities[0],cities[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[1] ,hours1[2] , cities[1],cities[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[2] ,hours1[3] , cities[2],cities[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[3] ,hours1[4] , cities[3],cities[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[4] ,hours1[5] , cities[4],cities[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[5] ,hours1[6] , cities[5],cities[6]))
        # Reverse
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[0] ,hours1[1] , citiesReverse[0],citiesReverse[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[1] ,hours1[2] , citiesReverse[1],citiesReverse[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[2] ,hours1[3] , citiesReverse[2],citiesReverse[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[3] ,hours1[4] , citiesReverse[3],citiesReverse[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[4] ,hours1[5] , citiesReverse[4],citiesReverse[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours1[5] ,hours1[6] , citiesReverse[5],citiesReverse[6]))

    #2a viagem dia
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[0] ,hours2[1] , cities[0],cities[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[1] ,hours2[2] , cities[1],cities[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[2] ,hours2[3] , cities[2],cities[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[3] ,hours2[4] , cities[3],cities[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[4] ,hours2[5] , cities[4],cities[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[5] ,hours2[6] , cities[5],cities[6]))
        # Reverse
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[0] ,hours2[1] , citiesReverse[0],citiesReverse[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[1] ,hours2[2] , citiesReverse[1],citiesReverse[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[2] ,hours2[3] , citiesReverse[2],citiesReverse[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[3] ,hours2[4] , citiesReverse[3],citiesReverse[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[4] ,hours2[5] , citiesReverse[4],citiesReverse[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours2[5] ,hours2[6] , citiesReverse[5],citiesReverse[6]))

    #3a viagem dia
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[0] ,hours3[1] , cities[0],cities[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[1] ,hours3[2] , cities[1],cities[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[2] ,hours3[3] , cities[2],cities[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[3] ,hours3[4] , cities[3],cities[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[4] ,hours3[5] , cities[4],cities[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[5] ,hours3[6] , cities[5],cities[6]))
        # Reverse
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[0] ,hours3[1] , citiesReverse[0],citiesReverse[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[1] ,hours3[2] , citiesReverse[1],citiesReverse[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[2] ,hours3[3] , citiesReverse[2],citiesReverse[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[3] ,hours3[4] , citiesReverse[3],citiesReverse[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[4] ,hours3[5] , citiesReverse[4],citiesReverse[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours3[5] ,hours3[6] , citiesReverse[5],citiesReverse[6]))

    #4a viagem dia
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[0] ,hours4[1] , cities[0],cities[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[1] ,hours4[2] , cities[1],cities[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[2] ,hours4[3] , cities[2],cities[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[3] ,hours4[4] , cities[3],cities[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[4] ,hours4[5] , cities[4],cities[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[5] ,hours4[6] , cities[5],cities[6]))
        # Reverse
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[0] ,hours4[1] , citiesReverse[0],citiesReverse[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[1] ,hours4[2] , citiesReverse[1],citiesReverse[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[2] ,hours4[3] , citiesReverse[2],citiesReverse[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[3] ,hours4[4] , citiesReverse[3],citiesReverse[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[4] ,hours4[5] , citiesReverse[4],citiesReverse[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours4[5] ,hours4[6] , citiesReverse[5],citiesReverse[6]))

    #5a viagem dia
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[0] ,hours5[1] , cities[0],cities[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[1] ,hours5[2] , cities[1],cities[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[2] ,hours5[3] , cities[2],cities[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[3] ,hours5[4] , cities[3],cities[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[4] ,hours5[5] , cities[4],cities[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[5] ,hours5[6] , cities[5],cities[6]))
        # Reverse
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[0] ,hours5[1] , citiesReverse[0],citiesReverse[1]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[1] ,hours5[2] , citiesReverse[1],citiesReverse[2]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[2] ,hours5[3] , citiesReverse[2],citiesReverse[3]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[3] ,hours5[4] , citiesReverse[3],citiesReverse[4]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[4] ,hours5[5] , citiesReverse[4],citiesReverse[5]))
    file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'AP', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours5[5] ,hours5[6] , citiesReverse[5],citiesReverse[6]))
