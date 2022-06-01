use mavenfuzzyfactory;

create temporary table first_pageview

select 
 website_session_id,
 min(website_pageview_id) as min_pv_id

from  website_pageviews
where website_pageview_id < 1000 -- arbitrary
group by website_session_id;

