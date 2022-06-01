-- step 0: fiu=nd out when the new page/lander launched
-- step1: finding the first website_page_view_id for relevant sessions
-- step 2: identifying the landing page of each session
-- step 3: counting pageviews for each session, to identofy "bounces"
-- step 5: summarizing total sessions and bounced sessions, by landing page

use mavenfuzzyfactory;
 -- step 0
select 
	min(wp.created_at) AS first_created_at,
    min(wp.website_pageview_id) as first_pageview_id
from website_pageviews wp

where wp.pageview_url = '/lander-1'
		and created_at is not null;
-- step 1
	-- first_created_at = '2012-06-19' , first_pageview_id = 23504
  create temporary table first_test_pageviews  
  select wp.website_session_id,
			min(wp.website_pageview_id) as min_pageview_id
  
     from website_pageviews wp inner join website_sessions ws on wp.website_session_id = ws.website_session_id
     and ws.created_at < '2012-07-28'  -- prescribed by the assignment
     and wp.website_pageview_id >= 23504
     and ws.utm_source = 'gsearch'
     and ws.utm_campaign = 'nonbrand'
     and wp.pageview_url in ('/home', '/lander-1')
     group by wp.website_session_id;
     
     
     
     -- next, we'll bring in the landing page to each session, like last time, but restrict to home or lander-1 this time
  -- then a table to have the count of pageviews per session
  --  then limit it to just bounced sessions 
  create temporary table nonbrand_test_sessions_w_landing_page
    select 
			ftp.website_session_id,
			wp.pageview_url as landing_page
     from first_test_pageviews ftp left join website_pageviews wp on ftp.min_pageview_id = wp.website_pageview_id
     where wp.pageview_url in ('/home', '/lander-1'); 
     
     -- step 3 
     create temporary table nonbrand_test_bounced_sessions
     select 
       ntlp.website_session_id,
		ntlp.landing_page,
        count(wp.website_pageview_id)  as count_of_pages_viewed
        from nonbrand_test_sessions_w_landing_page ntlp left join website_pageviews wp on ntlp.website_session_id = wp.website_session_id 
        group by ntlp.website_session_id,
		ntlp.landing_page
        Having count_of_pages_viewed=1;
        
        -- finally
	select 
       nonbrand_p.landing_page,
       count(distinct nonbrand_p.website_session_id) as sessions,
       count(distinct nonbrand_s.website_session_id) as bounced_sessions,
       (count(distinct nonbrand_s.website_session_id)/count(distinct nonbrand_p.website_session_id))*100 as bounced_rate
    From nonbrand_test_sessions_w_landing_page nonbrand_p left join 
		  nonbrand_test_bounced_sessions nonbrand_s on nonbrand_p.website_session_id = nonbrand_s.website_session_id 
     group by nonbrand_p.landing_page;
     
        
        