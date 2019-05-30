import random

# open files for saving SQL insert operations
insert_trains = open('insert_trains.sql', 'w')
insert_carriages = open('insert_carriages.sql', 'w')

# number of trains type
urbano_regional = ['UR' for i in range(12)]
intercidades = ['IC' for i in range(8)]
alfa_pendular = ['AP' for i in range(5)]
mercadorias = ['M' for i in range(10)]

# all trains
trains = urbano_regional + intercidades + alfa_pendular + mercadorias

for train_no in range(len(trains)):
    if trains[train_no] == 'M':
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
            seats_no = random.randint(20,40)
        elif carriages[carriage_no] == 'E':
            seats_no = random.randint(50,70)
        else:
            seats_no = 0
        total_seats += seats_no
        insert_carriages.write("INSERT INTO Railway.Carriage VALUES ({}, {}, {}, '{}');\n".format(carriage_no + 1, train_no + 1, seats_no, carriages[carriage_no]))
    insert_trains.write("INSERT INTO Railway.Train VALUES ({}, {}, '{}');\n".format(no_carriages, total_seats, trains[train_no]))
insert_trains.close()
insert_carriages.close()
