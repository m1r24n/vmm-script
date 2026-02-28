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
nw IN A 172.16.11.4
client1 IN A 172.16.11.5
nms1 IN A 172.16.11.6


EOF


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      addresses : ['172.16.11.254/24']
       
    eth2:
      addresses : ['172.16.12.254/24']
       
      
EOF



cat << EOF | sudo tee /usr/local/bin/start_vnc.sh
#!/bin/bash
websockify -D --web=/usr/share/novnc/ 6081 q-pod-61u.englab.juniper.net:5904
websockify -D --web=/usr/share/novnc/ 6082 q-pod-61a.englab.juniper.net:5904
websockify -D --web=/usr/share/novnc/ 6083 q-pod-62p.englab.juniper.net:5908
websockify -D --web=/usr/share/novnc/ 6084 q-pod-61f.englab.juniper.net:5907
exit 1
EOF

sudo chmod +x /usr/local/bin/start_vnc.sh

cat << EOF | sudo tee /etc/update-motd.d/99-update
#!/bin/bash
echo "----------------------------------------------"
echo "To access console of VM, use the following URL"
echo "----------------------------------------------"
echo "console fw1 : http://10.52.98.140:6081/vnc.html"
echo "console fw2 : http://10.52.98.140:6082/vnc.html"
echo "console fw3 : http://10.52.98.140:6083/vnc.html"
echo "console nw : http://10.52.98.140:6084/vnc.html"
EOF

sudo chmod +x  /etc/update-motd.d/99-update
cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCx22aCBNHVov9suzB3Yv7yz9Bo+LaIHxw6ok5cTztjm4RkLZwcf9AE7yQduIK36ZmR9yMd1XXjON9zN/lQUa8wYxWPFdmzcpJEd67cLg+TUfsAa2MbXhOueFt4NpxCyE1OSLuQPVVxe93kvm71TbSZ38n2NP7DTb8SwAN4X82Q5ggX6k6mFeKmG4KUq7kClLiPQF/lXq0YpQCrSr1XO6M7tA+U9xui8fd6rU4vyvoo78hPKP7ESdNIYyJiJ8K+VRTofs6yyeMY8KveGFxSOTyThLGtd2NvmzbvmQ5PVq21ycAx3fjdeU3HwfLKOiOGXOnQFtB/aha4yG5t5xgGp3iB
EOF

cat << EOF |  tee ~/.ssh/id_rsa
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
