

use role USERADMIN;
create role DATAENGINEER;
// El role dueño del securable object puede dar los grants.
use role accountadmin;
grant all on table CUSTOMER to role DATAENGINEER;
use role sysadmin;
grant usage on schema MARKETDATA to role DATAENGINEER;
grant usage on database REPORTING to role DATAENGINEER;
use role USERADMIN;
grant role DATAENGINEER to user SECONDUSER;
SHOW GRANTS ON schema marketdata;
SHOW GRANTS ON table customer;
select current_role() as "Mi rol actual";



use role USERADMIN;
grant role ANALYST to user SECONDUSER;
ALTER USER SECONDUSER SET DEFAULT_ROLE=ANALYST; => ERROR si uso USERADMIN
-- Use the owner role or its parent, or a role with MANAGE GRANTS privilege.
-- As discussed at https://docs.snowflake.com/en/user-guide/security-access-control-overview#systemdefined-roles, the USERADMIN role can manage users and roles that it owns

SHOW GRANTS ON ROLE ANALYST;
use role accountadmin;
alter user seconduser set default_role=analyst;
grant role analyst to user seconduser;

use role analyst;



grant select on table CUSTOMER to role ANALYST;
grant usage on schema MARKETDATA to role ANALYST;
grant usage on database REPORTING to role ANALYST;



use role SYSADMIN;
create database REPORTING;
create schema MARKETDATA;
create table CUSTOMER (
    c_custkey NUMBER(38,0) NOT NULL,
    c_name VARCHAR(40),
    c_address VARCHAR(255),
    c_country VARCHAR(3),
    c_mktsegment VARCHAR(255)
);



use role USERADMIN;
create role ANALYST;

drop user firstuser;

describe user seconduser;

alter user seconduser set email = 'user2@email.com';


create user SecondUser
  first_name = 'Second'
  last_name = 'User'
  display_name = 'Second User'
  password = 'Password456!'
  email = 'seconduser@email.com';



show parameters in account;

alter session set TIMEZONE = 'America/Mexico_City';
SELECT CURRENT_TIMESTAMP();

- To check your account timezone

-- To check your session timezone
SELECT CURRENT_TIMESTAMP();

show parameters like 'network_policy' in account;

show parameters like 'network_policy' in user aaronsnow03;

