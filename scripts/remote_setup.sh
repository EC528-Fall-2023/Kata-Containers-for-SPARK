#!/bin/bash

# This script will be run by deploy_hadoop.sh on remote Hadoop nodes regardless of master or workers
# to initiate the necessary setup work.

HADOOP_USER='hadoop'

function install_hadoop {
    if [[ -d "$HADOOP_HOME" ]]; then
        return
    fi

    wget -q https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
    tar -xf hadoop-3.3.6.tar.gz
    sudo mv -f hadoop-3.3.6 "$HADOOP_HOME"
    rm hadoop-3.3.6.tar.gz
}

function install_jre {
    if [[ -d "$JAVA_HOME" ]]; then
        return
    fi

    wget -q https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u382-b05/OpenJDK8U-jre_x64_linux_hotspot_8u382b05.tar.gz
    tar -xf OpenJDK8U-jre_x64_linux_hotspot_8u382b05.tar.gz
    sudo mv -f jdk8u382-b05-jre "/usr/local/$JAVA_HOME"
    rm OpenJDK8U-jre_x64_linux_hotspot_8u382b05.tar.gz
}

function install_spark {
    if [[ -d "$SPARK_HOME" ]]; then
        return
    fi

    wget -q https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-without-hadoop.tgz
    tar -xf spark-3.5.0-bin-without-hadoop.tgz
    sudo mv -f spark-3.5.0-bin-without-hadoop "$SPARK_HOME"
    rm spark-3.5.0-bin-without-hadoop.tgz
}

function install_libssl {
    if [[ -f "/usr/lib/x86_64-linux-gnu/libcrypto.so.1.1" ]]; then
        return
    fi
    
    echo "libcrypto.so.1.1 not found, installing..."

    wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.19_amd64.deb
    sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2.19_amd64.deb
    rm libssl1.1_1.1.1f-1ubuntu2.19_amd64.deb

    echo "Done"
}

function revert_hadoop_owners_lce {
    sudo chown $HADOOP_USER:hadoop "$HADOOP_HOME"
    sudo chown $HADOOP_USER:hadoop "$HADOOP_HOME/etc"
    sudo chown $HADOOP_USER:hadoop "$HADOOP_HOME/etc/hadoop"
}

function setup_hadoop_yarn {
    install_hadoop
    install_jre
    install_spark
    install_libssl

    revert_hadoop_owners_lce
}

setup_hadoop_yarn