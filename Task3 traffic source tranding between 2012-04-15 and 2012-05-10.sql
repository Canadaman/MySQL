use mavenfuzzyfactory;
Select 
-- year(ws.created_at) as yr,
-- week(ws.created_at) as wk,
count(distinct website_session_id) as sessions,
 min(date(ws.created_at)) as week_started_at
From website_sessions ws
where ws.created_at between '2012-04-15' and'2012-05-10'
and utm_source = 'gsearch'
and utm_campaign = 'nonbrand'
group by year(ws.created_at), week(ws.created_at)
