#!/bin/bash

batchid=`cat /home/acadgild/project/logs/current-batch.txt`
LOGFILE=/home/acadgild/project/logs/log_batch_$batchid

echo "Creating mysql tables if not present.... " >> $LOGFILE
mysql -u root < /home/acadgild/project/scripts/create_schema.sql

echo "Running sqoop job for data export..." >>$LOGFILE

sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--P \
--table 'top_10_stations' \
--export-dir hdfs://localhost/user/hive/warehouse/project.db/top_10_stations/batchid=$batchid/part-m-00000 \
--input-fields-terminated-by ',' \
-m 1;
sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--table song_duration \
--export-dir hdfs://localhost/user/hive/warehouse/project.db/song_duration/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1;
sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--table top_10_royality_songs \
--export-dir hdfs://localhost/user/hive/warehouse/project.db/top_10_songs_maxrevenue/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1;

sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--table connected_artists \
--export-dir hdfs://localhost/user/hive/warehouse/project.db/connected_artists/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1;

sqoop export \
--connect jdbc:mysql://localhost/project \
--username 'root' \
--table top_10_unsubscribed_users \
--export-dir hdfs://localhost/user/hive/warehouse/project.db/top_10_unsubscribed_users/batchid=$batchid \
--input-fields-terminated-by ',' \
-m 1;

