-- Analizing Conversion Funnel
/* Building conversion funnel
 step 1: select all pageviews for revelant sessions
 step2: identify each pageview as the specific funnel step
 step3: create the session-level conversion funnel view
 step4: aggregate the data assess funnel performance
*/

use mavenfuzzyfactory;
create temporary table session_level_made_it_flag
  select 
   website_session_id,
   max(products_page) as product_made_it,
   max(mfuzzy_page) as mfuzzy_made_it,
   max(cart_page) as cart_made_it,
   max(shipping_page) as shipping_made_it,
   max(billing_page) as billing_made_it,
   max(thankyou_page) as thankyou_made_it
   
  from 
  -- Subquery 
   (select  
         ws.website_session_id,
         wp.pageview_url,
         case when pageview_url = '/products' then 1 else 0 end as products_page, 
         case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mfuzzy_page, 
         case when pageview_url = '/cart' then 1 else 0 end as cart_page, 
         case when pageview_url = '/shipping' then 1 else 0 end as shipping_page, 
         case when pageview_url = '/billing' then 1 else 0 end as billing_page, 
         case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page 
		from website_sessions ws left join website_pageviews wp on ws.website_session_id = wp.website_session_id
	where ws.utm_source = 'gsearch'
    and ws.utm_campaign = 'nonbrand'
    and ws.created_at between '2012-08-05' and '2012-09-05'
    
    order by ws.website_session_id,
         wp.created_at) as pageview_level
    group by   website_session_id;

-- In this query, we will produce the final output
 select  
 count(distinct website_session_id) as sessions,
count(distinct case when product_made_it = 1 then website_session_id else null end) as to_products,
count(distinct case when mfuzzy_made_it = 1 then website_session_id else null end) as to_mfuzzy,
count(distinct case when cart_made_it = 1 then website_session_id else null end) as to_cart,
count(distinct case when shipping_made_it = 1 then website_session_id else null end) as to_shipping,
count(distinct case when billing_made_it = 1 then website_session_id else null end) as to_billing,
count(distinct case when thankyou_made_it = 1 then website_session_id else null end) as to_thankyou
 from session_level_made_it_flag s_flag;
 
 -- then this as final output part 2 - click rates
 
  select  
count(distinct case when product_made_it = 1 then website_session_id else null end)/ count(distinct website_session_id) as lander_click_rt,
count(distinct case when mfuzzy_made_it = 1 then website_session_id else null end)/ count(distinct case when product_made_it = 1 then website_session_id else null end) as product_click_rt,
count(distinct case when cart_made_it = 1 then website_session_id else null end)/count(distinct case when mfuzzy_made_it = 1 then website_session_id else null end) as mfuzzy_click_rt,
count(distinct case when shipping_made_it = 1 then website_session_id else null end)/count(distinct case when cart_made_it = 1 then website_session_id else null end) as cart_click_rt,
count(distinct case when billing_made_it = 1 then website_session_id else null end)/count(distinct case when shipping_made_it = 1 then website_session_id else null end) as shipping_click_rt,
count(distinct case when thankyou_made_it = 1 then website_session_id else null end)/count(distinct case when billing_made_it = 1 then website_session_id else null end) as billing_click_rt
 from session_level_made_it_flag s_flag;
    