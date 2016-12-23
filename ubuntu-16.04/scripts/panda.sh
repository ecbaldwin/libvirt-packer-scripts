#!/bin/bash

if [ "$(systemctl is-enabled firewalld)" = "enabled" ]
then
    systemctl stop firewalld
    systemctl disable firewalld
fi

# For docker
apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
if [ $? -ne 0 ]; then
    echo "Try from a different pgp key source"
    apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
fi

apt-get -y install apt-transport-https

echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
apt-get update

apt-get -y install \
    apt-transport-https \
    build-essential \
    docker-engine \
    emacs24-nox \
    git \
    libffi-dev \
    libssl-dev \
    libvirt-bin \
    libvirt-dev \
    libxml2-dev \
    libxslt-dev \
    python-dev \
    python-libvirt \
    python-mysqldb \
    python-pip \
    qemu \
    tcpdump \
    tcptrace \
    tmux \
    vim-nox

pip install --upgrade pip docker-py graphviz gitpython
pip install --upgrade "ansible>=2" python-openstackclient python-neutronclient tox

usermod -aG docker vagrant
usermod -aG libvirtd vagrant
usermod -aG kvm vagrant

systemctl daemon-reload
systemctl enable docker
systemctl restart docker

apt-get clean
