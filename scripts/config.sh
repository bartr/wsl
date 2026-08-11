#!/bin/bash

if [ "$USER" == "root" ]; then
    echo "You cannot run as user:root"
    exit 1
fi

export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin:$HOME/.local/share/fnm

# install oh my zsh
cd $HOME

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
fi

cp .oh-my-zsh/templates/zshrc.zsh-template .zshrc

# make some directories we will need
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
mkdir -p $HOME/go/src
mkdir -p $HOME/go/bin
mkdir -p $HOME/bin
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.secrets
mkdir -p "$HOME/.oh-my-zsh/completions"

{
  echo ""
  echo "export PATH=\$PATH:\$HOME/bin:\$HOME/.local/bin:\$HOME/go/bin:\$HOME/.local/share/fnm:/usr/local/go/bin"
  echo "export GOPATH=\$HOME/go"
  echo ""
  echo "export GITHUB_TOKEN=$GITHUB_TOKEN"
  echo "export COPILOT_GITHUB_TOKEN=$COPILOT_GITHUB_TOKEN"
  echo "export MODEL_API_KEY=$MODEL_API_KEY"
  echo "export CLAUDE_CODE_OAUTH_TOKEN=$CLAUDE_CODE_OAUTH_TOKEN"
  echo ""

  echo "export REPO=$HOME/deep-swe"
  echo "export PYTHONPATH=\$REPO/copilot-agent"
  echo ""

  # echo "alias k='kubectl'"
  # echo "alias kaf='kubectl apply -f'"
  # echo "alias kdelf='kubectl delete -f'"
  # echo "alias kl='kubectl logs'"
  # echo "alias kak='kubectl apply -k'"
  # echo "alias kuse='kubectl config use-context'"
  # echo "alias kgp='kubectl get pods -A'"
  # echo "alias kgs='kubectl get svc -A'"
  # echo "alias kgi='kubectl get ingress -A'"
  # echo "alias kgc='kubectl config get-contexts'"
  echo "alias ipconfig='ip -4 a show eth0 | grep inet | sed \"s/inet//g\" | sed \"s/ //g\" | cut -d / -f 1'"
  echo "alias code='/mnt/c/Program Files/Microsoft VS Code/bin/code'"
} >> $HOME/.zshenv

echo "https://$USER:$GITHUB_TOKEN@github.com" > $HOME/.git-credentials

git config --global credential.helper store
git config --global core.whitespace blank-at-eol,blank-at-eof,space-before-tab
git config --global pull.rebase false
git config --global init.defaultBranch main
git config --global fetch.prune true
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
    echo 'eval "$(fnm env --use-on-cd --shell zsh)"'
    echo ""
    echo "compinit"

    echo ""
    echo '[[ "$PWD" == /mnt/* ]] && cd $HOME'
} >> $HOME/.zshrc

gh completion -s zsh > "$HOME/.oh-my-zsh/completions/_gh"
#kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"
#k3d completion zsh > "$HOME/.oh-my-zsh/completions/_k3d"
#kustomize completion zsh > "$HOME/.oh-my-zsh/completions/_kustomize"
#flux completion zsh > "$HOME/.oh-my-zsh/completions/_flux"
#helm completion zsh > "$HOME/.oh-my-zsh/completions/_helm"

# install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# install fnm and Node LTS
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# Activate fnm in the current subshell execution context
eval "$(fnm env --use-on-cd)"

fnm install --lts
fnm use lts-latest

npm install -g @anthropic-ai/claude-code
curl -fsSL https://dev.meta.ai/install.sh | bash
curl -fsSL https://gh.io/copilot-install | sudo bash

uv tool install datacurve-pier

cd $HOME

if [ ! -d "$HOME/deep-swe" ]; then
    git clone https://github.com/bartr/deep-swe
fi

cd $HOME/deep-swe
git checkout bartr
git pull

docker build --pull -t public.ecr.aws/x8v8d7g8/mars-base:latest mars-base-override
