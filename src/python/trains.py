import random

# open files for saving SQL insert operations
insert_trains = open('insert_trains.sql', 'w')
insert_carriages = open('insert_carriages.sql', 'w')

# number of trains type
urbano = ['Urbano' for i in range(25)]
regional = ['Regional' for i in range(20)]
intercidades = ['Intercidades' for i in range(30)]
alfa_pendular = ['Alfa-pendular' for i in range(10)]
mercadorias = ['Mercadorias' for i in range(15)]

# all trains
trains = urbano + regional + intercidades + alfa_pendular + mercadorias

for train_no in range(len(trains)):
    if trains[train_no] == 'Mercadorias':
        goods = ['M' for m in range(random.randint(5,8))]
        carriages = goods
    else:
        comfort =  ['C' for c in range(random.randint(1,3))]
        economic = ['E' for e in range(random.randint(3,5))]
        carriages = comfort + economic

    no_carriages = len(carriages)
    total_seats = 0
    for carriage_no in range(len(carriages)):
        if carriages[carriage_no] == 'C':
            seats_no = random.randint(50,60)
        elif carriages[carriage_no] == 'E':
            seats_no = random.randint(70,80)
        else:
            seats_no = 0
        total_seats += seats_no
        insert_carriages.write("INSERT INTO RAILWAY.CARRIAGE VALUES ({}, {}, {}, '{}');\n".format(carriage_no + 1, train_no + 1, seats_no, carriages[carriage_no]))
    insert_trains.write("INSERT INTO RAILWAY.TRAIN VALUES ({}, {}, {}, '{}');\n".format(train_no + 1, no_carriages, total_seats, trains[train_no]))
insert_trains.close()
insert_carriages.close()
