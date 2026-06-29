#!/bin/bash
cat << EOF | sudo tee /etc/hosts
127.0.0.1 localhost
172.16.11.100 ac

# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

cat << EOF | sudo tee /etc/hostname
ac
EOF

sudo hostname ac

cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYboq4tx8OovmnbFlfYvjvTNbOfBLY7Tbv64jk/PfkkU5ImCGQX/v4t8TozSvz+luHJpxUu0d2NNEV93ZEG5dtzek+4VvLvMP3/xzm84leadhjCxLmQLo5AiFdVrQiPz4Rk0GdsceIiUkfb0vwTXKKkKsNWjfGYUld3FvjkWnRs2ncLVaZdkDbBSJRC0GWasur9hZSjSba/0NNzMeIpi3H6zvgZrmpy3fsp/a4wZpIsAWRfQTfZRaunU+idA7WGGRYKhhfWiyqt5xfasAhoGHFsBdAjJkffQBKPU4eoi1NGtttRFtn9Pm7EEFFjVSeaxD1vpDUM9DS74iM3JPEU+ox
EOF

cat << EOF | tee ~/.ssh/id_rsa
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

sudo cp ~/.ssh/id_rsa /root/.ssh/id_rsa
sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys

sudo rm /etc/netplan/*
cat << EOF | sudo tee /etc/netplan/01_net.yaml
network:
  ethernets:
    eth0:
      addresses : ['172.16.11.100/24', 'fc00:dead:beef:a011::50/64']
      nameservers:
         addresses: [172.16.11.254 ] 
         search: [ vmmlab.com ]
      routes: 
       - to: 0.0.0.0/0
         via: 172.16.11.254
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