import re
import sys
from datetime import datetime

f = open("energy.csv")

host = sys.argv[1]

for line in f.readlines():
    l = line.split(",")
    timestamp = l[0]
    date = datetime.fromtimestamp(int(timestamp) / 1000)
    if l[1] == host:
        print(str(date))