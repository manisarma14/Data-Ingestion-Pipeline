SET hive.auto.convert.join.noconditionaltask.size=629145600;
SET tez.runtime.unordered.output.buffer.size-mb=200;
SET hive.exec.reducers.max=50;
SET tez.am.resource.memory.mb=4096;
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.merge.tezfiles=false;
SET hive.merge.mapfiles=false;
SET hive.merge.mapredfiles=false;

CREATE TEMPORARY TABLE network.T_STB_RESOLUTION_EVENTS_tmp as select
`table`,
op_type,
op_ts,
op_ts_ist,
current_ts,
pos,
after.STB_DEVICE_SERIAL_NUMBER,
after.STB_RESOLUTION_STATUS ,
after.STB_RESOLUTION_LATEST_TIMESTAMP ,
after.STB_RESOLUTION_STATUS_TIMESTAMP ,
after.JDAP_TS ,
current_timestamp() as jbdl_ts,
to_date(op_ts_ist) as partition_date from(
select
`table`,
op_type,
op_ts,
from_utc_timestamp(op_ts,"Asia/Kolkata") as op_ts_ist,
current_ts,
pos,
Case when op_type="D" then before else after end as after from network.mani_stb_resolution_staging)q1;

insert into table network.mani_T_STB_RESOLUTION_EVENTS_po partition (partition_date)
SELECT * FROM network.T_STB_RESOLUTION_EVENTS_tmp;

TRUNCATE TABLE network.mani_stb_resolution_staging;
