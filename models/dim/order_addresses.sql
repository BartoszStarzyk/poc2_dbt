with customer_history as (
    select * from {{ref('src_customers_snapshot')}}
),
orders as (
    select * from {{ref('src_orders')}}
),
products as (
    select * from {{ref('src_products')}}
)

select
    orders.order_id,
	orders.order_date,
	customer_history.address,
	products.product_name,
from 
orders join customer_history on orders.customer_id = customer_history.customer_id
    and
    (orders.order_date >= customer_history.dbt_valid_from and 
    (orders.order_date < customer_history.dbt_valid_to or customer_history.dbt_valid_to is null))
join products on orders.product_id = products.product_id
