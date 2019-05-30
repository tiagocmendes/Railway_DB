insert_employee = open('insert_employee.sql', 'w', encoding='utf8')

ids = 100000000

def next_id():
    global ids
    ids+=1
    return ids

for i in range(16):
    insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Diretor',i+1))

for i in range(16):
    insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Motorista',i+1))
    insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Motorista',i+1))

insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Motorista',1))
insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Motorista',2))
insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Motorista',3))

for i in range(16):
    insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Picas',i+1))
    insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Picas',i+1))

insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Picas',1))
insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Picas',2))
insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Picas',3))

for i in range(16):
    insert_employee.write("INSERT INTO Railway.Employee VALUES ({},'{}',{});\n".format(next_id(),'Bilheteiro',i+1))

insert_employee.close()