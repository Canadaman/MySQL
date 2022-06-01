use mavenfuzzyfactory;
/*
Product conversion funnels
She'd like to look at our two products sinxe January 6th and
analyze the conversion funnels from each product page to convertion. 
Produce a comparison between the two conversion funnels, for all website traffic
Step 1: select all pageviews for relevant sessions
Step 2: figure out which pageview urls to look for
Step 3: pull all pageviews and identify the funnel steps
Step 4: create the session-level conversion funnel view
Step 5: aggregate the data to assess funnel performance
*/
-- finding the right pageview_urls to build the funnels
Select distinct pageview_url
From 
(
-- the begining of subquery level 0 
Select wp.website_session_id,
		wp.website_pageview_id,
        wp.pageview_url as product_page_seen
 From website_pageviews wp
 where wp.created_at between '2013-01-06' and '2013-04-10' -- specified by the task
 and wp.pageview_url in ('/the-original-mr-fuzzy','the-forever-love-bear')
 -- the end of subquery level 0
 ) as session_seeing_product_pages left join website_pageviews webp on
								session_seeing_product_pages.website_session_id = webp.website_session_id
	and session_seeing_product_pages.website_pageview_id < webp.website_pageview_id;
    
    -- we'll look at the inner query first to look over the pageview-level results
    -- then, turn it into a subquery and make it the summary with flags
  Select session_seeing_product_pages.website_session_id,
         session_seeing_product_pages.product_page_seen,
         case when pageview_url='/cart' then 1 else 0 end as cart_page,
           case when pageview_url='/shipping' then 1 else 0 end as shipping_page,
             case when pageview_url='/billing-2' then 1 else 0 end as billing_page,
               case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thankyou_page
From 
(
-- the begining of subquery level 0 
Select wp.website_session_id,
		wp.website_pageview_id,
        wp.pageview_url as product_page_seen
 From website_pageviews wp
 where wp.created_at between '2013-01-06' and '2013-04-10' -- specified by the task
 and wp.pageview_url in ('/the-original-mr-fuzzy','the-forever-love-bear')
 -- the end of subquery level 0
 ) as session_seeing_product_pages left join website_pageviews webp on
								session_seeing_product_pages.website_session_id = webp.website_session_id
	and session_seeing_product_pages.website_pageview_id < webp.website_pageview_id;  
    
    
 