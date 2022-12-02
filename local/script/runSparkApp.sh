#!/bin/bash

MY_PTH="/home/bigdata"

#removing output
rm -r $MY_PTH/output
mkdir $MY_PTH/output

#deactive hadoop safemode
$HADOOP_DIR/bin/hdfs dfsadmin -safemode leave

#removing old data
$HADOOP_DIR/bin/hdfs dfs -rm /train.csv
$HADOOP_DIR/bin/hdfs dfs -rm -r /trained_model
$HADOOP_DIR/bin/hdfs dfs -rm -r /phone_prediction.py

#load model data
$HADOOP_DIR/bin/hdfs dfs -put $MY_PTH/input/train.csv / 
$HADOOP_DIR/bin/hdfs dfs -put $MY_PTH/input/phone_prediction.py / 

#run model.pmml generation by spark with phone_prediction.py script
$SPARK_HOME/bin/spark-submit --master yarn --queue prod ~/input/phone_prediction.py 

#save spark output to /home/user/output
$HADOOP_DIR/bin/hdfs dfs -get /trained_model/model $MY_PTH/output

#rename part-00001 (pmml result file) in pmml extention
cd output/model
mv part-00001 model.xml
mmv -v '*.xml' '#1.pmml'
cd


