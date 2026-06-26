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
nms1 IN A 172.16.12.11
nms2 IN A 172.16.12.12
crpd IN A 172.16.11.10
lxc IN A 172.16.11.11
pe1 IN A 172.16.11.21
pe2 IN A 172.16.11.22
pe3 IN A 172.16.11.23
pe4 IN A 172.16.11.24
p1 IN A 172.16.11.25
p2 IN A 172.16.11.26
p3 IN A 172.16.11.27
p4 IN A 172.16.11.28


EOF


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      addresses : ['172.16.11.254/24']
       
    eth2:
      addresses : ['172.16.12.254/24', 'fc00:dead:beef:12aa::1/64']
       
      
EOF



cat << EOF | sudo tee /usr/local/bin/start_vnc.sh
#!/bin/bash
websockify -D --web=/usr/share/novnc/ 6081 q-pod-74o.englab.juniper.net:5908
exit 1
EOF

sudo chmod +x /usr/local/bin/start_vnc.sh

cat << EOF | sudo tee /etc/update-motd.d/99-update
#!/bin/bash
echo "----------------------------------------------"
echo "To access console of VM, use the following URL"
echo "----------------------------------------------"
echo "console lxc : http://10.54.3.91:6081/vnc.html"
EOF

sudo chmod +x  /etc/update-motd.d/99-update
cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCK6O/OBtLVrPmoGNEM/VYW9INFJDk/ZpR4gYucZ9S963PAmBeq4tA0ptGA7NhCav3Xoi5KiQaIer2Sotgmi2S/BWCAF5siEv1Mnq1cJ69QbNv+9wLtzoIYxuis18ugsPFzMz4S+SQjyfu94W8FkU/lJ7xVgbY0nMS9e1gpwlvKAZsYgcGpUdOx6um1dortnuGQwH8b8ygZjEQ+5ottwDAWJ1v+e/jvO5dS+GF3MCpBN/7RmOWQzSFi/bqXyrZdTb2BBxPH2XO5fqPFNann9V+L5YAH+ImLE5ruU3fQAN1XFw/0V5y7bHWNPu6NuqKoUJm3YPVH1vlZ5lM4/e+oMsst
EOF

cat << EOF |  tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEAiujvzgbS1az5qBjRDP1WFvSDRSQ5P2aUeIGLnGfUvetzwJgXquLQNKbRgOzYQmr9
16IuSokGiHq9kqLYJotkvwVggBebIhL9TJ6tXCevUGzb/vcC7c6CGMborNfLoLDxczM+EvkkI8n7
veFvBZFP5Se8VYG2NJzEvXtYKcJbygGbGIHBqVHTserptXaK7Z7hkMB/G/MoGYxEPuaLbcAwFidb
/nv47zuXUvhhdzAqQTf+0ZjlkM0hYv26l8q2XU29gQcTx9lzuX6jxTWp5/Vfi+WAB/iJixOa7lN3
0ADdVxcP9Fecu2x1jT7ujbqiqFCZt2D1R9b5WeZTOP3vqDLLLQAAA7g6PDH0Ojwx9AAAAAdzc2gt
cnNhAAABAQCK6O/OBtLVrPmoGNEM/VYW9INFJDk/ZpR4gYucZ9S963PAmBeq4tA0ptGA7NhCav3X
oi5KiQaIer2Sotgmi2S/BWCAF5siEv1Mnq1cJ69QbNv+9wLtzoIYxuis18ugsPFzMz4S+SQjyfu9
4W8FkU/lJ7xVgbY0nMS9e1gpwlvKAZsYgcGpUdOx6um1dortnuGQwH8b8ygZjEQ+5ottwDAWJ1v+
e/jvO5dS+GF3MCpBN/7RmOWQzSFi/bqXyrZdTb2BBxPH2XO5fqPFNann9V+L5YAH+ImLE5ruU3fQ
AN1XFw/0V5y7bHWNPu6NuqKoUJm3YPVH1vlZ5lM4/e+oMsstAAAAAwEAAQAAAQAJZG8ke9chHgFC
ca0e5vk9c5p1oBmj1QyIal/1exrKHaO1u8Lr6cqgqL/lKv6DXScdP6jIHuQ7caskQVECqC2vcc5g
0tfJMcYBOoBnyQIkWrv0TSDcUfh/cuGUIEIzMwucWbRihYiBR/y2zcmbM4RWrv1fvbXDcG8oDbE8
H5ljuucLwhUg7awdsKa8asjaRIz89J5v7nr/ugRdalCkkj8IEUGvph113XwV7xaw5pFuKOEhcXBV
a0nMvfMdtbusWsffZbAlC0tPuJOcYbQoGG/g/5kPT/MY4gd/5yKNhmPd8Vz87UlqVwDexdTSfpvY
BhzNvQTlh3IzNDf9N7QdjqbhAAAAgQCICwIAN4iWZF4STC5q1935peHUxEuvUQnq2tStN863kQ/V
2i/RKflT6RA2+jAYBi3baD2Bq1YajEyQVJNvFbkkvKRfi9k9Gb13USDJ1Zbi2kGWa2yZbKF60JRK
Jff/L+jTL+ojCW6wq6fO6tMSp5vsAqsxbYTvmo2IqjmcxGxuwwAAAIEAxAQbhuyeeE3obaZIU35J
KsCOaceia5oE8j00Ezg0jN91IKjuBpLDmPPmkHjDxH5jN66l+oNH5eFVj78rufltl59eC8c9vasf
ZZmUx+Yy6ud7lJ9fTRMUwX9jcyi3aF9q1yz2LMnIQlWaNEAPQwMEvRAWJVxrQL5Iw799x0MKrCEA
AACBALVrIsX3P8ShIYbQtsIkKkxph4xK3Cv/6RB/ZcZHjDWWqrxX648jyJooLTURtEK1oH4JdAWB
hMH0Fn2CC3G4ENYTBcQ8x+LFOa/Hz1uZPtqGqarEeBwGd5k9GhQRuETWyZaRjPLGTZLxd+Q9un19
z+E53mkcx/vCMnSSOunxil2NAAAAAAEC
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
