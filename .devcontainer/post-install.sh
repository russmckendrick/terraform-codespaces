#!/bin/sh

# source the bashrc-append from the repo
# you can add project specific settings to .bashrc-append and
# they will be added for every user that clones the repo with Codespaces
# including keys or secrets is a SECURITY RISK
echo "" >> ~/.bashrc
echo ". ${PWD}/.devcontainer/.bashrc-append" >> ~/.bashrc

# docker bash-completion
sudo curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker

DEBIAN_FRONTEND=noninteractive
# update apt-get
sudo apt-get update
sudo apt-get install -y --no-install-recommends apt-utils dialog

# update / install utils
sudo apt-get install -y --no-install-recommends dnsutils httpie wget unzip curl bash-completion jq
DEBIAN_FRONTEND=dialog

# install terraform

getLatestVersion() {
LATEST_ARR=($(wget -q -O- https://api.github.com/repos/hashicorp/terraform/releases 2> /dev/null | awk '/tag_name/ {print $2}' | cut -d '"' -f 2 | cut -d 'v' -f 2))
for ver in "${LATEST_ARR[@]}"; do
  if [[ ! $ver =~ beta ]] && [[ ! $ver =~ rc ]] && [[ ! $ver =~ alpha ]]; then
    LATEST="$ver"
    break
  fi
done
echo -n "$LATEST"
}

VERSION=$(getLatestVersion)

cd ~
wget "https://releases.hashicorp.com/terraform/"$VERSION"/terraform_"$VERSION"_linux_amd64.zip"
unzip "terraform_"$VERSION"_linux_amd64.zip"
sudo install terraform /usr/local/bin/