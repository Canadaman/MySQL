-- ASSIGNMENT_CALCULATING_BOUNCE_RATE

-- STEP1: findong the first website_pageview_id for relevant sessions
-- STEP2: identifying the landing page of each session
-- STEP3: counting pageviews for each session, to identify "bounces"alter
-- STEP4: summarizing by counting total sessions and bounced sessions

use mavenfuzzyfactory;
-- step 1

create temporary table first_pageviews
select 
	wp.website_session_id,
    min(wp.website_pageview_id) as min_pageview_id
  from website_pageviews wp
  where wp.created_at < '2012-06-14'
  group by wp.website_session_id;
   
-- step 2
create temporary table session_w_home_landing_page
select 
	fp.website_session_id,
    web_p.pageview_url as landing_page
from first_pageviews fp left join website_pageviews web_p on fp.min_pageview_id = web_p.website_pageview_id
where web_p.pageview_url = '/home';

 -- then a table to have count of pageviews per session
	-- then limit it to just bounced_sessions
 -- step 3
 
create temporary table bounced_sessions
 select 
		swlp.website_session_id,
        swlp.landing_page,
        count(webp.website_pageview_id) as count_of_pages_viewed
  from session_w_home_landing_page swlp left join website_pageviews webp on swlp.website_session_id = webp.website_session_id
  
  group by website_session_id,
        landing_page
  Having  count_of_pages_viewed = 1;     
        
        -- step 4
        -- we will do this first just to show what's in this query, then
        -- we'll count them all;
select 
	sp.website_session_id,
    bs.website_session_id as bounced_website_session_id
from session_w_home_landing_page sp left join bounced_sessions bs on
									sp.website_session_id = bs.website_session_id 
order by sp.website_session_id;

-- final output for Assignment_calculating_bounce_rates

 select 
   count( distinct sp.website_session_id) as total_sessions,
   count(distinct bs.website_session_id) as bounced_sessions,
   (count(distinct bs.website_session_id)/count( distinct sp.website_session_id))*100 as bounce_rate
  from session_w_home_landing_page sp left join bounced_sessions bs on
									sp.website_session_id = bs.website_session_id ;

  
  
  
