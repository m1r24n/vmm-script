#!/bin/bash
cat << EOF | sudo tee /etc/hosts
127.0.0.1 localhost
172.16.11.6 nms1

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
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCx22aCBNHVov9suzB3Yv7yz9Bo+LaIHxw6ok5cTztjm4RkLZwcf9AE7yQduIK36ZmR9yMd1XXjON9zN/lQUa8wYxWPFdmzcpJEd67cLg+TUfsAa2MbXhOueFt4NpxCyE1OSLuQPVVxe93kvm71TbSZ38n2NP7DTb8SwAN4X82Q5ggX6k6mFeKmG4KUq7kClLiPQF/lXq0YpQCrSr1XO6M7tA+U9xui8fd6rU4vyvoo78hPKP7ESdNIYyJiJ8K+VRTofs6yyeMY8KveGFxSOTyThLGtd2NvmzbvmQ5PVq21ycAx3fjdeU3HwfLKOiOGXOnQFtB/aha4yG5t5xgGp3iB
EOF

cat << EOF | tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEAsdtmggTR1aL/bLswd2L+8s/QaPi2iB8cOqJOXE87Y5uEZC2cHH/QBO8kHbiCt+mZ
kfcjHdV14zjfczf5UFGvMGMVjxXZs3KSRHeu3C4Pk1H7AGtjG14TrnhbeDacQshNTki7kD1VcXvd
5L5u9U20md/J9jT+w02/EsADeF/NkOYIF+pOphXiphuClKu5ApS4j0Bf5V6tGKUAq0q9VzujO7QP
lPcbovH3eq1OL8r6KO/ITyj+xEnTSGMiYifCvlUU6H7OssnjGPCr3hhcUjk8k4SxrXdjb5s275kO
T1attcnAMd343XlNx8Hyyjojhlzp0BbQf2oWuMhubecYBqd4gQAAA7j1/g7a9f4O2gAAAAdzc2gt
cnNhAAABAQCx22aCBNHVov9suzB3Yv7yz9Bo+LaIHxw6ok5cTztjm4RkLZwcf9AE7yQduIK36ZmR
9yMd1XXjON9zN/lQUa8wYxWPFdmzcpJEd67cLg+TUfsAa2MbXhOueFt4NpxCyE1OSLuQPVVxe93k
vm71TbSZ38n2NP7DTb8SwAN4X82Q5ggX6k6mFeKmG4KUq7kClLiPQF/lXq0YpQCrSr1XO6M7tA+U
9xui8fd6rU4vyvoo78hPKP7ESdNIYyJiJ8K+VRTofs6yyeMY8KveGFxSOTyThLGtd2NvmzbvmQ5P
Vq21ycAx3fjdeU3HwfLKOiOGXOnQFtB/aha4yG5t5xgGp3iBAAAAAwEAAQAAAQBPqM3TxCbbgcLX
R0vg3QUFadCVg3f1pcF1/YYNUCtwZJI6cDcwiIp5+0X4zdA2YTk4KDGhRh8j4zApodNXhw5pJKfe
S1ITTmh2pAg8c6DkQd6jBHYCJvO3vA5z3DnGq4H8YxUm+GGRj4IF1slJs0EFfjctv/SvMt42nquv
OXGPyMYZhdGL6j9V5XCwvTIzGNpZJD3DTjstFJjOSfn3jv7C2809K4P3RW5iWe7qi3jOptWsIrOQ
qKFUhw/ovgj1m995CTEHF5ZJVMCbWxI3sQr3RYVVNts/4KwTd2NuAH6iA7/vj08+RFRysZhLAUTT
5gEdm/8TY+V2tTRAXvmGyAH1AAAAgA7p0qwZKIWQn0HUgGbTTdxttgYdeGAHJvUt0Wc4NZ0xgWcG
lfj//JfyHaJFcKvkap/0xR6Q9kWyVdfMvpEJVeL4FIAOWkuiSfSg7JuSlzIYzNdS6Okc1Wymq+s5
vV4dljzGBoCtI1xgzXvLuHKKYWwoMO4uim/yddv7TdWDzKFfAAAAgQD6QnwJYqFhf0FqTarxizk8
8QZItCb3QstU0IsyEfA/lqdqK0eSQjwkIbeuGYmlumtdhDX/f3CZwRn8YVodp6dCNDfl4/zSSE8p
34q5KqgoYBneSV5lrjDXCaFU6qmFbXrqp0cMyYc/VCQvhxrknggRGO9Z01t0PpJEj/0+RevIUwAA
AIEAte/FKVk5vv5/9mbazEKt8uRwHuN1GtyTlAUTQAJDDrd9hJpjZbw0CUzVfAu72Gc6sS8D/TUh
fZSS4mEASLkbuJWW1zkTMP0wNVLHZPJa4w/EwXz8proL7kHGKUbrZ8Ud7vzfejkwkvk17y2VfgXm
BfT0BMRUQlO+iDgMJOYXUVsAAAAAAQID
-----END OPENSSH PRIVATE KEY-----
EOF

sudo cp ~/.ssh/id_rsa /root/.ssh/id_rsa
sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys

sudo rm /etc/netplan/*
cat << EOF | sudo tee /etc/netplan/01_net.yaml
network:
  ethernets:
    eth0:
      addresses : ['172.16.11.6/24']
      nameservers:
         addresses: [172.16.11.254 ] 
         search: [ vmmlab.com ]
      routes: 
       - to: 0.0.0.0/0
         via: 172.16.11.254
         metric: 1
       
       
    eth1:
      addresses : ['172.16.13.5/24']
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