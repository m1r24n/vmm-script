cat << EOF | sudo tee /etc/wireguard/wg1.conf
[Interface]
PrivateKey=KHzd0OF4CfTl0gyK1Pz7j/nDrQbyxrLqK/8KWgdAfX0=
Address=192.168.199.128/28
ListenPort=17845
[Peer]
# gwdc1
PublicKey=cdOoPi0T/PyjCkgSynB4K/3+ta5Ryox0DkmK9UQLrVI=
AllowedIPs=192.168.199.129/32,172.16.51.0/24,172.16.52.0/24
[Peer]
# gwdc2
PublicKey=+hczEmieqW+DEupI0IUwJEEs4UFE9xdMfG6re6cQP08=
AllowedIPs=192.168.199.130/32,172.16.61.0/24,172.16.62.0/24

EOF
sudo systemctl enable wg-quick@wg1
sudo systemctl start wg-quick@wg1
sudo hostname gwapstra
hostname | sudo tee /etc/hostname
sudo sed -i -e "s/gw/gwapstra/" /etc/hosts


# KHzd0OF4CfTl0gyK1Pz7j/nDrQbyxrLqK/8KWgdAfX0=
# 5m8Fitj/sUxdcctnGs/V1RMelS2Vc1cV1mNAlGmYBW4=

