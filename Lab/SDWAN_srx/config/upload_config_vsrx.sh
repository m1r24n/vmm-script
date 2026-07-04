#!/usr/bin/env bash
for i in hq br{1..3}
do 
scp ../tmp/${i}.conf admin@$i:~/
done
