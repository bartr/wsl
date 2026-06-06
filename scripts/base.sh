#!/bin/bash

cd "$(dirname $BASH_SOURCE[0])"
export dir=$(pwd)

if [ "$USER" != "root" ] || [ "$SUDO_USER" == "" ]; then
    echo "You must run using sudo ./base.sh"
    exit 1
fi

update-alternatives --set iptables /usr/sbin/iptables-legacy

apt-get update
apt-get install -y gpg wget
apt-get install -y apt-utils dialog apt-transport-https ca-certificates software-properties-common
apt-get install -y libssl-dev libffi-dev python2-dev build-essential cifs-utils lsb-release gnupg-agent
apt-get install -y curl git wget nano zsh
apt-get install -y jq zip unzip httpie dnsutils

apt-get upgrade -y

# add Docker repo
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

# add gh cli repo
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o /etc/apt/keyrings/githubcli-archive-keyring.gpg
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
apt-get install -y gh

# install latest Go
GO_VERSION=$(curl -fsSL https://go.dev/VERSION?m=text | head -n 1)
GO_ARCH=$(dpkg --print-architecture)
GO_TARBALL="${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
curl -fsSL "https://go.dev/dl/${GO_TARBALL}" -o "/tmp/${GO_TARBALL}"
rm -rf /usr/local/go
tar -C /usr/local -xzf "/tmp/${GO_TARBALL}"
rm -f "/tmp/${GO_TARBALL}"
ln -sf /usr/local/go/bin/go /usr/local/bin/go
ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt

# install kubectl
#curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
#rm -f kubectl

# install k3d
#wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v5.4.6 bash

# install flux
#curl -s https://fluxcd.io/install.sh | bash

# install K9s
#VERSION=$(curl -i https://github.com/derailed/k9s/releases/latest | grep "location: https://github.com/" | rev | cut -f 1 -d / | rev | sed 's/\r//')
#wget https://github.com/derailed/k9s/releases/download/$VERSION/k9s_Linux_amd64.tar.gz
#tar -zxvf k9s_Linux_amd64.tar.gz -C /usr/local/bin
#rm -f k9s_Linux_amd64.tar.gz

# install jp (jmespath)
#VERSION=$(curl -i https://github.com/jmespath/jp/releases/latest | grep "location: https://github.com/" | rev | cut -f 1 -d / | rev | sed 's/\r//')
#wget https://github.com/jmespath/jp/releases/download/$VERSION/jp-linux-amd64 -O /usr/local/bin/jp
#chmod +x /usr/local/bin/jp

# install helm
#curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# install Kustomize
#cd /usr/local/bin
#curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
#cd $OLD_PWD

# start the docker service
service docker start
