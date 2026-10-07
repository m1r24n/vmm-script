#!/usr/bin/env bash
for i in nms1 client1 gw
do
    ssh $i "sudo reboot"
done
