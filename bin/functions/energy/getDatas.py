import re
import sys
from datetime import datetime

path = sys.argv[1]

f = open(path + "/energy.csv")

for line in f.readlines():
    l = line.split(",")
    timestamp = l[0]
    date = datetime.fromtimestamp(int(timestamp) / 1000)
    if l[1] == '0':
        print(str(date))
