use mavenfuzzyfactory;

Select 
  pageview_url,
  count(distinct website_pageview_id) as pvs
from  website_pageviews
where website_pageview_id < 1000 -- arbitrary
group by pageview_url
order by pvs desc;