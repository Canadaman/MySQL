-- Analyzing free channels
/*
Pull organic search, direct type in, and paid brand seach sessions by month, and ahow those sessions
as a % of paud search nonbrand 
 */


select Year(created_at) as year_at,
       month(created_at) as month_at,
       count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else null end) as nonbrand,
        count(distinct case when channel_group = 'paid_brand' then website_session_id else null end) as  brand,
        (count(distinct case when channel_group = 'paid_brand' then website_session_id else null end) /
         count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else null end))*100 as  brand_pct_of_nonbrand,
          count(distinct case when channel_group = 'direct_type_in' then website_session_id else null end) as direct,
         (count(distinct case when channel_group = 'direct_type_in' then website_session_id else null end) /
         count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else null end))*100 as  direct_pct_of_nonbrand,
         count(distinct case when channel_group = 'organic_search' then website_session_id else null end) as organic,
         (count(distinct case when channel_group = 'organic_search' then website_session_id else null end) /
         count(distinct case when channel_group = 'paid_nonbrand' then website_session_id else null end))*100 as  organic_pct_of_nonbrand
from

 -- the begining of the subquery
 (select 
   ws.website_session_id,
   ws.created_at,
   case
     when ws.utm_source is null and ws.http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
     when utm_campaign = 'nonbrand' then 'paid_nonbrand'
     when utm_campaign = 'brand' then 'paid_brand'
     when utm_source is null and ws.http_referer is null then 'direct_type_in'
     End As channel_group
	From website_sessions ws
    where ws.created_at < '2012-12-23')
    -- the end of subquery
    as session_w_channel_froup
    
    group by year_at, month_at;


