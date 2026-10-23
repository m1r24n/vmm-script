# on node GW, add static route to 172.16.53.0/24 via 172.16.62.6

    cat << EOF | sudo tee /etc/netplan/02_net.yaml
    network:
        ethernets:
            eth1:
                addresses : ['172.16.61.254/24', 'fc00:dead:beef:ff61::FFFF/64']
            eth2:
                addresses : ['172.16.62.254/24', 'fc00:dead:beef:ff62::FFFF/64']
                routes:
                - to: 172.16.53.0/24
                  via: 172.16.62.6
                - to: 172.16.52.0/24
                  via: 172.16.62.6
                - to: 172.16.51.0/24
                  via: 172.16.62.6
            eth3:
                addresses : ['172.16.63.254/24', 'fc00:dead:beef:ff63::FFFF/64']
    EOF
    sudo netplan apply

# lxd1ext1

    cat << EOF | sudo tee /etc/netplan/02_net.yaml
    network:
        bridges:
            ext:
                interfaces: [eth2]    
            vxlangw:
                interfaces: [eth1]
    EOF
    sudo netplan apply

# PE3

    set policy-options policy-statement NH then next-hop self
    set policy-options policy-statement NH then accept
    set routing-instances vrf_mgmt instance-type vrf
    set routing-instances vrf_mgmt protocols bgp source-packet-routing srv6 locator SRV6-LOC-1 micro-dt4-sid
    set routing-instances vrf_mgmt protocols bgp source-packet-routing srv6 locator SRV6-LOC-1 micro-dt6-sid
    set routing-instances vrf_mgmt interface ge-0/0/3.0
    set routing-instances vrf_mgmt route-distinguisher 10.100.255.3:1001
    set routing-instances vrf_mgmt vrf-target target:65000:1001
    set routing-instances vrf_mgmt vrf-table-label
    set routing-options source-packet-routing srv6 block USID_BLOCK 5f00:0000::/32
    set routing-options source-packet-routing srv6 locator SRV6-LOC-1 5f00:0000:0100::/48
    set routing-options source-packet-routing srv6 locator SRV6-LOC-1 micro-sid block-name USID_BLOCK
    set routing-options route-distinguisher-id 10.100.255.1
    set routing-options router-id 10.100.255.1
    set routing-options autonomous-system 4200000001
    set protocols bgp group to_p1 type internal
    set protocols bgp group to_p1 local-address fc00:dead:beef:ffff::ffff:1
    set protocols bgp group to_p1 family inet-vpn unicast extended-nexthop
    set protocols bgp group to_p1 family inet-vpn unicast advertise-srv6-service
    set protocols bgp group to_p1 family inet-vpn unicast accept-srv6-service
    set protocols bgp group to_p1 family inet6-vpn unicast advertise-srv6-service
    set protocols bgp group to_p1 family inet6-vpn unicast accept-srv6-service
    set protocols bgp group to_p1 neighbor fc00:dead:beef:ffff::ffff:11 export NH
    set protocols bgp rfc8950-compliant
    set protocols isis source-packet-routing srv6 locator SRV6-LOC-1 micro-node-sid

# PE2


    set policy-options policy-statement NH then next-hop self
    set policy-options policy-statement NH then accept
    set routing-instances vrf_mgmt instance-type vrf
    set routing-instances vrf_mgmt protocols bgp source-packet-routing srv6 locator SRV6-LOC-1 micro-dt4-sid
    set routing-instances vrf_mgmt protocols bgp source-packet-routing srv6 locator SRV6-LOC-1 micro-dt6-sid
    set routing-instances vrf_mgmt interface ge-0/0/3.0
    set routing-instances vrf_mgmt route-distinguisher 10.100.255.2:1001
    set routing-instances vrf_mgmt vrf-target target:65000:1001
    set routing-instances vrf_mgmt vrf-table-label
    set routing-options source-packet-routing srv6 block USID_BLOCK 5f00:0000::/32
    set routing-options source-packet-routing srv6 locator SRV6-LOC-1 5f00:0000:0200::/48
    set routing-options source-packet-routing srv6 locator SRV6-LOC-1 micro-sid block-name USID_BLOCK
    set routing-options route-distinguisher-id 10.100.255.2
    set routing-options router-id 10.100.255.2
    set routing-options autonomous-system 4200000001
    set protocols bgp group to_p1 type internal
    set protocols bgp group to_p1 local-address fc00:dead:beef:ffff::ffff:2
    set protocols bgp group to_p1 family inet-vpn unicast extended-nexthop
    set protocols bgp group to_p1 family inet-vpn unicast advertise-srv6-service
    set protocols bgp group to_p1 family inet-vpn unicast accept-srv6-service
    set protocols bgp group to_p1 family inet6-vpn unicast advertise-srv6-service
    set protocols bgp group to_p1 family inet6-vpn unicast accept-srv6-service
    set protocols bgp group to_p1 neighbor fc00:dead:beef:ffff::ffff:11 export NH
    set protocols bgp rfc8950-compliant
    set protocols isis source-packet-routing srv6 locator SRV6-LOC-1 micro-node-sid



# PE1


    set policy-options policy-statement NH then next-hop self
    set policy-options policy-statement NH then accept
    set routing-instances vrf_mgmt instance-type vrf
    set routing-instances vrf_mgmt protocols bgp source-packet-routing srv6 locator SRV6-LOC-1 micro-dt4-sid
    set routing-instances vrf_mgmt protocols bgp source-packet-routing srv6 locator SRV6-LOC-1 micro-dt6-sid
    set routing-instances vrf_mgmt interface ge-0/0/3.0
    set routing-instances vrf_mgmt route-distinguisher 10.100.255.1:1001
    set routing-instances vrf_mgmt vrf-target target:65000:1001
    set routing-instances vrf_mgmt vrf-table-label
    set routing-options source-packet-routing srv6 block USID_BLOCK 5f00:0000::/32
    set routing-options source-packet-routing srv6 locator SRV6-LOC-1 5f00:0000:0100::/48
    set routing-options source-packet-routing srv6 locator SRV6-LOC-1 micro-sid block-name USID_BLOCK
    set routing-options route-distinguisher-id 10.100.255.1
    set routing-options router-id 10.100.255.1
    set routing-options autonomous-system 4200000001
    set protocols bgp group to_p1 type internal
    set protocols bgp group to_p1 local-address fc00:dead:beef:ffff::ffff:1
    set protocols bgp group to_p1 family inet-vpn unicast extended-nexthop
    set protocols bgp group to_p1 family inet-vpn unicast advertise-srv6-service
    set protocols bgp group to_p1 family inet-vpn unicast accept-srv6-service
    set protocols bgp group to_p1 family inet6-vpn unicast advertise-srv6-service
    set protocols bgp group to_p1 family inet6-vpn unicast accept-srv6-service
    set protocols bgp group to_p1 neighbor fc00:dead:beef:ffff::ffff:11 export NH
    set protocols bgp rfc8950-compliant
    set protocols isis source-packet-routing srv6 locator SRV6-LOC-1 micro-node-sid


## P1

    set policy-options policy-statement LB term 1 then load-balance per-flow
    set policy-options policy-statement LB term 1 then accept
    set routing-options source-packet-routing srv6 block USID_BLOCK 5f00:0000::/32
    set routing-options source-packet-routing srv6 locator SRV6-LOC-1 5f00:0000:1000::/48
    set routing-options source-packet-routing srv6 locator SRV6-LOC-1 micro-sid block-name USID_BLOCK
    set routing-options route-distinguisher-id 10.100.255.11
    set routing-options router-id 10.100.255.11
    set routing-options autonomous-system 4200000001
    set routing-options forwarding-table export LB
    set protocols bgp group to_pe type internal
    set protocols bgp group to_pe local-address fc00:dead:beef:ffff::ffff:11
    set protocols bgp group to_pe passive
    set protocols bgp group to_pe family inet-vpn unicast extended-nexthop
    set protocols bgp group to_pe family inet6-vpn unicast
    set protocols bgp group to_pe cluster 10.100.255.11
    set protocols bgp group to_pe allow fc00:dead:beef:ffff::/64
    set protocols bgp rfc8950-compliant
    set protocols isis source-packet-routing srv6 locator SRV6-LOC-1 micro-node-sid


## dhcprelay1

    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                addresses: [ 172.16.51.10/24]
                nameservers:
                    addresses: [ 172.16.62.254]
                    search: [vmmlab.com]
                routes:
                - to: default
                  via: 172.16.51.254
    EOF
    sudo hostname dhcprelay1
    hostname | sudo tee /etc/hostname
    sudo netplan apply


## dhcprelay2

    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                addresses: [ 172.16.52.10/24]
                nameservers:
                    addresses: [ 172.16.62.254]
                    search: [vmmlab.com]
                routes:
                - to: default
                  via: 172.16.52.254
    EOF
    sudo hostname dhcprelay2
    hostname | sudo tee /etc/hostname
    sudo netplan apply

## ubuntu server configuration 
# node SVR
    #!/bin/bash
    VM=svr3dc2
    MAC=56:04:15:00:6c:ac
    IPv4=192.168.202.13/24
    IPv6=fc00:dead:beef:a202::1000:13/64
    GWv4=192.168.202.1
    GWv6=fc00:dead:beef:a202::1
    DNS=172.16.62.254
    sudo hostname ${VM}
    hostname | sudo tee /etc/hostname
    cat << EOF | sudo tee /etc/netplan/01_net.yaml
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
                nameservers:
                    addresses: [${DNS}]
    EOF
    uuidgen | sed -e "s/-//g" | sudo tee /etc/machine-id
    sudo netplan apply

## node LXD

install LXD

    sudo lxd init
    lxc image copy images:alpine/edge local: --alias alpine
    lxc launch alpine server
    lxc exec server sh 
    apk update
    apk upgrade
    apk add openssh iperf links
    rc-update add sshd
    cat << EOF | tee -a /etc/ssh/sshd_config
    PermitRootLogin yes
    EOF
    passwd
    service sshd start
    lxc stop server

create OVS bridge and LAG interface

    #!/bin/bash
    export MAC=56:04:15:00:55:d7
    export INTF1=eth0
    export INTF2=eth1
    export IPv4=192.168.2.103/24
    export IPv6=fc00:dead:beef:a002::1000:103/64
    export GW4=192.168.2.1
    export DNS=172.16.62.254
    export H1=lxc3dc2
    sudo hostname ${H1}
    hostname | sudo tee /etc/hostname
    cat << EOF | sudo tee /etc/netplan/02_net.yaml
    network:
        ethernets:
            ${INTF1}:
                dhcp4: no
                mtu: 9000
            ${INTF2}:
                dhcp4: no
                mtu: 9000
        bridges:
            ovs0:
                openvswitch: {}
                interfaces: [ bond0 ]
                addresses: [ ${IPv4}, ${IPv6}]
                gateway4: ${GW4}
                nameservers:
                    addresses: [ ${DNS} ]
        bonds:
            bond0:
                macaddress: ${MAC}
                mtu: 9000
                interfaces:
                - ${INTF1}
                - ${INTF2}
                parameters:
                    mode: 802.3ad
    EOF
    sudo netplan apply

create LXC container with vlan

    export LXC_NAME=lxc1
    export VLAN=201
    export OVS=ovs0
    export IPv4=192.168.201.102/24
    export GWv4=192.168.201.1
    export IPv6=fc00:dead:beef:a201::1000:102/64
    export GWv6=fc00:dead:beef:a201::1
    export SOURCE_LXC=server
    export DNS=172.16.62.254
    #!/bin/bash
    echo "Creating VM ${LXC_NAME}"
    lxc copy ${SOURCE_LXC} ${LXC_NAME}
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
    nameserver ${DNS}
    EOF
    lxc file push ./resolv.conf ${LXC_NAME}/etc/resolv.conf
    lxc start ${LXC_NAME}

create LXC container without vlan

    export LXC_NAME=lxc1
    export VLAN=201
    export OVS=ovs0
    export IPv4=192.168.201.102/24
    export GWv4=192.168.201.1
    export IPv6=fc00:dead:beef:a201::1000:102/64
    export GWv6=fc00:dead:beef:a201::1
    export SOURCE_LXC=server
    export DNS=172.16.62.254
    #!/bin/bash
    echo "Creating VM ${LXC_NAME}"
    lxc copy ${SOURCE_LXC} ${LXC_NAME}
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
    nameserver ${DNS}
    EOF
    lxc file push ./resolv.conf ${LXC_NAME}/etc/resolv.conf
    lxc start ${LXC_NAME}

## FRR configuration on node GW

    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
    sudo systemctl restart frr

    !
    ipv6 route ::/0 Null0
    !
    no router bgp 4200000001
    router bgp 4200000001
    no bgp ebgp-requires-policy
    neighbor 172.16.63.3 remote-as 4200009001
    neighbor 172.16.63.3 bfd
    neighbor 172.16.63.3 bfd profile BFD1
    neighbor fc00:dead:beef:ff63::3 remote-as 4200009001
    neighbor fc00:dead:beef:ff63::3 bfd
    neighbor fc00:dead:beef:ff63::3 bfd profile BFD1
     neighbor 172.16.63.6 remote-as 4200009002
    neighbor 172.16.63.6 bfd
    neighbor 172.16.63.6 bfd profile BFD1
    neighbor fc00:dead:beef:ff63::6 remote-as 4200009002
    neighbor fc00:dead:beef:ff63::6 bfd
    neighbor fc00:dead:beef:ff63::6 bfd profile BFD1

    !
    address-family ipv4 unicast
    network 0.0.0.0/0
    exit-address-family
    !
    address-family ipv6 unicast
    network ::/0
    neighbor fc00:dead:beef:ff63::3 activate
    neighbor fc00:dead:beef:ff63::6 activate
    exit-address-family
    exit
    !
    bfd
    profile BFD1
    transmit-interval 500
    receive-interval 500
    exit
    !
    exit
    !


# basis configuration fwext1, fwext2, fw1/fw2

    set system host-name fw1
    set system root-authentication encrypted-password "$1$X.Q52Yjv$qOBjPbq6AzlCCOGW/8ki7."
    set system login user admin class super-user
    set system login user admin authentication encrypted-password "$6$wXEML3m7$iFDcokpuGRfSumXK1d/UwhAM1H6Ge72hVSIFz/SwOeNh1ssw4seHJO6WaDLyran0Xog6NBv5LdJ0Jd1jE7oPS0"
    set system services ssh root-login allow
    set system services ssh sftp-server
    set system services netconf ssh
    set system management-instance
    set interfaces fxp0 unit 0 family inet dhcp


## fwext1

configuration for RZ1 on *fwext1*

    set interfaces ge-0/0/0 unit 0 family inet address 172.16.63.3/24
    set interfaces ge-0/0/0 unit 0 family inet6 address fc00:dead:beef:ff63::3/64
    set security zones security-zone untrust host-inbound-traffic system-services ping
    set security zones security-zone untrust host-inbound-traffic protocols bgp
    set security zones security-zone untrust host-inbound-traffic protocols bfd
    set security zones security-zone untrust interfaces ge-0/0/0.0
    set protocols bgp group to_ext bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_ext bfd-liveness-detection multiplier 3
    set protocols bgp group to_ext neighbor 172.16.63.254 export to_ext
    set protocols bgp group to_ext neighbor 172.16.63.254 peer-as 4200000001
    set protocols bgp group to_ext neighbor fc00:dead:beef:ff63::ffff peer-as 4200000001
    set routing-options autonomous-system 4200009001
    set routing-options static route 172.16.1.0/28 discard
    set routing-options static route 172.16.1.16/28 discard
    set policy-options policy-statement to_ext term 1 from route-filter 172.16.1.0/28 orlonger
    set policy-options policy-statement to_ext term 1 then accept
    set policy-options policy-statement to_ext term 2 from route-filter 172.16.1.16/28 orlonger
    set policy-options policy-statement to_ext term 2 then accept
    set policy-options policy-statement to_ext term default then reject

    set interfaces ge-0/0/1 vlan-tagging
    set interfaces ge-0/0/1 unit 1001 vlan-id 1001
    set interfaces ge-0/0/1 unit 1001 family inet address 172.16.100.1/31
    set interfaces ge-0/0/1 unit 1001 family inet6 address fc00:dead:beef:f100::1/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1001 vlan-id 1001
    set interfaces ge-0/0/2 unit 1001 family inet address 172.16.100.3/31
    set interfaces ge-0/0/2 unit 1001 family inet6 address fc00:dead:beef:f100::3/127
    set security zones security-zone RZ1 host-inbound-traffic system-services ping
    set security zones security-zone RZ1 host-inbound-traffic system-services ssh
    set security zones security-zone RZ1 host-inbound-traffic protocols all
    set security zones security-zone RZ1 interfaces ge-0/0/1.1001
    set security zones security-zone RZ1 interfaces ge-0/0/2.1001
    set protocols bgp group to_border_leaf_RZ1 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ1 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ1 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ1 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ1 neighbor 172.16.100.0 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ1 neighbor 172.16.100.2 peer-as 4200001106
    set protocols bgp group to_border_leaf_RZ1 neighbor fc00:dead:beef:f100::0 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ1 neighbor fc00:dead:beef:f100::2 peer-as 4200001106
    set policy-options policy-statement to_border_leaf term 1 from route-filter 0.0.0.0/0 exact
    set policy-options policy-statement to_border_leaf term 1 then accept
    set policy-options policy-statement to_border_leaf term 2 from route-filter ::/0 exact
    set policy-options policy-statement to_border_leaf term 2 then accept
    set policy-options policy-statement to_border_leaf term default then reject

    set security nat source pool pool1 address 172.16.1.0/28
    set security nat source rule-set rs1 from zone RZ1
    set security nat source rule-set rs1 to zone untrust
    set security nat source rule-set rs1 rule rule1 match source-address 0.0.0.0/0
    set security nat source rule-set rs1 rule rule1 match destination-address 0.0.0.0/0
    set security nat source rule-set rs1 rule rule1 match application any
    set security nat source rule-set rs1 rule rule1 then source-nat pool pool1

    set security nat destination pool dnat1 address 192.168.101.11/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule1 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule1 match destination-address 172.16.1.16/32
    set security nat destination rule-set rs1 rule rule1 match application junos-ssh
    set security nat destination rule-set rs1 rule rule1 then destination-nat pool dnat1

    set security address-book global address svr1v6 fc00:dead:beef:a101::1000:11/128
    set security address-book global address svr1v4 192.168.101.11/32
    set security policies from-zone untrust to-zone RZ1 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ1 policy policy1 match destination-address svr1v6
    set security policies from-zone untrust to-zone RZ1 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ1 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ1 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ1 policy policy2 match destination-address svr1v4
    set security policies from-zone untrust to-zone RZ1 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ1 policy policy2 then permit
    set security policies from-zone RZ1 to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZ1 to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZ1 to-zone untrust policy policy1 match application any
    set security policies from-zone RZ1 to-zone untrust policy policy1 then permit

configuration for RZ2 on *fwext1*

    set interfaces ge-0/0/1 unit 1002 vlan-id 1002
    set interfaces ge-0/0/1 unit 1002 family inet address 172.16.100.5/31
    set interfaces ge-0/0/1 unit 1002 family inet6 address fc00:dead:beef:f100::5/127
    set interfaces ge-0/0/2 unit 1002 vlan-id 1002
    set interfaces ge-0/0/2 unit 1002 family inet address 172.16.100.7/31
    set interfaces ge-0/0/2 unit 1002 family inet6 address fc00:dead:beef:f100::7/127
    set security zones security-zone RZ2 host-inbound-traffic system-services ping
    set security zones security-zone RZ2 host-inbound-traffic system-services ssh
    set security zones security-zone RZ2 host-inbound-traffic protocols all
    set security zones security-zone RZ2 interfaces ge-0/0/1.1002
    set security zones security-zone RZ2 interfaces ge-0/0/2.1002
    set protocols bgp group to_border_leaf_RZ2 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ2 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ2 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ2 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ2 neighbor 172.16.100.4 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ2 neighbor 172.16.100.6 peer-as 4200001106
    set protocols bgp group to_border_leaf_RZ2 neighbor fc00:dead:beef:f100::4 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ2 neighbor fc00:dead:beef:f100::6 peer-as 4200001106


    set security nat source rule-set rs1 from zone RZ2

    set security nat destination pool dnat2 address 192.168.111.101/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule2 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule2 match destination-address 172.16.1.17/32
    set security nat destination rule-set rs1 rule rule2 match application junos-ssh
    set security nat destination rule-set rs1 rule rule2 then destination-nat pool dnat2

    set security address-book global address lxc3lxd1v111v6 fc00:dead:beef:a111::1000:101/128
    set security address-book global address lxc3lxd1v111v4 192.168.111.101/32
    set security policies from-zone untrust to-zone RZ2 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ2 policy policy1 match destination-address lxc3lxd1v111v4
    set security policies from-zone untrust to-zone RZ2 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ2 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ2 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ2 policy policy2 match destination-address lxc3lxd1v111v6
    set security policies from-zone untrust to-zone RZ2 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ2 policy policy2 then permit
    set security policies from-zone RZ2 to-zone untrust policy default-permit match source-address any
    set security policies from-zone RZ2 to-zone untrust policy default-permit match destination-address any
    set security policies from-zone RZ2 to-zone untrust policy default-permit match application any
    set security policies from-zone RZ2 to-zone untrust policy default-permit then permit


configuration for RZ3 on *fwext1*

    set interfaces ge-0/0/1 unit 1003 vlan-id 1003
    set interfaces ge-0/0/1 unit 1003 family inet address 172.16.100.9/31
    set interfaces ge-0/0/1 unit 1003 family inet6 address fc00:dead:beef:f100::9/127
    set interfaces ge-0/0/2 unit 1003 vlan-id 1003
    set interfaces ge-0/0/2 unit 1003 family inet address 172.16.100.11/31
    set interfaces ge-0/0/2 unit 1003 family inet6 address fc00:dead:beef:f100::11/127
    set security zones security-zone RZ3 host-inbound-traffic system-services ping
    set security zones security-zone RZ3 host-inbound-traffic system-services ssh
    set security zones security-zone RZ3 host-inbound-traffic protocols all
    set security zones security-zone RZ3 interfaces ge-0/0/1.1003
    set security zones security-zone RZ3 interfaces ge-0/0/2.1003
    set protocols bgp group to_border_leaf_RZ3 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ3 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ3 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ3 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ3 neighbor 172.16.100.8 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ3 neighbor 172.16.100.10 peer-as 4200001106
    set protocols bgp group to_border_leaf_RZ3 neighbor fc00:dead:beef:f100::8 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ3 neighbor fc00:dead:beef:f100::10 peer-as 4200001106


    set security nat source rule-set rs1 from zone RZ3
    set security nat destination pool dnat3 address 192.168.122.101/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule3 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule3 match destination-address 172.16.1.18/32
    set security nat destination rule-set rs1 rule rule3 match application junos-ssh
    set security nat destination rule-set rs1 rule rule3 then destination-nat pool dnat3


    set security address-book global address lxc1lxd2v122v6 fc00:dead:beef:a122::1000:101/128
    set security address-book global address lxc1lxd2v122v4 192.168.122.101/32
    set security policies from-zone untrust to-zone RZ3 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ3 policy policy1 match destination-address lxc1lxd2v122v4
    set security policies from-zone untrust to-zone RZ3 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ3 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ3 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ3 policy policy2 match destination-address lxc1lxd2v122v6
    set security policies from-zone untrust to-zone RZ3 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ3 policy policy2 then permit
    set security policies from-zone RZ3 to-zone untrust policy default-permit match source-address any
    set security policies from-zone RZ3 to-zone untrust policy default-permit match destination-address any
    set security policies from-zone RZ3 to-zone untrust policy default-permit match application any
    set security policies from-zone RZ3 to-zone untrust policy default-permit then permit


configuration for SVRMGMT on **fwext1**

    set interfaces ge-0/0/1 unit 1004 vlan-id 1004
    set interfaces ge-0/0/1 unit 1004 family inet address 172.16.100.13/31
    set interfaces ge-0/0/1 unit 1004 family inet6 address fc00:dead:beef:f100::13/127
    set interfaces ge-0/0/2 unit 1004 vlan-id 1004
    set interfaces ge-0/0/2 unit 1004 family inet address 172.16.100.15/31
    set interfaces ge-0/0/2 unit 1004 family inet6 address fc00:dead:beef:f100::15/127
    set security zones security-zone SVRMGMT host-inbound-traffic system-services ping
    set security zones security-zone SVRMGMT host-inbound-traffic system-services ssh
    set security zones security-zone SVRMGMT host-inbound-traffic protocols all
    set security zones security-zone SVRMGMT interfaces ge-0/0/1.1004
    set security zones security-zone SVRMGMT interfaces ge-0/0/2.1004
    set protocols bgp group to_border_leaf_SVRMGMT export to_border_leaf
    set protocols bgp group to_border_leaf_SVRMGMT multipath multiple-as
    set protocols bgp group to_border_leaf_SVRMGMT bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_SVRMGMT bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_SVRMGMT neighbor 172.16.100.12 peer-as 4200001105
    set protocols bgp group to_border_leaf_SVRMGMT neighbor 172.16.100.14 peer-as 4200001106
    set protocols bgp group to_border_leaf_SVRMGMT neighbor fc00:dead:beef:f100::12 peer-as 4200001105
    set protocols bgp group to_border_leaf_SVRMGMT neighbor fc00:dead:beef:f100::14 peer-as 4200001106


    set security nat source rule-set rs1 from zone SVRMGMT
    set security nat destination pool dnat4 address 192.168.1.101/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule4 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule4 match destination-address 172.16.1.19/32
    set security nat destination rule-set rs1 rule rule4 match application junos-ssh
    set security nat destination rule-set rs1 rule rule4 then destination-nat pool dnat4

    set security address-book global address lxd1dc1v6 fc00:dead:beef:1::1000:101/128
    set security address-book global address lxd1dc1v4 192.168.1.101/32
    set security address-book global address lxds fc00:dead:beef:a001::/64
    set security policies from-zone untrust to-zone SVRMGMT policy policy1 match source-address any
    set security policies from-zone untrust to-zone SVRMGMT policy policy1 match destination-address lxd1dc1v4
    set security policies from-zone untrust to-zone SVRMGMT policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone SVRMGMT policy policy1 then permit
    set security policies from-zone untrust to-zone SVRMGMT policy policy2 match source-address any
    set security policies from-zone untrust to-zone SVRMGMT policy policy2 match destination-address lxds
    set security policies from-zone untrust to-zone SVRMGMT policy policy2 match destination-address lxd1dc1v6
    set security policies from-zone untrust to-zone SVRMGMT policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone SVRMGMT policy policy2 then permit
    set security policies from-zone SVRMGMT to-zone untrust policy default-permit match source-address any
    set security policies from-zone SVRMGMT to-zone untrust policy default-permit match destination-address any
    set security policies from-zone SVRMGMT to-zone untrust policy default-permit match application any
    set security policies from-zone SVRMGMT to-zone untrust policy default-permit then permit

    

## HBR, LXD2dc1

    sudo hostname lxd2dc1
    hostname | sudo tee /etc/hostname
    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                dhcp4: false
                addresses:
                - 192.168.11.102/24
                - fc00:dead:beef:1011::1000:102/64
            eth1:
                dhcp6: false
                addresses:
                - 192.168.12.102/24
                - fc00:dead:beef:1012::1000:102/64
        bridges:
            br0:
                addresses:
                - 192.168.122.1/24
                - fc00:dead:Beef:a122::1/64
    EOF
    sudo netplan apply
    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
    sudo systemctl restart frr


    Current configuration:
    !
    frr version 10.5.1
    frr defaults traditional
    hostname lxd2dc2
    log syslog informational
    service integrated-vtysh-config
    !
    router bgp 4200008002
    no bgp ebgp-requires-policy
    bgp bestpath as-path multipath-relax
    neighbor 192.168.11.1 remote-as 4200001101
    neighbor 192.168.11.1 bfd
    neighbor 192.168.11.1 bfd profile BFD1
    neighbor 192.168.12.1 remote-as 4200001102
    neighbor 192.168.12.1 bfd
    neighbor 192.168.12.1 bfd profile BFD1
    neighbor fc00:dead:beef:1011::1 remote-as 4200001101
    neighbor fc00:dead:beef:1011::1 bfd
    neighbor fc00:dead:beef:1011::1 bfd profile BFD1
    neighbor fc00:dead:beef:1012::1 remote-as 4200001102
    neighbor fc00:dead:beef:1012::1 bfd
    neighbor fc00:dead:beef:1012::1 bfd profile BFD1
    !
    address-family ipv4 unicast
    network 192.168.122.0/24
    neighbor 192.168.11.1 distribute-list adv1v4 out
    neighbor 192.168.12.1 distribute-list adv1v4 out
    maximum-paths 4
    exit-address-family
    !
    address-family ipv6 unicast
    network fc00:dead:beef:a122::/64
    neighbor fc00:dead:beef:1011::1 activate
    neighbor fc00:dead:beef:1011::1 distribute-list adv1v6 out
    neighbor fc00:dead:beef:1012::1 activate
    neighbor fc00:dead:beef:1012::1 distribute-list adv1v6 out
    maximum-paths 4
    exit-address-family
    exit
    !
    access-list adv1v4 seq 5 permit 192.168.122.0/24
    !
    ipv6 access-list adv1v6 seq 5 permit fc00:dead:beef:a122::/64
    !
    bfd
    profile BFD1
    transmit-interval 500
    receive-interval 500
    exit
    !
    exit
    !
    end

## HBR, LXD4dc2

    sudo hostname lxd4dc1
    hostname | sudo tee /etc/hostname
    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                dhcp4: false
                addresses:
                - 192.168.11.104/24
                - fc00:dead:beef:1011::1000:104/64
            eth1:
                dhcp6: false
                addresses:
                - 192.168.12.104/24
                - fc00:dead:beef:1012::1000:104/64
        bridges:
            br0:
                addresses:
                - 192.168.124.1/24
                - fc00:dead:Beef:a124::1/64
    EOF
    sudo netplan apply
    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
    sudo systemctl restart frr


    Current configuration:
    !
    frr version 10.5.1
    frr defaults traditional
    hostname lxd2dc2
    log syslog informational
    service integrated-vtysh-config
    !
    router bgp 4200008004
    no bgp ebgp-requires-policy
    bgp bestpath as-path multipath-relax
    neighbor 192.168.11.1 remote-as 4200001103
    neighbor 192.168.11.1 bfd
    neighbor 192.168.11.1 bfd profile BFD1
    neighbor 192.168.12.1 remote-as 4200001104
    neighbor 192.168.12.1 bfd
    neighbor 192.168.12.1 bfd profile BFD1
    neighbor fc00:dead:beef:1011::1 remote-as 4200001103
    neighbor fc00:dead:beef:1011::1 bfd
    neighbor fc00:dead:beef:1011::1 bfd profile BFD1
    neighbor fc00:dead:beef:1012::1 remote-as 4200001104
    neighbor fc00:dead:beef:1012::1 bfd
    neighbor fc00:dead:beef:1012::1 bfd profile BFD1
    !
    address-family ipv4 unicast
    network 192.168.124.0/24
    neighbor 192.168.11.1 distribute-list adv1v4 out
    neighbor 192.168.12.1 distribute-list adv1v4 out
    maximum-paths 4
    exit-address-family
    !
    address-family ipv6 unicast
    network fc00:dead:beef:a124::/64
    neighbor fc00:dead:beef:1011::1 activate
    neighbor fc00:dead:beef:1011::1 distribute-list adv1v6 out
    neighbor fc00:dead:beef:1012::1 activate
    neighbor fc00:dead:beef:1012::1 distribute-list adv1v6 out
    maximum-paths 4
    exit-address-family
    exit
    !
    access-list adv1v4 seq 5 permit 192.168.124.0/24
    !
    ipv6 access-list adv1v6 seq 5 permit fc00:dead:beef:a124::/64
    !
    bfd
    profile BFD1
    transmit-interval 500
    receive-interval 500
    exit
    !
    exit
    !
    end

## HBR, LXD6dc1

    sudo hostname lxd6dc1
    hostname | sudo tee /etc/hostname

    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                dhcp4: false
                addresses:
                - 192.168.11.106/24
                - fc00:dead:beef:1011::1000:106/64
            eth1:
                dhcp6: false
                addresses:
                - 192.168.12.106/24
                - fc00:dead:beef:1012::1000:106/64
        bridges:
            br0:
                addresses:
                - 192.168.126.1/24
                - fc00:dead:Beef:a126::1/64
    EOF
    sudo netplan apply
    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
    sudo systemctl restart frr


    Current configuration:
    !
    frr version 10.5.1
    frr defaults traditional
    hostname lxd2dc2
    log syslog informational
    service integrated-vtysh-config
    !
    router bgp 4200008006
    no bgp ebgp-requires-policy
    bgp bestpath as-path multipath-relax
    neighbor 192.168.11.1 remote-as 4200001105
    neighbor 192.168.11.1 bfd
    neighbor 192.168.11.1 bfd profile BFD1
    neighbor 192.168.12.1 remote-as 4200001106
    neighbor 192.168.12.1 bfd
    neighbor 192.168.12.1 bfd profile BFD1
    neighbor fc00:dead:beef:1011::1 remote-as 4200001105
    neighbor fc00:dead:beef:1011::1 bfd
    neighbor fc00:dead:beef:1011::1 bfd profile BFD1
    neighbor fc00:dead:beef:1012::1 remote-as 4200001106
    neighbor fc00:dead:beef:1012::1 bfd
    neighbor fc00:dead:beef:1012::1 bfd profile BFD1
    !
    address-family ipv4 unicast
    network 192.168.126.0/24
    neighbor 192.168.11.1 distribute-list adv1v4 out
    neighbor 192.168.12.1 distribute-list adv1v4 out
    maximum-paths 4
    exit-address-family
    !
    address-family ipv6 unicast
    network fc00:dead:beef:a126::/64
    neighbor fc00:dead:beef:1011::1 activate
    neighbor fc00:dead:beef:1011::1 distribute-list adv1v6 out
    neighbor fc00:dead:beef:1012::1 activate
    neighbor fc00:dead:beef:1012::1 distribute-list adv1v6 out
    maximum-paths 4
    exit-address-family
    exit
    !
    access-list adv1v4 seq 5 permit 192.168.126.0/24
    !
    ipv6 access-list adv1v6 seq 5 permit fc00:dead:beef:a126::/64
    !
    bfd
    profile BFD1
    transmit-interval 500
    receive-interval 500
    exit
    !
    exit
    !
    end



## HBR, LXD8dc1

    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                dhcp4: false
                addresses:
                - 192.168.11.108/24
                - fc00:dead:beef:1011::1000:108/64
            eth1:
                dhcp6: false
                addresses:
                - 192.168.12.108/24
                - fc00:dead:beef:1012::1000:108/64
        bridges:
            br0:
                addresses:
                - 192.168.128.1/24
                - fc00:dead:Beef:a128::1/64
    EOF
    sudo netplan apply
    sudo hostname lxd8dc1
    hostname | sudo tee /etc/hostname
    sudo netplan apply
    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
    sudo systemctl restart frr

    Current configuration:
    !
    
    !
    router bgp 4200008008
    no bgp ebgp-requires-policy
    bgp bestpath as-path multipath-relax
    neighbor 192.168.11.1 remote-as 4200001107
    neighbor 192.168.11.1 bfd
    neighbor 192.168.11.1 bfd profile BFD1
    neighbor 192.168.12.1 remote-as 4200001108
    neighbor 192.168.12.1 bfd
    neighbor 192.168.12.1 bfd profile BFD1
    neighbor fc00:dead:beef:1011::1 remote-as 4200001107
    neighbor fc00:dead:beef:1011::1 bfd
    neighbor fc00:dead:beef:1011::1 bfd profile BFD1
    neighbor fc00:dead:beef:1012::1 remote-as 4200001108
    neighbor fc00:dead:beef:1012::1 bfd
    neighbor fc00:dead:beef:1012::1 bfd profile BFD1
    !
    address-family ipv4 unicast
    network 192.168.128.0/24
    neighbor 192.168.11.1 distribute-list adv1v4 out
    neighbor 192.168.12.1 distribute-list adv1v4 out
    maximum-paths 4
    exit-address-family
    !
    address-family ipv6 unicast
    network fc00:dead:beef:a128::/64
    neighbor fc00:dead:beef:1011::1 activate
    neighbor fc00:dead:beef:1011::1 distribute-list adv1v6 out
    neighbor fc00:dead:beef:1012::1 activate
    neighbor fc00:dead:beef:1012::1 distribute-list adv1v6 out
    maximum-paths 4
    exit-address-family
    exit
    !
    access-list adv1v4 seq 5 permit 192.168.128.0/24
    !
    ipv6 access-list adv1v6 seq 5 permit fc00:dead:beef:a128::/64
    !
    bfd
    profile BFD1
    transmit-interval 500
    receive-interval 500
    exit
    !
    exit
    !
    end

## manual onboarding

    delete system processes dhcp-service
    delete protocols router-advertisement
    delete chassis auto-image-upgrade
    set system host-name VM6ABFC396B3
    set system login user admin class super-user
    set system services ssh root-login allow
    set system services netconf ssh
    set system services ssh
    set system commit synchronize
    set system management-instance
    delete interfaces fxp0
    set interfaces fxp0 unit 0 family inet address 172.16.52.101/24
    set routing-instances mgmt_junos routing-options static route 0.0.0.0/0 next-hop 172.16.52.254
    set chassis evpn-vxlan-default-switch-support
    set chassis fpc 0 pic 0 number-of-ports 12
    set system root-authentication plain-text-password
    set system login user admin authentication plain-text-password
    
    <!-- set system root-authentication encrypted-password "$6$cefxD9PZ$6EizIIKGuVEQj/.Mfk8wtfPYfWJo9nymrGb8QwD7ap8UmoUm1XHa/iXbemKgOAPd0cXIZTN4b0jZvX21qzGO//”
    set system login user admin authentication encrypted-password "$6$xa3ILNh.$.r3RWzm1gOyxXZSLzz1frTwv.2IOKnzi9ptZrtlOpmnwodEOv98kGTCH2pCYrzqjc5vxrTDrctuy0mq4g22.F.” -->
    
    
    
    
## fwext2

configuration for **fwext2

    set interfaces ge-0/0/0 unit 0 family inet address 172.16.63.6/24
    set interfaces ge-0/0/0 unit 0 family inet6 address fc00:dead:beef:ff63::6/64
    set security zones security-zone untrust host-inbound-traffic system-services ping
    set security zones security-zone untrust host-inbound-traffic protocols bgp
    set security zones security-zone untrust host-inbound-traffic protocols bfd
    set security zones security-zone untrust interfaces ge-0/0/0.0
    set protocols bgp group to_ext bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_ext bfd-liveness-detection multiplier 3
    set protocols bgp group to_ext neighbor 172.16.63.254 export to_ext
    set protocols bgp group to_ext neighbor 172.16.63.254 peer-as 4200000001
    set protocols bgp group to_ext neighbor fc00:dead:beef:ff63::ffff peer-as 4200000001
    set routing-options autonomous-system 4200009002
    set routing-options static route 172.16.1.32/28 discard
    set routing-options static route 172.16.1.48/28 discard
    set policy-options policy-statement to_ext term 1 from route-filter 172.16.1.32/28 orlonger
    set policy-options policy-statement to_ext term 1 then accept
    set policy-options policy-statement to_ext term 2 from route-filter 172.16.1.48/28 orlonger
    set policy-options policy-statement to_ext term 2 then accept
    set policy-options policy-statement to_ext term default then reject

configuration for RZ4 on **fwext2**

    set interfaces ge-0/0/1 vlan-tagging
    set interfaces ge-0/0/1 unit 1001 vlan-id 1001
    set interfaces ge-0/0/1 unit 1001 family inet address 172.16.100.17/31
    set interfaces ge-0/0/1 unit 1001 family inet6 address fc00:dead:beef:f100::17/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1001 vlan-id 1001
    set interfaces ge-0/0/2 unit 1001 family inet address 172.16.100.19/31
    set interfaces ge-0/0/2 unit 1001 family inet6 address fc00:dead:beef:f100::19/127
    set security zones security-zone RZ4 host-inbound-traffic system-services ping
    set security zones security-zone RZ4 host-inbound-traffic system-services ssh
    set security zones security-zone RZ4 host-inbound-traffic protocols all
    set security zones security-zone RZ4 interfaces ge-0/0/1.1001
    set security zones security-zone RZ4 interfaces ge-0/0/2.1001
    set protocols bgp group to_border_leaf_RZ4 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ4 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ4 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ4 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ4 neighbor 172.16.100.16 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ4 neighbor 172.16.100.18 peer-as 4200002002
    set protocols bgp group to_border_leaf_RZ4 neighbor fc00:dead:beef:f100::16 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ4 neighbor fc00:dead:beef:f100::18 peer-as 4200002002
    set policy-options policy-statement to_border_leaf term 1 from route-filter 0.0.0.0/0 exact
    set policy-options policy-statement to_border_leaf term 1 then accept
    set policy-options policy-statement to_border_leaf term 2 from route-filter ::/0 exact
    set policy-options policy-statement to_border_leaf term 2 then accept
    set policy-options policy-statement to_border_leaf term default then reject

    set security nat source pool pool1 address 172.16.1.32/28
    set security nat source rule-set rs1 from zone RZ4
    set security nat source rule-set rs1 to zone untrust
    set security nat source rule-set rs1 rule rule1 match source-address 0.0.0.0/0
    set security nat source rule-set rs1 rule rule1 match destination-address 0.0.0.0/0
    set security nat source rule-set rs1 rule rule1 match application any
    set security nat source rule-set rs1 rule rule1 then source-nat pool pool1

    set security nat destination pool dnat1 address 192.168.201.11/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule1 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule1 match destination-address 172.16.1.48/32
    set security nat destination rule-set rs1 rule rule1 match application junos-ssh
    set security nat destination rule-set rs1 rule rule1 then destination-nat pool dnat1

    set security address-book global address purple fc00:dead:beef:a201::/64
    set security address-book global address svr1dc2v4 192.168.201.11/32
    set security policies from-zone untrust to-zone RZ4 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ4 policy policy1 match destination-address purple
    set security policies from-zone untrust to-zone RZ4 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ4 policy policy1 match application junos-ping
    set security policies from-zone untrust to-zone RZ4 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ4 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ4 policy policy2 match destination-address svr1dc2v4
    set security policies from-zone untrust to-zone RZ4 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ4 policy policy2 then permit
    set security policies from-zone RZ4 to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZ4 to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZ4 to-zone untrust policy policy1 match application any
    set security policies from-zone RZ4 to-zone untrust policy policy1 then permit


configuration for RZ5 on **fwext2**

    set interfaces ge-0/0/1 vlan-tagging
    set interfaces ge-0/0/1 unit 1002 vlan-id 1002
    set interfaces ge-0/0/1 unit 1002 family inet address 172.16.100.21/31
    set interfaces ge-0/0/1 unit 1002 family inet6 address fc00:dead:beef:f100::21/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1002 vlan-id 1002
    set interfaces ge-0/0/2 unit 1002 family inet address 172.16.100.23/31
    set interfaces ge-0/0/2 unit 1002 family inet6 address fc00:dead:beef:f100::23/127
    set security zones security-zone RZ5 host-inbound-traffic system-services ping
    set security zones security-zone RZ5 host-inbound-traffic system-services ssh
    set security zones security-zone RZ5 host-inbound-traffic protocols all
    set security zones security-zone RZ5 interfaces ge-0/0/1.1002
    set security zones security-zone RZ5 interfaces ge-0/0/2.1002
    set protocols bgp group to_border_leaf_RZ5 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ5 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ5 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ5 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ5 neighbor 172.16.100.20 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ5 neighbor 172.16.100.22 peer-as 4200002002
    set protocols bgp group to_border_leaf_RZ5 neighbor fc00:dead:beef:f100::20 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ5 neighbor fc00:dead:beef:f100::22 peer-as 4200002002



    set security nat source rule-set rs1 from zone RZ5

    set security nat destination pool dnat3 address 192.168.202.13/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule2 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule2 match destination-address 172.16.1.49/32
    set security nat destination rule-set rs1 rule rule2 match application junos-ssh
    set security nat destination rule-set rs1 rule rule2 then destination-nat pool dnat3

    set security address-book global address magenta fc00:dead:beef:a202::/64
    set security address-book global address svr3dc2v4 192.168.202.13/32
    set security policies from-zone untrust to-zone RZ5 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ5 policy policy1 match destination-address magenta
    set security policies from-zone untrust to-zone RZ5 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ5 policy policy1 match application junos-ping
    set security policies from-zone untrust to-zone RZ5 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ5 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ5 policy policy2 match destination-address svr3dc2v4
    set security policies from-zone untrust to-zone RZ5 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ5 policy policy2 then permit
    set security policies from-zone RZ5 to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZ5 to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZ5 to-zone untrust policy policy1 match application any
    set security policies from-zone RZ5 to-zone untrust policy policy1 then permit


configuration for RZ6 on **fwext2**

    set interfaces ge-0/0/1 vlan-tagging
    set interfaces ge-0/0/1 unit 1003 vlan-id 1003
    set interfaces ge-0/0/1 unit 1003 family inet address 172.16.100.25/31
    set interfaces ge-0/0/1 unit 1003 family inet6 address fc00:dead:beef:f100::25/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1003 vlan-id 1003
    set interfaces ge-0/0/2 unit 1003 family inet address 172.16.100.27/31
    set interfaces ge-0/0/2 unit 1003 family inet6 address fc00:dead:beef:f100::27/127
    set security zones security-zone RZ6 host-inbound-traffic system-services ping
    set security zones security-zone RZ6 host-inbound-traffic system-services ssh
    set security zones security-zone RZ6 host-inbound-traffic protocols all
    set security zones security-zone RZ6 interfaces ge-0/0/1.1003
    set security zones security-zone RZ6 interfaces ge-0/0/2.1003

    set protocols bgp group to_border_leaf_RZ6 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ6 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ6 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ6 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ6 neighbor 172.16.100.24 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ6 neighbor 172.16.100.26 peer-as 4200002002
    set protocols bgp group to_border_leaf_RZ6 neighbor fc00:dead:beef:f100::24 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ6 neighbor fc00:dead:beef:f100::26 peer-as 4200002002


    set security nat source rule-set rs1 from zone RZ6

    set security nat destination pool dnat5 address 192.168.222.101/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule3 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule3 match destination-address 172.16.1.50/32
    set security nat destination rule-set rs1 rule rule3 match application junos-ssh
    set security nat destination rule-set rs1 rule rule3 then destination-nat pool dnat5

    set security address-book global address RZ6a222 fc00:dead:beef:a222::/64
    set security address-book global address RZ6a224 fc00:dead:beef:a224::/64
    set security address-book global address RZ6lxc1 192.168.222.101/32
    set security policies from-zone untrust to-zone RZ6 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ6 policy policy1 match destination-address RZ6a222
    set security policies from-zone untrust to-zone RZ6 policy policy1 match destination-address RZ6a224
    set security policies from-zone untrust to-zone RZ6 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ6 policy policy1 match application junos-ping
    set security policies from-zone untrust to-zone RZ6 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ6 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ6 policy policy2 match destination-address RZ6lxc1
    set security policies from-zone untrust to-zone RZ6 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ6 policy policy2 then permit
    set security policies from-zone RZ6 to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZ6 to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZ6 to-zone untrust policy policy1 match application any
    set security policies from-zone RZ6 to-zone untrust policy policy1 then permit
    


configuration for RZsvrmgmt on **fwext2**

    set interfaces ge-0/0/1 vlan-tagging
    set interfaces ge-0/0/1 unit 1004 vlan-id 1004
    set interfaces ge-0/0/1 unit 1004 family inet address 172.16.100.29/31
    set interfaces ge-0/0/1 unit 1004 family inet6 address fc00:dead:beef:f100::29/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1004 vlan-id 1004
    set interfaces ge-0/0/2 unit 1004 family inet address 172.16.100.31/31
    set interfaces ge-0/0/2 unit 1004 family inet6 address fc00:dead:beef:f100::31/127
    set security zones security-zone RZsvrmgmt host-inbound-traffic system-services ping
    set security zones security-zone RZsvrmgmt host-inbound-traffic system-services ssh
    set security zones security-zone RZsvrmgmt host-inbound-traffic protocols all
    set security zones security-zone RZsvrmgmt interfaces ge-0/0/1.1004
    set security zones security-zone RZsvrmgmt interfaces ge-0/0/2.1004

    set protocols bgp group to_border_leaf_RZsvrmgmt export to_border_leaf
    set protocols bgp group to_border_leaf_RZsvrmgmt multipath multiple-as
    set protocols bgp group to_border_leaf_RZsvrmgmt bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZsvrmgmt bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZsvrmgmt neighbor 172.16.100.28 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZsvrmgmt neighbor 172.16.100.30 peer-as 4200002002
    set protocols bgp group to_border_leaf_RZsvrmgmt neighbor fc00:dead:beef:f100::28 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZsvrmgmt neighbor fc00:dead:beef:f100::30 peer-as 4200002002



    set security nat source rule-set rs1 from zone RZsvrmgmt

    set security nat destination pool dnat6 address 192.168.2.101/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule4 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule4 match destination-address 172.16.1.51/32
    set security nat destination rule-set rs1 rule rule4 match application junos-ssh
    set security nat destination rule-set rs1 rule rule4 then destination-nat pool dnat5

    set security address-book global address RZsvrmgmt fc00:dead:beef:a002::/64
    set security address-book global address RZsvrmgmtlxd1 192.168.2.101/32
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy1 match destination-address RZsvrmgmt
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy1 match application junos-ping
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy1 then permit
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy2 match destination-address RZsvrmgmtlxd1
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZsvrmgmt policy policy2 then permit
    set security policies from-zone RZsvrmgmt to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZsvrmgmt to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZsvrmgmt to-zone untrust policy policy1 match application any
    set security policies from-zone RZsvrmgmt to-zone untrust policy policy1 then permit


## HBR, LXD2dc2

    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                dhcp4: false
                addresses:
                - 192.168.21.102/24
                - fc00:dead:beef:2021::1000:102/64
            eth1:
                dhcp6: false
                addresses:
                - 192.168.22.102/24
                - fc00:dead:beef:2022::1000:102/64
        bridges:
            br0:
                addresses:
                - 192.168.222.1/24
                - fc00:dead:Beef:a222::1/64
    EOF
    sudo netplan apply
    sudo hostname lxd2dc2
    hostname | sudo tee /etc/hostname
    sudo netplan apply
    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
    sudo systemctl restart frr

    Current configuration:
    !
    
    !
    router bgp 4200008202
    no bgp ebgp-requires-policy
    bgp bestpath as-path multipath-relax
    neighbor 192.168.21.1 remote-as 4200002001
    neighbor 192.168.21.1 bfd
    neighbor 192.168.21.1 bfd profile BFD1
    neighbor 192.168.22.1 remote-as 4200002002
    neighbor 192.168.22.1 bfd
    neighbor 192.168.22.1 bfd profile BFD1
    neighbor fc00:dead:beef:2021::1 remote-as 4200002001
    neighbor fc00:dead:beef:2021::1 bfd
    neighbor fc00:dead:beef:2021::1 bfd profile BFD1
    neighbor fc00:dead:beef:2022::1 remote-as 4200002002
    neighbor fc00:dead:beef:2022::1 bfd
    neighbor fc00:dead:beef:2022::1 bfd profile BFD1
    !
    address-family ipv4 unicast
    network 192.168.222.0/24
    neighbor 192.168.21.1 distribute-list adv1v4 out
    neighbor 192.168.22.1 distribute-list adv1v4 out
    maximum-paths 4
    exit-address-family
    !
    address-family ipv6 unicast
    network fc00:dead:beef:a222::/64
    neighbor fc00:dead:beef:2021::1 activate
    neighbor fc00:dead:beef:2021::1 distribute-list adv1v6 out
    neighbor fc00:dead:beef:2022::1 activate
    neighbor fc00:dead:beef:2022::1 distribute-list adv1v6 out
    maximum-paths 4
    exit-address-family
    exit
    !
    access-list adv1v4 seq 5 permit 192.168.222.0/24
    !
    ipv6 access-list adv1v6 seq 5 permit fc00:dead:beef:a222::/64
    !
    bfd
    profile BFD1
    transmit-interval 500
    receive-interval 500
    exit
    !
    exit
    !
    end


## HBR, LXD4dc2

    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                dhcp4: false
                addresses:
                - 192.168.21.104/24
                - fc00:dead:beef:2021::1000:104/64
            eth1:
                dhcp6: false
                addresses:
                - 192.168.22.104/24
                - fc00:dead:beef:2022::1000:104/64
        bridges:
            br0:
                addresses:
                - 192.168.224.1/24
                - fc00:dead:Beef:a224::1/64
    EOF
    sudo netplan apply
    sudo hostname lxd4dc2
    hostname | sudo tee /etc/hostname
    sudo netplan apply
    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
    sudo systemctl restart frr

    Current configuration:
    !
    
    !
    router bgp 4200008204
    no bgp ebgp-requires-policy
    bgp bestpath as-path multipath-relax
    neighbor 192.168.21.1 remote-as 4200002001
    neighbor 192.168.21.1 bfd
    neighbor 192.168.21.1 bfd profile BFD1
    neighbor 192.168.22.1 remote-as 4200002002
    neighbor 192.168.22.1 bfd
    neighbor 192.168.22.1 bfd profile BFD1
    neighbor fc00:dead:beef:2021::1 remote-as 4200002001
    neighbor fc00:dead:beef:2021::1 bfd
    neighbor fc00:dead:beef:2021::1 bfd profile BFD1
    neighbor fc00:dead:beef:2022::1 remote-as 4200002002
    neighbor fc00:dead:beef:2022::1 bfd
    neighbor fc00:dead:beef:2022::1 bfd profile BFD1
    !
    address-family ipv4 unicast
    network 192.168.224.0/24
    neighbor 192.168.21.1 distribute-list adv1v4 out
    neighbor 192.168.22.1 distribute-list adv1v4 out
    maximum-paths 4
    exit-address-family
    !
    address-family ipv6 unicast
    network fc00:dead:beef:a224::/64
    neighbor fc00:dead:beef:2021::1 activate
    neighbor fc00:dead:beef:2021::1 distribute-list adv1v6 out
    neighbor fc00:dead:beef:2022::1 activate
    neighbor fc00:dead:beef:2022::1 distribute-list adv1v6 out
    maximum-paths 4
    exit-address-family
    exit
    !
    access-list adv1v4 seq 5 permit 192.168.224.0/24
    !
    ipv6 access-list adv1v6 seq 5 permit fc00:dead:beef:a224::/64
    !
    bfd
    profile BFD1
    transmit-interval 500
    receive-interval 500
    exit
    !
    exit
    !
    end


# for DCI/OTT

## PE1

    set interfaces ge-0/0/0.0 family inet address 172.16.100.33/31
    set interfaces ge-0/0/0 mtu 9000
    set interfaces ge-0/0/1 mtu 9000
    set interfaces ge-0/0/1.0 family inet address 172.16.100.35/31
    set routing-instances underlay instance-type vrf
    set routing-instances underlay vrf-table-label
    set routing-instances underlay protocols bgp source-packet-routing srv6 locator SRV6-LOC-1 micro-dt4-sid
    set routing-instances underlay interface ge-0/0/0.0
    set routing-instances underlay interface ge-0/0/1.0
    set routing-instances underlay route-distinguisher 10.100.255.1:1010
    set routing-instances underlay vrf-target target:65000:1010
    set routing-instances underlay vrf-table-label
    set routing-instances underlay protocols bgp group to_dc1 neighbor 172.16.100.32 peer-as 4200001105
    set routing-instances underlay protocols bgp group to_dc1 neighbor 172.16.100.34 peer-as 4200001106

## PE2

    set interfaces ge-0/0/0.0 family inet address 172.16.100.37/31
    set interfaces ge-0/0/1.0 family inet address 172.16.100.39/31
    set interfaces ge-0/0/0 mtu 9000
    set interfaces ge-0/0/1 mtu 9000
    set routing-instances underlay instance-type vrf
    set routing-instances underlay vrf-table-label
    set routing-instances underlay protocols bgp source-packet-routing srv6 locator SRV6-LOC-1 micro-dt4-sid
    set routing-instances underlay interface ge-0/0/0.0
    set routing-instances underlay interface ge-0/0/1.0
    set routing-instances underlay route-distinguisher 10.100.255.2:1010
    set routing-instances underlay vrf-target target:65000:1010
    set routing-instances underlay vrf-table-label
    set routing-instances underlay protocols bgp group to_dc2 neighbor 172.16.100.36 peer-as 4200002001
    set routing-instances underlay protocols bgp group to_dc2 neighbor 172.16.100.38 peer-as 4200002002




configuration for RZ11 on *fwext1*


    set interfaces ge-0/0/1 unit 1005 vlan-id 1005
    set interfaces ge-0/0/1 unit 1005 family inet address 172.16.100.41/31
    set interfaces ge-0/0/1 unit 1005 family inet6 address fc00:dead:beef:f100::41/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1005 vlan-id 1005
    set interfaces ge-0/0/2 unit 1005 family inet address 172.16.100.43/31
    set interfaces ge-0/0/2 unit 1005 family inet6 address fc00:dead:beef:f100::43/127
    set security zones security-zone RZ11 host-inbound-traffic system-services ping
    set security zones security-zone RZ11 host-inbound-traffic system-services ssh
    set security zones security-zone RZ11 host-inbound-traffic protocols all
    set security zones security-zone RZ11 interfaces ge-0/0/1.1005
    set security zones security-zone RZ11 interfaces ge-0/0/2.1005
    set protocols bgp group to_border_leaf_RZ11 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ11 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ11 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ11 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ11 neighbor 172.16.100.40 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ11 neighbor 172.16.100.42 peer-as 4200001106
    set protocols bgp group to_border_leaf_RZ11 neighbor fc00:dead:beef:f100::40 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ11 neighbor fc00:dead:beef:f100::42 peer-as 4200001106

    set security nat source rule-set rs1 from zone RZ11

    set security nat destination pool dnat7 address 192.168.31.101/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule5 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule5 match destination-address 172.16.1.20/32
    set security nat destination rule-set rs1 rule rule5 match application junos-ssh
    set security nat destination rule-set rs1 rule rule5 then destination-nat pool dnat7

    set security address-book global address L3DC1 fc00:dead:beef:a031::/64
    set security address-book global address lxc4lxd1dc1 192.168.31.101/32
    set security policies from-zone untrust to-zone RZ11 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ11 policy policy1 match destination-address L3DC1
    set security policies from-zone untrust to-zone RZ11 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ11 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ11 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ11 policy policy2 match destination-address lxc4lxd1dc1
    set security policies from-zone untrust to-zone RZ11 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ11 policy policy2 then permit
    set security policies from-zone RZ11 to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZ11 to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZ11 to-zone untrust policy policy1 match application any
    set security policies from-zone RZ11 to-zone untrust policy policy1 then permit



configuration for RZ12 on *fwext1*

    set interfaces ge-0/0/1 unit 1006 vlan-id 1006
    set interfaces ge-0/0/1 unit 1006 family inet address 172.16.100.49/31
    set interfaces ge-0/0/1 unit 1006 family inet6 address fc00:dead:beef:f100::49/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1006 vlan-id 1006
    set interfaces ge-0/0/2 unit 1006 family inet address 172.16.100.51/31
    set interfaces ge-0/0/2 unit 1006 family inet6 address fc00:dead:beef:f100::51/127
    set security zones security-zone RZ12 host-inbound-traffic system-services ping
    set security zones security-zone RZ12 host-inbound-traffic system-services ssh
    set security zones security-zone RZ12 host-inbound-traffic protocols all
    set security zones security-zone RZ12 interfaces ge-0/0/1.1006
    set security zones security-zone RZ12 interfaces ge-0/0/2.1006
    set protocols bgp group to_border_leaf_RZ12 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ12 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ12 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ12 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ12 neighbor 172.16.100.48 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ12 neighbor 172.16.100.50 peer-as 4200001106
    set protocols bgp group to_border_leaf_RZ12 neighbor fc00:dead:beef:f100::48 peer-as 4200001105
    set protocols bgp group to_border_leaf_RZ12 neighbor fc00:dead:beef:f100::50 peer-as 4200001106

    set security nat source rule-set rs1 from zone RZ12

    set security nat destination pool dnat8 address 192.168.41.101/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule6 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule6 match destination-address 172.16.1.21/32
    set security nat destination rule-set rs1 rule rule6 match application junos-ssh
    set security nat destination rule-set rs1 rule rule6 then destination-nat pool dnat8

    set security address-book global address L2DC1 fc00:dead:beef:a041::/64
    set security address-book global address lxc5lxd1dc1 192.168.41.101/32
    set security policies from-zone untrust to-zone RZ12 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ12 policy policy1 match destination-address L2DC1
    set security policies from-zone untrust to-zone RZ12 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ12 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ12 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ12 policy policy2 match destination-address lxc5lxd1dc1
    set security policies from-zone untrust to-zone RZ12 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ12 policy policy2 then permit
    set security policies from-zone RZ12 to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZ12 to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZ12 to-zone untrust policy policy1 match application any
    set security policies from-zone RZ12 to-zone untrust policy policy1 then permit


configuration for RZ11 on *fwext2*


    set interfaces ge-0/0/1 unit 1005 vlan-id 1005
    set interfaces ge-0/0/1 unit 1005 family inet address 172.16.100.45/31
    set interfaces ge-0/0/1 unit 1005 family inet6 address fc00:dead:beef:f100::45/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1005 vlan-id 1005
    set interfaces ge-0/0/2 unit 1005 family inet address 172.16.100.47/31
    set interfaces ge-0/0/2 unit 1005 family inet6 address fc00:dead:beef:f100::47/127
    set security zones security-zone RZ11 host-inbound-traffic system-services ping
    set security zones security-zone RZ11 host-inbound-traffic system-services ssh
    set security zones security-zone RZ11 host-inbound-traffic protocols all
    set security zones security-zone RZ11 interfaces ge-0/0/1.1005
    set security zones security-zone RZ11 interfaces ge-0/0/2.1005
    set protocols bgp group to_border_leaf_RZ11 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ11 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ11 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ11 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ11 neighbor 172.16.100.44 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ11 neighbor 172.16.100.46 peer-as 4200002002
    set protocols bgp group to_border_leaf_RZ11 neighbor fc00:dead:beef:f100::44 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ11 neighbor fc00:dead:beef:f100::46 peer-as 4200002002

    set security nat source rule-set rs1 from zone RZ11

    set security nat destination pool dnat7 address 192.168.32.201/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule5 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule5 match destination-address 172.16.1.52/32
    set security nat destination rule-set rs1 rule rule5 match application junos-ssh
    set security nat destination rule-set rs1 rule rule5 then destination-nat pool dnat7

    set security address-book global address L3DC2 fc00:dead:beef:a032::/64
    set security address-book global address lxc4lxd1dc2 192.168.32.201/32
    set security policies from-zone untrust to-zone RZ11 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ11 policy policy1 match destination-address L3DC2
    set security policies from-zone untrust to-zone RZ11 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ11 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ11 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ11 policy policy2 match destination-address lxc4lxd1dc2
    set security policies from-zone untrust to-zone RZ11 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ11 policy policy2 then permit
    set security policies from-zone RZ11 to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZ11 to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZ11 to-zone untrust policy policy1 match application any
    set security policies from-zone RZ11 to-zone untrust policy policy1 then permit

configuration for RZ12 on *fwext2*


    set interfaces ge-0/0/1 unit 1006 vlan-id 1006
    set interfaces ge-0/0/1 unit 1006 family inet address 172.16.100.53/31
    set interfaces ge-0/0/1 unit 1006 family inet6 address fc00:dead:beef:f100::53/127
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 1006 vlan-id 1006
    set interfaces ge-0/0/2 unit 1006 family inet address 172.16.100.55/31
    set interfaces ge-0/0/2 unit 1006 family inet6 address fc00:dead:beef:f100::55/127
    set security zones security-zone RZ12 host-inbound-traffic system-services ping
    set security zones security-zone RZ12 host-inbound-traffic system-services ssh
    set security zones security-zone RZ12 host-inbound-traffic protocols all
    set security zones security-zone RZ12 interfaces ge-0/0/1.1006
    set security zones security-zone RZ12 interfaces ge-0/0/2.1006
    set protocols bgp group to_border_leaf_RZ12 export to_border_leaf
    set protocols bgp group to_border_leaf_RZ12 multipath multiple-as
    set protocols bgp group to_border_leaf_RZ12 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_border_leaf_RZ12 bfd-liveness-detection multiplier 3
    set protocols bgp group to_border_leaf_RZ12 neighbor 172.16.100.52 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ12 neighbor 172.16.100.54 peer-as 4200002002
    set protocols bgp group to_border_leaf_RZ12 neighbor fc00:dead:beef:f100::52 peer-as 4200002001
    set protocols bgp group to_border_leaf_RZ12 neighbor fc00:dead:beef:f100::54 peer-as 4200002002

    set security nat source rule-set rs1 from zone RZ12

    set security nat destination pool dnat8 address 192.168.41.201/32
    set security nat destination rule-set rs1 from zone untrust
    set security nat destination rule-set rs1 rule rule6 match source-address 0.0.0.0/0
    set security nat destination rule-set rs1 rule rule6 match destination-address 172.16.1.53/32
    set security nat destination rule-set rs1 rule rule6 match application junos-ssh
    set security nat destination rule-set rs1 rule rule6 then destination-nat pool dnat8

    set security address-book global address L2DC2 fc00:dead:beef:a041::/64
    set security address-book global address lxc5lxd1dc2 192.168.41.201/32
    set security policies from-zone untrust to-zone RZ12 policy policy1 match source-address any
    set security policies from-zone untrust to-zone RZ12 policy policy1 match destination-address L2DC2
    set security policies from-zone untrust to-zone RZ12 policy policy1 match application junos-ssh
    set security policies from-zone untrust to-zone RZ12 policy policy1 then permit
    set security policies from-zone untrust to-zone RZ12 policy policy2 match source-address any
    set security policies from-zone untrust to-zone RZ12 policy policy2 match destination-address lxc5lxd1dc2
    set security policies from-zone untrust to-zone RZ12 policy policy2 match application junos-ssh
    set security policies from-zone untrust to-zone RZ12 policy policy2 then permit
    set security policies from-zone RZ12 to-zone untrust policy policy1 match source-address any
    set security policies from-zone RZ12 to-zone untrust policy policy1 match destination-address any
    set security policies from-zone RZ12 to-zone untrust policy policy1 match application any
    set security policies from-zone RZ12 to-zone untrust policy policy1 then permit