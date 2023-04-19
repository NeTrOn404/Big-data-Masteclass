CREATE database covid_db_fin;

use covid_db_fin;

CREATE TABLE IF NOT EXISTS covid_db.covid_staging_fin 
( Country STRING, Total_Cases DOUBLE, New_Cases DOUBLE, Total_Deaths DOUBLE, New_Deaths DOUBLE, Total_Recovered DOUBLE, Active_Cases DOUBLE,
 Serious DOUBLE, Tot_Cases DOUBLE, Deaths DOUBLE, Total_Tests DOUBLE, Tests DOUBLE, CASES_per_Test DOUBLE, Death_in_Closed_Cases STRING,
 Rank_by_Testing_rate DOUBLE, Rank_by_Death_rate DOUBLE, Rank_by_Cases_rate DOUBLE, Rank_by_Death_of_Closed_Cases DOUBLE)
ROW FORMAT DELIMITED FIELDS TERMINATED by ',' STORED as TEXTFILE LOCATION '/user/cloudera/ds/COVID_HDFS_LZ_FIN' tblproperties ("skip.header.line.count"="1");



CREATE EXTERNAL TABLE IF NOT EXISTS covid_db.covid_ds_partitioned_fin
 ( Country STRING, Total_Cases DOUBLE, New_Cases DOUBLE, Total_Deaths DOUBLE, New_Deaths DOUBLE, Total_Recovered DOUBLE, Active_Cases DOUBLE,
 Serious DOUBLE, Tot_Cases DOUBLE, Deaths DOUBLE, Total_Tests DOUBLE, Tests DOUBLE, CASES_per_Test DOUBLE, Death_in_Closed_Cases STRING,
 Rank_by_Testing_rate DOUBLE, Rank_by_Death_rate DOUBLE, Rank_by_Cases_rate DOUBLE, Rank_by_Death_of_Closed_Cases DOUBLE)
 PARTITIONED BY (COUNTRY_NAME STRING) ROW FORMAT DELIMITED FIELDS TERMINATED by ',' LOCATION '/home/cloudera/ds/COVID_HDFS_PARTITIONED_FIN';


SET hive.exec.dynamic.partition.mode=nonstrict;


SET hive.exec.max.dynamic.partitions.pernode = 100000


FROM covid_db.covid_staging_fin INSERT INTO TABLE covid_db.covid_ds_partitioned_fin PARTITION(COUNTRY_NAME) SELECT *,Country WHERE Country is not null;


CREATE EXTERNAL TABLE covid_db.covid_output_fin( TOP_DEATH STRING, TOP_TEST STRING)
 PARTITIONED BY (COUNTRY_NAME STRING) ROW FORMAT DELIMITED FIELDS TERMINATED by ',' STORED as TEXTFILE LOCATION '/user/cloudera/ds/COVID_OUTPUT_FIN';


FROM covid_db.covid_staging_fin INSERT INTO TABLE covid_db.covid_output_fin PARTITION(COUNTRY_NAME) SELECT
 Rank_by_Death_rate, Rank_by_Testing_rate, Country WHERE Country is not null;



SET hive.io.output.fileformat = CSVTextFile;


INSERT OVERWRITE LOCAL DIRECTORY '/home/cloudera/covid_project/Output' SELECT * from covid_db.covid_output_fin;