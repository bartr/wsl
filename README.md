# Kubernetes on WSL

WSL is a great developer experience for Windows. It requires no additional licensing fees and provides additional Windows host and VS Code integration. Creating and using "snapshots" of your VM is very straight forward. WSL is very fast! We haven't found anything yet that doesn't work as expected using this setup.

These instructions work on a local Windows host as well as a virtual Windows host such as [Microsoft Dev Box](https://learn.microsoft.com/en-us/azure/dev-box/overview-what-is-microsoft-dev-box). For virtual hosts, `nested virtualization` must be supported.

## Prerequisites (on Windows host)

- Git CLI
- Visual Studio Code
- az CLI (if desired)

## Clone this Repo

```powershel

git clone https://github.com/bartr/wsl

```

## Install VS Code Extension

- Install VS Code Remote Extensions Pack

```powershell

code --install-extension ms-vscode-remote.vscode-remote-extensionpack

```

## Install WSL (version 2)

- Update WSL

```powershell

wsl --update

```

- If you get an error that you need to install WSL first, the following command will install WSL
  - A reboot will be required

```powershell

wsl --install

```

- Set WSL to always use verion 2

```powershell

wsl --set-default-version 2

```

- Reboot if necessary
  - After you reboot, WSL will automatically begin the install process and you can skip the next step

## Start Ubuntu in WSL

- Enter your user name and password
  - Using the same user name as Windows will make things easier

```powershell

wsl --install -d ubuntu

```

## Set git config

- Change the values

```bash

git config --global user.name bartr
git config --global user.email bartr@microsoft.com

# exit the shell
exit

```

## Install components

- Enter the password you used when creating the WSL VM

```powershell

wsl -- sudo ./install.sh

```

## Finish Setup

- This will start the WSL shell in VS Code

  ```powershell

  # note that the second "wsl" is this repo directory
  # you could use "." or "~" for $HOME
  # or whatever repo you have cloned and want to work on
  wsl -- code wsl

  ```

- Use "ctl `" to open a terminal (if necessary)

## Save the Image

- Use WSL to save the image for reuse
  - Close VS Code
- Change to the directory you want to store the file (3 - 8 GB)
  - You can store in this directory - .gitignore won't checkin .tar or .vhdx files

```powershell

# stop the instance
wsl -t ubuntu

# export the image
wsl --export ubuntu kic.tar

# unregister ubuntu
wsl --unregister ubuntu

# import the image as "bartr" - store in ./bartr
# change "bartr"
wsl --import bartr bartr kic.tar

# start the image in this repo
wsl -- code wsl

```

## Create a Cluster

- This will create the k3d cluster using `kic`
- KiC is a custom CLI that automatates common K8s tasks
- KiC provides robust tab completion which makes it easier for new to K8s engineers
- Everything in KiC can be accomplished using the underlying CLIs

```bash

cd "$HOME/wsl"

kic cluster create

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

# give the ingress controller webhook time to start
sleep 3

echo ""
kubectl get pods -A

```

## Deploy Sample Workloads

```bash

cd "$HOME/wsl/deploy"

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

kic check heartbeat

kic check config

```

- Using your browser, go to <http://localhost/version> and <http://localhost/heartbeat/version>

## Lagniappe (a little extra)

The WSL and VS Code teams have done a great job at integrating the Linux developer experience on Windows. Here are a few `tricks`

- If you logged into GitHub from Windows, "it just works" in the VS Code terminal in WSL
  - Note that it does not work from an SSH terminal - you have to configure first
- If you have the `az CLI` installed and logged in via Windows, "it just works" in WSL.
  - Just type `az account show` from your VS Code terminal in WSL
  - Type `which az` and you'll notice that it runs from `/mnt/c/Program Files/Microsoft SDKs/Azure/CLI2/wbin/az`
- You can access your Windows host machine from `/mnt/c/..`
  - Try `cd /mnt/c/Users/$USER` (assuming you used the same user name)
- Type `path` from your VS Code terminal to see all of the Windows paths mounted
  - Typing `which path` will show you the shell script is in `$HOME/bin/path`
- Type `ipconfig` to get your WSL IP address (it's an alias)
- Type `alias` to see the different aliases that are defined
- Type `code ~/.zshrc` and `code ~/.zshenv` to edit your default shell
  - You can change your `oh-my-zsh` theme if you want
  - A list of themes is [here](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
  - You can also add aditional zsh [plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/plugins)
- If you would rather have your repos somewhere other than $HOME (like /workspaces), you can create the directory and cause the shell to automatically start there (i.e. `cd /workspaces` instead of `cd $HOME` in .zshenv)
  - After creating the directory, make sure to run `sudo chown -R $USER:$USER /workspaces`
- Typing `cd ~` or just `~` will cd to $HOME
- Typing `cd -` or just `-` will cd to $OLD_PWD
- Typing `..` or `...` or `......` will go back one or more directories in the tree
- Type `cd ~/wsl/deploy/heartbeat` and then `code *.yaml` to open all the yaml files
- Typing `code dirName` will open a new instance of code at that directory
  - This is awesome for `mono repos`

## Support

This project uses GitHub Issues to track bugs and feature requests. Please search the existing issues before filing new issues to avoid duplicates.  For new issues, file your bug or feature request as a new issue.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
