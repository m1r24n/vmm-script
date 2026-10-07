# IP address table

Host | Virtual Network | ip address
-|-|-
svr1| Blue | 192.168.101.11/24
svr2| Red | 192.168.102.12/24
svr3| Red | 192.168.102.13/24
svr4| Blue | 192.168.101.14/24
svr5| Yellow | 192.168.121.12/24



Host | Virtual Network | hypervisor | ip address
-|-|-|-
vm1blue| Blue | LXD1 | 192.168.101.101/24
vm1red| Red | LXD1 | 192.168.102.101/24
vm1yellow| yellow | LXD1|192.168.121.101/24
vm2blue| Blue | LXD3 | 192.168.101.102/24
vm2yellow| yellow | LXD3|192.168.121.102/24
vm3blue| Blue | LXD5 | 192.168.101.103/24
vm3red| Red | LXD5 | 192.168.102.103/24
