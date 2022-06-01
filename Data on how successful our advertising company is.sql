use mavenfuzzyfactory;

select  ws.utm_content , count(distinct ws.website_session_id) as sessions,
 count(distinct o.order_id) as orders,
(count(distinct o.order_id)/ count(distinct ws.website_session_id))*100 as session_to_order_conv_rt
from website_sessions ws
  left join orders o
    on ws.website_session_id = o.website_session_id
where ws.website_session_id between 1000 and 2000
group by ws.utm_campaign
order by sessions desc;