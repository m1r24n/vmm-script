#!/usr/bin/env python3 
import sys, pathlib, yaml, subprocess, json, os
from jinja2 import Template

if len(sys.argv) < 4:
    print("usage:")
    print("create_templay.py <jinja_template> <data> <output>")
    exit(1)
outfile=sys.argv[3]
j2_file=sys.argv[1]
data_file=sys.argv[2]
if not os.path.isfile(j2_file):
    print(f"file {j2_file} is not available")
    exit(1)
if not os.path.isfile(data_file):
    print(f"file {data_file} is not available")
    exit(1)
print(f"reading jinja file {j2_file}")
with open(j2_file) as f1:
    t0=f1.read()
t1=Template(t0)
print(f"reading jinja data {data_file}")
with open(data_file) as f1:
    d0=f1.read()
d1=yaml.load(d0,Loader=yaml.FullLoader)
r0 = t1.render(d1)
r1=yaml.load(r0,Loader=yaml.FullLoader)
print(f"writing file {outfile}")
with open(outfile,"w") as f1:
    f1.write(json.dumps(r1,indent=4))
