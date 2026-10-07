# Initialize and setup LXD on node client

1. open ssh session into node client

       ssh client
2. Initialize LXD

       sudo lxd init

3. Download alpine linux image

       lxc image copy images:alpine/edge local: --alias alpine

4. Create linux container client using image alpine

       lxc launch alpine client

5. Access container **client** and install the necessary package and configure

       
       lxc exec client sh
       apk update
       apk upgrade
       apk add openssh iperf links
       cat << EOF | tee -a /etc/ssh/sshd_config
       PermitRootLogin yes
       EOF
       passwd
       rc-update add sshd
       service sshd start
       
6. Clone container **client** to **router**

       lxc stop client
       lxc copy client router
       lxc start router
       lxc exec router sh
       apk add frr dnsmasq
       sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
       sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
       rc-update add frr
       rc-update add dnsmasq
       cat << EOF | tee /etc/sysctl.d/01_forward.conf
       net.ipv4.ip_forward=1
       net.ipv6.conf.all.forwarding=1
       EOF
       lxc stop router
       lxc ls
       
