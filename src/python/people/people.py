# coding: utf-8
import random

insert_people = open('insert_people.sql', 'w', encoding='utf8')

f = open('last_names.txt', 'r')
last_names = []
for line in f:
    last_names.append(line.strip('\n'))

male_names = ['André', 'António', 'José', 'Vasco', 'Tiago', 'Tomás', 'Dinis', 'André', 'Rodrigo', 'Roberto', 'Filipe', 'João', 'Rui', 'Duarte', 'Dinis', 'Luís', 'Jorge', 'Rafael', 'Cristiano', 'Marcelo', 'Mateus', 'Jonhy', 'Paulo', 'Ângelo', 'Daniel', 'Jon', 'Tyrion']
female_names = ['Ana', 'Beatriz', 'Inês', 'Filipa', 'Leonor', 'Catarina', 'Carolina', 'Maria', 'Marta', 'Sofia', 'Rafela', 'Joana', 'Mariana', 'Matilde', 'Emília', 'Daenerys', 'Irina', 'Lara', 'Cristina', 'Cremilde', 'Amélia', 'Idalina']

postal_codes = {
                'Açores': [9500, 9980],
                'Aveiro': [3020, 4550],
                'Beja': [7230,7960],
                'Braga': [4615,4905],
                'Bragança': [5140,5385],
                'Castelo Branco': [6000,6320],
                'Coimbra': [3000,6285],
                'Évora': [2965,7490],
                'Faro': [8000,8970],
                'Guarda': [3570,6440],
                'Leiria': [2400,3280],
                'Lisboa': [1000,2799],
                'Madeira': [9000,9400],
                'Portalegre': [6040,7480],
                'Porto': [4000,5040],
                'Santarém': [2000,6120],
                'Setúbal': [2100,7595],
                'Viana do Castelo': [4900,4990],
                'Vila Real': [4870,5470],
                'Viseu': [3360,5130],
                }


ids = 100000000
nifs = 100000000
phones = 900000000
d = open('dates.txt', 'r')
dates = []
for line in d:
    dates.append(line.strip('\n'))

# males
for i in range(100):
    # id
    id = ids
    ids+=1

    # name
    fname = random.choice(male_names)
    lname = random.choice(last_names)

    # birthdate
    birthdate = random.choice(dates)

    # nif
    nif = nifs
    nifs+=1

    # city and postal code
    city = random.choice(list(postal_codes))
    postal_code = random.randint(postal_codes[city][0],postal_codes[city][1])

    # phone
    phone = phones
    phones+=1

    insert_people.write("INSERT INTO Railway.Person VALUES ('{}',NULL,'{}','{}',{},'M','{}','{}','Portugal',{});\n".format(fname,lname,birthdate,nif, postal_code, city,phone))

for i in range(100):
    # id
    id = ids
    ids+=1

    # name
    fname = random.choice(female_names)
    lname = random.choice(last_names)

    # birthdate
    birthdate = random.choice(dates)

    # nif
    nif = nifs
    nifs+=1

    # city and postal code
    city = random.choice(list(postal_codes))
    postal_code = random.randint(postal_codes[city][0],postal_codes[city][1])

    # phone
    phone = phones
    phones+=1

    insert_people.write("INSERT INTO Railway.Person VALUES ('{}',NULL,'{}','{}',{},'F','{}','{}','Portugal',{});\n".format(fname,lname,birthdate,nif, postal_code, city,phone))
insert_people.close()