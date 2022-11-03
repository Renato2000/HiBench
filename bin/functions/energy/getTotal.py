import re
import sys
import os
from datetime import datetime

hosts = []
for file in os.listdir(os.getcwd()):
    matches = re.findall(r'energy_([\w._]+).csv', file)
    if len(matches) == 1:
        hosts.append(matches[0])

host = hosts[int(sys.argv[1])]
f = open("energy_" + host + ".csv")

total = 0
index = 0
for line in f.readlines():
    if index != 0:
        l = line.split(",")
        energy = float(l[2])
        total += energy
    index += 1

print(round(total, 4))

