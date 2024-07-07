use role SYSADMIN;
create warehouse COMPUTE_WH with warehouse_size = 'X-Small';
grant usage on warehouse COMPUTE_WH to PUBLIC;
