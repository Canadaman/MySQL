use mavenfuzzyfactory;
create temporary table first_pageviews
Select 
  website_session_id,
  MIN(website_pageview_id) as   first_page
from  website_pageviews
where created_at < '2012-06-12'
group by website_session_id;

select wp.pageview_url as landing_page,
       count(distinct fp.website_session_id) as session_hitting_page
From  website_pageviews wp left join first_pageviews fp on wp.website_pageview_id = fp.first_page
group by landing_page
Having session_hitting_page > 0
order by session_hitting_page desc;


