# configuration for host client

    cat << EOF | sudo tee  /etc/netplan/02_net.yaml
    network:
      bridges:
        fw3ge3:
            interfaces:
            - eth13
        acc1ge2:
            interfaces:
            - eth1
        acc2ge2:
            interfaces:
            - eth2
        acc3ge2:
            interfaces:
            - eth3
        acc4ge2:
            interfaces:
            - eth4
        acc1ge3:
            interfaces:
            - eth5
        acc2ge3:
            interfaces:
            - eth6
        acc3ge3:
            interfaces:
            - eth7
        acc4ge3:
            interfaces:
            - eth8
        acc1ge4:
            interfaces:
            - eth9
        acc2ge4:
            interfaces:
            - eth10
        acc3ge4:
            interfaces:
            - eth11
        acc4ge4:
            interfaces:
            - eth12
    EOF


# DHCP server configuration, /etc/kea/kea-dhcp4.conf

    {
        "Dhcp4": {
            "interfaces-config": {
                "interfaces": [ "eth0" ]
                // "dhcp-socket-type": "udp"
            },
            "control-socket": {
                "socket-type": "unix",
                "socket-name": "kea-dhcp4-ctrl.sock"
            },
            "lease-database": {
                "type": "memfile",
                "lfc-interval": 3600
            },
            "expired-leases-processing": {
                "reclaim-timer-wait-time": 10,
                "flush-reclaimed-timer-wait-time": 25,
                "hold-reclaimed-time": 3600,
                "max-reclaim-leases": 100,
                "max-reclaim-time": 250,
                "unwarned-reclaim-cycles": 5
            },
            "renew-timer": 900,
            "rebind-timer": 1800,
            "valid-lifetime": 3600,

            "option-data": [
                {
                    "name": "domain-name-servers",
                    "data": "172.16.12.1"
                },
            ],
            "subnet4": [
                {
                    "id": 1,
                    "subnet": "192.168.101.0/24",
                    "pools": [ { "pool": "192.168.101.100 - 192.168.101.200" } ],
                    "option-data": [
                        {
                            "name": "routers",
                            "data": "192.168.101.1"
                        }
                    ],
                    "match-client-id": false,
                    "reservations": [

                        // This is a reservation for a specific hardware/MAC address.
                        // It's a rather simple reservation: just an address and nothing
                        // else.
                        //{
                        //   "hw-address": "1a:1b:1c:1d:1e:1f",
                        //   "ip-address": "192.0.2.201"
                        //},
                    ]
                },
                {
                    "id": 2,
                    "subnet": "192.168.102.0/24",
                    "pools": [ { "pool": "192.168.102.100 - 192.168.102.200" } ],
                    "option-data": [
                        {
                            "name": "routers",
                            "data": "192.168.102.1"
                        }
                    ],
                    "match-client-id": false,
                    "reservations": [

                        // This is a reservation for a specific hardware/MAC address.
                        // It's a rather simple reservation: just an address and nothing
                        // else.
                        //{
                        //   "hw-address": "1a:1b:1c:1d:1e:1f",
                        //   "ip-address": "192.0.2.201"
                        //},
                    ]
                },
            ],

            "loggers": [
                {
                    "name": "kea-dhcp4",
                    "output-options": [
                        {
                            "output": "kea-dhcp4.log"
                        },
                    ],
                    "severity": "INFO",
                    "debuglevel": 0
                }
            ]
        }
    }


# dhcpserver configuration

    SOURCE=client
    LXC_NAME=dhcpserver
    BRIDGE=fw3ge3
    IPv4=172.16.13.1/24
    GWv4=172.16.13.254
    IPv6=fc00:dead:beef:a013::1000:1/64
    DNS=172.16.12.1
    lxc copy client ${LXC_NAME}
    lxc query --request PATCH /1.0/instances/${LXC_NAME} --data "{
        \"devices\": {
            \"eth0\" :{
            \"name\": \"eth0\",
            \"nictype\": \"bridged\",
            \"parent\": \"${BRIDGE}\",
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
    EOF

    lxc file push ./interface.conf ${LXC_NAME}/etc/network/interfaces
    cat << EOF | tee ./resolv.conf
    nameserver ${DNS}
    EOF

    lxc file push ./resolv.conf ${LXC_NAME}/etc/resolv.conf
    lxc start ${LXC_NAME}
    

# firewall fw1 configuration

    set system host-name fw1
    set system root-authentication encrypted-password "$6$IU4xesWh$zpni2/wxzHi779yF79No7CzTXQXDZ6pjSQfrqgw1W6gx9E1BfujwW6lG6wqZQaier8ob/Jhg5N42858PEitpI/"
    set system login user admin class super-user
    set system login user admin authentication encrypted-password "$6$DVdSTJkL$Wd7EYcvRqAamdmE0P2.FBRPkOTGxqSPC7xG1ESWm0szE6dJpm5Ahwe1J/GLuJ49iMOwGjZFQk7ZEzxqPIMZMD."

    set system services ssh protocol-version v2
    set system services ssh sftp-server

    set system name-server 172.16.12.1

    set security nat source rule-set rs1 from zone trust
    set security nat source rule-set rs1 to zone untrust
    set security nat source rule-set rs1 rule rule1 match source-address 0.0.0.0/0
    set security nat source rule-set rs1 rule rule1 match destination-address 0.0.0.0/0
    set security nat source rule-set rs1 rule rule1 match application any
    set security nat source rule-set rs1 rule rule1 then source-nat interface
    set security nat source rule-set rs2 from zone overlay
    set security nat source rule-set rs2 to zone untrust
    set security nat source rule-set rs2 rule rule2 match source-address 0.0.0.0/0
    set security nat source rule-set rs2 rule rule2 match destination-address 0.0.0.0/0
    set security nat source rule-set rs2 rule rule2 match application any
    set security nat source rule-set rs2 rule rule2 then source-nat interface
    set security nat source rule-set rs3 from zone underlay
    set security nat source rule-set rs3 to zone untrust
    set security nat source rule-set rs3 rule rule3 match source-address 0.0.0.0/0
    set security nat source rule-set rs3 rule rule3 match destination-address 0.0.0.0/0
    set security nat source rule-set rs3 rule rule3 match application any
    set security nat source rule-set rs3 rule rule3 then source-nat interface


    set security zones security-zone trust host-inbound-traffic system-services ping
    set security zones security-zone trust host-inbound-traffic system-services ssh
    set security zones security-zone trust interfaces ge-0/0/3.0
    set security zones security-zone untrust screen untrust-screen
    set security zones security-zone untrust host-inbound-traffic system-services ping
    set security zones security-zone untrust host-inbound-traffic system-services ssh
    set security zones security-zone untrust interfaces ge-0/0/0.0
    set security zones security-zone underlay host-inbound-traffic system-services ping
    set security zones security-zone underlay host-inbound-traffic protocols bgp
    set security zones security-zone underlay interfaces ge-0/0/1.100
    set security zones security-zone underlay interfaces ge-0/0/2.100
    set security zones security-zone overlay host-inbound-traffic system-services ping
    set security zones security-zone overlay host-inbound-traffic protocols bgp
    set security zones security-zone overlay interfaces ge-0/0/1.200
    set security zones security-zone overlay interfaces ge-0/0/2.200

    set security policies from-zone trust to-zone trust policy default-permit match source-address any
    set security policies from-zone trust to-zone trust policy default-permit match destination-address any
    set security policies from-zone trust to-zone trust policy default-permit match application any
    set security policies from-zone trust to-zone trust policy default-permit then permit

    set security policies from-zone trust to-zone untrust policy default-permit match source-address any
    set security policies from-zone trust to-zone untrust policy default-permit match destination-address any
    set security policies from-zone trust to-zone untrust policy default-permit match application any
    set security policies from-zone trust to-zone untrust policy default-permit then permit

    set security policies from-zone overlay to-zone trust policy permit-all match source-address any
    set security policies from-zone overlay to-zone trust policy permit-all match destination-address any
    set security policies from-zone overlay to-zone trust policy permit-all match application any
    set security policies from-zone overlay to-zone trust policy permit-all then permit

    set security policies from-zone trust to-zone overlay policy permit-all match source-address any
    set security policies from-zone trust to-zone overlay policy permit-all match destination-address any
    set security policies from-zone trust to-zone overlay policy permit-all match application any
    set security policies from-zone trust to-zone overlay policy permit-all then permit
    set security policies from-zone underlay to-zone untrust policy permit-all match source-address any
    set security policies from-zone underlay to-zone untrust policy permit-all match destination-address any
    set security policies from-zone underlay to-zone untrust policy permit-all match application any
    set security policies from-zone underlay to-zone untrust policy permit-all then permit
    set security policies from-zone overlay to-zone untrust policy permit-all match source-address any
    set security policies from-zone overlay to-zone untrust policy permit-all match destination-address any
    set security policies from-zone overlay to-zone untrust policy permit-all match application any
    set security policies from-zone overlay to-zone untrust policy permit-all then permit

    set interfaces ge-0/0/0 unit 0 family inet address 172.16.12.2/24
    set interfaces ge-0/0/1 vlan-tagging
    set interfaces ge-0/0/1 unit 100 vlan-id 1002
    set interfaces ge-0/0/1 unit 100 family inet address 172.16.100.0/31
    set interfaces ge-0/0/1 unit 200 vlan-id 1001
    set interfaces ge-0/0/1 unit 200 family inet address 172.16.100.4/31
    set interfaces ge-0/0/2 vlan-tagging
    set interfaces ge-0/0/2 unit 100 vlan-id 1002
    set interfaces ge-0/0/2 unit 100 family inet address 172.16.100.2/31
    set interfaces ge-0/0/2 unit 200 vlan-id 1001
    set interfaces ge-0/0/2 unit 200 family inet address 172.16.100.6/31
    set interfaces ge-0/0/3 unit 0 family inet address 172.16.13.254/24
    set policy-options policy-statement to_core term 2 from route-filter 0.0.0.0/0 exact
    set policy-options policy-statement to_core term 2 then accept
    set policy-options policy-statement to_core term default then reject
    set protocols bgp group to_core export to_core
    set protocols bgp group to_core neighbor 172.16.100.5 peer-as 4200000101
    set protocols bgp group to_core neighbor 172.16.100.7 peer-as 4200000102
    set protocols bgp group to_core neighbor 172.16.100.1 peer-as 4200000101
    set protocols bgp group to_core neighbor 172.16.100.3 peer-as 4200000102
    set routing-options autonomous-system 4200000001
    set routing-options static route 0.0.0.0/0 next-hop 172.16.12.1

# additional configuration to allow in-band management

## core switches

    delete groups top policy-options policy-statement evpn_underlay_export
    set groups top policy-options policy-statement evpn_underlay_export term 01-loopback from route-filter <loopback0 routes> orlonger
    set groups top policy-options policy-statement evpn_underlay_export term 01-loopback then accept
    set groups top policy-options policy-statement evpn_underlay_export term 01-default from route-filter 0.0.0.0/0 exact
    set groups top policy-options policy-statement evpn_underlay_export term 01-default then accept
    set groups top policy-options policy-statement evpn_underlay_export term 02-default then reject

## distribution switches

    delete groups top policy-options policy-statement evpn_underlay_export
    set groups top policy-options policy-statement evpn_underlay_export term 01-loopback from route-filter <loopback0 routes> orlonger
    set groups top policy-options policy-statement evpn_underlay_export term 01-loopback then accept
    set groups top policy-options policy-statement evpn_underlay_export term 01-default from route-filter 0.0.0.0/0 exact
    set groups top policy-options policy-statement evpn_underlay_export term 01-default then accept
    set groups top policy-options policy-statement evpn_underlay_export term 02-default then reject

    delete groups top policy-options policy-statement evpn_underlay_import
    set groups top policy-options policy-statement evpn_underlay_import term 01-loopback from route-filter <loopback0 routes> orlonger
    set groups top policy-options policy-statement evpn_underlay_import term 01-loopback then accept
    set groups top policy-options policy-statement evpn_underlay_import term 01-default from route-filter 0.0.0.0/0 exact
    set groups top policy-options policy-statement evpn_underlay_import term 01-default then accept
    set groups top policy-options policy-statement evpn_underlay_import term 02-default then reject


