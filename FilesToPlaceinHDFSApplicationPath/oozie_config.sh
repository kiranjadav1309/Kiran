export appl1nameNode=hdfs://dev1hdp
export appl1jobTracker=<servername>:8050
export appl1resourceManager=<servername>:8050

export appl1JDBCUrl="jdbc:hive2://<servername>:2181,<servername>:2181,<servername>:2181/default;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2;transportMode=http;httpPath=cliservice;"
#export appl1JDBCUrl="jdbc:hive2://<servername>:10001/default;transportMode=http;httpPath=cliservice"
export appl1hs2Principal=hive/_HOST@domain.com
export appl1QueueName=default
export appl1HdpVersion=2.x.x.xx-x
export appl1ZeroCountTblVar=zeroCountTbl
export appl1SSHHost=<hostname>
export OozieURL=http://<ooziehost>:11000/oozie
