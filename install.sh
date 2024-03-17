#!/bin/bash

cd "$(dirname $BASH_SOURCE[0])"
export dir=$(pwd)

if [ "$USER" != "root" ] || [ "$SUDO_USER" == "" ]; then
    echo "You must run using sudo ./install.sh"
    exit 1
fi

echo "installing base"
echo ""
./scripts/base.sh

echo ""
echo ""
echo "configuring $SUDO_USER"
echo ""

# no password for sudo
echo "$SUDO_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$SUDO_USER
echo -e "\n[user]\ndefault=$SUDO_USER\n" >> /etc/wsl.conf

# create / add to groups
groupadd docker
usermod -aG sudo $SUDO_USER
usermod -aG admin $SUDO_USER
usermod -aG docker $SUDO_USER
gpasswd -a $SUDO_USER sudo

# change shell to zsh
chsh -s /usr/bin/zsh $SUDO_USER
touch /home/$SUDO_USER/.zshrc

# change ownership of home directory
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER

echo ""
echo ""
echo "running as $SUDO_USER"
echo ""

cd $dir
sudo -u $SUDO_USER ./scripts/config.sh
