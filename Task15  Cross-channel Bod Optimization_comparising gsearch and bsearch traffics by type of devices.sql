-- Cross-channel Bod Optimization

Select device_type , utm_source,
count(distinct ws.website_session_id) as sessions,
count(distinct o.order_id) as orders,
(count(distinct o.order_id)/count(distinct ws.website_session_id))*100 as conv_rate
From website_sessions ws left join orders o on ws.website_session_id = o.website_session_id
where ws.created_at between '2012-08-22' and '2012-09-19' -- specified in the request
and utm_campaign = 'nonbrand'  -- limiting to nonbrand paid search
group by device_type ,utm_source
order by device_type ,utm_source