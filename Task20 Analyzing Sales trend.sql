/*
Pull monthly trends to date for number of sales, total revenue, and total margin generated for the business
*/

use mavenfuzzyfactory;
 select year(o.created_at) as year_at,
		month(o.created_at) as month_at,
        count(distinct o.order_id) as number_of_orders,
        sum(o.price_usd) as total_of_revenue,
        sum(o.price_usd - o.cogs_usd) as total_of_margin
  From orders o
  where o.created_at < '2014-01-04' -- date of the request
  group by year(o.created_at),
		month(o.created_at)
