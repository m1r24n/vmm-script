#!/usr/bin/env bash
for i in client1 client2 mon1 gw
do
    ssh $i "sudo reboot"
done
