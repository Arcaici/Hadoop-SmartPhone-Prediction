# Hadoop-SmartPhone-Prediction

## Authors
- [Maiorani Simone](https://github.com/maioranisimone)
- [Venturi Marco](https://github.com/Arcaici)

## Introduction
The repo contains a Hadoop cluster configuration and a client-server app. The goal is to predict smartphone's price range using a machine learning model generated over Apache Spark, and visualize charts about smarphone statistics using data originated by Apache Hive.  
<img src="Images/Logo for Spark.svg" width="105">  <img src="Images/Logo for Hive.svg" width="105">  

## Hadoop Configuration

The application is tested in both local and cluster modes.  
We used [ZeroTier](https://www.zerotier.com/) to connect our two machines.  

These configuration are available as README to:
* [Hadoop Local Mode](https://github.com/Arcaici/Hadoop-SmartPhone-Prediction/blob/main/local)
* [Hadoop Cluster Mode](https://github.com/Arcaici/Hadoop-SmartPhone-Prediction/tree/main/cluster)

## How to run it
For run the project you need these packages:
* NumPy library
* [JPMML-SparkML jar](https://github.com/jpmml/jpmml-sparkml#features)
* [PySpark2PMML](https://github.com/jpmml/pyspark2pmml)
* [OpenScoring Server](https://openscoring.io/#overview)
* Node.js
* Google Chrome

### How to do it
First, you need to download [JPMML-SparkML jar](https://github.com/jpmml/jpmml-sparkml#features) and add it to Spark jars folder. After downloading it, you can install [PySpark2PMML](https://github.com/jpmml/pyspark2pmml). Before downloading and installing all pmml libraries please check which Spark version you have, you can check on pmml documentation which version is compatible with yours. Remember to install numpy too, because is used by PysparkPMML.
 
The project use Google Chrome to open the client because it consents to manage CORS policy.

### Change paths
In both cluster and local folders, you can find a folder named script, inside there are the main scripts for launch the project.  
These scripts are:

* runHadoop.sh
* runHive.sh
* runSparkAPP.sh
* runProject.sh

You need to run just **runProject.sh**, but before running it you should change all paths containend in the other scripts, like Hadoop, Spark and Hive paths and Python path too.
