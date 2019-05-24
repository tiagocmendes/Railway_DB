# 6 > 8 > 10 > 12 > 14 > 16 > 18 > 20
# 8 horas de viagens
file = open('insert_tripsIC.txt', 'w+', encoding='utf8')
 
# Lisboa Oriente, Barreiro, 
# Setúbal, Évora, Beja, Lagos, Portimão, Faro, Tavira
# 28 cidades

cidades = ['Mirandela', 'Vila Real', 'Guimarães', 'Braga', 'Viana do Castelo', 'Porto São Bento',  'Régua', 'Guarda', 'Aveiro',
        'Figueira da Foz', 'Coimbra',  'Pombal',  'Covilhã', 'Castelo Branco', 'Elvas', 'Abrantes', 'Tomar',  'Entroncamento', 'Santarém',
        'Caldas da Rainha', 'Lisboa Oriente', 'Barreiro', 'Setúbal', 'Évora', 'Beja', 'Tavira', 'Faro', 'Portimão', 'Lagos' ]

cidadesReverse = ['Lagos', 'Portimão', 'Faro', 'Tavira', 'Beja', 'Évora', 'Setúbal', 'Barreiro', 'Lisboa Oriente', 'Caldas da Rainha',
    'Santarém', 'Entroncamento', 'Tomar', 'Abrantes', 'Elvas', 'Castelo Branco', 'Covilhã', 'Pombal', 'Coimbra', 'Figueira da Foz',
    'Aveiro', 'Guarda', 'Régua', 'Porto São Bento', 'Viana do Castelo', 'Braga', 'Guimarães', 'Vila Real', 'Mirandela']

weekDays = ['Segunda-feira', 'Terça-feira','Quarta-feira','Quinta-feira','Sexta-feira', 'Sábado', 'Domingo' ]

hours6 = ['6:00', '6:20', '6:40', '7:00', '7:20', '7:40', '8:00', '8:20', '8:40', '9:00', '9:20', '9:40', '10:00', '10:20', '10:40',
            '11:00', '11:20', '11:40', '12:00', '12:20', '12:40', '13:00', '13:20', '13:40', '14:00', '14:20', '14:40', '15:00', '15:20']

hours8 = [  '08:00', '08:20', '08:40', '09:00', '09:20', '09:40', '10:00', '10:20', '10:40', '11:00', '11:20', '11:40', '12:00', '12:20', '12:40', '13:00', '13:20', '13:40', '14:00', '14:20', '14:40', '15:00', '15:20', '15:40', '16:00', '16:20', '16:40', '17:00', '17:20']
hours10 = [ '10:00', '10:20', '10:40', '11:00', '11:20', '11:40', '12:00', '12:20', '12:40', '13:00', '13:20', '13:40', '14:00', '14:20', '14:40', '15:00', '15:20', '15:40', '16:00', '16:20', '16:40', '17:00', '17:20', '17:40', '18:00', '18:20', '18:40', '19:00', '19:20']
hours12 = [ '12:00', '12:20', '12:40', '13:00', '13:20', '13:40', '14:00', '14:20', '14:40', '15:00', '15:20', '15:40', '16:00', '16:20', '16:40', '17:00', '17:20', '17:40', '18:00', '18:20', '18:40', '19:00', '19:20', '19:40', '20:00', '20:20', '20:40', '21:00', '21:20']
hours14 = [ '14:00', '14:20', '14:40', '15:00', '15:20', '15:40', '16:00', '16:20', '16:40', '17:00', '17:20', '17:40', '18:00', '18:20', '18:40', '19:00', '19:20', '19:40', '20:00', '20:20', '20:40', '21:00', '21:20', '21:40', '22:00', '22:20', '22:40', '23:00', '23:20']
hours16 = [ '16:00', '16:20', '16:40', '17:00', '17:20', '17:40', '18:00', '18:20', '18:40', '19:00', '19:20', '19:40', '20:00', '20:20', '20:40', '21:00', '21:20', '21:40', '22:00', '22:20', '22:40', '23:00', '23:20', '23:40', '00:00', '00:20', '00:40', '01:00', '01:20']
hours18 = [ '18:00', '18:20', '18:40', '19:00', '19:20', '19:40', '20:00', '20:20', '20:40', '21:00', '21:20', '21:40', '22:00', '22:20', '22:40', '23:00', '23:20', '23:40', '00:00', '00:20', '00:40', '01:00', '01:20', '01:40', '02:00', '02:20', '02:40', '03:00', '03:20']
hours20 = [ '20:00', '20:20', '20:40', '21:00', '21:20', '21:40', '22:00', '22:20', '22:40', '23:00', '23:20', '23:40', '00:00', '00:20', '00:40', '01:00', '01:20', '01:40', '02:00', '02:20', '02:40', '03:00', '03:20', '03:40', '04:00', '04:20', '04:40', '05:00', '05:20']


for i in range(len(weekDays)):
    for j in range(28):
        #1a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours6[j] ,hours6[j+1] , cidades[j],cidades[j+1]))

        #2a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours8[j] ,hours8[j+1] , cidades[j],cidades[j+1]))

        #3a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours10[j] ,hours10[j+1] , cidades[j],cidades[j+1]))

        #4a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours12[j] ,hours12[j+1] , cidades[j],cidades[j+1]))

        #5a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours14[j] ,hours14[j+1] , cidades[j],cidades[j+1]))

        #6a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours16[j] ,hours16[j+1] , cidades[j],cidades[j+1]))

        #7a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours18[j] ,hours18[j+1] , cidades[j],cidades[j+1]))

        #8a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours20[j] ,hours20[j+1] , cidades[j],cidades[j+1]))

    # REVERSE
            #1a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours6[j] ,hours6[j+1] , cidadesReverse[j],cidadesReverse[j+1]))

        #2a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours8[j] ,hours8[j+1] ,  cidadesReverse[j],cidadesReverse[j+1]))

        #3a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours10[j] ,hours10[j+1] ,  cidadesReverse[j],cidadesReverse[j+1]))

        #4a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours12[j] ,hours12[j+1] ,  cidadesReverse[j],cidadesReverse[j+1]))

        #5a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours14[j] ,hours14[j+1] , cidadesReverse[j],cidadesReverse[j+1]))

        #6a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours16[j] ,hours16[j+1] , cidadesReverse[j],cidadesReverse[j+1]))

        #7a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours18[j] ,hours18[j+1] , cidadesReverse[j],cidadesReverse[j+1]))

        #8a viagem dia    
        file.write("INSERT INTO RAILWAY.TRIP VALUES ('{}', 'IC', '{}', '{}', '{}', '{}');\n".format(weekDays[i], hours20[j] ,hours20[j+1] , cidadesReverse[j],cidadesReverse[j+1]))
