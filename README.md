# Docker on WSL

WSL is a great developer experience for Windows. It requires no additional licensing fees and provides additional Windows host and VS Code integration. Creating and using "snapshots" of your VM is very straight forward. WSL is very fast! We haven't found anything yet that doesn't work as expected using this setup.

These instructions work on a local Windows host as well as a virtual Windows host such as [Microsoft Dev Box](https://learn.microsoft.com/en-us/azure/dev-box/overview-what-is-microsoft-dev-box). For virtual hosts, `nested virtualization` must be supported.

## Prerequisites (on Windows host)

- Visual Studio Code

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

- Change the name and email
- Git needs these values set for commits

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
- Use "ctl `" to open a terminal (if necessary)
  - Note that the second "wsl" is this repo directory
  - You could use "." or "~" for $HOME
    - Or whatever repo you have cloned and want to work on

  ```powershell

  wsl -- code wsl

  ```

## Save the Image

- Use WSL to save the image for reuse
  - Close VS Code
- Change to the directory you want to store the file (3 - 8 GB)
  - You can store in this directory - .gitignore won't checkin .tar or .vhdx files

```powershell

# stop the instance
wsl -t ubuntu

# export the image
wsl --export ubuntu diw.tar

# unregister ubuntu
wsl --unregister ubuntu

# import the image as "bartr" - store in ./bartr
# change "bartr"
wsl --import bartr bartr diw.tar

# start the image in this repo
wsl -- code wsl

```

## Support

This project uses GitHub Issues to track bugs and feature requests. Please search the existing issues before filing new issues to avoid duplicates.  For new issues, file your bug or feature request as a new issue.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow [Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
