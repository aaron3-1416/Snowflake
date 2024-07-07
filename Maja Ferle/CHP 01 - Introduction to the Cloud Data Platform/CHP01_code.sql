use role SYSADMIN;
create warehouse COMPUTE_WH with warehouse_size = 'X-Small';
grant usage on warehouse COMPUTE_WH to PUBLIC;

USE ROLE SECURITYADMIN;

CREATE role if not exists webmatch_administrator;
CREATE role if not exists webmatch_engineer;
CREATE role if not exists webmatch_analyst;
GRANT role webmatch_analyst TO role webmatch_engineer;
GRANT role webmatch_engineer TO role webmatch_administrator;

use database snowflake;
use schema account_usage;
CREATE ROLE IF NOT EXISTS ;
