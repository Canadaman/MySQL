  -- Channel portfolio trends
  -- weekly session valume for gsearch and bsearch nonbrand, broken down by device
  
  select 
    yearweek(ws.created_at) as year_week, 
    min(date(ws.created_at)) as week_start_date,
    count(distinct case when utm_source ='gsearch' and device_type = 'desktop' then ws.website_session_id else null end) as gsearch_desktop_session,
    count(distinct case when utm_source ='bsearch' and device_type = 'desktop' then ws.website_session_id else null end) as bsearch_desktop_session,
    (count(distinct case when utm_source ='bsearch' and device_type = 'desktop' then ws.website_session_id else null end)/
		count(distinct case when utm_source ='gsearch' and device_type = 'desktop' then ws.website_session_id else null end) )*100 as B_pct_of_gtop,
    count(distinct case when utm_source ='gsearch' and device_type = 'mobile' then ws.website_session_id else null end) as gsearch_mobile_session,
    count(distinct case when utm_source ='bsearch' and device_type = 'mobile' then ws.website_session_id else null end) as bsearch_mobile_session,
     (count(distinct case when utm_source ='bsearch' and device_type = 'mobile' then ws.website_session_id else null end)/
		count(distinct case when utm_source ='gsearch' and device_type = 'mobile' then ws.website_session_id else null end) )*100 as B_pct_of_gmobile
   From website_sessions ws
   where ws.created_at between '2012-11-04' and '2012-12-22' -- specified in the request
   and ws.utm_campaign = 'nonbrand' -- limiting to nonbrand paid search
   
   group by year_week