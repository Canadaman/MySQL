-- calculating bounce rates

-- step 1: finging the first wibsite_pageview_id for relevant session
-- step2: identify the landing page of each session
-- step3: counting pageviews for each session, to identify 'bounces'
-- step4: summarazing total sessions and bounced sessions, by LP (landing page)

-- finding the minimum website pageview id associated with each session we care about
create temporary table first_pageviews_demo
select wp.website_session_id, min(wp.website_pageview_id) as min_pageview_id
from website_pageviews wp inner join website_sessions ws on
							wp.website_session_id = ws.website_session_id
and ws.created_at between '2014-01-01' and '2014-02-01'
group by wp.website_session_id;

-- next, we will bring in the landing page to each session
create temporary table sessions_w_landing_page_demo
select fpd.website_session_id, webp.pageview_url as landing_page
from  first_pageviews_demo  fpd left join website_pageviews webp on fpd.min_pageview_id = webp.website_pageview_id;

-- next, we make a table to include a count of pageviews per session
 create temporary Table bounced_sessions_only

select  swlpd.website_session_id,
		swlpd.landing_page,
        count(website_pageviews.website_pageview_id) as count_of_pages_viewed
From sessions_w_landing_page_demo swlpd left join website_pageviews  on swlpd.website_session_id = website_pageviews.website_session_id

group by swlpd.website_session_id,
		swlpd.landing_page
Having count_of_pages_viewed = 1;

-- we will do this first , then we'll summarize with a count after;

select swd.landing_page,
	swd.website_session_id,
    bso.website_session_id as bounced_website_session_id
 from sessions_w_landing_page_demo swd left join bounced_sessions_only  bso on swd.website_session_id = bso.website_session_id
 
  order by swd.website_session_id;
  
  -- final output
		-- we will use the same query we previously ran, and run a count of records
        -- we will group by landing [age, and then we'll add a bounce rate column
        
	select swd.landing_page,
	count(distinct swd.website_session_id) as sessions,
    count(distinct bso.website_session_id) as bounced_sessions,
    (count(distinct bso.website_session_id)/count(distinct swd.website_session_id))*100 as rate_of_bounce
 from sessions_w_landing_page_demo swd left join bounced_sessions_only  bso on swd.website_session_id = bso.website_session_id
  group by swd.landing_page
  order by swd.website_session_id;