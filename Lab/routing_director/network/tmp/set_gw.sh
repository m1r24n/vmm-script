#!/bin/bash

cat << EOF | sudo tee /etc/coredns/Corefile
.:53 {
    forward . 10.49.32.95 10.49.32.97 
    
    log
    errors
}
vmmlab.com:53 {
    file /etc/coredns/vmmlab.com.db
    log
    errors
}
EOF



cat << EOF | sudo tee /etc/coredns/vmmlab.com.db
\$ORIGIN vmmlab.com.
@    IN       SOA    vmmlab.com. mir.vmmlab.com 2502011720 7200 3600 1209600 3600
pe1 IN A 172.16.10.1
pe2 IN A 172.16.10.2
pe3 IN A 172.16.10.3
pe4 IN A 172.16.10.4
pe5 IN A 172.16.10.5
p1 IN A 172.16.10.11
p2 IN A 172.16.10.12
p3 IN A 172.16.10.13
p4 IN A 172.16.10.14
p5 IN A 172.16.10.15
br1 IN A 172.16.10.21
br2 IN A 172.16.10.22
br3 IN A 172.16.10.23
client IN A 172.16.10.24
crpd IN A 172.16.10.25
nms1 IN A 172.16.10.26


EOF


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      addresses : ['172.16.10.254/24']
       
    eth2:
      dhcp4: false
       
    eth3:
      addresses : ['172.16.13.254/24']
      routes: 
       - to: 10.100.255.0/24
         via: 172.16.13.15
         metric: 1
       - to: 10.100.0.0/24
         via: 172.16.13.15
         metric: 1
       
       
      
EOF



cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDf44+9FMA16Q2h3d4mvOH21p8Y1GwzIaf6VMGt91oLvX/gQ64jgGcZ7yheHXBwdrqIlm+0BN4edS5X4R8+FkEyncwKD5fm9vS/f6ANx7Lryz05x1q2Vy2CMzh1sgixGGoYv+Ev84tWZ9iZPyk+qsAETbPXYwNn7N3DfA292czxFNrVOZsC4SbqpV6B0nGiOdJgH0YKS8YN0o+VQTW+omVKjkG0bp1LZnMu4jJX/+Jcqqhvx7RPX/fzlDekfWN/cJHyMs/XQ/vIyC051nxULOCb35eUpgUQPghKstV28RX+4pQIx8WlKwpn4w9wzh0yv/vc4jlR9xyHAUpk4Jk75s8H
EOF

cat << EOF |  tee ~/.ssh/id_rsa
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

chmod og-rwx ~/.ssh/*

sudo netplan apply

sudo mv ~/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf
sudo systemctl enable startup.service
sudo systemctl restart startup.service
sudo systemctl restart kea-dhcp4-server.service
sudo systemctl restart tftpd-hpa.service
sudo systemctl restart coredns.service
sudo mv ~/tftp/*.conf /srv/tftp/

sudo rm /etc/resolv.conf
cat << EOF | sudo tee /etc/resolv.conf
nameserver 127.0.0.1
search vmmlab.com
EOF

# sudo reboot
