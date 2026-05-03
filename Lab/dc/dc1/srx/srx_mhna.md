# configuration of FW2

    set groups MHNA chassis high-availability local-id 2
    set groups MHNA chassis high-availability local-id local-ip 172.16.255.2
    set groups MHNA chassis high-availability peer-id 1 peer-ip 172.16.255.1
    set groups MHNA chassis high-availability peer-id 1 interface lo0.0
    set groups MHNA chassis high-availability peer-id 1 liveness-detection minimum-interval 500
    set groups MHNA chassis high-availability peer-id 1 liveness-detection multiplier 3
    set groups MHNA chassis high-availability services-redundancy-group 0 peer-id 1
    set groups MHNA interfaces lo0 unit 0 family inet address 172.16.255.2/32
    set groups MHNA interfaces ge-0/0/5 mtu 9000
    set groups MHNA interfaces ge-0/0/5 unit 0 family inet address 172.16.255.129/31
    set groups MHNA policy-options policy-statement to_fw1 term 1 from route-filter 172.16.255.2/32 exact
    set groups MHNA policy-options policy-statement to_fw1 term 1 then accept
    set groups MHNA policy-options policy-statement to_fw1 term default then reject
    set groups MHNA protocols bgp group to_fw1 neighbor 172.16.255.128 export to_fw1
    set groups MHNA protocols bgp group to_fw1 neighbor 172.16.255.128 peer-as 4200008001
    set routing-options autonomous-system 4200008002
    set security zones security-zone trust host-inbound-traffic system-services ping
    set security zones security-zone trust host-inbound-traffic system-services ssh
    set security zones security-zone trust host-inbound-traffic system-services high-availability
    set security zones security-zone trust host-inbound-traffic protocols bgp
    set security zones security-zone trust interfaces ge-0/0/5.0
    set security zones security-zone trust interfaces lo0.0



# configuration of FW1

    set groups MHNA chassis high-availability local-id 1
    set groups MHNA chassis high-availability local-id local-ip 172.16.255.1
    set groups MHNA chassis high-availability peer-id 2 peer-ip 172.16.255.2
    set groups MHNA chassis high-availability peer-id 2 interface lo0.0
    set groups MHNA chassis high-availability peer-id 2 liveness-detection minimum-interval 500
    set groups MHNA chassis high-availability peer-id 2 liveness-detection multiplier 3
    set groups MHNA chassis high-availability services-redundancy-group 0 peer-id 2
    set groups MHNA interfaces lo0 unit 0 family inet address 172.16.255.1/32
    set groups MHNA interfaces ge-0/0/5 mtu 9000
    set groups MHNA interfaces ge-0/0/5 unit 0 family inet address 172.16.255.128/31
    set groups MHNA policy-options policy-statement to_fw2 term 1 from route-filter 172.16.255.1/32 exact
    set groups MHNA policy-options policy-statement to_fw2 term 1 then accept
    set groups MHNA policy-options policy-statement to_fw2 term default then reject
    set groups MHNA protocols bgp group to_fw2 neighbor 172.16.255.129 export to_fw2
    set groups MHNA protocols bgp group to_fw2 neighbor 172.16.255.129 peer-as 4200008002
    set routing-options autonomous-system 4200008001    
    set security zones security-zone trust host-inbound-traffic system-services ping
    set security zones security-zone trust host-inbound-traffic system-services ssh
    set security zones security-zone trust host-inbound-traffic system-services high-availability
    set security zones security-zone trust host-inbound-traffic protocols bgp
    set security zones security-zone trust interfaces ge-0/0/5.0
    set security zones security-zone trust interfaces lo0.0
