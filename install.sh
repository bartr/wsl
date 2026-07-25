#!/bin/bash

cd "$(dirname $BASH_SOURCE[0])"
export dir=$(pwd)

if [ "$USER" == "root" ] || [ "$SUDO_USER" != "" ]; then
    echo "You cannot run using sudo or root"
    exit 1
fi

echo "installing base"
echo ""
sudo ./scripts/base.sh

echo ""
echo ""
echo "configuring $USER"
echo ""


cd $dir
./scripts/config.sh
