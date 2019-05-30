connects_to = open('connects_to.sql', 'w', encoding='utf8')
for i in range(1,16):
    connects_to.write("INSERT INTO Railway.ConnectsTo VALUES ({},{});\n".format(i,i+1))
    connects_to.write("INSERT INTO Railway.ConnectsTo VALUES ({},{});\n".format(i+1,i))
connects_to.close()