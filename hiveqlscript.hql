SET tez.grouping.min-size=250000000;
SET tez.grouping.max-size=1073741824;
SET mapred.reduce.tasks=-1;
SET tez.grouping.split-count=20;
SET hive.tez.container.size=4096;
SET tez.task.resource.memory.mb=4096;
SET tez.runtime.io.sort.mb=1638;
SET hive.auto.convert.join.noconditionaltask.size=629145600;
SET tez.runtime.unordered.output.buffer.size-mb=200;
SET hive.exec.reducers.max=50;
SET tez.am.resource.memory.mb=4096;
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.merge.tezfiles=false;
SET hive.merge.mapfiles=false;
SET hive.merge.mapredfiles=false;

CREATE TEMPORARY TABLE devices.T_STB_RESOLUTION_EVENTS_tmp as select
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
Case when op_type="D" then before else after end as after from devices.T_mani_STB_RESOLUTION_staging)q1;

insert into table devices.T_STB_RESOLUTION_EVENTS_po partition (partition_date)
SELECT * FROM devices.T_mani_STB_RESOLUTION_staging;

TRUNCATE TABLE devices.T_mani_STB_RESOLUTION_staging;
