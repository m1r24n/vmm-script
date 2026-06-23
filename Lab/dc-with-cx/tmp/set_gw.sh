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
afc IN A 172.16.11.1
spine1 IN A 172.16.11.11
spine2 IN A 172.16.11.12
leaf1 IN A 172.16.11.21
leaf2 IN A 172.16.11.22
leaf3 IN A 172.16.11.23
leaf4 IN A 172.16.11.24
leaf5 IN A 172.16.11.25
leaf6 IN A 172.16.11.26


EOF


cat << EOF | sudo tee /etc/netplan/02_net.yaml
network:
  ethernets:
    eth1:
      addresses : ['172.16.11.254/24']
       
    eth2:
      addresses : ['10.1.255.128/31', 'fc00:dead:beef:aaff::0/127']
      mtu: 9000
       
    eth3:
      addresses : ['10.1.255.130/31', 'fc00:dead:beef:aaff::2/127']
      mtu: 9000
       
      
EOF



cat << EOF | sudo tee /usr/local/bin/start_vnc.sh
#!/bin/bash
websockify -D --web=/usr/share/novnc/ 6081 q-pod-104m.englab.juniper.net:5914
websockify -D --web=/usr/share/novnc/ 6082 q-pod-104i.englab.juniper.net:5909
websockify -D --web=/usr/share/novnc/ 6083 q-pod-104g.englab.juniper.net:5909
websockify -D --web=/usr/share/novnc/ 6084 q-pod-103n.englab.juniper.net:5903
websockify -D --web=/usr/share/novnc/ 6085 q-pod-103h.englab.juniper.net:5955
websockify -D --web=/usr/share/novnc/ 6086 q-pod-103f.englab.juniper.net:5935
websockify -D --web=/usr/share/novnc/ 6087 q-pod-103a.englab.juniper.net:5924
websockify -D --web=/usr/share/novnc/ 6088 q-pod-104c.englab.juniper.net:5912
websockify -D --web=/usr/share/novnc/ 6089 q-pod-103l.englab.juniper.net:5919
websockify -D --web=/usr/share/novnc/ 6090 q-pod-103e.englab.juniper.net:5908
websockify -D --web=/usr/share/novnc/ 6091 q-pod-104j.englab.juniper.net:5918
websockify -D --web=/usr/share/novnc/ 6092 q-pod-104l.englab.juniper.net:5907
exit 1
EOF

sudo chmod +x /usr/local/bin/start_vnc.sh

cat << EOF | sudo tee /etc/update-motd.d/99-update
#!/bin/bash
echo "----------------------------------------------"
echo "To access console of VM, use the following URL"
echo "----------------------------------------------"
echo "console svr1 : http://10.38.208.112:6081/vnc.html"
echo "console svr2 : http://10.38.208.112:6082/vnc.html"
echo "console lxd1 : http://10.38.208.112:6083/vnc.html"
echo "console lxd2 : http://10.38.208.112:6084/vnc.html"
echo "console svr3 : http://10.38.208.112:6085/vnc.html"
echo "console svr4 : http://10.38.208.112:6086/vnc.html"
echo "console lxd3 : http://10.38.208.112:6087/vnc.html"
echo "console lxd4 : http://10.38.208.112:6088/vnc.html"
echo "console lxd5 : http://10.38.208.112:6089/vnc.html"
echo "console lxd6 : http://10.38.208.112:6090/vnc.html"
echo "console lxd7 : http://10.38.208.112:6091/vnc.html"
echo "console lxd8 : http://10.38.208.112:6092/vnc.html"
EOF

sudo chmod +x  /etc/update-motd.d/99-update
cat << EOF | tee ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrWvRNB9ApfNb5jxQ3B2sfiSu4872YEETtCN8xs8U9u8Ls3eMF0tSCFlgIkrcnph3s4Gn/JDZISfH2/PPXoNkyN7Wl9X5/ZrTMx89lh8ofF8Rj66rxY8eoTKdAFHDdkofR9JJN0EW8pvCROjB3xU0ykBAUZiUBo6vGyKd5vNL4qg8eOglTbPux5cHbOmtJHTDJom+Ye+FNFLscVLgRhCjdau48Cb1ynHvrSEt/b2uRYrAB7E6WC65tJbIO6dGAq4V73WDbuSonBZOnAiPQM46EJNiHMseKKf07VCWwdn2Kly3xJCj02eb1vdejsjqw69lMxZID5+Apcof2Z7q0afb7
EOF

cat << EOF |  tee ~/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcnNhAAAA
AwEAAQAAAQEAq1r0TQfQKXzW+Y8UNwdrH4kruPO9mBBE7QjfMbPFPbvC7N3jBdLUghZYCJK3J6Yd
7OBp/yQ2SEnx9vzz16DZMje1pfV+f2a0zMfPZYfKHxfEY+uq8WPHqEynQBRw3ZKH0fSSTdBFvKbw
kTowd8VNMpAQFGYlAaOrxsinebzS+KoPHjoJU2z7seXB2zprSR0wyaJvmHvhTRS7HFS4EYQo3Wru
PAm9cpx760hLf29rkWKwAexOlguubSWyDunRgKuFe91g27kqJwWTpwIj0DOOhCTYhzLHiin9O1Ql
sHZ9ipct8SQo9Nnm9b3Xo7I6sOvZTMWSA+fgKXKH9me6tGn2+wAAA7gGGmDjBhpg4wAAAAdzc2gt
cnNhAAABAQCrWvRNB9ApfNb5jxQ3B2sfiSu4872YEETtCN8xs8U9u8Ls3eMF0tSCFlgIkrcnph3s
4Gn/JDZISfH2/PPXoNkyN7Wl9X5/ZrTMx89lh8ofF8Rj66rxY8eoTKdAFHDdkofR9JJN0EW8pvCR
OjB3xU0ykBAUZiUBo6vGyKd5vNL4qg8eOglTbPux5cHbOmtJHTDJom+Ye+FNFLscVLgRhCjdau48
Cb1ynHvrSEt/b2uRYrAB7E6WC65tJbIO6dGAq4V73WDbuSonBZOnAiPQM46EJNiHMseKKf07VCWw
dn2Kly3xJCj02eb1vdejsjqw69lMxZID5+Apcof2Z7q0afb7AAAAAwEAAQAAAQABTxp+O0selN9Y
ZbN8C9itATYJgilx+N1F7f6ifewAmIL0VY5z6t1RcDpmpcshrTFm5sVmO+vwzm4W1iTYuQ7o116I
8KnMyqLZqDKHCawEY8oEx2O+ji7vWGlq9GYpwN28Ue6dnSF6Gz5d7smmbSY1m1DXjw0OUe+L7NhW
rRfPNFUAeGy3sQ5eWVKVXOiZgix1b4exlaqppkJNzj31V17fCsyETsFwSxL3PbfU+EVxZXbokOrR
DYk46mvRPW6zcpbgDddpf2XtKpwNYIrl8ra6PjZVrNXOYmPpfJ9srb+gFCp2fCXkAdXkp4z30BoO
WJbEgncSSwW1wYfjMqK/Q16NAAAAgQCKbkVlXOJ5hidpKGpMrWXtiTObUT2l6r00vhQOdf+yqLC5
sIWSjdp9QchfUteHnaLBhT0BrhQJ7UuAI5KWZ08p1bQuxCbDV4B9+31cJ+bcwFXyUHB5R8o4LWCs
hda/9o9s7hB8wOokvAZIJ4Gzhgbfkh4ztfl0tHU+NNeOYkzsMQAAAIEA7QqN/FQ0QKkmypCLUlnA
SBnNlY5kZrZtXCMUMMbYUyurXUdtbTYImNRA+7i6MEaaOhNAS4WZwj+lW8buR57mnDQX3131aA+3
cYPqZeWldLLXNYjVo6iFhG3LySmGaqaZG0LRCbS6RahjVsEppU3N5MxpMVCk3OCGk9NOyxRCh1cA
AACBALkPeQogBtgL73fyFGYd+Xg1aDwfPNzu79wAGFzYG78hWmZZm4exOvawQ6Y04tJ9ostPlmBc
7fcM2R5Q/GirYcPOU5EYsF2wUwZ+ryQd0I8CmwdiR+3SkSUdd4hP1+v4hDTBE/+T1OEBhVtoUtBB
OKID6ZzoGevXBlxMLPFuM7r9AAAAAAEC
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
