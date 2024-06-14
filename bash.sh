#!/bin/bash
hql_file=/home/dev_network_lsr/mani/hivescript.hql
connection_string="jdbc:hive2://nvmbdprp017346.bss.jio.com:2181,nvmbdprp017347.bss.jio.com:2181,nvmbdprp017348.bss.jio.com:2181/default;principal=hive/_HOST@DEVBDPRIL.COM;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2"

hdfs dfs -test -d /warehouse/tablespace/external/hive/network.db/mani_gg_parivartan/mani_STB_RESOLUTION_staging/json_data

if [ $? == 0 ]; then
echo "dir already exists, skipping mv"

beeline -u "$connection_string" -f "$hql_file" || exit 1

else
   echo "dir doesn't exists, mv-> run hql"

        hdfs dfs -mv /tmp/mani/json_data /warehouse/tablespace/external/hive/network.db/mani_gg_parivartan/mani_STB_RESOLUTION_staging/

        beeline -u "$connection_string" -f "$hql_file" || exit 1


fi
