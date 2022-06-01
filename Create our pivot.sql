use mavenfuzzyfactory;

Select primary_product_id,
count(distinct case when items_purchased = 1 then order_id else null end) as orders_w_1_item,
count(distinct case when items_purchased = 2 then order_id else null end) as orders_w_2_item,
count(distinct order_id) as total_orders
from orders
where order_id between 31000 and 32000 -- arbitrary
group by primary_product_id
