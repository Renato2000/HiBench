import re
import sys
import os
from datetime import datetime

report_file = sys.argv[1]

with open(report_file) as f:
    # Read all of the lines of the file into a list
    lines = f.readlines()
    
    # Get the last line of the file by accessing the last element of the list
    last_line = lines[-1]

    # Split the last line into a list of words
    words = last_line.split()

    # Get the fifth word in the last line by accessing the fifth element of the list
    time = words[4]

    # Print the fifth word
    print(time)
