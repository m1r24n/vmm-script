#!/usr/bin/env python3
import os, stat
cmd1=["echo 'hello line one'","echo 'hello line 2'","echo 'hello line 3'"]
cmd2 = "\n".join(cmd1)
with open("testing.sh","w") as f1:
    f1.write(cmd2)
os.chmod("testing.sh",0o744)