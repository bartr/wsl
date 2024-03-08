#!/bin/bash

cd $HOME || exit 1

# make some directories we will need
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
mkdir -p $HOME/go/src
mkdir -p $HOME/go/bin
mkdir -p $HOME/.kube
mkdir -p $HOME/bin
mkdir -p $HOME/.k9s

{
    echo ""
    echo 'cd $HOME'

    echo "export PATH=\$PATH:\$HOME/bin:\$HOME/.dotnet/tools:\$HOME/go/bin"
    echo ""

    echo "export PAT=$PAT"
    echo ""

    echo "alias k='kubectl'"
    echo "alias kaf='kubectl apply -f'"
    echo "alias kdelf='kubectl delete -f'"
    echo "alias kl='kubectl logs'"
    echo "alias kak='kubectl apply -k'"
    echo "alias kuse='kubectl config use-context'"
    echo "alias ipconfig='ip -4 a show eth0 | grep inet | sed \"s/inet//g\" | sed \"s/ //g\" | cut -d / -f 1'"
    echo ""

    echo "export GO111MODULE=on"
    # echo "export KUBECONFIG=/mnt/c/Users/$USER/.kube/config"
} > $HOME/.zshenv

git config --global core.whitespace blank-at-eol,blank-at-eof,space-before-tab
git config --global pull.rebase false
git config --global init.defaultbranch main
git config --global fetch.prune true
git config --global core.pager more
git config --global diff.colorMoved zebra
git config --global devcontainers-theme.show-dirty 1
git config --global core.editor "nano -w"

dotnet tool install --global webvalidate

# install oh my zsh
bash -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# add to .zshrc
{
    echo ""

    echo "# start a process so WSL doesn't exit"
    echo "if ! ps -ef | grep \"sleep infinity\" | grep -v grep > /dev/null; then"
    echo "    nohup sleep infinity >& \$HOME/nohup.out &"
    echo "fi"
    echo ""

    echo "compinit"
} >> $HOME/.zshrc
