#!/bin/bash

cd "$(dirname $BASH_SOURCE[0])"
export dir=$(pwd)

if [ "$USER" != "root" ] || [ "$SUDO_USER" == "" ]; then
    echo "You must run using sudo ./base.sh"
    exit 1
fi

echo "$SUDO_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$SUDO_USER
chmod 0440 /etc/sudoers.d/$SUDO_USER

exit 1

#update-alternatives --set iptables /usr/sbin/iptables-legacy

apt-get update
apt-get install -y gpg wget
apt-get install -y apt-utils dialog apt-transport-https ca-certificates software-properties-common
apt-get install -y libssl-dev libffi-dev python2-dev build-essential cifs-utils lsb-release gnupg-agent
apt-get install -y curl git wget nano zsh
apt-get install -y jq zip unzip httpie dnsutils
apt-get install -y golang
#apt-get install -y nginx mariadb-server mariadb-client
#apt-get install -y php-fpm php-common php-mysql php-gmp php-curl php-intl php-mbstring php-xmlrpc php-gd php-xml php-cli php-zip

apt-get upgrade -y
#apt-get install -y dotnet-sdk-7.0 dotnet-sdk-8.0

# add Docker repo
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# apt-get install -y gh

# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

# install k3d
#wget -q -O - https://raw.githubusercontent.com/rancher/k3d/main/install.sh | TAG=v5.4.6 bash

# install flux
curl -s https://fluxcd.io/install.sh | bash

# install K9s
VERSION=$(curl -i https://github.com/derailed/k9s/releases/latest | grep "location: https://github.com/" | rev | cut -f 1 -d / | rev | sed 's/\r//')
wget https://github.com/derailed/k9s/releases/download/$VERSION/k9s_Linux_amd64.tar.gz
tar -zxvf k9s_Linux_amd64.tar.gz -C /usr/local/bin
rm -f k9s_Linux_amd64.tar.gz

# install jp (jmespath)
VERSION=$(curl -i https://github.com/jmespath/jp/releases/latest | grep "location: https://github.com/" | rev | cut -f 1 -d / | rev | sed 's/\r//')
wget https://github.com/jmespath/jp/releases/download/$VERSION/jp-linux-amd64 -O /usr/local/bin/jp
chmod +x /usr/local/bin/jp

# install helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# install Kustomize
cd /usr/local/bin
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
cd $OLD_PWD

# install k3s
curl -sfL https://get.k3s.io | sh -
