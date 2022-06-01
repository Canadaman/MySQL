/*
Analyzing impact of New Product Launch
She would like to see monthly order volume, overall conversion rates, revenue per session, and a breakdown
of sales by produc, all for the time period since April 1,2021
*/


 Select 
  year(ws.created_at) as year_at,
  month(ws.created_at) as month_at,
  count(distinct ws.website_session_id) as sessions,
  count(distinct o.order_id) as orders,
  (count(distinct o.order_id)/count(distinct ws.website_session_id))*100 as convert_rate,
  sum(o.price_usd)/count(distinct ws.website_session_id)  as revenue_per_session,
  count(distinct case when o.primary_product_id=1 then o.order_id else null end) as first_product_orders,
   count(distinct case when o.primary_product_id=2 then o.order_id else null end) as second_product__orders
 from website_sessions ws left join orders o on ws.website_session_id = o.website_session_id
 where ws.created_at between '2012-01-04' and '2013-05-04' -- specified in the request
 group by  year_at, month_at