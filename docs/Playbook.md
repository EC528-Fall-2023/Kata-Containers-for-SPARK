# Playbook

## Quick setup for Spark on Yarn cluster

### Add ssh pub key of Kata1 to other nodes

### Modify the host

add all ip addresses to the hosts on every node

```
x.x.x.x kata1
x.x.x.x kata2
.......
```

### Install Spark

you can actually do this only on master node

```sh
wget https://dlcdn.apache.org/spark/spark-3.5.0/spark-3.5.0-bin-hadoop3.tgz
tar -xvzf spark-3.5.0-bin-hadoop3.tgz
mv spark-3.5.0-bin-hadoop3.tgz /usr/local/spark
```

edit `~/.bashrc`

```bash
export SPARK_HOME=/usr/local/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
```

```sh
source ~/.bashrc
```

### Install Hadoop

This must be done on every node

https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz

```sh
wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xvzf hadoop-3.3.6.tar.gz
mv hadoop-3.3.6 /usr/local/hadoop
```

edit`~/.bashrc`

```bash
export HADOOP_HOME=/path/to/hadoop-3.x.x
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```

```sh
source ~/.bashrc
```

### Edit Hadoop

1. `$HADOOP_HOME/etc/hadoop/core-site.xml`

```xml
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://kata1:9000</value>
</property>
```
2. **Edit hdfs-site.xml (optional):** In `etc/hadoop/hdfs-site.xml`, add:

```xml
<property>
   <name>dfs.replication</name>
   <value>3</value>
</property>
```
3. **Edit mapred-site.xml:** In `etc/hadoop/mapred-site.xml`, add:

```xml
<property>
   <name>mapreduce.framework.name</name>
   <value>yarn</value>
</property>
```

4. **Edit yarn-site.xml:** In `etc/hadoop/yarn-site.xml`, add:

```xml
<property>
   <name>yarn.resourcemanager.hostname</name>
   <value>kata1</value>
</property>
```

5. **Edit workers (on master node):** In `etc/hadoop/workers`, add:

```
kata2
kata3
kata4
```

6. **Format HDFS (on master node):** Run the following command:

```sh
hdfs namenode -format
```

7. **Start the Cluster (on master node):**

```sh
start-dfs.sh
start-yarn.sh
```

### Submit Spark task

```sh
cd $SPARK_HOME
./bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode client --executor-memory 4g --num-executors 4 ./examples/jars/spark-examples*.jar 100
```

## Enable launching Docker containers

### Install Docker (all nodes)

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

```sh
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
sudo docker pull library/openjdk:8
```

### Enable Linux Container Executor

1. `yarn-site.xml`

```xml
<property>    
  <name>yarn.nodemanager.container-executor.class</name>
  <value>org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor</value>
  <description>
    This is the container executor setting that ensures that all applications
    are started with the LinuxContainerExecutor.
  </description>
</property>

<property>
  <name>yarn.nodemanager.linux-container-executor.group</name>
  <value>ubuntu</value>
</property>

<property>
  <name>yarn.nodemanager.linux-container-executor.nonsecure-mode.limit-users</name>
  <value>true</value>
</property>

<property>
  <name>yarn.nodemanager.linux-container-executor.nonsecure-mode.local-user</name>
  <value>ubuntu</value>
</property>
```

2. `container-executor.cfg`

```
yarn.nodemanager.linux-container-executor.group=ubuntu
allowed.system.users=hdfs,yarn,mapred,ubuntu
banned.users=root,bin
min.user.id=100
```

3. grant permissions

```sh
sudo chown root:ubuntu /usr/local/hadoop/bin/container-executor 
sudo chmod 6050 /usr/local/hadoop/bin/container-executor

sudo chown root:ubuntu /usr/local/hadoop/etc/hadoop/container-executor.cfg
sudo chmod 0400 /usr/local/hadoop/etc/hadoop/container-executor.cfg

sudo chown root:ubuntu /usr/local/hadoop
sudo chown root:ubuntu /usr/local/hadoop/etc
sudo chown root:ubuntu /usr/local/hadoop/etc/hadoop
```

