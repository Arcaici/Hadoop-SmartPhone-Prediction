## Hadoop Local Configuration

Before going through those configuration you should already have configured a ssh connection, without password, to your localhost
and have downloaded Hadoop, Spark and Hive

### Environment Variables

/home
```
  sudo nano .bashrc
```

Paste those env var and change the below folder names with your Hadoop/Spark/Hive folder path and names.
```
export HADOOP_DIR="/home/bigdata/hadoop-3.3.4"
export HADOOP_CONF_DIR=$HADOOP_DIR/etc/hadoop
export SPARK_HOME="/home/bigdata/spark-3.2.2"
export HIVE_HOME=/home/bigdata/apache-hive-2.3.9-bin
export PATH=$PATH:$HIVE_HOME/bin
```

### HDFS Configuration

Inside: 
```
  cd {your-hadoop-folder}/etc/hadoop
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
                <value>/home/bigdata/hdfs/namenode/</value>
        </property>
        <property>
                <name>df.datanode.data.dir</name>
                <value>/home/bigdata/hdfs/datanode/</value>
        </property>
</configuration>
```
 
 After those changes you MUST create the given folders:
```
 mkdir /{your-path}/hdfs
 mkdir /{your-path}/hdfs/namenode
 mkdir /{your-path}/hdfs/datanode
```

#### hadoop-env.shfile

Find  your JAVA path and then open hadoop-env.sh and find the lines below:
```
# The java implementation to use. By default, this environment
# variable is REQUIRED on ALL platforms except OS X!
#export JAVA_HOME=
```

should look something like this:
```
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

### YARN Configuration file

#### yarn-siste.xml

In this file we setted up jsut two queues, dev and prod , because we want to implement capacity scheduler.
Usualy in this configuration file we should add also resourcemanager path, but because is hadoop local mode,the system presuppose that it is inside localhost.

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

Now that Hadoop is setted up there is just one last step, we need to format namenode.

go to:
```
  cd {your-hadoop-folder}/bin
```

and run:
```
./hdfs namenode -format
```
Now we are all set for run Hadoop!

### Spark

Inside:
```
  cd /{your-spark-path}/conf
```

#### spark-env.sh

At the end of the file paste your hadoop, yarn and python path:
```
export HADOOP_CONF_DIR=/home/bigdata/hadoop-3.3.4/etc/hadoop/
export YARN_CONF_DIR=/home/bigdata/hadoop-3.3.4/etc/hadoop/
export PYSPARK_PYTHON=/home/bigdata/virtualenv/bin/python
```

In this case we used a virtual enviroment for install python and all libraries.

#### workers

In this file we will write just localhost because it's a local mode  configuration for spark.
```
localhost
```

Now we are all set for run Spark!

### Hive

Inside:
```
  cd /{your-hive-path}/bin
```
 
go to hive-config.sh:
```
sudo nano  hive-config.sh
```

and and HADOOP_HOME path:
```
export HADOOP_HOME="/home/bigdata/hadoop-3.3.4"
```

#### Creat Hive directories

Create those directory inside HDFS file system and give permission to all.
```
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse
```

#### Guava Conflicts

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

In our case we use derby database for testing purpose, we reccomend to use another type as MySQl that implement multi-client query mode too.
