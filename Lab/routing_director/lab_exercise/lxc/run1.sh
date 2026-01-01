#!/bin/bash
echo creating LXC
lxc copy client cl11-cust1
lxc query --request PATCH /1.0/instances/cl11-cust1 --data '{"devices": {"eth0": {"name": "eth0", "nictype": "bridged", "parent": "s1-cust1", "type": "nic"}}}'
lxc copy client cl12-cust1
lxc query --request PATCH /1.0/instances/cl12-cust1 --data '{"devices": {"eth0": {"name": "eth0", "nictype": "bridged", "parent": "s1-cust1", "type": "nic"}}}'
lxc copy router ce1-cust1
lxc query --request PATCH /1.0/instances/ce1-cust1 --data '{"devices": {"eth0": {"name": "eth0", "nictype": "bridged", "parent": "pe1ge3", "vlan": "1001", "type": "nic"}, "eth1": {"name": "eth1", "nictype": "bridged", "parent": "s1-cust1", "type": "nic"}}}'
lxc copy client cl31-cust1
lxc query --request PATCH /1.0/instances/cl31-cust1 --data '{"devices": {"eth0": {"name": "eth0", "nictype": "bridged", "parent": "s3-cust1", "type": "nic"}}}'
lxc copy client cl32-cust1
lxc query --request PATCH /1.0/instances/cl32-cust1 --data '{"devices": {"eth0": {"name": "eth0", "nictype": "bridged", "parent": "s3-cust1", "type": "nic"}}}'
lxc copy router ce3-cust1
lxc query --request PATCH /1.0/instances/ce3-cust1 --data '{"devices": {"eth0": {"name": "eth0", "nictype": "bridged", "parent": "pe3ge2", "vlan": "1001", "type": "nic"}, "eth1": {"name": "eth1", "nictype": "bridged", "parent": "s3-cust1", "type": "nic"}}}'