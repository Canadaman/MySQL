use mavenfuzzyfactory;
select  count(distinct ws.website_session_id) as sessions, utm_source, utm_campaign, http_referer,
count(distinct o.order_id) as orders, 
(count(distinct o.order_id)/ count(distinct ws.website_session_id))*100 as CVR
From website_sessions ws left join orders o  on ws.website_session_id=o.website_session_id
where ws.created_at < '2012-04-14'
and ws.utm_source='gsearch'
and ws.utm_campaign='nonbrand'
group by utm_source, utm_campaign, http_referer

order by sessions desc;



