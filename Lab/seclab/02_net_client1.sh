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
  bridges:
    fw1ge1:
      openvswitch: {}
      interfaces: 
      - eth1
    fw2ge1:
      openvswitch: {}
      interfaces: 
      - eth2
    fw3ge1:
      openvswitch: {}
      interfaces: 
      - eth3
    nwge1:
      openvswitch: {}
      interfaces: 
      - eth4
EOF
sudo netplan apply



