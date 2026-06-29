# initial configuration 

    set system root-authentication encrypted-password $1$iEgtjnMz$UfoQkc06YUH/N1s/RvAXM0
    set system login user admin class super-user
    set system login user admin authentication encrypted-password $1$iEgtjnMz$UfoQkc06YUH/N1s/RvAXM0
    set system services ssh root-login allow
    set system services ssh sftp-server
    set system services netconf ssh
    set system syslog user * any emergency
    set system syslog file messages any notice
    set system syslog file messages authorization info
    set system syslog file interactive-commands interactive-commands any
    set system management-instance
    set interfaces fxp0 unit 0 family inet address 172.16.101.103/24
    set system host-name br3
# configuration for HQ

    set protocols bgp group to_internet neighbor 192.168.210.1 peer-as 4200000100
    set protocols bgp group to_internet neighbor 192.168.210.1 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_internet neighbor 192.168.210.1 bfd-liveness-detection multiplier 3
    set routing-options autonomous-system 4200000001

    set security zones security-zone trust host-inbound-traffic system-services ping
    set security zones security-zone trust host-inbound-traffic system-services ssh
    set security zones security-zone trust interfaces ge-0/0/0.0
    set security zones security-zone untrust screen untrust-screen
    set security zones security-zone untrust host-inbound-traffic system-services ping
    set security zones security-zone untrust host-inbound-traffic protocols bfd
    set security zones security-zone untrust host-inbound-traffic protocols bgp
    set security zones security-zone untrust interfaces ge-0/0/1.0
    set security zones security-zone untrust interfaces ge-0/0/2.0
    set system domain-name vmmlab.com
    set system name-server 172.16.101.254
    delete system default-address-selection

# configuration for BR1

    set protocols bgp group to_internet neighbor 192.168.210.3 peer-as 4200000100
    set protocols bgp group to_internet neighbor 192.168.210.3 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_internet neighbor 192.168.210.3 bfd-liveness-detection multiplier 3
    set routing-options autonomous-system 4200000011

    set security zones security-zone trust host-inbound-traffic system-services ping
    set security zones security-zone trust host-inbound-traffic system-services ssh
    set security zones security-zone trust interfaces ge-0/0/0.0
    set security zones security-zone untrust screen untrust-screen
    set security zones security-zone untrust host-inbound-traffic system-services ping
    set security zones security-zone untrust host-inbound-traffic protocols bfd
    set security zones security-zone untrust host-inbound-traffic protocols bgp
    set security zones security-zone untrust interfaces ge-0/0/1.0
    set security zones security-zone untrust interfaces ge-0/0/2.0
    set system domain-name vmmlab.com
    set system name-server 172.16.101.254
    delete system default-address-selection


# configuration for BR2

    set protocols bgp group to_internet neighbor 192.168.210.5 peer-as 4200000100
    set protocols bgp group to_internet neighbor 192.168.210.5 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_internet neighbor 192.168.210.5 bfd-liveness-detection multiplier 3
    set routing-options autonomous-system 4200000012

    set security zones security-zone trust host-inbound-traffic system-services ping
    set security zones security-zone trust host-inbound-traffic system-services ssh
    set security zones security-zone trust interfaces ge-0/0/0.0
    set security zones security-zone untrust screen untrust-screen
    set security zones security-zone untrust host-inbound-traffic system-services ping
    set security zones security-zone untrust host-inbound-traffic protocols bfd
    set security zones security-zone untrust host-inbound-traffic protocols bgp
    set security zones security-zone untrust interfaces ge-0/0/1.0
    set security zones security-zone untrust interfaces ge-0/0/2.0
    set system domain-name vmmlab.com
    set system name-server 172.16.101.254
    delete system default-address-selection

# configuration for BR3

    set protocols bgp group to_internet neighbor 192.168.210.7 peer-as 4200000100
    set protocols bgp group to_internet neighbor 192.168.210.7 bfd-liveness-detection minimum-interval 500
    set protocols bgp group to_internet neighbor 192.168.210.7 bfd-liveness-detection multiplier 3
    set routing-options autonomous-system 4200000013

    set security zones security-zone trust host-inbound-traffic system-services ping
    set security zones security-zone trust host-inbound-traffic system-services ssh
    set security zones security-zone trust interfaces ge-0/0/0.0
    set security zones security-zone untrust screen untrust-screen
    set security zones security-zone untrust host-inbound-traffic system-services ping
    set security zones security-zone untrust host-inbound-traffic protocols bfd
    set security zones security-zone untrust host-inbound-traffic protocols bgp
    set security zones security-zone untrust interfaces ge-0/0/1.0
    set security zones security-zone untrust interfaces ge-0/0/2.0
    set system domain-name vmmlab.com
    set system name-server 172.16.101.254
    delete system default-address-selection
    


