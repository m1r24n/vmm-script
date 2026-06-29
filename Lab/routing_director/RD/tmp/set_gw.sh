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
ac IN A 172.16.11.100
node1 IN A 172.16.11.11
node2 IN A 172.16.11.12
node3 IN A 172.16.11.13
node4 IN A 172.16.11.14


EOF


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      addresses : ['172.16.11.254/24', 'fc00:dead:beef:a011::1/64']
       
      
EOF



cat << EOF | sudo tee /usr/local/bin/start_vnc.sh
#!/bin/bash
websockify -D --web=/usr/share/novnc/ 6081 q-pod-104c.englab.juniper.net:5917
websockify -D --web=/usr/share/novnc/ 6082 q-pod-103l.englab.juniper.net:5920
websockify -D --web=/usr/share/novnc/ 6083 q-pod-103k.englab.juniper.net:5910
websockify -D --web=/usr/share/novnc/ 6084 q-pod-103i.englab.juniper.net:5908
websockify -D --web=/usr/share/novnc/ 6085 q-pod-103d.englab.juniper.net:5909
exit 1
EOF

sudo chmod +x /usr/local/bin/start_vnc.sh

cat << EOF | sudo tee /etc/update-motd.d/99-update
#!/bin/bash
echo "----------------------------------------------"
echo "To access console of VM, use the following URL"
echo "----------------------------------------------"
echo "console ac : http://10.38.203.197:6081/vnc.html"
echo "console node1 : http://10.38.203.197:6082/vnc.html"
echo "console node2 : http://10.38.203.197:6083/vnc.html"
echo "console node3 : http://10.38.203.197:6084/vnc.html"
echo "console node4 : http://10.38.203.197:6085/vnc.html"
EOF

sudo chmod +x  /etc/update-motd.d/99-update
cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYboq4tx8OovmnbFlfYvjvTNbOfBLY7Tbv64jk/PfkkU5ImCGQX/v4t8TozSvz+luHJpxUu0d2NNEV93ZEG5dtzek+4VvLvMP3/xzm84leadhjCxLmQLo5AiFdVrQiPz4Rk0GdsceIiUkfb0vwTXKKkKsNWjfGYUld3FvjkWnRs2ncLVaZdkDbBSJRC0GWasur9hZSjSba/0NNzMeIpi3H6zvgZrmpy3fsp/a4wZpIsAWRfQTfZRaunU+idA7WGGRYKhhfWiyqt5xfasAhoGHFsBdAjJkffQBKPU4eoi1NGtttRFtn9Pm7EEFFjVSeaxD1vpDUM9DS74iM3JPEU+ox
EOF

cat << EOF |  tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEA2G6KuLcfDqL5p2xZX2L470zWznwS2O027+uI5Pz35JFOSJghkF/7+LfE6M0r8/pb
hyacVLtHdjTRFfd2RBuXbc3pPuFby7zD9/8c5vOJXmnYYwsS5kC6OQIhXVa0Ij8+EZNBnbHHiIlJ
H29L8E1yipCrDVo3xmFJXdxb45Fp0bNp3C1WmXZA2wUiUQtBlmrLq/YWUo0m2v9DTczHiKYtx+s7
4Ga5qct37Kf2uMGaSLAFkX0E32UWrp1PonQO1hhkWCoYX1osqrecX2rAIaBhxbAXQIyZH30ASj1O
HqItTRrbbURbZ/T5uxBBRY1UnmsQ9b6Q1DPQ0u+IjNyTxFPqMQAAA7iKOiB4ijogeAAAAAdzc2gt
cnNhAAABAQDYboq4tx8OovmnbFlfYvjvTNbOfBLY7Tbv64jk/PfkkU5ImCGQX/v4t8TozSvz+luH
JpxUu0d2NNEV93ZEG5dtzek+4VvLvMP3/xzm84leadhjCxLmQLo5AiFdVrQiPz4Rk0GdsceIiUkf
b0vwTXKKkKsNWjfGYUld3FvjkWnRs2ncLVaZdkDbBSJRC0GWasur9hZSjSba/0NNzMeIpi3H6zvg
Zrmpy3fsp/a4wZpIsAWRfQTfZRaunU+idA7WGGRYKhhfWiyqt5xfasAhoGHFsBdAjJkffQBKPU4e
oi1NGtttRFtn9Pm7EEFFjVSeaxD1vpDUM9DS74iM3JPEU+oxAAAAAwEAAQAAAQAe87wiC4pFARi8
EVo8sn5QVshXklXtsQsMx731pZncFc3AwwT1zUxPNxTRiFoTU8gYLXTpBzmCla4bOp8uwVVoLiz/
waHroqzSACmFe+m212NLUs+an0IimgPkgdxUE4BQaiNVppGXHK8Y8EVHcgQB/guAZtkYJVylMDjx
9B9SjlcSHE+keoCOk7M2kLl+PqeIRkg/dNig5Eq8JViedxvIbPJa9n2qHzIn+hcwQWoziDRP3EwR
i3IsU64rcz0ewKnapW5d1N0b1yVXibIqSuO57gG1WHxkuYd6VWPWNeLIPseI6Tlm/xElyd9ZFXjQ
6yNgWuMZFICgenvl29HM19orAAAAgAgsvGJQC4g9A0tAY4ByRqp+ir9N0OWWG3inWppRbz1E1PNG
BLjDrG46lluXfWieFVx6hIHgqqh+TAcjo+WQkjDLjg6DUdOYkJuGuN+CyKbbypRdQiXFg1G9JYY6
0HJ+Q7lWbnc3t+LKZA4JfoePKcIBAqac2Cpo73gjfW/g2X0ZAAAAgQD5emBdirD1wMpfwZwv0Xgt
Ir4BnsDu7he5nGlzAcO9BdPJgg53IFFy7j0be2KZzaDkMlhqq9BkSHRhFS3M3fXbwNkZnIP6TNp0
4xX/pBe68ZAkSxVwtCm6rM6g+HGBPtYkjoFW8eV8SZxZ1uIGILNAYBWeyNQnEJIQ5MiwObinawAA
AIEA3hcBMLOzt0N3cZSxiUvHbajeCjGP7ysPPDf2LSizJzpjvZf3vhotFQk6HDJOXm2xBj9DvgAw
ct9+EcwEX+DXjckykSubUrplhx7VmZT7ODLJ4QgBnpLZxiF/tzKuIBFy5QMKkkhn9Lol9b76IyyV
S6lVG0oVcgoPqsBokkcqB9MAAAAAAQID
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
