import re
import sys
from datetime import datetime

f = open("energy.csv")

host = sys.argv[1]

for line in f.readlines():
    l = line.split(",")
    energy = l[2]
    if l[1] == host:
        print(str(energy))
