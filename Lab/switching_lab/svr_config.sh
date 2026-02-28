# node SVR
#!/bin/bash
VM=svr1
MAC=56:04:15:00:6b:40
IPv4=192.168.10.101/24
IPv6=fc00:dead:beef:a10::1000:101/64
GWv4=192.168.10.1
GWv6=fc00:dead:beef:a010::1
# sudo hostname ${VM}
# hostname | sudo tee /etc/hostname
cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      dhcp4: no
    eth2:
      dhcp4: no
  bonds:
    bond0:
      macaddress: ${MAC}
      interfaces:
        - eth1
        - eth2
      parameters:
         mode: 802.3ad
      addresses: [ ${IPv4} , ${IPv6}]
      routes:
      - to: 0.0.0.0/0
        via: ${GWv4}
      - to: ::/0
        via: ${GWv6}
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
EOF
#uuidgen | sed -e "s/-//g" | sudo tee /etc/machine-id
sudo netplan apply



set interfaces ge-0/0/0 description "connection to port eth1 of svr1"
set interfaces ge-0/0/0 gigether-options 802.3ad ae0
set interfaces ge-0/0/1 description "connection to port eth2 of svr1"
set interfaces ge-0/0/1 gigether-options 802.3ad ae0
set interfaces ge-0/0/2 description "connection to port eth1 of svr2"
set interfaces ge-0/0/2 mtu 9000
set interfaces ge-0/0/3 description "connection to port eth2 of svr2"
set interfaces ge-0/0/3 mtu 9000
set interfaces ae0 aggregated-ether-options lacp active
set interfaces ae0 unit 0 family ethernet-switching interface-mode access
set interfaces ae0 unit 0 family ethernet-switching vlan members vlan10
set interfaces fxp0 unit 0 family inet address 172.16.11.10/24
set interfaces irb unit 10 family inet address 192.168.10.1/24
set vlans vlan10 vlan-id 10
set vlans vlan10 l3-interface irb.10