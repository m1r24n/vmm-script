#!/usr/bin/env bash
echo "---" | tee data/nodes_sernum.yaml
for i in {1..5} 
do
sernum=`ssh admin@pe${i} -i ~/.ssh/rdnet36 "show chassis hardware | match Chassis" | tr -s '[:space:]' | cut -f 2 -d " "`
echo "PE${i}: ${sernum}" | tee -a data/nodes_sernum.yaml
sernum=`ssh admin@p${i} -i ~/.ssh/rdnet36 "show chassis hardware | match Chassis" | tr -s '[:space:]' | cut -f 2 -d " "`
echo "P${i}: ${sernum}" | tee -a data/nodes_sernum.yaml
done

# for i in {1..5} 
# do

# done
