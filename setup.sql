create or replace database POC_2_DBT;

create or replace schema POC_2_DBT.PUBLIC;

create or replace schema POC_2_DBT.RAW;

create or replace schema POC_2_DBT.DEV;


create or replace TABLE POC_2_DBT.RAW.RAW_CUSTOMERS (
	ID NUMBER(38,0),
	FIRST_NAME VARCHAR(16777216),
	LAST_NAME VARCHAR(16777216),
	ADDRESS VARCHAR(16777216),
	INPUT_DATE VARCHAR(16777216)
);

create or replace TABLE POC_2_DBT.RAW.RAW_ORDERS (
	ID NUMBER(38,0),
	CUSTOMER_ID NUMBER(38,0),
	PRODUCT_ID NUMBER(38,0),
	QUANTITY NUMBER(38,0),
	ORDER_DATE VARCHAR(16777216)
);
create or replace TABLE POC_2_DBT.RAW.RAW_PRODUCTS (
	ID NUMBER(38,0),
	PRODUCT_NAME VARCHAR(16777216),
	PRICE NUMBER(38,0)
);
CREATE OR REPLACE FILE FORMAT POC_2_DBT.PUBLIC.CSV_FILEFORMAT
	TYPE = csv
	FIELD_DELIMITER = ';'
	SKIP_HEADER = 1
	NULL_IF = ('NULL', 'null')
;

create or replace stage POC_2_DBT.PUBLIC.customers_stage
    url = 's3://poc2-bs/customers/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = POC_2_DBT.PUBLIC.csv_fileformat;

create or replace stage POC_2_DBT.PUBLIC.products_stage
    url = 's3://poc2-bs/products/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = POC_2_DBT.PUBLIC.csv_fileformat;

create or replace stage POC_2_DBT.PUBLIC.orders_stage
    url = 's3://poc2-bs/orders/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = POC_2_DBT.PUBLIC.csv_fileformat;

create or replace pipe POC_2_DBT.PUBLIC.CUSTOMERS_PIPE auto_ingest=true as COPY INTO RAW.RAW_customers
    FROM @POC_2_DBT.PUBLIC.customers_stage;
create or replace pipe POC_2_DBT.PUBLIC.ORDERS_PIPE auto_ingest=true as COPY INTO RAW.RAW_orders
    FROM @POC_2_DBT.PUBLIC.orders_stage;
create or replace pipe POC_2_DBT.PUBLIC.PRODUCTS_PIPE auto_ingest=true as COPY INTO RAW.RAW_products
    FROM @POC_2_DBT.PUBLIC.products_stage;