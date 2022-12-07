import re
import sys
import os
from datetime import datetime

path = sys.argv[1]

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
            if energy > 0:
                total += energy
        index += 1

print(str(round(total, 4)))

