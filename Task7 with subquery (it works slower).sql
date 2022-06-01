Select wp.pageview_url as landing_page,
       count(distinct table1.website_session_id) as session_hitting_page
From  website_pageviews wp left join
(Select 
  website_session_id,
  MIN(website_pageview_id) as   first_page
from  website_pageviews
-- where created_at < '2012-06-12'
group by website_session_id) as table1 on wp.website_pageview_id = table1.first_page 
where created_at < '2012-06-12'
group by landing_page
Having session_hitting_page>0 ;