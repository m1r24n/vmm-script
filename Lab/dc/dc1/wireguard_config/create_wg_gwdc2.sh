#!/bin/bash
if [ "$1" = "" ];
then
    echo "what is the ip address of gwapstra ? "
    exit
fi
cat << EOF | sudo tee /etc/wireguard/wg0.conf
[Interface]
PrivateKey=AHtqwT8QXbPV9yNHkRLdFQjU/3T+qecVRSCTLK47LHg=
Address=192.168.199.130/32
[Peer]
# gwrd
PublicKey=5m8Fitj/sUxdcctnGs/V1RMelS2Vc1cV1mNAlGmYBW4=
EndPoint=${1}:17845
AllowedIPs=192.168.199.128/28,172.16.55.0/24
EOF
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
sudo hostname gwdc1
hostname | sudo tee /etc/hostname
sudo sed -i -e "s/gw/gwdc3/" /etc/hosts


# EJCdiVEcLifpqIcAsWKcNoQ9zU7lWiXQh8AfWA9rOGM=
# cdOoPi0T/PyjCkgSynB4K/3+ta5Ryox0DkmK9UQLrVI=



