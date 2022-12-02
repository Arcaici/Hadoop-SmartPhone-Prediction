#!/bin/bash

$HADOOP_DIR/sbin/start-dfs.sh
$HADOOP_DIR/sbin/start-yarn.sh

$HADOOP_DIR/bin/hdfs dfsadmin -safemode leave
