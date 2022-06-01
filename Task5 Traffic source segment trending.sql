use mavenfuzzyfactory;

select 
  -- year(ws.created_at),
 --  week(ws.created_at),
   min(date(ws.created_at)) as week_start_date,
    count(distinct case when device_type = 'desktop' then  ws.website_session_id else null end) as desktop_session,
    count(distinct case when device_type = 'mobile' then  ws.website_session_id else null end) as phone_session
  --  count(distinct ws.website_session_id) as total_session

from website_sessions ws
where ws.created_at between '2012-04-19' and '2012-06-09'
and utm_source = 'gsearch'
and utm_campaign = 'nonbrand'
group by year(ws.created_at),
   week(ws.created_at)