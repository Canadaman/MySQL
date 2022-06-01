/*
Let's look at sessions which hit the/products page and see where they went next.
Pull clickthrough rates from/products since the new product launch of January 6th 2013, 
by product, and compare to the 3 months leading up to launch as a baseline
Assigment product pathing analysis

Step 1: find the relevant /products pageviews with website_session_id
Step 2: find the next pageview id that occurs /after the product pageview
Step 3: find the pageview_url associated with any applicable next pageview id
Step 5: summarize the data and analyze the pre vs post periods
*/
drop table session_next_pageview_url;
create temporary table session_next_pageview_url
Select 
  session_next_pageview.time_period,
  session_next_pageview.website_session_id,
  w_p.pageview_url as next_pageview_url
From 
( -- the begining of subquery level 1
Select 
  products_pageviews.time_period,
  products_pageviews.website_session_id,
  min(webp.website_pageview_id) as min_next_pageview_id
 from
( -- The begining of subquery level 0
select wp.website_session_id,
       wp.website_pageview_id,
       wp.created_at,
       case
		when wp.created_at < '2013-01-06' then 'A.Preproduct_2'
        when wp.created_at >= '2013-01-06' then 'B.postproduct_2'
        else 'This is an exception, you need to check your data'
        end as time_period
 From website_pageviews wp
 where wp.created_at  between '2012-10-06' and  '2013-04-06' -- date of request, start of 3 month before product 2 lauch
 and wp.pageview_url ='/products'
 -- the end of subquery level 0
 ) as products_pageviews  left join website_pageviews webp on  products_pageviews.website_session_id = webp.website_session_id
 and webp.website_pageview_id > products_pageviews.website_pageview_id
 group by products_pageviews.time_period,
  products_pageviews.website_session_id
  -- the end of subquery level 1
  ) as session_next_pageview left join website_pageviews w_p on session_next_pageview.min_next_pageview_id = w_p.website_pageview_id;
  
  -- just to show distinct next pageview urls
  -- Finally, summarize the data and analyze the pre and post periods
  
  select 
  session_next_pageview_url.time_period,
  count(distinct website_session_id) as sessions,
  count( distinct case when next_pageview_url is not null then website_session_id else null end) as w_next_pg,
  count( distinct case when next_pageview_url is not null then website_session_id else null end)/ count(distinct website_session_id) as pct_w_next_pg,
  count( distinct case when next_pageview_url= '/the-original-mr-fuzzy' then website_session_id else null end) as to_mr_fuzzy,
  count( distinct case when next_pageview_url= '/the-original-mr-fuzzy' then website_session_id else null end)/count(distinct website_session_id) as pct_to_mrfuzzy,
  count( distinct case when next_pageview_url= '/the-forever-love-bear' then website_session_id else null end) as to_love_bear,
  count( distinct case when next_pageview_url= '/the-forever-love-bear' then website_session_id else null end)/count(distinct website_session_id) as pct_to_love_bear
   From session_next_pageview_url
  group by session_next_pageview_url.time_period;
  
