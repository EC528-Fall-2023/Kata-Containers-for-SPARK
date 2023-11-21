# Root Cause Analysis - Docker Bridge Network Issue (Spark on YARN)

## Background

Recently we have been stuck by the Docker bridge network issue for two sprints. We are able to submit Spark applications to YARN + Docker with host network being enabled, however, when we change the network to bridge, the Spark application was crashed due to a binding address error. We have to change the network to bridge because the Kata runtime cannot support the host network, so we have no choice but troublshooting this issue.

## Troubleshooting

After night by night debugging, we found the root cause is in Spark Executor, there is a bug in the Spark Executor that makes it bind to a wrong address instead of its local address when the bridge network is enabled.

It is very difficult to troubleshoot this kind of issue, because we first think it's something wrong in YARN, in fact it's caused by the incompatibility between YARN and Spark. To debug Spark, the current logs in Spark are somewhat not suffcient and we also need to add more logs in their source codes, every time we did this change, we need to rebuild it, each build may take at least 10 mintues, and we have rebuilt it for at least 20 times.

### Toubleshooting Steps
Here are the steps we performed to identify the root cause:
1. Enable all logs of Spark by setting `spark.log.level ALL` in `$SPARK_HOME/conf/spark-defaults.conf` 
2. Enable all logs of netty (the network library used by Spark) by setting:
   ```
   log4j.logger.org.apache.spark.network.netty.NettyBlockRpcServer=ALL
   logging.level.reactor.netty.http.client=DEBUG
   ```
   in `$SPARK_HOME/conf/log4j2.properties`
3. Based on the detailed logs, we found that the binding address error happens while creating a new Executor by `new Executor(executorId, hostname, env, getUserClassPath, isLocal = false, resources = _resources)` in `core/src/main/scala/org/apache/spark/executor/CoarseGrainedExecutorBackend.scala:176`
4. After further investigation, we found that the error message was raised from `startServiceOnPort[T] -> startService -> TransportContext::createServer -> new TransportServer(this, host, port, rpcHandler, bootstraps) -> TransportServer::init -> bootstrap.bind(address)` --> fail!
5. Then we found the hostname that the executors try to bind is the hostname of the VM host,
   1. Which is fine for host network, because the Docker container shares the network with the host when the host network is eanbled, however, as mentioned before, it is not supported by Kata runtime.
   2. In bridge network, this hostname causes problem because the executor is trying to bind an address that does not belong to it. Note in this case, the containers in the bridge network will have a separate network from the host, and this makes things clear, how can an application bind to a hostname/IP that is not its local address? 

You may ask why Spark Executor was given the hostname of the VM host?
> We believe it is because Spark is not aware of Docker network and containers, the current mechanism to determine the hostname of an executor needs to be enhanced to support Docker bridge network, or at least let the executors can use `SPARK_LOCAL_IP` environment variable if it is set, current implementation is not using `SPARK_LOCAL_IP` with the highest priority.

### Simple Illustration

![](./rca-dbn-diagram-host.svg)

![](./rca-dbn-diagram-bridge.svg)

## Workaround

To mitigate this issue, we simply let the executors bind to `0.0.0.0` to avoid the bind error.

In `spark/common/network-common/src/main/java/org/apache/spark/network/server/TransportServer.java::init`, do:
```java
InetSocketAddress address = new InetSocketAddress(portToBind);
channelFuture = bootstrap.bind(address);
```

![](./rca-dbn-04.png)

After the Spark rebuild done, simply run the following command:

```
HADOOP_HOME=/usr/local/hadoop
SPARK_HOME=/usr/local/spark
MOUNTS="$HADOOP_HOME:$HADOOP_HOME:ro,/etc/passwd:/etc/passwd:ro,/etc/group:/etc/group:ro"
IMAGE_ID="library/openjdk:8"

$SPARK_HOME/bin/spark-shell --master yarn \
    --conf spark.yarn.appMasterEnv.YARN_CONTAINER_RUNTIME_TYPE=docker \
    --conf spark.yarn.appMasterEnv.YARN_CONTAINER_RUNTIME_DOCKER_IMAGE=$IMAGE_ID \
    --conf spark.yarn.appMasterEnv.YARN_CONTAINER_RUNTIME_DOCKER_MOUNTS=$MOUNTS \
    --conf spark.yarn.appMasterEnv.YARN_CONTAINER_RUNTIME_DOCKER_CONTAINER_NETWORK=bridge \
    --conf spark.yarn.appMasterEnv.YARN_CONTAINER_RUNTIME_DOCKER_RUNTIME=kata \
    --conf spark.executorEnv.YARN_CONTAINER_RUNTIME_TYPE=docker \
    --conf spark.executorEnv.YARN_CONTAINER_RUNTIME_DOCKER_IMAGE=$IMAGE_ID \
    --conf spark.executorEnv.YARN_CONTAINER_RUNTIME_DOCKER_MOUNTS=$MOUNTS \
    --conf spark.executorEnv.YARN_CONTAINER_RUNTIME_DOCKER_CONTAINER_NETWORK=bridge \
    --conf spark.executorEnv.YARN_CONTAINER_RUNTIME_DOCKER_RUNTIME=kata
```

It should work without any errors.

## Screenshots
![](./rca-dbn-01.png)
![](./rca-dbn-02.png)
![](./rca-dbn-03.png)

## Action Items

- [ ] Check the most recent Spark source codes to see if this issue was fixed in a PR.
  - [ ] If not, we need to modify the Spark source codes to let executors be able to bind `SPARK_LOCAL_IP` if it is set and raise a PR to Spark official Github repo.