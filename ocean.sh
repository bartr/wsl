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
