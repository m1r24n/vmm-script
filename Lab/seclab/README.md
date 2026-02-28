# Running Security Lab
this script is to run vsrx on juniper's VMM

## Topology
The logical topology of the testbed is as follows :
![topology](images/topo1.webp)



## Devices in the lab

- vSRX: fw1, fw2, fw2
- vJunosRouter: nw
- Linux VM : client1, nms1

## Credential to access devices
- Ubuntu linux
    - user: ubuntu
    - password: pass01

- vJunosRouter and vSRX
    - user: admin
    - password: admin


## Deploying lab topology

Screenshot recording for this can be found [here]()

1. Go to directory [seclab](../seclab)

        cd seclab 

2. Edit file [lab.yaml](./apstra/lab.yaml). Set the following parameters to choose which vmm server that you are going to use and the login credential:
    - vmmserver 
    - user 
3. If you want to add devices or change the topooogy of the lab, then edit file [lab.yaml](lab.yaml)
4. use [vmm.py](../../vmm.py) script to deploy the topology into the VMM. Run the following command from terminal

        ../../vmm.py upload  <-- to create the topology file and the configuration for the VMs and upload them into vmm server
        ../../vmm.py start   <-- to start the topology in the vmm server

5. Verify that you can access node **gw** using ssh (username: ubuntu,  password: pass01 ). You may have to wait for few minutes for node **gw** to be up and running
6. Run script [vmm.py](../../vmm.py) to send and run initial configuration on node **gw**

        ../../vmm.py set_gw

7. Run script [vmm.py](../../vmm.py) to configure host **client1** and **nms1**

        ../../../vmm.py set_host

7. Run ansible-playbook [setup/update_nodes.yaml](setup/update_nodes.yaml) to install the necessary software on node gw, nms1, client1

        cd setup
        ansible-playbook update_nodes.yaml


## Setup IP addresses of vSRX node (fw1, fw2, fw3)
Screenshot recording for this can be found [here]()

1. access serial console of mode **fw1**, and login as root

        ssh vmm 
        vmm serial -t fw1

2. put the following configuration on fw1

       configure
       set system root-authentication encrypted-password "$1$UdIF9kKl$Cv.QwIWJtaKr5et5AWQev1"
       set system login user admin class super-user
       set system login user admin authentication encrypted-password "$1$UdIF9kKl$Cv.QwIWJtaKr5et5AWQev1"
       set system login user admin authentication ssh-rsa "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCx22aCBNHVov9suzB3Yv7yz9Bo+LaIHxw6ok5cTztjm4RkLZwcf9AE7yQduIK36ZmR9yMd1XXjON9zN/lQUa8wYxWPFdmzcpJEd67cLg+TUfsAa2MbXhOueFt4NpxCyE1OSLuQPVVxe93kvm71TbSZ38n2NP7DTb8SwAN4X82Q5ggX6k6mFeKmG4KUq7kClLiPQF/lXq0YpQCrSr1XO6M7tA+U9xui8fd6rU4vyvoo78hPKP7ESdNIYyJiJ8K+VRTofs6yyeMY8KveGFxSOTyThLGtd2NvmzbvmQ5PVq21ycAx3fjdeU3HwfLKOiOGXOnQFtB/aha4yG5t5xgGp3iB"
       set system services netconf ssh
       set system services ssh root-login allow
       set system services ssh sftp-server
       set system management-instance
       set protocols lldp interface all
       set interfaces fxp0 unit 0 family inet address 172.16.11.3/24
       set system host-name fw3
       commit

3. Repeat the process for fw2 and fw2, by changing the hostname and the ip-address

       set interfaces fxp0 unit 0 family inet address 172.16.11.2/24
       set system host-name fw2


       set interfaces fxp0 unit 0 family inet address 172.16.11.3/24
       set system host-name fw3

## configure FRR on  configuration on gw

1. ssh to node **gw**, edit file /etc/frr/daemons, and enable bgp

       ssh gw
       sudo sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
       sudo systemctl restart frr

2. put the following configuration on the frr

       sudo vtysh 
       config t
       router bgp 4200000000
       no bgp ebgp-requires-policy
       neighbor 172.16.12.4 remote-as 4200000001
       !
       address-family ipv4 unicast
       network 0.0.0.0/0
       exit-address-family
       exit
       write
## configure vjunosrouter nw1, and vsrx (fw1, fw2, fw3)

2. These are the ip address for Apstra nodes

    node | IP address| gateway| DNS
    -|-|-|-
    apstra| 172.16.55.1/24|172.16.55.254|172.16.55.254
    apstraw2|172.16.55.2/24|172.16.55.254|172.16.55.254
    apstraw3|172.16.55.3/24|172.16.55.254|172.16.55.254
    ztp| 172.16.55.4/24|172.16.55.254|172.16.55.254
    flow| 172.16.55.5/24|172.16.55.254|172.16.55.254

3. To setup those apstra node, use serial console of the VM
4. to open console of VM of juniper Apstra. Open ssh session into node vmm, and run command **vmm serial -t apstra** (this is for controller node)

        ssh vmm
        vmm serial -t apstra

5. Open session session into node apstra, and start the initial configuration, such as changing login password and set ip address to static
6. Repeat the process for node apstraw2, apstraw3, ztp and flow
7. Open ssh session into node gw, and test connectivity to the apstra node

        ssh gw
        ping 172.16.55.1
        ssh admin@172.16.55.1
8. Or if wireguard session has been established, test connectivity directly with the apstra nodes from your workstation

        ping 172.16.55.1
        ssh admin@172.16.55.1
        curl http://172.16.55.1
        curl -k https://172.16.55.1

## Deploying topology DC1

Screenshot recording for this can be found [here]()

1. Go to directory [dc1](./dc1)

        cd dc1

2. Edit file [lab.yaml](./dc1/lab.yaml). Set the following parameters to choose which vmm server that you are going to use and the login credential:
    - vmmserver 
    - user 
3. If you want to add devices or change the topology of the lab, then edit file [lab.yaml](lab.yaml)
4. use [vmm.py](../../vmm.py) script to deploy the topology into the VMM. Run the following command from terminal

       ../../../vmm.py upload  <-- to create the topology file and the configuration for the VMs and upload them into vmm server
       ../../../vmm.py start   <-- to start the topology in the vmm server

5. Verify that you can access node **gw** using ssh (username: ubuntu,  password: pass01 ). You may have to wait for few minutes for node **gw** to be up and running
6. Run script [vmm.py](../../../vmm.py) to send and run initial configuration on node **gw**

        ../../../vmm.py set_gw
7. Open ssh session into node **vmm** and access serial console of node svr0

       ssh vmm
       vmm serial -t svr0

8. Run the following script on node **svr0**

       cat << EOF | sudo tee /etc/netplan/01_net.yaml
       network:
         version: 2
         ethernets:
           eth0:
             addresses: [ 172.16.51.100/24]
             nameservers:
               addresses: [ 172.16.51.254]
               search: [vmmlab.com]
             routes:
             - to: default
               via: 172.16.51.254
       EOF
       sudo hostname svr0
       hostname | sudo tee /etc/hostname
       sudo netplan apply

9. Run script [vmm.py](../../vmm.py) to send and run initial configuration on node all ubuntu nodes

       ../../../vmm.py set_host

10. Run ansible-playbook [dc1/setup/update_nodes.yaml](dc1/setup/update_nodes.yaml) to install the necessary software on node gw

        cd setup
        ansible-playbook update_nodes.yaml
        ./reboot_vm.sh

11. Run script [vmm.py](../../vmm.py) to get the mac addresses of vJunosSwitch and vJunosEvolved nodes in the lab. Record this information, it is required for ZTP configuration on the next steps
        
        ../../../vmm.py get_vjunos_mac


## Initial setup of Apstra 

Screenshot recording for this can be found [here](https://youtu.be/Jnnpxnlu764)

1. login into web dashboard of Apstra server, https://172.16.55.1
2. Add license into Apstra
3. Add worker nodes, apstraw2 and apstraw3, into apstra controller. 
4. Add user for ZTP server. 
    
        user: ztp
        global_roles: device_ztp

5. get the list of mac addresses for all network devices in the datacenter (spine and leaf switches)
6. login into dashboard of Apstra ZTP server, https://172.16.55.4 
7. configure DHCP: subnet, ip pool and ip addresses reservation. For ip address reservation use the mac address information from the previous steps.
8. Configure ztp.json  with the junos version and custom script for vJunosSwitch and vJunosEvolved. To accept any version for vJunos, just delete the existing version from the dashboard, and remove the URL for the image.

9. Use the following for the custom script for vJunosSwitch : 

       #!/bin/sh
       cli -c "configure; set system commit synchronize; set chassis evpn-vxlan-default-switch-support; set chassis fpc 0 pic 0 number-of-ports 12; commit and-quit"

10. Use the following for the custom script for vJunosEvolved

        #!/bin/sh 
        cli -c "configure; set forwarding-options tunnel-termination; commit and-quit"


## Connecting topology Apstra and topology DC1


Screenshot recording for this can be found [here](https://asciinema.org/a/747229)

1. upload script [create_wg_gwapstra.sh](dc1/wireguard_config/create_wg_gwapstra.sh) into node **gw** of topology Apstra (ip address 172.16.55.254), open ssh session into node **gw** of topology apstra, and run the script. It will create wireguard interface for connection to topology DC1

       scp dc1/wireguard_config/create_wg_gwapstra.sh ubuntu@172.16.55.254:~/
       ssh ubuntu@172.16.55.254
       ./create_wg_gwapstra.sh
       ip link show
       ip addr show dev eth0

2. Get ip address of interface eth0 of node **gw** of topology apstra, and record it. it is required for the next step.


       ssh ubuntu@172.16.55.254 "ip addr show dev eth0"

3. upload script [create_wg_gwdc1.sh](dc1/wireguard_config/create_wg_gwdc1.sh) into node **gw** of topology DC1, open ssh session into node **gw** of topology DC1, and run the script. It will create wireguard interface for connection to topology Apstra.

       scp dc1/wireguard_config/create_wg_gwdc1.sh gw:~/
       ssh gw
       ./create_wg_gwdc1.sh <ip_of_eth0_of_node_gw_topology_apstra>
       ip link show

4. Test connectivity to apstra server

       ping 172.16.55.1
       ping 172.16.55.4
       curl -k https://172.16.55.1

## Configure dhcp-relay on node svr0

Screenshot recording for this can be found [here](https://youtu.be/wjjGzq_HzVU)

Since the dhcp and ZTP server are located on different subnet/topology (topology Apstra), then dhcp relay must be configured on topology DC1 to forward dhcp request from vJunos Nodes to the apstra ZTP server.

Since dhcp-relay can't be configured on node **gw** of topology DC1, so dhcp-relay is configured on node svr0.

1. open ssh session into node svr0
       ssh svr0

2. install isc-dhcp-relay application and set the dhcp-relay (server: 172.16.55.4, interface: eth0)

       sudo apt install isc-dhcp-relay -y

3. Then DHCP request from all the vJunos nodes on topology DC1 will be forwarded into Apstra ZTP Server and the vJunos Nodes will be onboarded into Juniper Apstra.

4. Verify that devices (vJunosSwitch and vJunosEvolved) are onboarded on Juniper Apstra Server


## Lab exercise

You can refer to [this document](LabExercise/README.md) for lab exercise




