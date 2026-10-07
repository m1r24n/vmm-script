#!/usr/bin/env bash
for i in dhcprelay1 dhcprelay2 lxd1ext ac gw
do
    ssh $i "sudo reboot"
done
