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

insert_passenger = open('insert_passenger.sql', 'w', encoding='utf8')

f = open('asd.txt','r',encoding='utf8')
ids = 100000102
for line in f:
    line = line.split('(')[1]
    fname = line.split(',')[0].split("'")[1]
    lname = line.split(',')[2].split("'")[1]
    email = "{}_{}@ua.pt".format(fname.lower(),lname.lower())
    pw = generate_pw()
    insert_passenger.write("INSERT INTO Railway.Passenger VALUES ({},'{}', HASHBYTES('SHA1', '{}'));\n".format(ids,email,pw))
    ids+=1