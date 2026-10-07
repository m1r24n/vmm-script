# LXD6

## reconfigure frr daemons

    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons

## netplan config

    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                addresses: [ 192.168.191.6/24, fc00:dead:beef:a191::1000:6/64]
            eth1:
                addresses: [ 192.168.192.6/24, fc00:dead:beef:a192::1000:6/64]
        bridges:
            br1:
                addresses: [ 192.168.11.1/24, fc00:dead:Beef:a011::1/64]
    EOF

    sudo netplan apply


## FRR config
    ip prefix-list local1 seq 5 permit 192.168.11.0/24
    !
    ipv6 prefix-list local6 seq 5 permit fc00:dead:beef:a011::/64
    !
    route-map LOCAL4 permit 1
    match ip address prefix-list local1
    exit
    !
    route-map LOCAL6 permit 1
    match ipv6 address prefix-list local6
    exit
    !
    router bgp 4200009006
    no bgp ebgp-requires-policy
    neighbor 192.168.191.1 remote-as 4200001105
    neighbor 192.168.192.1 remote-as 4200001106
    neighbor fc00:dead:beef:a191::1 remote-as 4200001105
    neighbor fc00:dead:beef:a192::1 remote-as 4200001106
    !
    address-family ipv4 unicast
    network 192.168.11.0/24
    neighbor 192.168.191.1 route-map LOCAL4 out
    neighbor 192.168.192.1 route-map LOCAL4 out
    exit-address-family
    !
    address-family ipv6 unicast
    network fc00:dead:beef:a011::/64
    neighbor fc00:dead:beef:a191::1 activate
    neighbor fc00:dead:beef:a191::1 route-map LOCAL6 out
    neighbor fc00:dead:beef:a192::1 activate
    neighbor fc00:dead:beef:a192::1 route-map LOCAL6 out
    exit-address-family
    exit
    !
    bfd
    profile bfd1
    echo transmit-interval 1000
    echo receive-interval 1000
    exit
    !
    peer fc00:dead:beef:a191::1
    profile bfd1
    exit
    !
    peer fc00:dead:beef:a192::1
    profile bfd1
    exit
    !
    peer 192.168.191.1
    profile bfd1
    exit
    !
    peer 192.168.192.1
    profile bfd1
    exit
    !
    exit
    !
    end



# LXD8

## reconfigure frr daemons

    sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
    sudo sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons

## netplan config

    cat << EOF | sudo tee /etc/netplan/01_net.yaml
    network:
        version: 2
        ethernets:
            eth0:
                addresses: [ 192.168.191.8/24, fc00:dead:beef:a191::1000:8/64]
            eth1:
                addresses: [ 192.168.192.8/24, fc00:dead:beef:a192::1000:8/64]
        bridges:
            br1:
                addresses: [ 192.168.12.1/24, fc00:dead:Beef:a012::1/64]
    EOF

    sudo netplan apply


## FRR config
    ip prefix-list local1 seq 5 permit 192.168.12.0/24
    !
    ipv6 prefix-list local6 seq 5 permit fc00:dead:beef:a012::/64
    !
    route-map LOCAL4 permit 1
    match ip address prefix-list local1
    exit
    !
    route-map LOCAL6 permit 1
    match ipv6 address prefix-list local6
    exit
    !
    router bgp 4200009008
    no bgp ebgp-requires-policy
    neighbor 192.168.191.1 remote-as 4200001108
    neighbor 192.168.192.1 remote-as 4200001107
    neighbor fc00:dead:beef:a191::1 remote-as 4200001108
    neighbor fc00:dead:beef:a192::1 remote-as 4200001107
    !
    address-family ipv4 unicast
    network 192.168.12.0/24
    neighbor 192.168.191.1 route-map LOCAL4 out
    neighbor 192.168.192.1 route-map LOCAL4 out
    exit-address-family
    !
    address-family ipv6 unicast
    network fc00:dead:beef:a012::/64
    neighbor fc00:dead:beef:a191::1 activate
    neighbor fc00:dead:beef:a191::1 route-map LOCAL6 out
    neighbor fc00:dead:beef:a192::1 activate
    neighbor fc00:dead:beef:a192::1 route-map LOCAL6 out
    exit-address-family
    exit
    !
    bfd
    profile bfd1
    echo transmit-interval 1000
    echo receive-interval 1000
    exit
    !
    peer fc00:dead:beef:a191::1
    profile bfd1
    exit
    !
    peer fc00:dead:beef:a192::1
    profile bfd1
    exit
    !
    peer 192.168.191.1
    profile bfd1
    exit
    !
    peer 192.168.192.1
    profile bfd1
    exit
    !
    exit
    !
    end

