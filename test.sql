-- -- use database poc_2_dbt;
-- -- use schema raw;
-- -- truncate raw_customers;
-- -- truncate raw_orders;
-- -- truncate raw_products;


-- select * from POC_2_DBT.RAW.RAW_products;

-- use database po
-- select SYSTEM$PIPE_STATUS('CUSTOMERS_PIPE');
-- ---- sprawdzic czy działa n razy
-- -- ALTER PIPE mydb.myschema.my_pipe
-- --     REFRESH FILES = ('path/to/file1.csv', 'path/to/file2.csv');
-- -- alter pipe customers_pipe refresh;

select count(*) from dev.order_addresses;