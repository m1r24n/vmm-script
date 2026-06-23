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
ac IN A 172.16.55.10


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
websockify -D --web=/usr/share/novnc/ 6081 q-pod-23e.englab.juniper.net:5906
websockify -D --web=/usr/share/novnc/ 6082 q-pod-23n.englab.juniper.net:5903
websockify -D --web=/usr/share/novnc/ 6083 q-pod-23p.englab.juniper.net:5902
websockify -D --web=/usr/share/novnc/ 6084 q-pod-23v.englab.juniper.net:5904
websockify -D --web=/usr/share/novnc/ 6085 q-pod-23w.englab.juniper.net:5903
websockify -D --web=/usr/share/novnc/ 6086 q-pod-23w.englab.juniper.net:5904
exit 1
EOF

sudo chmod +x /usr/local/bin/start_vnc.sh

cat << EOF | sudo tee /etc/update-motd.d/99-update
#!/bin/bash
echo "----------------------------------------------"
echo "To access console of VM, use the following URL"
echo "----------------------------------------------"
echo "console apstra : http://10.52.140.49:6081/vnc.html"
echo "console apstraw2 : http://10.52.140.49:6082/vnc.html"
echo "console apstraw3 : http://10.52.140.49:6083/vnc.html"
echo "console ztp : http://10.52.140.49:6084/vnc.html"
echo "console flow : http://10.52.140.49:6085/vnc.html"
echo "console ac : http://10.52.140.49:6086/vnc.html"
EOF

sudo chmod +x  /etc/update-motd.d/99-update
cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgVIaWmOuUuR5bHtVCLEBVr/5aeyT8nx9D66zvG1wxm6oMW6MVHM94mFjnR6nb8aYv/WdtQLozngau/pswwa9NMY1nny8C2wYIRwdPpt4BCBTo98sNCkj14vEaanqckKr9SP9F3SGo4EvTNks1yEqeGfjVBn+N6blGGsBxHktVGzE4TOUjup7wPHJPmzIGu3UxnwA89+AQYTOLdvUdSINhN6dv7uSJl/WSLI1TgWEU+27cNYYDG+2U1IEH0yAToTwgGqF0veICJvb6F9aOETeW2/ruqvus8q6Sr41PxvSqlGVVh/RuzDJa//B+JE0uPQudfhSQdomwmCeV4A20dccJ
EOF

cat << EOF |  tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEA4FSGlpjrlLkeWx7VQixAVa/+Wnsk/J8fQ+us7xtcMZuqDFujFRzPeJhY50ep2/Gm
L/1nbUC6M54Grv6bMMGvTTGNZ58vAtsGCEcHT6beAQgU6PfLDQpI9eLxGmp6nJCq/Uj/Rd0hqOBL
0zZLNchKnhn41QZ/jem5RhrAcR5LVRsxOEzlI7qe8DxyT5syBrt1MZ8APPfgEGEzi3b1HUiDYTen
b+7kiZf1kiyNU4FhFPtu3DWGAxvtlNSBB9MgE6E8IBqhdL3iAib2+hfWjhE3ltv67qr7rPKukq+N
T8b0qpRlVYf0bswyWv/wfiRNLj0LnX4UkHaJsJgnleANtHXHCQAAA7j8EXun/BF7pwAAAAdzc2gt
cnNhAAABAQDgVIaWmOuUuR5bHtVCLEBVr/5aeyT8nx9D66zvG1wxm6oMW6MVHM94mFjnR6nb8aYv
/WdtQLozngau/pswwa9NMY1nny8C2wYIRwdPpt4BCBTo98sNCkj14vEaanqckKr9SP9F3SGo4EvT
Nks1yEqeGfjVBn+N6blGGsBxHktVGzE4TOUjup7wPHJPmzIGu3UxnwA89+AQYTOLdvUdSINhN6dv
7uSJl/WSLI1TgWEU+27cNYYDG+2U1IEH0yAToTwgGqF0veICJvb6F9aOETeW2/ruqvus8q6Sr41P
xvSqlGVVh/RuzDJa//B+JE0uPQudfhSQdomwmCeV4A20dccJAAAAAwEAAQAAAQAFioJIYWwDQHcp
R3JmJ/8+++yE/2Dx4PvQmDdisMAxmlTZqTX2u+oSLQrYIUyRqgRsT8lF2R5oTz1UG1D0brpQkQUQ
mSLcAmfhx+BckC8luHWCGM8iCgifPeJtoBGZ1lcfj8BSG/98eILYS3Fm5A+XcWXfMYHbJ2RmoLCe
HVeSw+qdNl+uC3X/YVnlZCJPZantU+e8qmOqg1WgWUAPmmXaoOKocwhOs5oMCS4TxN4eSXNUTPXu
WU2XO+/B6ay6wdei4FTSFr1epqQtjfM1xiCT8dMb09ox64xer4gVLnORUNf0i0Alz0UkEufvKA9f
exAWNaqzcS+no+XRQCEVPZQhAAAAgQDOf3a7HVDgA5g/cBYz04kGy5mQlSEtzbNjSyXd3ffFS7m0
dJJSjkaoTziKecLIKkjowqzAH/LeaBRBQWp7AN0qkg27twIIKFb87XLBTJspnSkmpT3pwXTi3NU0
wL5HhnnaXJWYsSJLPLXxwz9zFizxxwYH8iW5VGKevI93sf0SOAAAAIEA/m8AQmxSumDxwRmVmXGk
wGYayfobe7bNp6EYuq4yZTy7VVHl5fExHMachVjXtpOlKdL5Qj6+0b9T+BZcKcpmmIwTOgBrhZAN
I0xhN3PZz/mTF5hF6YjyKhTLmKhZhkIdt2ZgcPXlLqzjVfIFOGjJ1UZY+4aPXOqlHnMDPqRsAKEA
AACBAOG2FJJBkTosR2MHzMceFXm5NHwR6LHGs4dTprsva7S/3MniQOI5c5IrV2Xxl2lrEvmK5JPX
/TRrVoKF0d8fUQUUASBXpGknaOEOiSWHHDU2/rlQOGD6UA6V9PdeOMbJjQU1CmXvqteivpEdY7eL
3QMf/6pDJhSf6GGFZNMdqmVpAAAAAAEC
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
