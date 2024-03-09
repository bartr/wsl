# Kubernetes on WSL

## Install WSL (version 2)

- From an elevated Command Prompt
  - Install WSL (skip this step if WSL is installed)

    ```bash

    wsl --install

    ```

  - You may have to run --update multiple times

    ```bash

    wsl --update

    ```

    - The most recent version of Windows Subsystem for Linux is already installed.
  - Set WSL to always use verion 2

    ```bash

    wsl --set-default-version 2

    ```
  
  - Reboot if necessary

## Start Ubuntu in WSL

- Enter your user name and password
  - Using the same user name as Windows will make things easier

  ```bash

  set USERNAME

  wsl --install -d ubuntu

  ```

## Update IP Tables

- Once WSL starts, you will be in a bash prompt inside your Ubuntu VM
- You will have to enter your password the first time you run `sudo`

```bash

echo "choose Legacy IP Tables"
echo ""

sudo update-alternatives --config iptables

```

## Set git config

- Change the values

```bash

git config --global user.name bartr
git config --global user.email bartr@microsoft.com

```

## Clone this repo

```bash

cd $HOME

git clone https://github.com/bartr/wsl wsl
cd wsl

```

## Install components

```bash

sudo ./install.sh

```

## Configure oh-my-zsh

```bash

./config.sh

```

## Finish Setup

- `exit` the WSL shell until you're back at the Command Prompt
- Restart the WSL shell
  - This will start the WSL shell in VS Code

  ```bash

  wsl -- code .

  ```

- Use "ctl `" to open a terminal

```bash

mkdir -p "$HOME/.oh-my-zsh/completions"
kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"
k3d completion zsh > "$HOME/.oh-my-zsh/completions/_k3d"
kustomize completion zsh > "$HOME/.oh-my-zsh/completions/_kustomize"
gh completion zsh > "$HOME/.oh-my-zsh/completions/_gh"
flux completion zsh > "$HOME/.oh-my-zsh/completions/_flux"
helm completion zsh > "$HOME/.oh-my-zsh/completions/_helm"
compinit

```

## Create a Cluster

- This will create the k3d cluster

```bash

cd "$HOME/wsl"

./create-cluster.sh

```

## Deploy NGINX Ingress Controller

```bash

cd "$HOME/wsl/deploy"

# create an NGINX ingress controller
kubectl apply -k cert-manager
kubectl apply -k ingress-nginx

echo ""
echo "waiting for ingress to start"

kubectl wait pods -n ingress-nginx -l app.kubernetes.io/component=controller --for condition=Ready --timeout=30s

echo ""
kubectl get pods -A

```

## Deploy Sample Workloads

```bash

kubectl apply -k heartbeat
kubectl apply -k config

echo ""
echo "waiting for pods to start"

kubectl wait pods -n heartbeat -l app=heartbeat --for condition=Ready --timeout=30s
kubectl wait pods -n config -l app=config --for condition=Ready --timeout=30s

echo ""
kubectl get pods -A

```

## Test the Cluster

```bash

http localhost/heartbeat/version

http localhost/version

```

- Using your browser, go to <http://localhost> and <http://localhost/heartbeat/16>

## Save the Image

- Use WSL to save the image for reuse
  - Exit WSL into the Command Prompt
  - Close VS Code
- Change to the directory you want to store the file (3 - 8 GB)

```bash

# delete the cluster
wsl -- k3d cluster delete

# stop the instance
wsl -t ubuntu

# export the image
wsl --export ubuntu kwsl.tar

# unregister ubuntu
wsl --unregister ubuntu

# import the image as "kwsl" - store in ./kwsl
wsl --import kwsl kwsl kwsl.tar

# start the image
# run ./create-cluster.sh if you deleted the cluster
wsl -- code .

```

## Stop the WSL Instance

```bash

wsl -t ubuntu

```

## Destroy the WSL Instance

```bash

wsl --unregister ubuntu

```

## Stop WSL

```bash

wsl --shutdown

```

## Support

This project uses GitHub Issues to track bugs and feature requests. Please search the existing issues before filing new issues to avoid duplicates.  For new issues, file your bug or feature request as a new issue.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
