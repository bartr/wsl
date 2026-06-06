#!/bin/bash

cd "$(dirname $BASH_SOURCE[0])"
export dir=$(pwd)

echo "installing base"
echo ""
sudo ./scripts/base.sh

echo ""
echo ""
echo "configuring $USER"
echo ""

# change ownership of home directory
chown -R $USER:$USER /home/$USER
git config --global user.name bartr
git config --global user.email bartr@microsoft.com

cd $dir
./scripts/config.sh

echo ""
echo "installing caddy"
echo ""

sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt-get update
sudo apt-get install -y caddy

sudo tee /etc/caddy/Caddyfile > /dev/null <<'EOF'
bartr.dev {
    reverse_proxy localhost:8080
}
EOF

sudo systemctl enable caddy
sudo systemctl restart caddy
