#!/bin/bash

set -e

# check whether script is run as root user
if [ "$EUID" -ne 0 ]; then
    echo "Error! Please run as root"
    exit 1
fi

# remove unofficial Docker packages
yum -y remove docker docker-common container-selinux

# remove conflicting packages
yum -y remove docker-selinux

# Setup the repo
yum install -y yum-utils
yum-config-manager --add-repo https://docs.docker.com/engine/installation/linux/repo_files/centos/docker.repo

# Install docker
yum makecache fast
yum -y install docker-engine
systemctl enable docker
systemctl start docker

# Add user to docker group
echo "To add current user to docker group:"
echo "  sudo usermod -aG docker \$USER"

# Install docker compose
curl -L "https://github.com/docker/compose/releases/download/1.11.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Installing Command Completion
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

