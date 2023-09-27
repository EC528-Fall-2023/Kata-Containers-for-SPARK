# Same as before
FROM ubuntu:20.04

# Set environment variables for Hadoop and Spark
ENV HADOOP_VERSION=3.3.6
ENV SPARK_VERSION=3.5.0
ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Install necessary packages and Java
RUN apt-get update && apt-get install -y \
    wget \
    openjdk-11-jdk \
    ssh \
    rsync \
 && apt-get clean

# Download and install Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
 && tar -xzf hadoop-$HADOOP_VERSION.tar.gz \
 && mv hadoop-$HADOOP_VERSION $HADOOP_HOME \
 && rm hadoop-$HADOOP_VERSION.tar.gz

# Download and install Spark
RUN wget https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz \
 && tar -xzf spark-$SPARK_VERSION-bin-hadoop3.tgz \
 && mv spark-$SPARK_VERSION-bin-hadoop3 $SPARK_HOME \
 && rm spark-$SPARK_VERSION-bin-hadoop3.tgz

# Configure Hadoop environment
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# Add other necessary configurations to Hadoop.
COPY core-site.xml $HADOOP_HOME/etc/hadoop/
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY yarn-site.xml $HADOOP_HOME/etc/hadoop/

# Expose necessary ports 
# 8088 for ResourceManager, 9870 for NameNode, 8042 for NodeManager, and 8080 for SparkMaster
EXPOSE 8088 9870 8042 8080
