-- comparing channel charecteristics

Select utm_source,
count(distinct website_session_id) as sessions,
count(distinct case when device_type='mobile' then website_session_id else null end) as mobile_sessions,
(count(distinct case when device_type='mobile' then website_session_id else null end)/count(distinct website_session_id))*100 as pct_mobile
From website_sessions
where created_at between '2012-08-22' and '2012-11-30' -- specified in the request
and utm_campaign ='nonbrand' -- limiting to nonbrand paid search
group by utm_source