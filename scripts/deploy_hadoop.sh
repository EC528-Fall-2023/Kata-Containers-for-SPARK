#!/bin/bash

# This script is intended for deploying hadoop cluster.
# You need the SSH access (user 'ubuntu') to all the provided nodes before running this script.
# You need to change "hadoop_nodes" file to include the information of all the nodes

. ./deploy_hadoop_functions.sh

function check_getopt {
    # Check if getopt exists and support enhanced features
    if [[ -z $(which getopt) ]]; then
        echo "Cannot find getopt, please either install it or add it into PATH!" >&2
        exit 1
    fi

    # Found getopt, checking if it supports enhanced features
    getopt -T
    local ret=$?
    if [[ $ret -ne 4 ]]; then
        echo "Found getopt but it does not support enhanced features, please make sure the enhanced version of getopt is installed!" >&2
        exit 1
    fi
}

function show_usage {
    usage="usage: $(basename "$0") [-h] [-f nodes_file] [-s] -- script to deploy Apache Hadoop YARN + Docker Cluster automatically

    -h      show the help document

    -f nodes_file
            specify the file that contains the information of all the nodes

    -s      if specified start the cluster after deployment being finished
    
    EXAMPLE 1:
    ./deploy_hadoop.sh -f hadoop_nodes -s"

    echo "$usage"
}

function parse_args {
    check_getopt

    local short_options='hvsf:k'
    local long_options='help,verbose,start-cluster,file:,enable-kata'

    local temp_opts=$(getopt --options $short_options --longoptions $long_options --name "$0" -- "$@")

    if [ $? -ne 0 ]; then
        echo 'Failed to parse args, terminating...' >&2
        exit 1
    fi

    # Note the quotes around "$temp_opts": they are essential!
    eval set -- "$temp_opts"
    unset temp_opts

    while true; do
        case "$1" in
            '-h'|'--help')
                show_usage
                exit 0
            ;;
            '-v'|'--verbose')
                echo 'Verbose Mode enabled'
                VERBOSE=1
                shift
                continue
            ;;
            '-f'|'--file')
                echo "Using nodes from file '$2'"
                NODES_CONFIG_FILE="$2"
                shift 2
                continue
            ;;
            '-s'|'--start-cluster')
                echo "Will start cluster after deployment being finished"
                START_CLUSTER=1
                shift
                continue
            ;;
            '-k'|'--enable-kata')
                echo "Will enable kata runtime for the cluster after deployment being finished"
                ENABLE_KATA=1
                shift
                continue
            ;;
            '--')
                shift
                break
            ;;
            *)
                echo 'Internal error!' >&2
                exit 1
            ;;
        esac
    done

    if [[ -n "$VERBOSE" ]]; then
        set -x
    fi

    # -f/--file is requried option
    if [[ -z "$NODES_CONFIG_FILE" ]]; then
        echo "nodes config file must be specified throught -f/--file!" >&2
        show_usage

        exit 1
    fi

    read_hadoop_nodes "$NODES_CONFIG_FILE"
}

function start_deploy {
    setup_hadoop_user_on_nodes
    set_envs_on_nodes
    setup_hosts_entries_on_nodes
    generate_master_pubkey
    distribute_master_pubkey_to_nodes

    setup_hadoop_yarn_on_nodes

    copy_hadoop_default_configs_to_nodes
    copy_spark_default_configs_to_nodes
    copy_docker_daemon_config_to_nodes
    restart_systemd_and_docker_daemon_on_nodes

    init_hdfs

    if [[ -z $ENABLE_KATA ]]; then
        enable_yarn_docker_on_nodes
    else
        copy_kata_manager_to_nodes
        enable_yarn_kata_on_nodes  
    fi

    on_deploy_finished

    if [[ -n "$START_CLUSTER" ]]; then
        stop_hadoop_cluster
        start_hadoop_cluster
    fi
}

function main {
    parse_args "$@"

    start_deploy
}

main "$@"