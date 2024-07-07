-- Creación de objetos
USE role SYSADMIN;

CREATE DATABASE DB_WEBMATCH;
CREATE SCHEMA DB_WEBMATCH.telemetry;
CREATE WAREHOUSE VWH_TELEMETRY_ETL WITH WAREHOUSE_SIZE='X-Small';
CREATE WAREHOUSE VWH_TELEMETRY_ANALYSIS WITH WAREHOUSE_SIZE='X-Small';
USE ROLE SECURITYADMIN;
grant usage on warehouse VWH_TELEMETRY_ETL to PUBLIC;
grant usage on warehouse VWH_TELEMETRY_ANALYSIS to PUBLIC;


-- Creación de roles
USE ROLE SECURITYADMIN;
CREATE role if not exists webmatch_administrator;
CREATE role if not exists webmatch_engineer;
CREATE role if not exists webmatch_analyst;

-- Creación dejerarquía de roles
GRANT role webmatch_analyst TO role webmatch_engineer;
GRANT role webmatch_engineer TO role webmatch_administrator;

-- Asignación de privilegios a los roles creados
GRANT USAGE ON DATABASE rocketship TO role rocketship_analyst;
GRANT USAGE ON SCHEMA rocketship.telemetry TO role rocketship_analyst;
GRANT SELECT ON ALL FUTURE TABLES IN SCHEMA rocketship.telemetry TO ROLE rocketship_analyst;
GRANT USAGE ON WAREHOUSE telemetry_analysis TO role rocketship_analyst;




use database snowflake;
use schema account_usage;
CREATE ROLE IF NOT EXISTS ;
