# deploying kubernetes

## configure haproxy on node gw

Configure HAproxy on node GW to allow load balance traffic to multiple master

1. Edit file /etc/netplan/02_net.yaml, and add secondary ip address, 172.16.11.101/24 to interface eth1

       cat << EOF | sudo tee /etc/netplan/02_net.yaml
       network:
       ethernets:
         eth1:
           addresses : ['172.16.11.1/24',172.16.11.101/24]
           mtu: 9000
         eth2:
           addresses : ['172.16.12.1/24']
           mtu: 9000
         eth3:
           addresses : ['172.16.13.1/24']
           mtu: 9000
        EOF

        sudo netplan apply

2. edit file /etc/haproxy/haproxy.cfg
3. add the following entry into file haproxy.cfg

       cat << EOF  | sudo tee -a /etc/haproxy/haproxy.cfg
       frontend k8s
           bind 172.16.11.101:6443
           mode tcp
           option tcplog
           default_backend k8smasters

       backend k8smasters
           mode tcp
           balance roundrobin
           option tcp-check
           server node0 172.16.11.10:6443 check
           server node1 172.16.11.11:6443 check
           server node2 172.16.11.12:6443 check
       EOF
       sudo systemctl restart haproxy

## installing local registry 
1. open ssh session into node registry

       ssh registry

2. install containerd and podman 

       sudo apt install containerd podman

3. create directory ~/registry/certs and ~/registry/data

       mkdir -p ~/registry/certs
       mkdir -p ~/registry/data

4. edit file **sudo vi /etc/ssl/openssl.cnf** and add the following 

       [ v3_ca ]
       subjectAltName=IP:172.16.13.10
       # 172.16.13.10 is the ip address of VM registry. If the VM is using different IP address, then set it accordingly

5. create self signed certificate. use the following script. You can fill anything for the fields, except for "Common Name", you have to put the ip address of the VM where the registry is running, for example 172.16.13.10

        cd ~/registry
        openssl req -newkey rsa:4096 -nodes -sha256 -keyout ./certs/registry.key -x509 -days 365 -out ./certs/registry.crt

6. Run registry 

       podman run --name registry \
            -p 5000:5000 \
            -v ~/registry/data:/var/lib/registry \
            -v ~/registry/certs:/certs \
            -e "REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt" \
            -e "REGISTRY_HTTP_TLS_KEY=/certs/registry.key" \
            --network podman \
            -d registry

7. Create directory /etc/containers/certs.d/172.16.13.10:5000/, and copy file ~/registry/certs/registry.crt into it

       sudo mkdir -p /etc/containers/certs.d/172.16.13.10:5000/
       sudo cp ~/registry/certs/registry.crt /etc/containers/certs.d/172.16.13.10:5000/ca.crt

8. upload file ~/registry.crt into directory /etc/ssl/certs on every k8s node

       #!/bin/bash
       for i in node{0..4}
       do
         scp ~/registry/certs/registry.crt ${i}:~/
         ssh ${i} "sudo cp ~/registry.crt /etc/ssl/certs/; sudo reboot"
       done


## installing containerd

Do the following on all k8s nodes

1. Download containerd from [here](https://github.com/containerd/containerd/releases)

       curl -L -O https://github.com/containerd/containerd/releases/download/v2.2.0/containerd-2.2.1-linux-amd64.tar.gz

2. extract the file 

       sudo tar Cxzvf /usr/local containerd-2.2.1-linux-amd64.tar.gz

3. Download [containerd.service](https://raw.githubusercontent.com/containerd/containerd/main/containerd.service) into /usr/local/lib/systemd/system/containerd.service

       curl -L -O https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
       sudo mkdir -p /usr/local/lib/systemd/system/
       sudo cp ./containerd.service /usr/local/lib/systemd/system/

3. Reload containerd

       systemctl daemon-reload
       systemctl enable --now containerd

## install runc

Do the following on all k8s nodes

1. Download runc from [here](https://github.com/opencontainers/runc/releases)

       curl -L -O https://github.com/opencontainers/runc/releases/download/v1.4.0/runc.amd64

2. Install runc

       sudo install -m 755 runc.amd64 /usr/local/sbin/runc

## install CNI plugins


Do the following on all k8s nodes

1. Download CNI plugins from [here](https://github.com/containernetworking/plugins/releases)

       curl -L -O https://github.com/containernetworking/plugins/releases/download/v1.8.0/cni-plugins-linux-amd64-v1.9.0.tgz

2. install CNI plugins

       sudo mkdir -p /opt/cni/bin
       sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.9.0.tgz

## edit config.toml 

Do the following on all k8s nodes

1. Create default config.toml

       sudo mkdir -p /etc/containerd
       containerd config default | sudo tee /etc/containerd/config.toml

2. edit file /etc/containerd/config.toml, change the value of  **SystemdCgroup** to true

       vi /etc/containerd/config.toml
       
       or 

       sed -i -e "s/SystemdCgroup = false/SystemdCgroup = true/" /etc/containerd/config.toml
       sudo systemctl restart containerd
    
## install kubeadm utility

Do the following on all k8s nodes

1. update packages

       sudo apt-get update
       sudo apt-get install -y apt-transport-https ca-certificates curl gpg
       curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
       echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
       sudo apt -y update
       sudo apt install -y kubelet kubeadm kubectl
       sudo apt-mark hold kubelet kubeadm kubectl
       sudo systemctl enable --now kubelet

## bootstrap kubernetes cluster
1. on the first master node, create the following kube_init.yaml 

       cat << EOF | tee kube_init.yaml
       ---
       apiVersion: kubelet.config.k8s.io/v1beta1
       kind: KubeletConfiguration
       cgroupDriver: systemd
       ---
       apiVersion: kubeadm.k8s.io/v1beta4
       kind: ClusterConfiguration
       networking:
           podSubnet: "10.32.0.0/12"
           serviceSubnet: "10.96.0.0/12"
       controlPlaneEndpoint: "172.16.11.101:6443"
       EOF
    
2. create the first k8s master

       sudo kubeadm init --pod-network-cidr "10.32.0.0/12" --service-cidr "10.96.0.0/12" --control-plane-endpoint "172.16.11.101:6443" --upload-certs 

       or 

       sudo kubeadm init --config kube_init.yaml --upload-certs 

3. record the kubeadm join for master and worker nodes
4. on the other master nodes, run the kubeadmm join for master
5. Taint all master to allow pods deployed on the master node

       kubectl taint nodes --all node-role.kubernetes.io/control-plane-

5. on worker nodes, run the kubeadm join for worker

## install cilium as CNI

Documentation can be found [here](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/#install-cilium)

1. install cilium cli

       CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
       CLI_ARCH=amd64
       if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
       curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
       sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
       sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
       rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

2. install cilium 

       cilium install --version 1.18.5

## install metallb as loadbalancer for k8s cluster

Documentation can be found [here](https://metallb.io/)

1. Enable strict ARP mode if the kube-proxy is in IPVS mode

       kubectl edit configmap -n kube-system kube-proxy

       apiVersion: kubeproxy.config.k8s.io/v1alpha1
       kind: KubeProxyConfiguration
       mode: "ipvs"
       ipvs:
         strictARP: true

2. Install metallab as loadbalancer

       kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-native.yaml

3. configure IP pool and 

       cat << EOF | tee metallb_config.yaml
       ---
       apiVersion: metallb.io/v1beta1
       kind: IPAddressPool
       metadata:
         name: pool1
         namespace: metallb-system
       spec:
         addresses:
         - 172.16.1.0/24
       ---
       apiVersion: metallb.io/v1beta1
       kind: BGPAdvertisement
       metadata:
         name: external
         namespace: metallb-system
       spec:
         ipAddressPools:
         - pool1
         aggregationLength: 32
       ---
       apiVersion: metallb.io/v1beta2
       kind: BGPPeer
       metadata:
         name: example
         namespace: metallb-system
       spec:
         myASN: 64512
         peerASN: 64512
         peerAddress: 172.16.11.1
       EOF
       kubectl apply -f metallb_config.yaml

## configure frr on node GW

1. configure frr with the following configuration

       router bgp 64512
         neighbor 172.16.11.10 remote-as 64512
         neighbor 172.16.11.11 remote-as 64512
         neighbor 172.16.11.12 remote-as 64512
         neighbor 172.16.11.13 remote-as 64512
         neighbor 172.16.11.14 remote-as 64512
       exit
