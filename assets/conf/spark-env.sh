### in conf/spark-env.sh ###

export SPARK_DIST_CLASSPATH=$(hadoop classpath)

export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop