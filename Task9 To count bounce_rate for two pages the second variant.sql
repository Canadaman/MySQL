-- step 0: fiu=nd out when the new page/lander launched
-- step1: finding the first website_page_view_id for relevant sessions
-- step 2: identifying the landing page of each session
-- step 3: counting pageviews for each session, to identofy "bounces"
-- step 5: summarizing total sessions and bounced sessions, by landing page

use mavenfuzzyfactory;
 -- step 0
drop table nonbrand_test_sessions_w_landing_page;
drop table nonbrand_test_bounced_sessions;
 select  @first_ctreated_date =  
 min(wp.created_at),
  @first_page = min(wp.website_pageview_id)
 from website_pageviews wp
where wp.pageview_url = '/lander-1'
		and created_at is not null;
 create temporary table nonbrand_test_sessions_w_landing_page
select wp.website_session_id,
			min(wp.website_pageview_id) as min_pageview_id,
            wp.pageview_url
	 from website_pageviews wp inner join website_sessions ws on wp.website_session_id = ws.website_session_id
     and ws.created_at < '2012-07-28'  -- prescribed by the assignment
     and wp.website_pageview_id >= @first_page
     and ws.utm_source = 'gsearch'
     and ws.utm_campaign = 'nonbrand'
     and wp.pageview_url in ('/home', '/lander-1')
     group by wp.website_session_id,  wp.pageview_url;
     
-- step 3
create temporary table nonbrand_test_bounced_sessions
select 
       ntlp.website_session_id,
		ntlp.pageview_url,
        count(wp.website_pageview_id)  as count_of_pages_viewed
        from nonbrand_test_sessions_w_landing_page ntlp left join website_pageviews wp on ntlp.website_session_id = wp.website_session_id 
        group by ntlp.website_session_id,
		ntlp.pageview_url
        Having count_of_pages_viewed=1;
        
           -- finally
	select 
       nonbrand_p.pageview_url,
       count(distinct nonbrand_p.website_session_id) as sessions,
       count(distinct nonbrand_s.website_session_id) as bounced_sessions,
       (count(distinct nonbrand_s.website_session_id)/count(distinct nonbrand_p.website_session_id))*100 as bounced_rate
    From nonbrand_test_sessions_w_landing_page nonbrand_p left join 
		  nonbrand_test_bounced_sessions nonbrand_s on nonbrand_p.website_session_id = nonbrand_s.website_session_id 
     group by nonbrand_p.pageview_url;
     
        
        