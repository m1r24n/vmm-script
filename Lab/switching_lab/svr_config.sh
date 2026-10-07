# node SVR
#!/bin/bash
VM=svr3
MAC=56:04:15:00:6e:1e
IPv4=192.168.13.101/24
IPv6=fc00:dead:beef:a13::1000:101/64
GWv4=192.168.13.254
GWv6=fc00:dead:beef:a013::1
sudo hostname ${VM}
hostname | sudo tee /etc/hostname
cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth0:
      dhcp4: no
    eth1:
      dhcp4: no
  bonds:
    bond0:
      macaddress: ${MAC}
      interfaces:
        - eth0
        - eth1
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
uuidgen | sed -e "s/-//g" | sudo tee /etc/machine-id
sudo netplan apply



VM=svr3
MAC=56:04:15:00:6e:1e
IPv4=192.168.13.101/24
IPv6=fc00:dead:beef:a13::1000:101/64
GWv4=192.168.13.254
GWv6=fc00:dead:beef:a013::1
sudo hostname ${VM}
hostname | sudo tee /etc/hostname
cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth0:
      dhcp4: no
    eth1:
      dhcp4: no
  bonds:
    bond0:
      macaddress: ${MAC}
      interfaces:
        - eth0
        - eth1
      parameters:
         mode: 802.3ad
  vlans:
    vlan13:
      link: bond0
      id: 13
      addresses: [ ${IPv4} , ${IPv6}]
      routes:
      - to: 0.0.0.0/0
        via: ${GWv4}
      - to: ::/0
        via: ${GWv6}
      nameservers:
        addresses: [8.8.8.8,8.8.4.4]
EOF
uuidgen | sed -e "s/-//g" | sudo tee /etc/machine-id
sudo netplan apply



# Download image

lxc image copy images:alpine/edge local: --alias alpine
lxc image copy --vm images:alpine/edge local: --alias alpineVM

# Start LXC instance
lxc launch alpine --name lxc

passwd root 
apk add openssh iperf
rc-update add sshd
service sshd start
cat << EOF | tee -a /etc/ssh/sshd_config
PermitRootLogin yes
EOF

# container

export LXC_NAME=cl1sw1
export VLAN=31
export OVS=ovs1
export IPv4=192.168.31.11/24
export GWv4=192.168.31.254
export IPv6=fc00:dead:beef:a031::1000:11/64
export GWv6=fc00:dead:beef:a031::1

echo "Creating VM ${LXC_NAME}"
lxc copy client ${LXC_NAME}
lxc query --request PATCH /1.0/instances/${LXC_NAME} --data "{
  \"devices\": {
    \"eth0\" :{
       \"name\": \"eth0\",
       \"nictype\": \"bridged\",
       \"parent\": \"${OVS}\",
       \"vlan\" : \"${VLAN}\",
       \"type\": \"nic\"
    }
  }
}"
echo "push configuration into node ${LXC_NAME}"
cat << EOF | tee ./interface.conf
auto eth0
iface eth0 inet static
    address ${IPv4}
    mtu 1500
    gateway ${GWv4}
iface eth0 inet6 static
    address ${IPv6}
    gateway ${GWv4}
EOF

lxc file push ./interface.conf ${LXC_NAME}/etc/network/interfaces
cat << EOF | tee ./resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
lxc file push ./resolv.conf ${LXC_NAME}/etc/resolv.conf
lxc start ${LXC_NAME}


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      mtu: 9000
    eth2:
      mtu: 9000
    eth3:
      mtu: 9000
    eth4:
      mtu: 9000
    eth5:
      mtu: 9000
    eth6:
      mtu: 9000
    eth7:
      mtu: 9000
  bonds:
    bond1:
        macaddress: 56:04:1b:00:07:22
        interfaces:
        - eth1
        - eth2
        parameters:
            mode: 802.3ad
    bond2:
        macaddress: 56:04:15:00:54:a5
        interfaces:
        - eth3
        - eth4
        parameters:
            mode: 802.3ad
    bond3:
        macaddress: 56:04:15:00:57:32
        interfaces:
        - eth5
        - eth6
        parameters:
            mode: 802.3ad
    bond4:
        macaddress: 56:04:15:00:55:2e
        interfaces:
        - eth7
        - eth8
        parameters:
            mode: 802.3ad
  bridges:
    ovs1:
      openvswitch: {}
      interfaces:
      - bond1
    ovs2:
      openvswitch: {}
      interfaces:
      - bond2
    ovs3:
      openvswitch: {}
      interfaces:
      - bond3
    ovs4:
      openvswitch: {}
      interfaces:
      - bond4
EOF



cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      mtu: 9000
    eth3:
      mtu: 9000
  bridges:
    ovs1:
      openvswitch: {}
      interfaces:
      - eth1
    ovs2:
      openvswitch: {}
      interfaces:
      - eth3
EOF

