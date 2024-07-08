select current_role();
select current_warehouse();
use warehouse vhw_telemetry_analisys;
use database snowflake;
use schema ACCOUNT_USAGE;
SELECT * FROM WAREHOUSE_EVENTS_HISTORY;
SELECT * FROM WAREHOUSE_LOAD_HISTORY;
SELECT * FROM WAREHOUSE_METERING_HISTORY;