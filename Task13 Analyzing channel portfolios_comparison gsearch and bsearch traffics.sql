
Select 
 Year(created_at) as Year_at,
 min(date(created_at)) as week_start_date,
 count(distinct website_session_id) as total_session,
  count(distinct case when utm_source = 'gsearch' then  website_session_id else null end) as gsearch_sessions,
  count(distinct case when utm_source = 'bsearch' then  website_session_id else null end) as bsearch_sessions
From website_sessions
where created_at between '2012-08-22' and '2012-11-29'
and utm_campaign = 'nonbrand'
group by yearweek(created_at)