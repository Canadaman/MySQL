
Select 
utm_content,
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders,
(count(distinct o.order_id)/count(distinct ws.website_session_id))*100 as session_to_conversion_rate
From website_sessions ws left join orders o on ws.website_session_id = o.website_session_id
where ws.created_at between '2014-01-01' and '2014-03-01'
Group by utm_content
order by sessions desc;