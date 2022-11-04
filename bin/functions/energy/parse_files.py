import os
import re
import sys
from datetime import datetime

current_dir = sys.argv[1]

energy_heatmap_file = open(current_dir + '/energy.csv', 'w')
energy_overall_file = open(current_dir + '/overall.csv', 'w')

hosts = []

for file in os.listdir(current_dir):
    matches = re.findall(r'energy_([\w._]+).csv', file)
    if len(matches) == 1:
        hosts.append(matches[0])

# parse data
hostno = 0
tot = 0
data = {}
sizes = []
highest = None
lowest = None
for host in hosts:
    data[host] = {}
    f = open(current_dir + '/energy_' + host + '.csv', 'r')
    lineno = 0
    for line in f.readlines():            
        if lineno != 0:
            time = int(datetime.strptime(line.split(',')[0], "%Y-%m-%d %H:%M:%S").timestamp()) * 1000
            data[host][time] = {
                'time': time,
                'hostno': hostno,
                'value': float(line.split(',')[3]),
                'host': host
                }
            tot += 1
            if lineno == 1 and (lowest == None or time > lowest):
                lowest = time
        lineno += 1
    if not highest or time < highest: 
        highest = time
    sizes.append(tot)
    hostno += 1
    f.close()

# get data from intervals
results = {}
hostno = 0
valid = 0
last = 0
for host in hosts:
    it = 1
    acc = 0
    for i in range(lowest, highest + 1000, 1000):
        if i in data[host] and data[host][i]['value'] >= 0:
            acc = acc + data[host][i]['value']
            valid += 1
        if it % 5 == 0:
            value = 0
            if valid != 0: 
                value = round(acc / valid, 5)
            if i - 2000 not in results:
                results[i - 2000] = {}
            last = i - 2000
            results[i - 2000][host] = {
                'time': str(i - 2000),
                'hostno': str(hostno),
                'value': str(value),
                'host': host
            }
            acc = 0
            valid = 0
        it += 1
    if valid != 0:
        index = last + 5000
        if index not in results:
            results[index] = {}
        value = round(acc / valid, 5)
        if value < 0: 
            value = 0
        results[index][host] = {
            'time': str(index),
            'hostno': str(hostno),
            'value': str(value),
            'host': host
        }
        acc = 0
        valid = 0
    hostno += 1

# save results
for i in results.keys():
    tot = 0
    for host in hosts:
        tot += float(results[i][host]['value'])
        parsed_line = str(results[i][host]['time']) + "," + str(results[i][host]['hostno']) + "," + str(results[i][host]['value']) + "," + results[i][host]['host'] + "\n"
        _ = energy_heatmap_file.write(parsed_line)
        #print(parsed_line.replace("\n", ""))
    _ = energy_overall_file.write(str(i) + ',' + str(round(tot,5)) + '\n')
                

energy_heatmap_file.close()
energy_overall_file.close()
