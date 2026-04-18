#!/bin/bash

if [ "$USER" == "root" ]; then
    echo "You cannot run as user:root"
    exit 1
fi


export PATH=$PATH:$HOME/bin:$HOME/.dotnet/tools:$HOME/go/bin

# make some directories we will need
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
mkdir -p $HOME/go/src
mkdir -p $HOME/go/bin
mkdir -p $HOME/.kube
mkdir -p $HOME/bin
mkdir -p $HOME/.k9s

{
    echo "export PATH=\$PATH:\$HOME/bin:\$HOME/.dotnet/tools:\$HOME/go/bin"
    echo "export GO111MODULE=on"
    echo ""

    echo "alias k='kubectl'"
    echo "alias kaf='kubectl apply -f'"
    echo "alias kdelf='kubectl delete -f'"
    echo "alias kl='kubectl logs'"
    echo "alias kak='kubectl apply -k'"
    echo "alias kuse='kubectl config use-context'"
    echo "alias kgp='kubectl get pods -A'"
    echo "alias kgs='kubectl get svc -A'"
    echo "alias kgi='kubectl get ingress -A'"
    echo "alias kgc='kubectl config get-contexts'"
    echo "alias ipconfig='ip -4 a show wlp4s0 | grep inet | sed \"s/inet//g\" | sed \"s/ //g\" | cut -d / -f 1'"
} > $HOME/.zshenv

git config --global user.name bartr
git config --global user.email bartr@microsoft.comgit config --global core.whitespace blank-at-eol,blank-at-eof,space-before-tab
git config --global pull.rebase false
git config --global init.defaultbranch main
git config --global fetch.prune true
git config --global core.pager more
git config --global diff.colorMoved zebra
git config --global devcontainers-theme.show-dirty 1
git config --global core.editor "nano -w"

# add to .zshrc
{
    echo ""
    echo 'PROMPT="%{$fg[blue]%}%~%{$reset_color%}"'
    echo "PROMPT+=' \$(git_prompt_info)'"
    echo 'ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}(%{$fg[red]%}"'
    echo 'ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "'
    echo 'ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[red]%}%1{✗%}"'
    echo 'ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"'

    echo ""
    echo "compinit"
} >> $HOME/.zshrc

mkdir -p "$HOME/.oh-my-zsh/completions"
kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"
kustomize completion zsh > "$HOME/.oh-my-zsh/completions/_kustomize"
#gh completion -s zsh > "$HOME/.oh-my-zsh/completions/_gh"
flux completion zsh > "$HOME/.oh-my-zsh/completions/_flux"
helm completion zsh > "$HOME/.oh-my-zsh/completions/_helm"

sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) -R ~/.kube
