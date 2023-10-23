#!/bin/bash

function add_docker_apt_repo {
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get -y install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources:
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
}

function install_docker {
    # Install Docker Engine
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function setup_lce_permissions {
    # Required by https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/DockerContainers.html

    local lce_bin="$HADOOP_HOME/bin/container-executor"
    local lce_config="$HADOOP_HOME/etc/hadoop/container-executor.cfg"

    sudo chown root:hadoop "$lce_bin"
    sudo chown root:hadoop "$lce_config"

    sudo chmod 6050 "$lce_bin"
    sudo chmod 0400 "$lce_config"
}

function setup_hadoop_owners_lce {
    sudo chown root:hadoop "$HADOOP_HOME"
    sudo chown root:hadoop "$HADOOP_HOME/etc"
    sudo chown root:hadoop "$HADOOP_HOME/etc/hadoop"
}

function enable_yarn_docker {
    add_docker_apt_repo
    install_docker
    setup_lce_permissions
    setup_hadoop_owners_lce
}

enable_yarn_docker