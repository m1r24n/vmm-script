lxc image copy images:alpine/edge local: --alias alpine
lxc image copy --vm images:alpine/edge local: --alias alpineVM

# Start LXC instance
lxc launch alpine  lxc
lxc exec lxc sh

passwd root 
apk add openssh iperf python3 py3-flask
cat << EOF | tee -a /etc/ssh/sshd_config
PermitRootLogin yes
EOF
rc-update add sshd
service sshd start


# container

export LXC_NAME=svr3b
export VLAN=32
export OVS=clientsite3
export IPv4=192.168.32.11/24
export GWv4=192.168.32.1
export IPv6=fc00:dead:beef:aa32::1000:11/64
export GWv6=fc00:dead:beef:aa32::1

echo "Creating VM ${LXC_NAME}"
lxc copy lxc ${LXC_NAME}
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
    gateway ${GWv6}
EOF

lxc file push ./interface.conf ${LXC_NAME}/etc/network/interfaces
cat << EOF | tee ./resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
lxc file push ./resolv.conf ${LXC_NAME}/etc/resolv.conf
lxc start ${LXC_NAME}



export LXC_NAME=ext2
export VLAN=11
export OVS=extsvr
export IPv4=172.16.14.102/24
export GWv4=172.16.14.254
export IPv6=fc00:dead:beef:aa14::1000:102/64
export GWv6=fc00:dead:beef:aa14::1

echo "Creating VM ${LXC_NAME}"
lxc copy lxc ${LXC_NAME}
lxc query --request PATCH /1.0/instances/${LXC_NAME} --data "{
  \"devices\": {
    \"eth0\" :{
       \"name\": \"eth0\",
       \"nictype\": \"bridged\",
       \"parent\": \"${OVS}\",
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
    gateway ${GWv6}
EOF

lxc file push ./interface.conf ${LXC_NAME}/etc/network/interfaces
cat << EOF | tee ./resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
lxc file push ./resolv.conf ${LXC_NAME}/etc/resolv.conf
lxc start ${LXC_NAME}
