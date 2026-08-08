# P5

        set protocols mpls lsp-external-controller pccd
        set protocols mpls statistics interval 10
        set protocols mpls traffic-engineering database import l3-unicast-topology bgp-link-state
        set protocols mpls traffic-engineering database import policy TE
        set protocols mpls sensor-based-stats
        set protocols mpls interface ge-0/0/0.0
        set protocols mpls interface ge-0/0/1.0
        set protocols mpls interface ge-0/0/2.0
        set protocols mpls interface ge-0/0/3.0
        set protocols mpls interface ge-0/0/4.0

        set protocols source-packet-routing lsp-external-controller pccd
        set protocols source-packet-routing traffic-engineering database

        set protocols isis traffic-engineering l3-unicast-topology
        set protocols isis traffic-engineering advertisement always
        set services rpm twamp server authentication-mode none
        set services rpm twamp server light

        set protocols pcep disable-multipath-capability
        set protocols pcep pce rd1 local-address 10.100.255.15
        set protocols pcep pce rd1 destination-ipv4-address 172.16.12.3
        set protocols pcep pce rd1 destination-port 4189
        set protocols pcep pce rd1 pce-type active
        set protocols pcep pce rd1 pce-type stateful
        set protocols pcep pce rd1 lsp-provisioning
        set protocols pcep pce rd1 lsp-cleanup-timer 300
        set protocols pcep pce rd1 spring-capability

        set policy-options policy-statement TE term 1 from family traffic-engineering
        set policy-options policy-statement TE term 1 from protocol isis
        set policy-options policy-statement TE term 1 then accept

        set protocols mpls traffic-engineering bgp-igp-both-ribs