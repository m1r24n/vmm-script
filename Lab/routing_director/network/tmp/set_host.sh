#!/bin/bash
cat << EOF | sudo tee /etc/hosts
127.0.0.1 localhost
172.16.10.26 nms1

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

cat << EOF | sudo tee /etc/hostname
nms1
EOF

sudo hostname nms1

cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDf44+9FMA16Q2h3d4mvOH21p8Y1GwzIaf6VMGt91oLvX/gQ64jgGcZ7yheHXBwdrqIlm+0BN4edS5X4R8+FkEyncwKD5fm9vS/f6ANx7Lryz05x1q2Vy2CMzh1sgixGGoYv+Ev84tWZ9iZPyk+qsAETbPXYwNn7N3DfA292czxFNrVOZsC4SbqpV6B0nGiOdJgH0YKS8YN0o+VQTW+omVKjkG0bp1LZnMu4jJX/+Jcqqhvx7RPX/fzlDekfWN/cJHyMs/XQ/vIyC051nxULOCb35eUpgUQPghKstV28RX+4pQIx8WlKwpn4w9wzh0yv/vc4jlR9xyHAUpk4Jk75s8H
EOF

cat << EOF | tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEA3+OPvRTANekNod3eJrzh9tafGNRsMyGn+lTBrfdaC71/4EOuI4BnGe8oXh1wcHa6
iJZvtATeHnUuV+EfPhZBMp3MCg+X5vb0v3+gDcey68s9OcdatlctgjM4dbIIsRhqGL/hL/OLVmfY
mT8pPqrABE2z12MDZ+zdw3wNvdnM8RTa1TmbAuEm6qVegdJxojnSYB9GCkvGDdKPlUE1vqJlSo5B
tG6dS2ZzLuIyV//iXKqob8e0T1/385Q3pH1jf3CR8jLP10P7yMgtOdZ8VCzgm9+XlKYFED4ISrLV
dvEV/uKUCMfFpSsKZ+MPcM4dMr/73OI5UfcchwFKZOCZO+bPBwAAA7iaG+Lrmhvi6wAAAAdzc2gt
cnNhAAABAQDf44+9FMA16Q2h3d4mvOH21p8Y1GwzIaf6VMGt91oLvX/gQ64jgGcZ7yheHXBwdrqI
lm+0BN4edS5X4R8+FkEyncwKD5fm9vS/f6ANx7Lryz05x1q2Vy2CMzh1sgixGGoYv+Ev84tWZ9iZ
Pyk+qsAETbPXYwNn7N3DfA292czxFNrVOZsC4SbqpV6B0nGiOdJgH0YKS8YN0o+VQTW+omVKjkG0
bp1LZnMu4jJX/+Jcqqhvx7RPX/fzlDekfWN/cJHyMs/XQ/vIyC051nxULOCb35eUpgUQPghKstV2
8RX+4pQIx8WlKwpn4w9wzh0yv/vc4jlR9xyHAUpk4Jk75s8HAAAAAwEAAQAAAQAJRmkfASwRT61T
5lgcrLiDvFJs+efdmmhWE4rOhS/Cyr/wb31YVSpwRZsbgwa0cga6P9ky0PzOsDYSR+4+aTecPDNG
u2ykkdiD0mq0B3DfGdVYfmzAnw3wleSh45U+mO9URSa0ENfV5Ylwl9BCm1pHE1z+8Egk1wg83/fF
xK8b0Zh82G30A5R+A92qU/jhq3OKO88jxE1ptdyTJ+BEHk1S/MtAePsU/TqVjhoG0BhL/lq4fosq
GC5KOkcN/9VsTFAPnlUW5CzMuouGK9tXoAV5vBI2HOqx/t4it6IqohFGHAhRdX7SE6YOpLKn+jXM
87xGbN+yG2wHlCRLIGIH/1IZAAAAgQDFreaAqn262F8fSJPev+GMlfgmYKgQEY13AB1Qd/3Q+U9c
wQEQ/jr3k6fFKP3H/TbQDNH+T8l7tEqV0bchqJr4TMutqaJgbsIi+cZ6IhUMsSFXVeecYsNBoIw9
fD3duoQ7TeTLSVKryvy8U2TBbnJCflqB5OvzGT1Olalp6wmsIQAAAIEA/Ye8x+xEEcIkJnk8XCGs
W6gM/MZBpQKF4bKsODyeY+al3vtpao9MpSwblOlXb/FU+aSOhESgDidDFIyCeNxrXApVaddR9RhE
iMCocXk5Y658EM2E2Ch8ajWis1IEVZ45wUuQ5RiFE7z7snxfsyhO4pXW6lU3exXoH/0hlDB+4GsA
AACBAOIR50xOAaS1DxAJL6oLUUlM7IjbniYieB7YErwSCedu1Zli6SQ3f5W9UCFym1SFTC+0MQQ7
Fp/uBQSEbN/gDTECUtF4bKIvNXOQJqOnz6XfYdWWdp8BcdXAyeXF24FHvN3p1OHo6jezab1BqxBy
9b6mE0/WdI/nUrH4a0ZCD8LVAAAAAAEC
-----END OPENSSH PRIVATE KEY-----
EOF

sudo cp ~/.ssh/id_rsa /root/.ssh/id_rsa
sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys

sudo rm /etc/netplan/*
cat << EOF | sudo tee /etc/netplan/01_net.yaml
network:
  ethernets:
    eth0:
      addresses : ['172.16.10.26/24']
      nameservers:
         addresses: [172.16.10.254 ] 
         search: [ vmmlab.com ]
      routes: 
       - to: 0.0.0.0/0
         via: 172.16.10.254
         metric: 1
       
       
    eth1:
      dhcp4: false
      mtu: 9000
       
      
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