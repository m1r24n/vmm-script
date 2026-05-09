# Lab exercise

## Routing Zone and Virtual network

RZ | Virtual Network | vlan | subnetv4| subnetv6
-|-|-|-|-
RZ1| Blue| 101| 192.168.111.0/24| fc00:dead:Beef:a111::/64
RZ1|Red| 102 | 192.168.112.0/24 | fc00:dead:beef:a112::/64
RZ1| left1 | 191| 192.168.191.0/24|fc00:dead:beef:a191::/64
RZ1| right1 | 192| 192.168.192.0/24|fc00:dead:beef:a192::/64
RZ2| Yellow| 121| 192.168.121.0/24| fc00:dead:Beef:a121::/64


## connection to FW1 and FW2

Firewall | interface | IP address | Spine | interface | ip address 
-|-|-|-|-|-
FW1| ge-0/0/1 | 172.16.255.128/31 | dc1spine1 | ge-0/0/9 | 172.16.255.129/31
-| ge-0/0/2 | 172.16.255.130/31 | dc1spine2 | ge-0/0/9 | 172.16.255.131/31
-| ge-0/0/3 | 172.16.255.132/31 | dc1spine3 | ge-0/0/9 | 172.16.255.133/31
-| ge-0/0/4 | 172.16.255.134/31 | dc1spine4 | ge-0/0/9 | 172.16.255.135/31
FW2| ge-0/0/1 | 172.16.255.136/31 | dc2spine1 | ge-0/0/10 | 172.16.255.137/31
-| ge-0/0/2 | 172.16.255.138/31 | dc2spine2 | ge-0/0/10 | 172.16.255.139/31
-| ge-0/0/3 | 172.16.255.140/31 | dc2spine3 | ge-0/0/10 | 172.16.255.141/31
-| ge-0/0/4 | 172.16.255.142/31 | dc2spine4 | ge-0/0/10| 172.16.255.143/31


Device | AS Number
-|-
FW1| 4200009001
FW2| 4200009002