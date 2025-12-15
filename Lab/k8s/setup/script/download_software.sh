#!/usr/bin/env bash
# script to install k8s
curl -L -O https://github.com/containerd/containerd/releases/download/v2.2.0/containerd-2.2.0-linux-amd64.tar.gz
curl -L -O https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
curl -L -O https://github.com/opencontainers/runc/releases/download/v1.4.0/runc.amd64
curl -L -O https://github.com/containernetworking/plugins/releases/download/v1.8.0/cni-plugins-linux-amd64-v1.8.0.tgz

cat << EOF | tee install_container.sh
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
EOF

chmod +x install_container.sh
cat << EOF | tee install_kubeadm.sh
#!/usr/bin/env bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt -y update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
EOF

chmod +x install_kubeadm.sh

for i in node{0..4}
do
    scp containerd-2.2.0-linux-amd64.tar.gz ubuntu@${i}:~/
    scp containerd.service ubuntu@${i}:~/
    scp runc.amd64 ubuntu@${i}:~/
    scp cni-plugins-linux-amd64-v1.8.0.tgz ubuntu@${i}:~/
    scp install_container.sh ubuntu@${i}:~/
    scp install_kubeadm.sh ubuntu@${i}:~/
done

