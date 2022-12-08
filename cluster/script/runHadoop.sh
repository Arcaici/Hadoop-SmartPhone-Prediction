#!/bin/bash

start-dfs.sh
start-yarn.sh
jps
hdfs dfsadmin -safemode leave
