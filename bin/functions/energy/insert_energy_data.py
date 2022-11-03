import sys
import re

monitor_path = sys.argv[1]

energy_heatmap = ["x,y,value,hostname"]
energy_overall = ["x,value"]

energy_data = open("energy.csv")
for energy_data_line in energy_data.readlines():
    energy_heatmap.append(energy_data_line.replace("\n", ""))

energy_overall_data = open("overall.csv")
for energy_overall_data_line in energy_overall_data.readlines():
    energy_overall.append(energy_overall_data_line.replace("\n", ""))

def my_replace(match):
    match = match.group()[1:-1]
    if match.endswith('heatmap') or match.endswith('overall'):
        return "\n".join(energy_data)
    elif match =='events':
        return "\n".join(energy_overall)
    else:
        return '{%s}' % match
        
with open(monitor_path + "/monitor_energy.html", 'w') as f:
    f.write(re.sub(r'{\w+}', my_replace, monitor_path + "/monitor.html"))