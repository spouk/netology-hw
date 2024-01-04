#---------------------------------------------------------------------------------
# --author:  aleksey.martynenko //2024 // cyberspouk@gmail.com // spouk@spouk.ru--
#---------------------------------------------------------------------------------
#!/bin/bash
# temp disable selinux
sudo setenforce 0
# permanent disable selinux
sudo sed -c -i "s/\SELINUX=.*/SELINUX=disabled/" /etc/sysconfig/selinux
# adding kubernetes repositary
cat <<EOF >/etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# adding net change for correct work kube cluster
cat <<EOF >>/etc/sysctl.conf
net.bridge.bridge-nf-call-iptables = 1
 net.ipv4.ip_forward = 1
 net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl -p
# install kubeadm and docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache

sudo yum remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-engine
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin kubeadm mc zsh tmux lsof tcpdump vim -y
# fix some trouble with cri in centos
sudo cp /etc/containerd/config.toml /etc/containerd/config.toml.0
sudo sed -c -i "s/\disabled_plugins = .*/#disabled_plugins =/" /etc/containerd/config.toml
cat <<EOF >/etc/crictl.yaml
runtime-endpoint: "unix:///run/containerd/containerd.sock"
timeout: 0
debug: false
EOF
# enable services
sudo systemctl enable kubelet --now
sudo systemctl enable docker --now
sudo systemctl enable containerd --now
# reboot vm
sudo reboot
