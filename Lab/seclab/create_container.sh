#!/bin/bash
echo "Creating VM ${LXC}"
lxc copy client ${LXC}
if [ "${VLAN}" == "" ]; then 
lxc query --request PATCH /1.0/instances/${LXC} --data "{
  \"devices\": {
    \"eth0\" :{
       \"name\": \"eth0\",
       \"nictype\": \"bridged\",
       \"parent\": \"${BRIDGE}\",
       \"type\": \"nic\"
    }
  }
}"
else
lxc query --request PATCH /1.0/instances/${LXC} --data "{
  \"devices\": {
    \"eth0\" :{
       \"name\": \"eth0\",
       \"nictype\": \"bridged\",
       \"parent\": \"${BRIDGE}\",
       \"vlan\" : \"${VLAN}\",
       \"type\": \"nic\"
    }
  }
}"
fi
echo "push configuration into node ${LXC}"

if [ "${IPv6}" == "" ]; then
cat << EOF | tee ./interface.conf
auto eth0
iface eth0 inet static
    address ${IPv4}
    mtu 1500
    gateway ${GWv4}
EOF
else
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
fi

lxc file push ./interface.conf ${LXC}/etc/network/interfaces
cat << EOF | tee ./resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
lxc file push ./resolv.conf ${LXC}/etc/resolv.conf
lxc start ${LXC}
