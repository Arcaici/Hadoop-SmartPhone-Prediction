#!/bin/bash

MY_PTH="/home/bigdata"

#removing previous querys
rm -r server/price_*

#deactive hadoop safemode
$HADOOP_DIR/bin/hdfs dfsadmin -safemode leave

#removing old data
$HADOOP_DIR/bin/hdfs dfs -rm /train.csv
$HADOOP_DIR/bin/hdfs dfs -rm -r /user/hive/warehouse/phone/

#load dataset
$HADOOP_DIR/bin/hdfs dfs -put $MY_PTH/input/train.csv / 

#entering on hive console
cd $HIVE_HOME/conf/

#launching hive querys from file (change bigdata with your user)
hive -f "/home/bigdata/input/hive_querys.sql"

cd
