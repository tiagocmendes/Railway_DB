def sum_horas(hour1, hour2):
    hour1 = hour1.split(':')

    total_hours = int(hour1[0]) + int(hour2)

    if total_hours < 10:
        total_hours = '0' + str(total_hours) 
    elif total_hours >= 24:
        total_hours = '0' + str(total_hours - 24)
    
    return str(total_hours) + ":" + str(hour1[1])

f = open('insert_urbanos.sql', 'w', encoding='utf8')
hours = [0,5,10,14,18]
for hour in hours:
    urbanos = open('urbanos.txt', 'r', encoding='utf8')
    for line in urbanos:
        station1 = line.rstrip().split('(')[1].split(',')[3]
        station2 = line.rstrip().split('(')[1].split(',')[4]
        first_hour = line.rstrip().split('(')[1].split(',')[1]
        second_hour = line.rstrip().split('(')[1].split(',')[2]
        first_hour = first_hour.split("'")[1]
        second_hour = second_hour.split("'")[1]
        first_hour = sum_horas(str(first_hour), hour)
        second_hour = sum_horas(str(second_hour), hour)
        f.write("INSERT INTO Railway.Trip VALUES ('UR','{}','{}',{},{},NULL);\n".format(first_hour,second_hour,station1,station2))
    urbanos.close()