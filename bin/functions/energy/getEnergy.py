import re
import sys
from datetime import datetime

path = sys.argv[1]

f = open(path + "/energy.csv")

host = sys.argv[2]

for line in f.readlines():
    l = line.split(",")
    energy = l[2]
    if float(energy) < 0:
        energy = 0
    if l[1] == host:
        print(str(energy))
