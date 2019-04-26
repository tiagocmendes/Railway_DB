import random
import string

def generate_pw():
    pwd = []
    for i in range(7):
        pwd.append(random.choice(string.ascii_lowercase))
        pwd.append(random.choice(string.ascii_uppercase))
        pwd.append(str(random.randint(0,9)))
    random.shuffle(pwd)
    return ''.join(pwd)

insert_passenger = open('insert_passenger.sql','w',encoding='utf8')

names = {
    100000176: ['Carolina', 'Machado'],
    100000177: ['Ana', 'Carvalho'],
    100000178: ['Daenerys', 'Melo'],
    100000179: ['Cremilde', 'Baptista'],
    100000180: ['Inês', 'Henriques'],
    100000181: ['Catarina', 'Machado'],
    100000182: ['Ana', 'Matias'],
    100000183: ['Maria', 'Vicente'],
    100000184: ['Marta', 'Nunes'],
    100000185: ['Joana', 'Oliveira'],
    100000186: ['Carolina', 'Ramos'],
    100000187: ['Joana', 'Jesus'],
    100000188: ['Irina', 'Maia'],
    100000189: ['Mariana', 'Abreu'],
    100000190: ['Filipa', 'Anjos'],
    100000191: ['Irina', 'Correia'],
    100000192: ['Maria', 'Gonçalves'],
    100000193: ['Sofia', 'Coelho'],
    100000194: ['Beatriz', 'Pinto'],
    100000195: ['Cremilde', 'Coelho'],
    100000196: ['Matilde', 'Andrade'],
    100000197: ['Lara', 'Lima'],
    100000198: ['Marta', 'Leal'],
    100000199: ['Beatriz', 'Machado'],
}

for name in names:
    email = "{}_{}@ua.pt".format(names[name][0].lower(),names[name][1].lower())
    pw = generate_pw()
    insert_passenger.write("INSERT INTO RAILWAY.PASSENGER VALUES ({},'{}','{}');\n".format(name, email,pw))
insert_passenger.close()
