import re
import sys
import os
from datetime import datetime

path = sys.argv[1]
log_file = sys.argv[2]

lines = open(log_file).read()

match = re.search("{\"Event\":\"SparkListenerApplicationStart\",\"App Name\":\"\w*\",\"App ID\":\".*\",\"Timestamp\":(\d*),\"User\":\"\w*\"}", lines)
start_time = int(match.group(1))

match = re.search("{\"Event\":\"SparkListenerApplicationEnd\",\"Timestamp\":(\d*)}", lines)
finish_time = int(match.group(1))

hosts = []
for file in os.listdir(path):
    matches = re.findall(r'energy_([\w._]+).csv', file)
    if len(matches) == 1:
        hosts.append(matches[0])

total = 0

for host in hosts:
    f = open(path + "/energy_" + host + ".csv")

    index = 0
    for line in f.readlines():
        if index != 0:
            l = line.split(",")
            energy = float(l[2])
            time = time = int(datetime.strptime(l[0], "%Y-%m-%d %H:%M:%S").timestamp()) * 1000
            if energy > 0 and time >= start_time and time <= finish_time:
                total += energy
        index += 1

print(str(round(total, 4)))

