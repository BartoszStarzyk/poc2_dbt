{{
    config(
        materialized = 'incremental',
    )
}}
with raw_orders as (
    select * from {{source('poc_2_dbt', 'orders')}}
)
select
    id as order_id,
    product_id,
    customer_id,
    quantity,
    TO_TIMESTAMP_NTZ(order_date) as order_date
from raw_orders