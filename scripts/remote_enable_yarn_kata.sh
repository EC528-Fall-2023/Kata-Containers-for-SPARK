#!/bin/bash

# Make sure your host has enabled nest virtualization before enabling kata runtime

function install_kata_runtime {
    local kata_enabled=$(which kata-runtime | grep -i kata-runtime | wc -l)
    
    if [[ -n $kata_enabled ]]; then
        echo "Kata Runtime is installed, skip installing kata runtime."
        return
    fi

    echo "Installing Kata Runtime ..."

    if [[ ! -f "/tmp/kata-manager.sh" ]]; then
        echo "kata-manager.sh not found! Something must be wrong!" >&2
        exit 1
    fi
    
    sudo bash -c "/tmp/kata-manager.sh -o -f"
}

function kata_runtime_check {
    sudo kata-runtime check
    local ret=$?

    if [[ $ret -ne 0 ]]; then
        echo "Your host does not support Kata Runtime, please double check \
              the hypervisor enables nest virtualization and the host has the virtualization capability!" >&2
        exit 1
    fi
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

function enable_yarn_kata {
    install_kata_runtime
    kata_runtime_check

    setup_lce_permissions
    setup_hadoop_owners_lce
}

enable_yarn_kata