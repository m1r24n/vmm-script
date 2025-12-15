#!/bin/bash
for i in {1..3}
do
for j in 1 2
do
echo "stop lxc cl${i}${j}-cust2-l2"
lxc stop cl${i}${j}-cust2-l2
lxc rm cl${i}${j}-cust2-l2
done
done