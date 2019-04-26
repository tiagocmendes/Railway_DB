
insert_employee = open('insert_employee.sql', 'w', encoding='utf8')
for i in range(35):
    insert_employee.write("INSERT INTO RAILWAY.EMPLOYEE VALUES ({},'Diretor',{});\n".format(100000001+i,i+1))

emp_no = 36
for i in range(35):
    insert_employee.write("INSERT INTO RAILWAY.EMPLOYEE VALUES ({},'Normal',{});\n".format(100000001+emp_no+i,i+1))
    emp_no+=1
    insert_employee.write("INSERT INTO RAILWAY.EMPLOYEE VALUES ({},'Bilheteiro',{});\n".format(100000001+emp_no+i,i+1))
    emp_no+=1
    insert_employee.write("INSERT INTO RAILWAY.EMPLOYEE VALUES ({},'Motorista',{});\n".format(100000001+emp_no+i,i+1))
    emp_no+=1
