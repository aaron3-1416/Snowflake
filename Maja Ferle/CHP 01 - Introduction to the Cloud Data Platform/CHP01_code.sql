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

-- Creación de jerarquía de roles
GRANT role webmatch_analyst TO role webmatch_engineer;
GRANT role webmatch_engineer TO role webmatch_administrator;

-- Profiling del rol de analista
-- USAGE on the schema and database so the user can use them
-- SELECT on all the tables that will be created in the schema
-- USAGE on a warehouse that can be used to query data
-- USE ROLE SECURITYADMIN;
GRANT USAGE ON DATABASE DB_WEBMATCH TO role webmatch_analyst;
GRANT USAGE ON SCHEMA DB_WEBMATCH.telemetry TO role webmatch_analyst;
GRANT SELECT ON FUTURE TABLES IN SCHEMA DB_WEBMATCH.telemetry TO ROLE webmatch_analyst;
GRANT USAGE ON WAREHOUSE VWH_TELEMETRY_ANALYSIS TO ROLE WEBMATCH_ANALYST;


-- Profiling del rol de engineer
-- CREATE TABLE and CREATE VIEW
-- INSERT privileges into those new tables and views
-- USAGE on a warehouse to perform etl
USE ROLE SECURITYADMIN;
GRANT INSERT ON FUTURE TABLES IN SCHEMA DB_WEBMATCH.telemetry TO ROLE WEBMATCH_ENGINEER;
GRANT CREATE TABLE,CREATE VIEW ON SCHEMA DB_WEBMATCH.telemetry TO ROLE WEBMATCH_ENGINEER;
GRANT USAGE ON WAREHOUSE VWH_TELEMETRY_ETL TO ROLE WEBMATCH_ENGINEER;



-- Profiling del rol de WEBMATCH_ADMINISTRATOR
-- El administrador debe poder crear stages en el
--esquema de telemetría para cargar datos telemétricos.
USE ROLE SECURITYADMIN;
GRANT CREATE STAGE ON SCHEMA DB_WEBMATCH.telemetry TO ROLE WEBMATCH_ADMINISTRATOR;



-- Creamos usuarios y controlamos la gestión de acceso a los recursos.
USE ROLE USERADMIN;
CREATE USER IF NOT EXISTS aaron_gonzalez WITH PASSWORD='aaron';
CREATE USER IF NOT EXISTS dinorah_zamora WITH PASSWORD='dinorah';
CREATE USER IF NOT EXISTS carla_cisneros WITH PASSWORD='carla';

USE ROLE SECURITYADMIN;
GRANT ROLE WEBMATCH_ADMINISTRATOR TO USER AARON_GONZALEZ;
GRANT ROLE WEBMATCH_ENGINEER TO USER DINORAH_ZAMORA;
GRANT ROLE WEBMATCH_ANALYST TO USER CARLA_CISNEROS;