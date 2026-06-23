#!/bin/bash
cat << EOF | sudo tee /etc/hosts
127.0.0.1 localhost
172.16.55.10 ac

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
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDgVIaWmOuUuR5bHtVCLEBVr/5aeyT8nx9D66zvG1wxm6oMW6MVHM94mFjnR6nb8aYv/WdtQLozngau/pswwa9NMY1nny8C2wYIRwdPpt4BCBTo98sNCkj14vEaanqckKr9SP9F3SGo4EvTNks1yEqeGfjVBn+N6blGGsBxHktVGzE4TOUjup7wPHJPmzIGu3UxnwA89+AQYTOLdvUdSINhN6dv7uSJl/WSLI1TgWEU+27cNYYDG+2U1IEH0yAToTwgGqF0veICJvb6F9aOETeW2/ruqvus8q6Sr41PxvSqlGVVh/RuzDJa//B+JE0uPQudfhSQdomwmCeV4A20dccJ
EOF

cat << EOF | tee ~/.ssh/id_rsa
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

sudo cp ~/.ssh/id_rsa /root/.ssh/id_rsa
sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys

sudo rm /etc/netplan/*
cat << EOF | sudo tee /etc/netplan/01_net.yaml
network:
  ethernets:
    eth0:
      addresses : ['172.16.55.10/24']
      nameservers:
         addresses: [172.16.55.254 ] 
         search: [ vmmlab.com ]
      routes: 
       - to: 0.0.0.0/0
         via: 172.16.55.254
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