#!/bin/bash

MY_PTH="/home/bigdata"

#removing previous querys
rm -r server/price_*

#deactive hadoop safemode
hdfs dfsadmin -safemode leave

#removing old data
hdfs dfs -rm /train.csv
hdfs dfs -rm -r /user/hive/warehouse/phone/

#load dataset
hdfs dfs -copyFromLocal $MY_PTH/input/train.csv /

#entering on hive console
cd $HIVE_HOME/conf/

#set mapred.job.queue.name=dev;

#launching hive querys from file (change bigdata with your user)
hive -f "/home/bigdata/input/hive_querys.sql"

cd
