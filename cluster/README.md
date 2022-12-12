## Hadoop Cluster Configuration

Before going through these configuration you should already have configured a ssh connections, without password, between all your nodes
and you MUST download Hadoop in all machines(Master and Slaves), Spark and Hive.

### Environment Variables

**Both Machines**  
/home
```
  sudo nano .bashrc
```

Paste these env vars and change the below folder names with your Hadoop/Spark/Hive folder paths and names.
```
#Hadoop Path
export HADOOP_HOME="{your-Hadoop-path}"
#export HADOOP_CONF_DIR=$HADOOP_DIR/etc/hadoop
export HADOOP_INSTALL="{your-Hadoop-path}"
export PATH=$PATH:$HADOOP_INSTALL/bin
export PATH=$PATH:$HADOOP_INSTALL/sbin
export HADOOP_CONF_DIR="{your-Hadoop-path}/etc/hadoop"
export HDFS_NAMENODE_USER=bigdata
export HDFS_DATANODE_USER=bigdata
export HDFS_SECONDARYNAMENODE_USER=bigdata
export HADOOP_MAPRED_HOME="{your-Hadoop-path}"
export HADOOP_COMMON_HOME="{your-Hadoop-path}"
export HADOOP_HDFS_HOME="{your-Hadoop-path}"
export YARN_HOME="{your-Hadoop-path}"

#Java Path
export JAVA_HOME={your-Java-path}
export PATH=$PATH:$JAVA_HOME/bin

export SPARK_HOME="{your-Spark-path}"
```

**Only Master**
```
export HIVE_HOME={your-Hive-path}
export PATH=$PATH:$HIVE_HOME/bin
```

### HDFS Configuration

Inside: 
```
  cd {your-hadoop-path}/etc/hadoop
```

You need to configure different files.

#### core-site.xml file

**Master Machine**  
This is HDFS filesystem namenode.
```
<configuration>
        <property>
                <name>hadoop.tmp.dir</name>
                <value>{path-to-hdfs-folder}/hdfs/tmp</value>
        </property>
        <property>
                <name>fs.defaultFS</name>
                <value>hdfs://Node1:9820/</value>
                <description>NameNode URI</description>
        </property>
        <property>
                <name>io.file.buffer.size</name>
                <value>131072</value>
                <description>Buffer size</description>
        </property>
</configuration>
```

**Slave Machines**
```
<configuration>
	<property>
		<name>fs.defaultFS</name>
		<value>hdfs://Node1:9820/</value>
		<description>NameNode URI</description>
	</property>
</configuration>
```

#### hdfs-site.xml file

**Master Machine**  
Here we are setting replication factor, namenode directory path, datanode directory path.
```
<configuration>
        <property>
                <name>dfs.namenode.name.dir</name>
                <value>file://{path-to-hdfs-folder}/hdfs/namenode</value>
                <description>NameNode directory for namespace and transaction logs storage.</descrip>
        </property>
        <property>
                <name>dfs.datanode.data.dir</name>
                <value>file://{path-to-hdfs-folder}/hdfs/datanode</value>
                <description>DataNode directory</description>
        </property>
        <property>
                <name>dfs.replication</name>
                <value>3</value>
        </property>
        <property>
                <name>dfs.permissions</name>
                <value>false</value>
        </property>
        <property>
                <name>dfs.datanode.use.datanode.hostname</name>
                <value>false</value>
        </property>
        <property>
                <name>dfs.namenode.datanode.registration.ip-hostname-check</name>
                <value>false</value>
        </property>
</configuration>
```
 
**Slaves Machines**
```
<configuration>
	<property>
                <name>dfs.datanode.data.dir</name>
                <value>file://{path-to-hdfs-folder}/hdfs/datanode</value>
                <description>DataNode directory</description>
        </property>
        <property>
                <name>dfs.replication</name>
                <value>3</value>
        </property>
        <property>
                <name>dfs.permissions</name>
                <value>false</value>
        </property>
        <property>
                <name>dfs.datanode.use.datanode.hostname</name>
                <value>false</value>
        </property>
</configuration>
```

After these changes you MUST create the given folders on **Both Machines**:
```
 mkdir /{your-path}/hdfs
 mkdir /{your-path}/hdfs/namenode
 mkdir /{your-path}/hdfs/datanode
```

#### hadoop-env.sh file

**Both Machines**  
Find  your JAVA path and then open hadoop-env.sh, find the lines below and update them:
```
# The java implementation to use. By default, this environment
# variable is REQUIRED on ALL platforms except OS X!
export JAVA_HOME={your-Java-path}

# Location of Hadoop.  By default, Hadoop will attempt to determine
# this location based upon its execution path.
export HADOOP_HOME="{your-Hadoop-path}"

# Location of Hadoop's configuration information.  i.e., where this
# file is living. If this is not defined, Hadoop will attempt to
# locate it based upon its execution path.
#
# NOTE: It is recommend that this variable not be set here but in
# /etc/profile.d or equivalent.  Some options (such as
# --config) may react strangely otherwise.
#
export HADOOP_CONF_DIR="{your-Hadoop-path}/etc/hadoop"
```

update these lines too:
```
# Where (primarily) daemon log files are stored.
# ${HADOOP_HOME}/logs by default.
# Java property: hadoop.log.dir
export HADOOP_LOG_DIR="{your-Hadoop-path}/logs"
```

### YARN Configuration file

#### yarn-site.xml

**Master Machine**  
In this file we setted up just two queues, dev and prod, because we want to implement capacity scheduler.
Usually in this configuration file we add resourceManager path, but since this configuration belong to Master node, the system presuppose that the resourceManager is inside this machine.

```
<configuration>
        <property>
                <name>yarn.nodemanager.aux-services</name>
                <value>mapreduce_shuffle</value>
                <description>Yarn Node Manager Aux Service</description>
        </property>
        <property>
                <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
                <value>org.apache.hadoop.mapred.ShuffleHandler</value>
        </property>
        <property>
                <name>yarn.nodemanager.local-dirs</name>
                <value>file://{your-folder-path}/yarn/local</value>
        </property>
        <property>
                <name>yarn.nodemanager.log-dirs</name>
                <value>file://{your-folder-path}/yarn/logs</value>
        </property>
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

**Slave Machines**
```
<configuration>
	<property>
		<name>yarn.nodemanager.aux-services</name>
		<value>mapreduce_shuffle</value>
		<description>Yarn Node Manager Aux Service</description>
	</property>
</configuration>
```

#### workers 

Insert your nodeManagers ip:
```
ip NodeManager1
ip Nodemanager2
```

#### mapred-site.xml file

**Master Machine**  
Some configuration for MapReduce engine.
```
<configuration>
        <property>
                <name>mapreduce.framework.name</name>
                <value>yarn</value>
                <description>MapReduce framework name</description>
        </property>
        <property>
                <name>mapreduce.jobhistory.address</name>
                <value>Node1:10020</value>
                <description>Default port is 10020.</description>
        </property>
        <property>
                <name>mapreduce.jobhistory.webapp.address</name>
                <value> Node1:19888</value>
                <description>Default port is 19888.</description>
        </property>
        <property>
                <name>mapreduce.jobhistory.intermediate-done-dir</name>
                <value>/mr-history/tmp</value>
                <description>Directory where history files are written by MapReduce jobs.</descripti>
        </property>
        <property>
                <name>mapreduce.jobhistory.done-dir</name>
                <value>/mr-history/done</value>
                <description>Directory where history files are managed by the MR obHistory Server.</>
        </property>
        <property>
                <name>yarn.app.mapreduce.am.env</name>
                <value>HADOOP_MAPRED_HOME={your-Hadoop-path}</value>
        </property>
        <property>
                <name>mapreduce.map.env</name>
                <value>HADOOP_MAPRED_HOME={your-Hadoop-path}</value>
        </property>
        <property>
                <name>mapreduce.reduce.env</name>
                <value>HADOOP_MAPRED_HOME={your-Hadoop-path}</value>
        </property>
</configuration>
```

**Slaves Machines**
```
<configuration>
	<property>
		<name>mapreduce.framework.name</name>
		<value>yarn</value>
		<description>MapReduce framework name</description>
	</property>
</configuration>
```

### Last HDFS/YARN Configuration Step!

**Both Machines**  
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
export HADOOP_CONF_DIR={your-Hadoop-path}/etc/hadoop/
export YARN_CONF_DIR={your-Hadoop-path}/etc/hadoop/
export PYSPARK_PYTHON={your-Hadoop-path}/virtualenv/bin/python
```

In this case we used a virtual enviroment for install Python and all libraries.

#### workers

In this file we wrote our hosts ip
```
ip1
ip2
```

Now we are all set for run Spark!

### Hive

Inside:
```
  cd /{your-Hive-path}/bin
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

Create these directory inside HDFS filesystem and give permission to all.
```
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/hive/warehouse
```

#### Guava Conflict

Sometimes Hive and Hadoop share same guava jar.
The solution is to remove guava from Hive and download the same version of it,
after the download, just put the dowloaded version inside Hive jars folder.

#### Initialize schema

Go to:
```
  cd /{your-Hive-path}/conf
```

And initialize database schema:
```
  schematool -initSchema -dbType derby
```

In our case we use derby database for testing purpose, we recommend to use another type, as MySQL that implement multi-client query mode too.
