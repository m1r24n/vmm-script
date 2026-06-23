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
dhcprelay IN A 172.16.51.100
fw1 IN A 172.16.52.21
fw2 IN A 172.16.52.22
vxlangw IN A 172.16.52.2
pe1 IN A 172.16.52.3
dc1spine1 IN A 172.16.51.101
dc1spine2 IN A 172.16.51.102
dc1spine3 IN A 172.16.51.103
dc1spine4 IN A 172.16.51.104
dc1leaf1 IN A 172.16.51.111
dc1leaf2 IN A 172.16.51.112
dc1leaf3 IN A 172.16.51.113
dc1leaf4 IN A 172.16.51.114
dc1leaf5 IN A 172.16.51.115
dc1leaf6 IN A 172.16.51.116
dc1leaf7 IN A 172.16.51.117
dc1leaf8 IN A 172.16.51.118
lxd10 IN A 172.16.52.16


EOF


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      addresses : ['172.16.51.254/24']
       
    eth2:
      addresses : ['172.16.52.254/24']
       
    eth3:
      addresses : ['172.16.53.254/24', 'fc00:dead:beef:a063::FFFF/64']
      mtu: 9000
       
    eth4:
      addresses : ['172.16.54.254/24', 'fc00:dead:beef:a054::FFFF/64']
      mtu: 9000
       
      
EOF



cat << EOF | sudo tee /usr/local/bin/start_vnc.sh
#!/bin/bash
websockify -D --web=/usr/share/novnc/ 6081 q-pod-38r.englab.juniper.net:5901
websockify -D --web=/usr/share/novnc/ 6082 q-pod-37a.englab.juniper.net:5922
websockify -D --web=/usr/share/novnc/ 6083 q-pod-39t.englab.juniper.net:5901
websockify -D --web=/usr/share/novnc/ 6084 q-pod-39q.englab.juniper.net:5903
websockify -D --web=/usr/share/novnc/ 6085 q-pod-38s.englab.juniper.net:5905
websockify -D --web=/usr/share/novnc/ 6086 q-pod-38g.englab.juniper.net:5910
websockify -D --web=/usr/share/novnc/ 6087 q-pod-37e.englab.juniper.net:5901
websockify -D --web=/usr/share/novnc/ 6088 q-pod-39h.englab.juniper.net:5913
websockify -D --web=/usr/share/novnc/ 6089 q-pod-38m.englab.juniper.net:5907
websockify -D --web=/usr/share/novnc/ 6090 q-pod-38h.englab.juniper.net:5906
websockify -D --web=/usr/share/novnc/ 6091 q-pod-38t.englab.juniper.net:5903
websockify -D --web=/usr/share/novnc/ 6092 q-pod-37x.englab.juniper.net:5901
websockify -D --web=/usr/share/novnc/ 6093 q-pod-39d.englab.juniper.net:5906
websockify -D --web=/usr/share/novnc/ 6094 q-pod-37n.englab.juniper.net:5906
websockify -D --web=/usr/share/novnc/ 6095 q-pod-38a.englab.juniper.net:5902
websockify -D --web=/usr/share/novnc/ 6096 q-pod-37d.englab.juniper.net:5903
websockify -D --web=/usr/share/novnc/ 6097 q-pod-37r.englab.juniper.net:5915
exit 1
EOF

sudo chmod +x /usr/local/bin/start_vnc.sh

cat << EOF | sudo tee /etc/update-motd.d/99-update
#!/bin/bash
echo "----------------------------------------------"
echo "To access console of VM, use the following URL"
echo "----------------------------------------------"
echo "console dhcprelay : http://10.49.246.236:6081/vnc.html"
echo "console svr1 : http://10.49.246.236:6082/vnc.html"
echo "console svr2 : http://10.49.246.236:6083/vnc.html"
echo "console svr3 : http://10.49.246.236:6084/vnc.html"
echo "console svr4 : http://10.49.246.236:6085/vnc.html"
echo "console svr5 : http://10.49.246.236:6086/vnc.html"
echo "console svr6 : http://10.49.246.236:6087/vnc.html"
echo "console lxd1 : http://10.49.246.236:6088/vnc.html"
echo "console lxd2 : http://10.49.246.236:6089/vnc.html"
echo "console lxd3 : http://10.49.246.236:6090/vnc.html"
echo "console lxd4 : http://10.49.246.236:6091/vnc.html"
echo "console lxd5 : http://10.49.246.236:6092/vnc.html"
echo "console lxd6 : http://10.49.246.236:6093/vnc.html"
echo "console lxd7 : http://10.49.246.236:6094/vnc.html"
echo "console lxd8 : http://10.49.246.236:6095/vnc.html"
echo "console lxd9 : http://10.49.246.236:6096/vnc.html"
echo "console lxd10 : http://10.49.246.236:6097/vnc.html"
EOF

sudo chmod +x  /etc/update-motd.d/99-update
cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDC523szGqQMF4/jACq12+VveiQtoz94GJTI3Bit2N0ya6CN+CmJtOW+V0QID1N+Hfh2WgUhKzqRT2YJBboxecYbpdmFfvIrqUpm8mMUhUGdARqKM21dp5g2xlr/3qzadqh29r6z4M8yrr/HPQs9FPKGp9pKpeG26+s3d6RQrmMCWgiVdSiT3eY4vvX5rt9GAdYOxKrw+x7r6R5ubFX/Qk+8PPzqe/9jWH2kUzIVg9iLvtX+qiDM0Fx95QvaZ/MtZd3XDXgxKGQCLCWHHcWXenyaoVDjO/alMNN4JNa+LiQTaWT4H+lDWdOU5/PeX22iejRmfX0SyFL7PLdzKhdxvdJ
EOF

cat << EOF |  tee ~/.ssh/id_rsa
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
