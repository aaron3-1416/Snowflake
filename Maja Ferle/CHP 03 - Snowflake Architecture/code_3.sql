

use role USERADMIN;
create role DATAENGINEER;
// El role dueño del securable object puede dar los grants.
use role accountadmin;
grant all on table CUSTOMER to role DATAENGINEER;
grant usage on schema MARKETDATA to role DATAENGINEER;
grant usage on database REPORTING to role DATAENGINEER;
use role USERADMIN;
grant role DATAENGINEER to user SECONDUSER;



select * from SNOWFLAKE_SAMPLE_DATA.INFORMATION_SCHEMA.TABLES;

use role accountadmin;
create database SALES;
CREATE SCHEMA SALESDATA;


create table CUSTOMER (
    c_custkey NUMBER(38,0) NOT NULL,
    c_name VARCHAR(40),
    c_address VARCHAR(255),
    c_country VARCHAR(3),
    c_mktsegment VARCHAR(255)
);

create temporary table CUSTOMER_TEMP (
    c_custkey NUMBER(38,0) NOT NULL,
    c_name VARCHAR(40),
    c_address VARCHAR(255),
    c_country VARCHAR(3),
    c_mktsegment VARCHAR(255)
);


create transient table CUSTOMER_TRANSIENT (
    c_custkey NUMBER(38,0) NOT NULL,
    c_name VARCHAR(40),
    c_address VARCHAR(255),
    c_country VARCHAR(3),
    c_mktsegment VARCHAR(255)
);

SELECT * FROM SALES.INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='SALESDATA';

SHOW TABLES;


create view CUSTOMER_VIEW_US as
select
    c_custkey,
    c_name,
    c_address,
    c_country,
    c_mktsegment
from CUSTOMER
where c_country = 'US';



create function CUBED (x integer)
    returns integer
as
$$
    x * x * x
$$
;

select cubed(4);



create function CUSTOMERS_BY_MARKET_SEGMENT (segment varchar)
    returns integer
as
$$
    select count(c_custkey)
    from SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER
    where c_mktsegment = segment
$$
;

select CUSTOMERS_BY_MARKET_SEGMENT ('MACHINERY');


create table LOG_TABLE (log_ts timestamp, message varchar(255));
create or replace procedure COPY_CUSTOMER()
    returns integer
    language sql
    execute as caller
as
begin
    create or replace table CUSTOMER_COPY as
        select * from CUSTOMER;
    insert into LOG_TABLE (log_ts, message)
        values (CURRENT_TIMESTAMP(), 'Customer copy completed');
end;

call COPY_CUSTOMER();

SELECT * FROM LOG_TABLE;


create table CUSTOMERS_FOR_CDC (
    c_custkey NUMBER(38,0),
    c_name VARCHAR(40),
    c_address VARCHAR(255),
    c_country VARCHAR(3)
);
insert into CUSTOMERS_FOR_CDC
values (1, 'First Customer', 'Street One', 'US');
insert into CUSTOMERS_FOR_CDC
values (2, 'Second Customer', 'Street Two', 'US');

create stream CUSTOMERS_FOR_CDC_STREAM
on table CUSTOMERS_FOR_CDC;

select * from CUSTOMERS_FOR_CDC_STREAM;


insert into CUSTOMERS_FOR_CDC
values (3, 'Third Customer', 'Street Three', 'US');

select * from CUSTOMERS_FOR_CDC_STREAM;

update CUSTOMERS_FOR_CDC
set c_country = 'FR'
where c_custkey = 3;

select * from CUSTOMERS_FOR_CDC_STREAM;


update CUSTOMERS_FOR_CDC
set c_country = 'IN'
where c_custkey = 1;

select * from CUSTOMERS_FOR_CDC_STREAM;


create table CUSTOMERS_FINAL like CUSTOMERS_FOR_CDC;
insert into CUSTOMERS_FINAL
select c_custkey, c_name, c_address, c_country
from CUSTOMERS_FOR_CDC_STREAM
where METADATA$ACTION = 'INSERT';

SELECT * FROM CUSTOMERS_FINAL;


create task PERIODIC_COPY_CUSTOMER
  warehouse = COMPUTE_WH
  schedule = '5 MINUTE'
as
  call COPY_CUSTOMER()
;


CREATE TASK PERIODIC_COPY_CUSTOMER
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '5 MINUTE'
  AS
    call COPY_CUSTOMER()
;


execute task PERIODIC_COPY_CUSTOMER;

alter task PERIODIC_COPY_CUSTOMER resume;

select *
  from table(INFORMATION_SCHEMA.TASK_HISTORY())
  order by scheduled_time desc;

alter task PERIODIC_COPY_CUSTOMER suspend;

create sequence CUST_PK_SEQ;

select CUST_PK_SEQ.NEXTVAL;

create table CUSTOMER_WITH_PK (
    c_custkey NUMBER(38,0) DEFAULT CUST_PK_SEQ.NEXTVAL ,
    c_name VARCHAR(40),
    c_address VARCHAR(255),
    c_country VARCHAR(3)
);

insert into CUSTOMER_WITH_PK (c_name, c_address, c_country)
values ('First Customer', 'Street One', 'US');
insert into CUSTOMER_WITH_PK (c_name, c_address, c_country)
values ('Second Customer', 'Street Two', 'US');


select * from CUSTOMER_WITH_PK;




