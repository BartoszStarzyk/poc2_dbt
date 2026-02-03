{{
    config(
        materialized = 'incremental',
    )
}}
with raw_products as (
    select * from {{source('poc_2_dbt', 'products')}}
)
select
    id as product_id,
    product_name,
    price
from raw_products