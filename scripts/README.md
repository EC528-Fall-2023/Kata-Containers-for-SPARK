# Usage of deploy_hadoop.sh

Run `deploy_hadooop.sh -h` to get usage information:
```
usage: deploy_hadoop.sh [-h] [-f nodes_file] [-s] -- script to deploy Apache Hadoop YARN + Docker Cluster automatically

    -h      show the help document

    -f nodes_file
            specify the file that contains the information of all the nodes

    -s      if specified start the cluster after deployment being finished
    
    EXAMPLE 1:
    ./deploy_hadoop.sh -f hadoop_nodes -s
```

Before running this script, you will need to:
1. Change `hadoop_nodes` file to include your own cluster nodes information. The information in `hadoop_nodes` file is quite simple, each row is `<node's name> <node's ip address>`
2. Make sure you have a user named `ubuntu` on each node, and the user `ubunut` is in sudoers (which means, it can run commands as a privilge user) and has set `NOPASSWD`.
3. Make sure your host has enabled nest virtualization (required by kata runtime).
4. Make sure your public key is in `authorized_keys` of user `ubuntu` in each node.