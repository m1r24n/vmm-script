#!/usr/bin/env bash
export CTR="containerd-2.2.0-linux-amd64.tar.gz"
export CNI_PLUGINS="cni-plugins-linux-amd64-v1.8.0.tgz"
sudo tar Cxzvf /usr/local ${CTR}
sudo mkdir -p /usr/local/lib/systemd/system/
sudo cp ./containerd.service /usr/local/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin ${CNI_PLUGINS}
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i -e "s/SystemdCgroup = false/SystemdCgroup = false/" /etc/containerd/config.toml
sudo systemctl restart containerd