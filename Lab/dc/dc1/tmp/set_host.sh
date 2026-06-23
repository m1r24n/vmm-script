#!/bin/bash
cat << EOF | sudo tee /etc/hosts
127.0.0.1 localhost
172.16.51.100 dhcprelay

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

cat << EOF | sudo tee /etc/hostname
dhcprelay
EOF

sudo hostname dhcprelay

cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC523szGqQMF4/jACq12+VveiQtoz94GJTI3Bit2N0ya6CN+CmJtOW+V0QID1N+Hfh2WgUhKzqRT2YJBboxecYbpdmFfvIrqUpm8mMUhUGdARqKM21dp5g2xlr/3qzadqh29r6z4M8yrr/HPQs9FPKGp9pKpeG26+s3d6RQrmMCWgiVdSiT3eY4vvX5rt9GAdYOxKrw+x7r6R5ubFX/Qk+8PPzqe/9jWH2kUzIVg9iLvtX+qiDM0Fx95QvaZ/MtZd3XDXgxKGQCLCWHHcWXenyaoVDjO/alMNN4JNa+LiQTaWT4H+lDWdOU5/PeX22iejRmfX0SyFL7PLdzKhdxvdJ
EOF

cat << EOF | tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEAwudt7MxqkDBeP4wAqtdvlb3okLaM/eBiUyNwYrdjdMmugjfgpibTlvldECA9Tfh3
4dloFISs6kU9mCQW6MXnGG6XZhX7yK6lKZvJjFIVBnQEaijNtXaeYNsZa/96s2naodva+s+DPMq6
/xz0LPRTyhqfaSqXhtuvrN3ekUK5jAloIlXUok93mOL71+a7fRgHWDsSq8Pse6+kebmxV/0JPvDz
86nv/Y1h9pFMyFYPYi77V/qogzNBcfeUL2mfzLWXd1w14MShkAiwlhx3Fl3p8mqFQ4zv2pTDTeCT
Wvi4kE2lk+B/pQ1nTlOfz3l9tono0Zn19EshS+zy3cyoXcb3SQAAA7iClmptgpZqbQAAAAdzc2gt
cnNhAAABAQDC523szGqQMF4/jACq12+VveiQtoz94GJTI3Bit2N0ya6CN+CmJtOW+V0QID1N+Hfh
2WgUhKzqRT2YJBboxecYbpdmFfvIrqUpm8mMUhUGdARqKM21dp5g2xlr/3qzadqh29r6z4M8yrr/
HPQs9FPKGp9pKpeG26+s3d6RQrmMCWgiVdSiT3eY4vvX5rt9GAdYOxKrw+x7r6R5ubFX/Qk+8PPz
qe/9jWH2kUzIVg9iLvtX+qiDM0Fx95QvaZ/MtZd3XDXgxKGQCLCWHHcWXenyaoVDjO/alMNN4JNa
+LiQTaWT4H+lDWdOU5/PeX22iejRmfX0SyFL7PLdzKhdxvdJAAAAAwEAAQAAAQBWKtbwb9dU8+1X
DuBkp2ZPv2wIPozK2N7ffrV7DzTLNzcNnwKUsmmtP4WjUX2I8SafFOzs1VNVJ1N55cqzEnt+07Xf
jiyIpp2ibZuHi+p7teMVxABeD5kpnPP6STLICy57jKWdaQzOXZqamwRgs4wvt+FuL0RafNmIBXcW
pXc+r0w36c1FhfYwN6l0pJNqCm7MqYuiUcDGwhx1b2ZpY1kKIZorWUTP85aTandPsgjrxatHNqsN
DtyBRzMZ6JNtLQ2dHwnnJRlkOzY094j31WBdLfVO28hk9igOenpAJ9zQIkUyYaI1bnzgL8X7fd41
6NYoqWDinD5qUXssp7/EyQeZAAAAgQCVK9zasopdocNfmxKkLyNGGSpKyCj7KuWTZBJnMqZp4V/B
i0AuYk2B8BSB3iZIFFun72pQyYQijQKCkTxP5kVS96wp/frp2g0KgjPCuTWVEUJUQMyy/moLSWx5
OPfKP5mkywWOldR5GulPHttr7Uu77KARiZYw6Za+ZZMZy5k5mgAAAIEA6rkX5DnEgSmNovxkmXWD
iZ6U4hgCX+1rgtVclblhrzB/vCePG+IPa+re7ZFw9pY5vlqQpKNvGJv82GOFqJq6/oqXx/dph/CF
G+nXkl4HbQLmG3uCdlPz3POUFBkb45gwjwosT0Id66AHl6X5Beklt3sW48AynXkmAsEow4BGO48A
AACBANSSTyhp7Y1BY9ueylqWzhLS08vIa8yybk0m76MmN2IQ5JJaU3r7T0CAomQSka8pPPAc+ZuC
8PEVI2Qn9ZbodpaAnWuc2WPdbYqHNxxRk+2r+cwmE5BwSZiTtQzQbm65h+7TS9qnq2liqMkZyyp+
W3r1ttnnW7VwR59swJ+SjZOnAAAAAAEC
-----END OPENSSH PRIVATE KEY-----
EOF

sudo cp ~/.ssh/id_rsa /root/.ssh/id_rsa
sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys

sudo rm /etc/netplan/*
cat << EOF | sudo tee /etc/netplan/01_net.yaml
network:
  ethernets:
    eth0:
      addresses : ['172.16.51.100/24']
      nameservers:
         addresses: [172.16.51.254 ] 
         search: [ vmmlab.com ]
      routes: 
       - to: 0.0.0.0/0
         via: 172.16.51.254
         metric: 1
       
       
      
EOF


sleep 2

uuidgen  | sed -e 's/-//g' |  sudo tee /etc/machine-id

sleep 2

cat << EOF | tee ~/.ssh/config
Host *
   StrictHostKeyChecking no
EOF
chmod og-rwx ~/.ssh/*

sleep 2 

sudo systemctl stop sshd
sudo rm /etc/ssh/ssh_host*
sudo ssh-keygen -q -f /etc/ssh/ssh_host_key -N '' -t rsa1
sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521
sudo systemctl restart sshd

sudo netplan apply