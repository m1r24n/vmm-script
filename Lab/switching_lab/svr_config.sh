# node SVR
#!/bin/bash
VM=svr1
MAC=56:04:15:00:54:96
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


# sw1

set chassis aggregated-devices ethernet device-count 8
delete  interfaces ge-0/0/0 mtu
set interfaces ge-0/0/0 gigether-options 802.3ad ae0
delete  interfaces ge-0/0/1 mtu
set interfaces ge-0/0/1 gigether-options 802.3ad ae0
set interfaces ae0 mtu 9014
set interfaces ae0 aggregated-ether-options lacp active
set interfaces ae0 unit 0 family inet address 10.0.0.0/31
set interfaces ae0 unit 0 family inet6
set interfaces fxp0 unit 0 family inet address 172.16.11.1/24
set interfaces lo0 unit 0 family inet address 10.0.255.1/32
set protocols ospf area 0.0.0.0 interface lo0.0 passive
set protocols ospf area 0.0.0.0 interface ae0.0 interface-type p2p


# sw2
interface lag 1
    no shutdown
    ip mtu 9000
    ip address 10.0.0.1/31
    lacp mode active
    ip ospf 1 area 0.0.0.0
    ip ospf network point-to-point
interface 1/1/1
    no shutdown
    mtu 9000
    lag 1
interface 1/1/2
    no shutdown
    mtu 9000
    lag 1
interface loopback 0
    ip address 10.0.255.2/32
    ip ospf 1 area 0.0.0.0
!
router ospf 1
    router-id 10.0.255.2
    area 0.0.0.0