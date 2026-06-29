#!/usr/bin/env bash
for i in ac lxd mpls gw
do
    ssh $i "sudo reboot"
done
