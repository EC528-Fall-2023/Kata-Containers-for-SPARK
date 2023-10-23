#!/bin/bash

# This script will be run by deploy_hadoop.sh on remote Hadoop nodes regardless of master or workers
# to initiate the necessary setup work.

function download_and_extract_hadoop {
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
    tar -xf hadoop-3.3.6.tar.gz
}

function download_and_extract_jre {
    wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u382-b05/OpenJDK8U-jre_x64_linux_hotspot_8u382b05.tar.gz
    tar -xf OpenJDK8U-jre_x64_linux_hotspot_8u382b05.tar.gz

    mv jdk8u382-b05-jre jre8
}

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
    sudo chmod 0400 "$lce_bin"
}

function setup_yarn_docker {
    download_and_extract_hadoop
    download_and_extract_jre

    add_docker_apt_repo
    install_docker
    setup_lce_permissions
}