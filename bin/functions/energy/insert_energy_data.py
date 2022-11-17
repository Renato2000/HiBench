import sys
import re

energy_path = sys.argv[1]
monitor_path = sys.argv[2]

energy_heatmap = ["x,y,value,hostname"]
energy_overall = ["x,value"]

energy_data = open(energy_path + "energy.csv")
for energy_data_line in energy_data.readlines():
    energy_heatmap.append(energy_data_line.replace("\n", ""))

energy_overall_data = open(energy_path + "overall.csv")
for energy_overall_data_line in energy_overall_data.readlines():
    energy_overall.append(energy_overall_data_line.replace("\n", ""))

def my_replace(match):
    match = match.group()[1:-1]
    if match.endswith('heatmap'):
        return "\n".join(energy_heatmap)
    elif match.endswith('overall'):
        return "\n".join(energy_overall)
    else:
        return '{%s}' % match
       
with open(monitor_path + "monitor.html") as f:
    monitor_file = f.read()

with open(monitor_path + "/monitor_energy.html", 'w') as f:
    f.write(re.sub(r'{\w+}', my_replace, monitor_file))
