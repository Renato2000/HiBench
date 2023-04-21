import re
import sys
from datetime import datetime

log_file = sys.argv[1]

lines = open(log_file).read()

match = re.search("{\"Event\":\"SparkListenerApplicationStart\",\"App Name\":\"\w*\",\"App ID\":\".*\",\"Timestamp\":(\d*),\"User\":\"\w*\"}", lines)
start_time = int(match.group(1)) / 1000

match = re.search("{\"Event\":\"SparkListenerApplicationEnd\",\"Timestamp\":(\d*)}", lines)
end_time = int(match.group(1)) / 1000

start_datetime = datetime.fromtimestamp(start_time)
end_datetime = datetime.fromtimestamp(end_time)
time_diff = (end_datetime - start_datetime).total_seconds()

print(time_diff)
