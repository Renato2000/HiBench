import re
import sys
import os
from datetime import datetime

path = sys.argv[1]

start_string = '<pre id="csv_cpu_overall" style="display: none">'
end_string = '</pre>'

total = 0
num_values = 0

with open(path) as f:
    file_content = f.read()

    # Extract the content between start and end strings
    match = re.search(f'{re.escape(start_string)}(.*?)\\s*{re.escape(end_string)}', file_content, re.DOTALL)
    if match:
        pre_content = match.group(1)
        lines = pre_content.strip().split('\n')[1:]  # Exclude the first line

        # Print the values line by line
        for line in lines:
            num_values += 1
            total += float(line.strip().split(',')[2])

        print(round(total / num_values, 4))
    else:
        print("Could not get cpu % from file")
