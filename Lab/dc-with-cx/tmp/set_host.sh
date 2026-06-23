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
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrWvRNB9ApfNb5jxQ3B2sfiSu4872YEETtCN8xs8U9u8Ls3eMF0tSCFlgIkrcnph3s4Gn/JDZISfH2/PPXoNkyN7Wl9X5/ZrTMx89lh8ofF8Rj66rxY8eoTKdAFHDdkofR9JJN0EW8pvCROjB3xU0ykBAUZiUBo6vGyKd5vNL4qg8eOglTbPux5cHbOmtJHTDJom+Ye+FNFLscVLgRhCjdau48Cb1ynHvrSEt/b2uRYrAB7E6WC65tJbIO6dGAq4V73WDbuSonBZOnAiPQM46EJNiHMseKKf07VCWwdn2Kly3xJCj02eb1vdejsjqw69lMxZID5+Apcof2Z7q0afb7
EOF

cat << EOF | tee ~/.ssh/id_rsa
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

sudo cp ~/.ssh/id_rsa /root/.ssh/id_rsa
sudo cp ~/.ssh/authorized_keys /root/.ssh/authorized_keys

sudo rm /etc/netplan/*
cat << EOF | sudo tee /etc/netplan/01_net.yaml
network:
  ethernets:
    eth0:
      addresses : ['172.16.11.100/24']
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