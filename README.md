# Hadoop-SmartPhone-Prediction

## Introduction
The repo contains a client-server app that generates predictions and charts using a machine learning model, generated over Hadoop Framework using Apache Spark, and charts data originated by Apache Hive.

## Configuration

Configuration are available as README to:
* [Hadoop Local Mode](https://github.com/Arcaici/Hadoop-SmartPhone-Prediction/blob/main/local)
* [Hadoop Cluster Mode](https://github.com/Arcaici/Hadoop-SmartPhone-Prediction/tree/main/cluster)

## How to run
For run the project you need

### what to install
First you need to download [JPMML-SparkML jar](https://github.com/jpmml/jpmml-sparkml#features) and add it to spark jars folder. After jar download it's time to install [PySpark2PMML](https://github.com/jpmml/pyspark2pmml). Before Downloading and installing all pmml library please check wich Spark version you have and check on pmml documentation wich version is compatible with your. Remember to install numpy too, because is used by PysparkPMML.
  
### Change paths
In  both cluster and local folder, you can find a folder named script, inside there are the main scripts for run the project, those scripts are :

* runHadoop.sh
* runHive.sh
* runSparkAPP.sh
* runProject.sh

You need to run just **runProject.sh**, but before running it you should change al paths containend in the other scripts, like Hadoop, Apache and Hive paths and also Python path.
