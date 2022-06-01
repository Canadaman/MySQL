/* solution for task10
step 1: finding the first website_pageview_id for revlevant sessions
step 2: identifying the landing page for each session
step 3: counting pageviews for each session, to identify "bounced"
step 4: sumarizing by week (bounce rate, sessions to each lander) */

use mavenfuzzyfactory;
     -- this is the common query (step 3)
     
    select min(session_created_at) as week_start_date,
    	count(distinct case when count_pages = 1 then website_session_id else null end)*1.0 / count(distinct website_session_id) as bounced_rate,
        count(distinct case when landing_page = '/home' then website_session_id else null end) as home_sessions,
        count(distinct case when landing_page = '/lander-1' then website_session_id else null end) as lander_sessions
     from (
      --  this is the subquery of first level  (the begining og the step 2)
      Select 
	session_w_min_pv.website_session_id,
    session_w_min_pv.first_pageview_id,
    count_pages,
    webp.pageview_url as landing_page,
    webp.created_at as session_created_at
 from (
   --  this is the subquery of first level (the core of our used tables and restrictions) the begining of the step 1
   select 
   ws.website_session_id,
   min(wp.website_pageview_id) as first_pageview_id,
   count(wp.website_pageview_id) as count_pages
from website_sessions ws left join website_pageviews wp on ws.website_session_id = wp.website_session_id
where ws.created_at between '2012-06-01' and  '2012-08-31'
and ws.utm_source = 'gsearch'
and ws.utm_campaign = 'nonbrand'
group by ws.website_session_id
 -- the end of the step 1
) as session_w_min_pv left join website_pageviews webp on
     session_w_min_pv.first_pageview_id = webp.website_pageview_id 
     -- the end of the step 2
     ) as results
     group by yearweek(results.session_created_at);