# this document provides guideline on how to prepeare for lxc
1. Initialize lxd

       sudo lxd init

2. copy lxc imagre from repository

       lxc image copy images:alpine/edge local: --alias alpine

3. create container **client**

       lxc launch alpine client

4. access container **client**

       lxc exec client sh

5. update package and install the necessary software (openssh, iperf and links)

       apk update && apk upgrade
       apk add openssh iperf links

6. change root password and reconfigure sshd server

       passwd
       cat << EOF | tee -a /etc/ssh/sshd_config
       PermitRootLogin yes
       EOF
       rc-update add sshd
       service sshd start
       ssh localhost 

7. Stop container **client** and clone it to container **router**

       lxc  stop client
       lxc ls
       lxc copy client router

8. start and access container **router** and add package frr and dnsmasq

       lxc start router
       lxc exec router sh
       apk add frr dnsmasq
       rc-update add frr
       rc-update add dnsmasq
       cat << EOF | tee /etc/sysctl.d/10_forward.conf
       net.ipv6.conf.all.forwarding=1
       net.ipv4.ip_forward=1
       EOF
       sed -i -e "s/bgpd=no/bgpd=yes/" /etc/frr/daemons
       sed -i -e "s/bfdd=no/bfdd=yes/" /etc/frr/daemons
       exit
       lxc stop router

9. Now you have to lxc image ready for the lab exercise

       lxc ls
