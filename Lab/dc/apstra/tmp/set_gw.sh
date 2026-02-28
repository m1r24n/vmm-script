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
apstra IN A 172.16.55.1
apstraw2 IN A 172.16.55.2
apstraw3 IN A 172.16.55.3
ztp IN A 172.16.55.4
flow IN A 172.16.55.5


EOF


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      addresses : ['172.16.55.254/24', 'fc00:dead:beef:ff55::FFFF/64']
      mtu: 9000
       
      
EOF



cat << EOF | sudo tee /usr/local/bin/start_vnc.sh
#!/bin/bash
websockify -D --web=/usr/share/novnc/ 6081 q-pod-94d.englab.juniper.net:5901
websockify -D --web=/usr/share/novnc/ 6082 q-pod-94b.englab.juniper.net:5904
websockify -D --web=/usr/share/novnc/ 6083 q-pod-94a.englab.juniper.net:5903
websockify -D --web=/usr/share/novnc/ 6084 q-pod-95n.englab.juniper.net:5901
websockify -D --web=/usr/share/novnc/ 6085 q-pod-94j.englab.juniper.net:5901
exit 1
EOF

sudo chmod +x /usr/local/bin/start_vnc.sh

cat << EOF | sudo tee /etc/update-motd.d/99-update
#!/bin/bash
echo "----------------------------------------------"
echo "To access console of VM, use the following URL"
echo "----------------------------------------------"
echo "console apstra : http://10.39.43.97:6081/vnc.html"
echo "console apstraw2 : http://10.39.43.97:6082/vnc.html"
echo "console apstraw3 : http://10.39.43.97:6083/vnc.html"
echo "console ztp : http://10.39.43.97:6084/vnc.html"
echo "console flow : http://10.39.43.97:6085/vnc.html"
EOF

sudo chmod +x  /etc/update-motd.d/99-update
cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0KSSDDCAzs1OwQis4Da0237nrSWrYgI7ke2lu6l5nMOtMROU4SKlz/qN+Sz7hiixOqfol6qJT9EdwlNgJVPkbZ/fCSI4imrNi1qEMMvnXMgMOQzYVN/ygKWtiotK2dN7LwL+erqoyFnS1YU5iC99Z73JOe+EHw/SvZoC9fGcI7i84DE4O2C11hnFzofKuUkievWthCcb8NRkcYnXEbx+//m8N3u3zkKwGOU85ZGLVLfxcxhltqmDP8WOeat3Ok/3+FvSHi4MLz2V5I5dbgE6JNvCMLMtx99acp5nGGV0ec7g7SbgLUADt4yvIrOPIfSi3YnLdB7WIG+8WH+Wavo8L
EOF

cat << EOF |  tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEAtCkkgwwgM7NTsEIrOA2tNt+560lq2ICO5HtpbupeZzDrTETlOEipc/6jfks+4Yos
Tqn6JeqiU/RHcJTYCVT5G2f3wkiOIpqzYtahDDL51zIDDkM2FTf8oClrYqLStnTey8C/nq6qMhZ0
tWFOYgvfWe9yTnvhB8P0r2aAvXxnCO4vOAxODtgtdYZxc6HyrlJInr1rYQnG/DUZHGJ1xG8fv/5v
Dd7t85CsBjlPOWRi1S38XMYZbapgz/FjnmrdzpP9/hb0h4uDC89leSOXW4BOiTbwjCzLcffWnKeZ
xhldHnO4O0m4C1AA7eMryKzjyH0ot2Jy3Qe1iBvvFh/lmr6PCwAAA7ijCbrhowm64QAAAAdzc2gt
cnNhAAABAQC0KSSDDCAzs1OwQis4Da0237nrSWrYgI7ke2lu6l5nMOtMROU4SKlz/qN+Sz7hiixO
qfol6qJT9EdwlNgJVPkbZ/fCSI4imrNi1qEMMvnXMgMOQzYVN/ygKWtiotK2dN7LwL+erqoyFnS1
YU5iC99Z73JOe+EHw/SvZoC9fGcI7i84DE4O2C11hnFzofKuUkievWthCcb8NRkcYnXEbx+//m8N
3u3zkKwGOU85ZGLVLfxcxhltqmDP8WOeat3Ok/3+FvSHi4MLz2V5I5dbgE6JNvCMLMtx99acp5nG
GV0ec7g7SbgLUADt4yvIrOPIfSi3YnLdB7WIG+8WH+Wavo8LAAAAAwEAAQAAAQALU+jsgODHddEs
LHgcmqa9ym+dgfmNw/hefzBmanMY6IQ3wL84fKa28rEjk3MDnS7JaKBs+n9ONkMfRFfL4mou7tvi
FrJlLgMoeRezaI/syxBSuPQkfZqZrj3TyMQYXjaiBHkOVUVbR+EuHgB4Y4gdvToCAeg1lxZPLwVA
pM4ZSz5IOSVmzAaZn1L2Agt43rihBFhXqNlYHwwp6S+JBdDZPNM4vagL8lonPHJMt7/p/TrCGCFt
3gcNGMEZ51wPULpW/HuEPXjtpCpJapPD8fGqcf7tJyWG0PgXKt+ajg8oTwhkruGxLbr1MooALRLG
9eOwbLzm86ypvjPvgeteW6D5AAAAgQCwx2KaEL0+TIZl9RJcc2GSKVpY89r1T+rhkPZ1Cf4fW5M5
n41V7l6+0vT6SC9QeaR5bRBNYBWkzy93mFDVKfAeeoafZPfBzlIQ2kfZSQMZz7Qw2EMjJKpIT7U/
A+E2pkQUBhFHrYSpLnch+zDIgfdTaH71gAxUlHrU2YFD9ib4sQAAAIEA7pRNmOC5ZUuOgmPeq7Q4
8FpXcJmpLgd3QaSbOQ1Iu+H/d1GBW1RNpJlSHzXc5+BhHRHkDFDiEVOTBSaK/+Lff7WiDdxBwW7x
HfVwJFOY72jP7YjO+OpREe1paQramOSoAVxTGT9hNzI/yYr20b+1kT2SA79ZxEzMTcqlT9LqDKkA
AACBAMFQ1j7Y6Eq61k5wzvhxf4dWUrknzxGOPc71lD3myNZZNfneavSQBC7YPLHW4gN8nB6Yxshu
1yBRmFBAGDRVG5MRvc+rO55X5ah5g8Aoe1QkuowbvwTPbNYCUCCziahqCv0omiRbL66R7WzFNucY
7AGqdOjG1GQJzJvm1qs1gzqTAAAAAAEC
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
