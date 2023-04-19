#!/bin/bash

#Landing Zones in Linux and HDFS
LINUX_L_ER=/home/cloudera/covid_project/landing_zone/COVID_SRC_LZ_ER
HDFS_LZ_FIN=/user/cloudera/ds/COVID_HDFS_LZ_ER/


echo "GLOBAL Variables= " $LINUX_L_ER ", " $HDFS_LZ_FIN


hdfs dfs -mkdir -p $HDFS_LZ_FIN
echo "COVID_HDFS_LZ_ER CREATED sucessfully"


hdfs dfs -put $LINUX_L_ER/covid-19_c.csv $HDFS_LZ_FIN
echo "covid-19_c.csv dataset LOADED sucessfully"


