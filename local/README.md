## Hadoop Local Configuration

Before going through these configuration you should already have configured a ssh connection, without password, to your localhost
and have downloaded Hadoop, Spark and Hive

In these configuration we used bigdata as our user name.

### Environment Variables

/home
```
  sudo nano .bashrc
```

Paste these env vars and change the below folder names with your Hadoop/Spark/Hive folder paths and names.
```
export HADOOP_DIR="{your-Hadoop-path}"
export HADOOP_CONF_DIR=$HADOOP_DIR/etc/hadoop
export SPARK_HOME="{your-Spark-path}2"
export HIVE_HOME={your-Hive-path}
export PATH=$PATH:$HIVE_HOME/bin
```

### HDFS Configuration

Inside: 
```
  cd {your-Hadoop-folder}/etc/hadoop
```

You need to configure different files.

#### core-site.xml file

This is HDFS filesystem namenode (Master).
```
<!--port: 9000, is default port-->
<configuration>
        <property>
                <name>fs.defaultFS</name>
                <value>hdfs://localhost:9000</value>
        </property>
</configuration>
```

#### hdfs-site.xml file

Here we are setting replication factor, namenode directory path, datanode directory path.
```
<configuration>
        <property>
                <name>dfs.replication</name>
                <value>3</value>
        </property>
        <property>
                <name>dfs.namenode.name.dir</name>
                <value>{your-folder-path}/hdfs/namenode/</value>
        </property>
        <property>
                <name>df.datanode.data.dir</name>
                <value>{your-folder-path}/hdfs/datanode/</value>
        </property>
</configuration>
```
 
 After these changes you MUST create the following folders:
```
 mkdir /{your-path}/hdfs
 mkdir /{your-path}/hdfs/namenode
 mkdir /{your-path}/hdfs/datanode
```

#### hadoop-env.sh file

Find  your JAVA path and then open hadoop-env.sh and add it to these lines below:
```
# The java implementation to use. By default, this environment
# variable is REQUIRED on ALL platforms except OS X!
#export JAVA_HOME={your-Java-path}
```

### YARN Configuration file

#### yarn-site.xml

In this file we setted up just two queues, dev and prod, because we want to implement capacity scheduler.
Usually in this configuration file we should add also resourceManager path, but since Hadoop is in local mode, the system presuppose that resourceManager is inside localhost.

```
<configuration>
        <property>
                <name>yarn.resourcemanager.scheduler.class</name>
		<value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler</value>
	</property>
        <property>
                <name>yarn.scheduler.capacity.root.queues</name>
                <value>prod,dev</value>
        </property>
        <property>
                <name>yarn.scheduler.capacity.prod.capacity</name>
                <value>0.5</value>
        </property>
        <property>
                <name>yarn.scheduler.capacity.dev.capacity</name>
                <value>0.5</value>
        </property>
        <property>
                <name>yarn.scheduler.capacity.prod.maximum-capacity</name>
                <value>0.7</value>
        </property>
        <property>
                <name>yarn.scheduler.capacity.dev.maximum-capacity</name>
                <value>0.5</value>
        </property>
</configuration>
```

### Last HDFS/YARN Configuration Step!

At this point, we need to format namenode.

Go to:
```
  cd {your-hadoop-folder}/bin
```

And run:
```
./hdfs namenode -format
```
Now we are all set for run Hadoop!

### Spark

Inside:
```
  cd /{your-Spark-path}/conf
```

#### spark-env.sh

At the end of the file paste your Hadoop, Yarn and Python path:
```
export HADOOP_CONF_DIR=/home/bigdata/hadoop-3.3.4/etc/hadoop/
export YARN_CONF_DIR=/home/bigdata/hadoop-3.3.4/etc/hadoop/
export PYSPARK_PYTHON=/home/bigdata/virtualenv/bin/python
```

In this case we used a virtual enviroment for install Python and all libraries.

#### workers

In this file we write only localhost, because Spark is in its local mode configuration.
```
localhost
```

Now we are all set for run Spark!

### Hive

Inside:
```
  cd /{your-hive-path}/bin
```
 
Go to hive-config.sh:
```
sudo nano  hive-config.sh
```

And add HADOOP_HOME path:
```
export HADOOP_HOME="{your-Hadoop-path}"
```

#### Create Hive directories

Create these directory inside HDFS file system and give permission to all.
```
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse
```

#### Guava Conflict

Some times Hive and Hadoop share same guava jar.
The solution is to remove guava from Hive and dowload the same version of it,
after just put the dowloaded version inside Hive jars folder.

#### Initialize schema

Go to:
```
  cd /{your-hive-path}/conf
```

And initialize database schema:
```
  schematool -initSchema -dbType derby
```
In our case we use derby database for testing purpose, we recommend to use another type, as MySQL that implement multi-client query mode too
