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
sw1 IN A 172.16.11.1
sw2 IN A 172.16.11.2
sw3 IN A 172.16.11.3
client IN A 172.16.11.10


EOF


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      addresses : ['172.16.11.254/24']
       
      
EOF



cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpZwm30gLIWtObS5lGoK9oai78i9XEZhdRTmcejTnw1aVgdzQTWNwEtb9t+AD9Yg1t1ULEb5bFDHigr0yY/2Qbv/KJhKo3n5emX/i1mMshmhq0h+N+rxACkXD2LsJN6+k5BoJSl75zaHu8aiUdQzEgA/GNr/XH0tedqjazi0aRb+m9W8VEXEpP8qFDIWzLOTVLOXZEPmZHMBqr0D+XCXDZumGBeGtCW+DxrFzinz37Zsw8InHUreCEHnX3jTjjKvDSU70oP4Ol71uWW5hPFn1RLDv6VFmiMFBDjGBn7oXnqZlMlMdwlSgUAFzxmdR3XWC3ZfX/q2NUIl7l9m/STwFP
EOF

cat << EOF |  tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEAqWcJt9ICyFrTm0uZRqCvaGou/IvVxGYXUU5nHo058NWlYHc0E1jcBLW/bfgA/WIN
bdVCxG+WxQx4oK9MmP9kG7/yiYSqN5+Xpl/4tZjLIZoatIfjfq8QApFw9i7CTevpOQaCUpe+c2h7
vGolHUMxIAPxja/1x9LXnao2s4tGkW/pvVvFRFxKT/KhQyFsyzk1Szl2RD5mRzAaq9A/lwlw2bph
gXhrQlvg8axc4p89+2bMPCJx1K3ghB5194044yrw0lO9KD+Dpe9blluYTxZ9USw7+lRZojBQQ4xg
Z+6F56mZTJTHcJUoFABc8ZnUd11gt2X1/6tjVCJe5fZv0k8BTwAAA7iKxoSsisaErAAAAAdzc2gt
cnNhAAABAQCpZwm30gLIWtObS5lGoK9oai78i9XEZhdRTmcejTnw1aVgdzQTWNwEtb9t+AD9Yg1t
1ULEb5bFDHigr0yY/2Qbv/KJhKo3n5emX/i1mMshmhq0h+N+rxACkXD2LsJN6+k5BoJSl75zaHu8
aiUdQzEgA/GNr/XH0tedqjazi0aRb+m9W8VEXEpP8qFDIWzLOTVLOXZEPmZHMBqr0D+XCXDZumGB
eGtCW+DxrFzinz37Zsw8InHUreCEHnX3jTjjKvDSU70oP4Ol71uWW5hPFn1RLDv6VFmiMFBDjGBn
7oXnqZlMlMdwlSgUAFzxmdR3XWC3ZfX/q2NUIl7l9m/STwFPAAAAAwEAAQAAAQAQNxHZ5msoGh2Q
NgvNaWXGOl0WBR09/UG1IX/tujn2FhU25yIfyffW0ZN/J2fng80M8DFsaSaxj5CKXPfu2zS4vUZY
0ySR9MpI0tM/2rNy8MkmnQKce+MDQ+sKqDjRdEfw5/EYjngx8X81Q/nFKSCDfoJ5fALW5j/c/SUw
SXVvR/MOE2xGN3pNkYAKNaOSiaRgmmPGh8gRP/2VBJLKRvQYjTxmsXqffrE/hDH8qHRi+g0QUgsN
YUOBMiEaYSCN4YO9SKX+dXItDvurwftHy+CyCZ/pSRmMGisf7ciqt+4WBDiPi89iJL8DOqmCaaM2
4br/jfCuZ6WLEwQO1GLghhFdAAAAgGVBkzuPIFwJFJzGNb83hBMzsPb3xLda5h/yb6JfYy87qOrX
tGvt1ozKXclQjFkGFQtsaNLu92rECS7ywGv2KL5nnvMveXRqWdV1nskC5K7n7FLVv87ofA4ThTmc
sEP/iLxDj9tb2667cz3GR+8Cx2JSysP883HYKrjeMpZ46PmxAAAAgQDU4LchIx8vF/OyvcPn+0Av
4s/dtiKPiJ6+rY8OWMuE1IfoZUMWBQYZkR5UF+h60eSj6aI/Ere6AB7Zu0vNtTvu0b4+pvPRPjaS
D+zxUJijEm6LRJKfCtVWFglXvQ0mR5ZDmHy/c+8L7SaiE7fbvP10YJfUuWniDF69jzNOvgmUPQAA
AIEAy7fOriSG8S8RFlJCOEgxfYL2Fb730/RbsGmaPPDhBO1ROy+R9nLiOA4fnNFjdo2n1f7yg/ob
tnoVUms3jW5lH7Eq/g/eyVbor/LZF/K5tmQpwrzNd9xXLflETNTjlc7Q8w0TZvwXuM+KNhC0OEXz
GtQ5/41mOmnrLp5GZwksaHsAAAAAAQID
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
