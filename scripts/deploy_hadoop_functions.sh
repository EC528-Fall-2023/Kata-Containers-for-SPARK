#!/bin/bash

LOCAL_KEY_PRI=$HOME/.ssh/id_ed25519
LOCAL_KEY_PUB=$HOME/.ssh/id_ed25519.pub
INIT_USER='ubuntu'
HADOOP_USER='hadoop'

function read_hadoop_nodes {
    local nodes_config_file=$1

    NODES=($(cat "$nodes_config_file" | awk '{ print $2 }'))
    MASTER=$(cat "$nodes_config_file" | grep master | awk '{ print $2 }')
    WORKERS=($(cat "$nodes_config_file" | grep worker | awk '{ print $2 }'))
}

function run_remote_cmd {
    local user
    local host
    local command

    if [[ "$1" = "$INIT_USER" ]]; then
        user="$1"
        host="$2"
        command="$3"

        ssh "$user@$host" "$command"
    else
        user="$HADOOP_USER"
        host="$1"
        command="$2"

        ssh -i $LOCAL_KEY_PRI "$user@$host" "bash --login -c '$command'"
    fi
}

function run_remote_script {
    local user=$1
    local host=$2
    local file=$3

    ssh -i $LOCAL_KEY_PRI "$user@$host" "bash -l -s" < $file
}

function setup_hadoop_user_on_nodes {
    # We need to do these steps from local host to remote hosts first,
    # so we can login as HADOOP_USER later to execute remote_setup.sh

    echo "Setting up hadoop user on all nodes"

    for node in "${NODES[@]}"; do
        # Create hadoop user
        echo "Creating user 'hadoop'..."
        run_remote_cmd "$INIT_USER" "$node" "sudo useradd -m $HADOOP_USER"
        echo "Done"

        # Set hadoop user as a sudoer
        echo "Setting user 'hadoop' as a sudoer..."
        run_remote_cmd "$INIT_USER" "$node" "sudo adduser $HADOOP_USER sudo"
        echo "Done"
        
        # Set NOPASSWD for hadoop user
        echo "Removing sudo password requirement for user 'hadoop'..."
        run_remote_cmd "$INIT_USER" "$node" "sudo bash -c \"echo '$HADOOP_USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$HADOOP_USER\""
        echo "Done"
    done

    distribute_local_pubkey_to_nodes

    echo "All done"
}

function set_envs_on_nodes {
    # Do these steps from local host to remote hosts so that
    # we do not need to source ~/.bashrc and ~/.profile

    # Using Heredoc, <<- cannot remove leading whitespace, it can only remove tabs
    # so we have to keep it in this ugly shape.
    # The delimiter is EOF

    echo "Setting envrionment variables on all nodes..."

    local vars=$(
cat <<- EOF
JAVA_HOME=/usr/local/jre8
HADOOP_HOME=/usr/local/hadoop
SPARK_HOME=/usr/local/spark
PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$SPARK_HOME/bin:\$SPARK_HOME/sbin:\$JAVA_HOME/bin:\$PATH
EOF
)
    
    # Append environment variables to each node's ~/.bashrc and ~/.profile
    local hadoop_env_set
    for node in "${NODES[@]}"; do
        hadoop_env_set=$(run_remote_cmd "$node" "cat \$HOME/.bashrc | grep HADOOP_HOME | wc -l")

        if [[ hadoop_env_set -ge 1 ]]; then
            continue
        fi

        run_remote_cmd "$node" "echo '$vars' | tee -a \$HOME/.bashrc \$HOME/.profile > /dev/null"
    done

    echo "Done"
}

function generate_master_pubkey {
    echo "Generating ssh key on master node..."

    local has_key
    has_key=$(run_remote_cmd  "$MASTER" "ls \$HOME/.ssh/id_ed25519" | wc -l)

    if [[ $has_key -ge 1 ]]; then
        return
    fi

    run_remote_cmd "$MASTER" "ssh-keygen -t ed25519 -f \$HOME/.ssh/id_ed25519 -q -N ''"

    echo "Done"
}

function setup_hosts_entries_on_nodes {
    echo "Setting hosts entries on nodes..."

    local hosts_entries=("$MASTER kata-master")

    for i in "${!WORKERS[@]}"; do
        hosts_entries+=("$node kata-worker-$i")
    done

    # Join hosts entries by ","
    hosts_entries_joined=$(printf ",%s" "${hosts_entries[@]}")
    hosts_entries_joined=${hosts_entries_joined:1}
    # Hosts entries line by line
    hosts_entries_joined=$(echo "${hosts_entries_joined}" | tr ',' '\n')

    for node in "${NODES[@]}"; do
        local n=$(run_remote_cmd "$node" "cat /etc/hosts | grep \"$hosts_entries_joined\" | wc -l")

        if [[ $n -ge 1 ]]; then
            continue
        fi

        run_remote_cmd "$node" "sudo bash -c \"echo '$hosts_entries_joined' >> /etc/hosts\""
    done

    echo "Done"
}

function distribute_master_pubkey_to_nodes {
    echo "Distributing master's public key to nodes..."

    local master_pubkey
    local pubkey_exists
    master_pubkey=$(run_remote_cmd "$MASTER" "cat \$HOME/.ssh/id_ed25519.pub")
    for node in "${NODES[@]}"; do
        pubkey_exists=$(run_remote_cmd "$INIT_USER" "$node" "sudo cat /home/$HADOOP_USER/.ssh/authorized_keys | grep \"$master_pubkey\" | wc -l")
        if [[ pubkey_exists -ge 1 ]]; then
            continue
        fi
        run_remote_cmd "$INIT_USER" "$node" "sudo bash -c \"echo '$master_pubkey' >> /home/$HADOOP_USER/.ssh/authorized_keys\""
    done

    echo "Done"
}

function distribute_local_pubkey_to_nodes {
    echo "Distributing local host public key to nodes..."
    
    local local_pubkey
    local_pubkey=$(cat $LOCAL_KEY_PUB)
    
    local pubkey_exists
    for node in "${NODES[@]}"; do
        pubkey_exists=$(run_remote_cmd "$INIT_USER" "$node" "sudo cat /home/$HADOOP_USER/.ssh/authorized_keys | grep \"$local_pubkey\" | wc -l")
        if [[ pubkey_exists -ge 1 ]]; then
            continue
        fi

        run_remote_cmd "$INIT_USER" "$node" "sudo bash -c \"echo '$local_pubkey' >> /home/$HADOOP_USER/.ssh/authorized_keys\""
    done

    echo "Done"
}

function copy_hadoop_default_configs_to_nodes {
    echo "Copying Hadoop preconfigured configs to all nodes..."

    for node in "${NODES[@]}"; do
        scp -q -i $LOCAL_KEY_PRI -r "../assets/etc/hadoop" "$HADOOP_USER@$node:/tmp/hadoop_configs"
        run_remote_cmd "$node" "sudo mv -f /tmp/hadoop_configs/hadoop/* \$HADOOP_HOME/etc/hadoop/"
    done

    echo "Done"
}

function copy_spark_default_configs_to_nodes {
    echo "Copying Spark preconfigured configs to all nodes..."

    for node in "${NODES[@]}"; do
        scp -q -i $LOCAL_KEY_PRI -r "../assets/conf/spark/spark-env.sh" "$HADOOP_USER@$node:/tmp/spark-env.sh"
        run_remote_cmd "$node" "sudo mv -f /tmp/spark-env.sh \$SPARK_HOME/conf/"
    done

    echo "Done"
}

function copy_docker_daemon_config_to_nodes {
    echo "Copying docker daemon.json to all nodes..."

    for node in "${NODES[@]}"; do
        scp -q -i $LOCAL_KEY_PRI "../assets/etc/docker/daemon.json" "$HADOOP_USER@$node:/tmp/daemon.json"
        run_remote_cmd "$node" "sudo mv -f /tmp/daemon.json /etc/docker/"
    done

    echo "Done"
}

function restart_systemd_and_docker_daemon_on_nodes {
    echo "Restarting systemd and docker daemon on all nodes..."

    for node in "${NODES[@]}"; do
        run_remote_cmd "$node" "sudo systemctl daemon-reload"
        run_remote_cmd "$node" "sudo systemctl restart docker.service"
    done

    echo "Done"
}

function setup_hadoop_yarn_on_nodes {
    echo "Running remote_setup.sh on all nodes"

    for node in "${NODES[@]}"; do
        run_remote_script $HADOOP_USER $node "remote_setup.sh"
    done

    echo "Done"
}

function enable_yarn_docker_on_nodes {
    echo "Running remote_enable_yarn_docker.sh on all nodes"

    for node in "${NODES[@]}"; do
        run_remote_script $HADOOP_USER $node "remote_enable_yarn_docker.sh"
    done

    echo "Done"
}

function on_deploy_finished {
    echo "Deploying Hadoop Cluster completed!"
}

function init_hdfs {
    stop_hadoop_cluster

    echo "Formatting Hadoop Cluster HDFS..."

    for node in "${NODES[@]}"; do
        run_remote_cmd "$node" "rm -rf /home/hadoop/data/"
    done

    run_remote_cmd "$MASTER" "hdfs namenode -format -force"

    echo "Done"
}

function stop_hadoop_cluster {
    echo "Stopping Hadoop Cluster..."

    echo "Stopping HDFS..."
    run_remote_cmd "$MASTER" "stop-dfs.sh"

    echo "Stopping YARN..."
    run_remote_cmd "$MASTER" "stop-yarn.sh"

    echo "Done"
}

function start_hadoop_cluster {
    echo "Starting Hadoop Cluster..."

    echo "Starting HDFS..."
    run_remote_cmd "$MASTER" "start-dfs.sh"

    echo "Starting YARN..."
    run_remote_cmd "$MASTER" "start-yarn.sh"

    echo "Done"
}