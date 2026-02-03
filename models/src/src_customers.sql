{{
    config(
        materialized = 'incremental',
    )
}}
with raw_customers as (
    select * from {{source('poc_2_dbt', 'customers')}}
)
select
    ID as customer_id,
	first_name,
	last_name,
	address,
	TO_TIMESTAMP_NTZ(input_date) as input_date

from raw_customers