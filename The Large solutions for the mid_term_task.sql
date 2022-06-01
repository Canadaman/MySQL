 -- Solutions for mid-term project
 use mavenfuzzyfactory;
 
 /* 
 1. Gsearch to be the biggest driver of our business. Could you pull monthly
 trends for gsearch sessions and orders so that we can showcase the groth there?
 */
 
 Select 
   Year(ws.created_at) as Year_c,
   Month(ws.created_at) as Month_c,
   count(distinct ws.website_session_id) as sessions,
   count(distinct o.order_id) as orders,
   ( count(distinct o.order_id) / count(distinct ws.website_session_id) )*100 as convert_rate
   From website_sessions ws left join orders o on ws.website_session_id = o.website_session_id
   where ws.created_at < '2012-11-27'
   and ws.utm_source = 'gsearch'
   group by Year_c, Month_c
   order by Year_c, Month_c;
   
  /*
  2. It would be great to see a similar monthly trend for Gsearch, but this time splitting out nonbrand
  amd brand campains seperately. I am wondering if brand is picking up at all. If so, this is a good story to tell.
  */
  
  Select 
   Year(ws.created_at) as Year_c,
   Month(ws.created_at) as Month_c,
   count(distinct case when utm_campaign = 'nonbrand' then ws.website_session_id else null end) as nonbrand_sessions,
   count(distinct case when utm_campaign = 'nonbrand' then o.order_id else null end) as nonbrand_orders, 
   count(distinct case when utm_campaign = 'brand' then ws.website_session_id else null end) as brand_sessions,
   count(distinct case when utm_campaign = 'brand' then o.order_id else null end) as brand_orders
   From website_sessions ws left join orders o on ws.website_session_id = o.website_session_id
   where ws.created_at < '2012-11-27'
   and ws.utm_source = 'gsearch'
   group by Year_c, Month_c
   order by Year_c, Month_c;
   
 /*
 3. While we are on Gsearch, could you drive into nonbrand, and pull monthly sessions and orders split by device type?
	I want to flex our analytical muscles a little and show the board we really know our traffic source.
 */
 
  Select 
   Year(ws.created_at) as Year_c,
   Month(ws.created_at) as Month_c,
   count(distinct case when device_type='desktop' then ws.website_session_id else null end) as desktop_sessions,
    count(distinct case when device_type='desktop' then o.order_id else null end) as desktop_orders,
    count(distinct case when device_type='mobile' then ws.website_session_id else null end) as mobile_sessions,
    count(distinct case when device_type='mobile' then o.order_id else null end) as mobile_orders
   From website_sessions ws left join orders o on ws.website_session_id = o.website_session_id
   where ws.created_at < '2012-11-27'
   and ws.utm_source = 'gsearch'
   and ws.utm_campaign = 'nonbrand'
   group by Year_c, Month_c
   order by Year_c, Month_c;
   
/*
4. I'm worried that one of our more pessimistic board members may be concerned about the large % of traffic from Gsearch.
	Can you pull monthly trend for Gsearch, alongside monthly trends for each of our other channels?

select distinct utm_source, utm_campaign, http_referer
 from website_sessions ws
 where  ws.created_at < '2012-11-27' ;   
*/
 
    
  Select 
   Year(ws.created_at) as Year_c,
   Month(ws.created_at) as Month_c,
    count(distinct case when ws.utm_source = 'gsearch' then ws.website_session_id else null end) as gsearch_paid_sessions,
    count(distinct case when ws.utm_source = 'bsearch' then ws.website_session_id else null end) as bsearch_paid_sessions,
    count(distinct case when ws.utm_source is null and ws.http_referer is not null then ws.website_session_id else null end) as organic_search_sessions,
	count(distinct case when ws.utm_source is null and ws.http_referer is null then ws.website_session_id else null end) as direct_type_in_sessions
   From website_sessions ws left join orders o on ws.website_session_id = o.website_session_id
   where ws.created_at < '2012-11-27'
     group by Year_c, Month_c
     order by Year_c, Month_c;

/*
5. I would like to tell the story of our website perfomance improvement over the course of the first 8 months.
	Could you pull session to order conversion rate, by month?
*/
    
  Select 
   Year(ws.created_at) as Year_c,
   Month(ws.created_at) as Month_c,
    count(distinct ws.website_session_id) as sessions,
    count(distinct o.order_id) as orders,
    (count(distinct o.order_id)/ count(distinct ws.website_session_id) )*100 as conversion_rate
   From website_sessions ws left join orders o on ws.website_session_id = o.website_session_id
   where ws.created_at < '2012-11-27'
     group by Year_c, Month_c
     order by Year_c, Month_c;

/*
6. For the gsearch lander test, estimate the revenue that test earned us, please.
(Hint: Look at the increase in CVR from the test (Jun 19 - Jun 28), and use
nonbrand sessions and revenue since then calculate incremental value)
 
 
select min(website_pageview_id) as first_test_pv, created_at
 from website_pageviews 
 where pageview_url = '/lander-1';  first_test_pv = 23504 */

 -- to find the difference between conversion rates
    Select 
    nonbrand_Landing_page.pageview_url as landing_page,
    count(distinct nonbrand_Landing_page.website_session_id) as sessions,
    count(distinct o.order_id) as orders,
    (count(distinct o.order_id)/count(distinct nonbrand_Landing_page.website_session_id))*100 as conv_rate
  from 
  -- Subquery (Step 1  We will bring the landing page to each session, like last time, but restrict to home or lander-1 this time
  -- and then we make a table to bring in orders)
 (select wp.website_session_id,
  min(wp.website_pageview_id) as min_pageview_id , wp.pageview_url
  from website_pageviews wp inner join website_sessions ws on wp.website_session_id = ws.website_session_id
  where ws.created_at between '2012-06-19 00:35:54' and '2012-07-28'
  and wp.website_pageview_id >=23504
  and utm_source = 'gsearch'
  and utm_campaign = 'nonbrand'
  and wp.pageview_url in ('/home', '/lander-1')
  group by wp.website_session_id
  -- the end of the subquery step 1
  ) as nonbrand_Landing_page left join orders o on
															nonbrand_Landing_page.website_session_id= o.website_session_id
  group by nonbrand_Landing_page.pageview_url;
  
   -- finding the most recent pageview for gsearch nonbrand where the traffic was sent to /home
  /*set @most_pageview = (select max(ws.website_session_id)  -- most_recent_home_pageview = 17145
    from website_sessions ws left join website_pageviews wp on ws.website_session_id = wp.website_session_id
    where utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
    and pageview_url = '/home'
    and ws.created_at < '2012-11-27'); */
    -- the number of website sessions since the test
    Select count(website_session_id ) as sessions_since_test
     From website_sessions webs
     where created_at < '2012-11-27'
     and utm_source = 'gsearch'
     and utm_campaign = 'nonbrand'
     and website_session_id > (select max(ws.website_session_id)  -- most_recent_home_pageview = 17145
    from website_sessions ws left join website_pageviews wp on ws.website_session_id = wp.website_session_id
    where utm_source =  'gsearch'
    and utm_campaign ='nonbrand'
    and pageview_url = '/home'
    and ws.created_at < '2012-11-27'); 
    
-- X 0.0087 incremental conversion = 202 incremental orders since 7/29
	-- roughly 4 months, so roughly 50 extra orders per month.
    
    /*
    7. For the landing page test  you analyzed previously, it would be great to show a full conversion funnel
    from each of the two pages to orders. You can use the same time period you analyzed last time (Jun 19 - Jul 28).
    */
  create temporary table session_level_made_it_flagged
  select 
   website_session_id,
     max(homepage) as saw_home_page,
     max(custom_lander) as saw_custom_lander,
     max(products_page) as saw_products_page,
     max(mrfuzzy_page) as saw_mrfuzzy_page,
     max(cart_page) as saw_cart_page,
     max(shipping_page) as saw_shipping_page,
     max(billing_page) as saw_billing_page,
     max(thankyou_page) as saw_thankyou_page
  
  from  
    
    (select 
		ws.website_session_id,
		wp.pageview_url,
        case when wp.pageview_url = '/home' then 1 else 0 end as homepage,
        case when wp.pageview_url = '/lander-1' then 1 else 0 end as custom_lander,
        case when wp.pageview_url = '/products' then 1 else 0 end as products_page,
        case when wp.pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
        case when wp.pageview_url = '/cart' then 1 else 0 end as cart_page,
        case when wp.pageview_url = '/shipping' then 1 else 0 end as shipping_page,
        case when wp.pageview_url = '/billing' then 1 else 0 end as billing_page,
        case when wp.pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
     from website_sessions ws left join  website_pageviews wp on ws.website_session_id = wp.website_session_id
     where ws.utm_source = 'gsearch'
     and ws.utm_campaign = 'nonbrand'
     and  ws.created_at between  '2012-06-19' and '2012-07-28'
	 group by ws.website_session_id, wp.pageview_url) as pageview_level
     
     group by website_session_id ;
     
     -- then this would produce the final output, part 1
     select 
     Case
		when saw_home_page = 1 then 'saw_home_page'
        when saw_custom_lander = 1 then 'saw_custom_lander'
        else 'uh oh ... check logic' 
        END
        as segment ,
        count(distinct website_session_id) as sessions,
        count(distinct case when saw_products_page = 1 then website_session_id else null end) as to_products,
        count(distinct case when saw_mrfuzzy_page = 1 then website_session_id else null end) as to_mrfuzzy,
        count(distinct case when saw_cart_page = 1 then website_session_id else null end) as to_cart,
        count(distinct case when saw_shipping_page = 1 then website_session_id else null end) as to_shipping,
        count(distinct case when saw_billing_page = 1 then website_session_id else null end) as to_billing,
        count(distinct case when saw_thankyou_page = 1 then website_session_id else null end) as to_thankyou
      from  session_level_made_it_flagged
      group by segment;
      
     -- final step, we define the click rates
     
       select 
     Case
		when saw_home_page = 1 then 'saw_home_page'
        when saw_custom_lander = 1 then 'saw_custom_lander'
        else 'uh oh ... check logic' 
        END
        as segment ,
		(count(distinct case when saw_products_page = 1 then website_session_id else null end)/count(distinct website_session_id)) as Lander_click_rt,
        (count(distinct case when saw_mrfuzzy_page = 1 then website_session_id else null end)/ count(distinct case when saw_products_page = 1 then website_session_id else null end)) as products_click_rt,
        (count(distinct case when saw_cart_page = 1 then website_session_id else null end)/count(distinct case when saw_mrfuzzy_page = 1 then website_session_id else null end)) as mrfuzzy_click_rt,
        (count(distinct case when saw_shipping_page = 1 then website_session_id else null end)/count(distinct case when saw_cart_page = 1 then website_session_id else null end)) as cart_click_rt,
        (count(distinct case when saw_billing_page = 1 then website_session_id else null end)/count(distinct case when saw_shipping_page = 1 then website_session_id else null end)) as shipping_click_rt,
        (count(distinct case when saw_thankyou_page = 1 then website_session_id else null end)/count(distinct case when saw_billing_page = 1 then website_session_id else null end)) as billing_click_rt
      from  session_level_made_it_flagged
      group by segment;
      
   /*
   8. I'd love for you to quantify tge impact of our billing test, as well. Please analyze the lift generated from the test (Sep 10 - Nov 10), in terms of revenue
   per billing page session, and then pull the number of billing page sessions for the past month to understand monthly impact.
   */
   Select 
     billing_version_seen,
     count(distinct website_session_id) as sessions,
     sum(price_usd)/count(distinct website_session_id) as revenue_per_billing_page_seen
   
   from 
    (select 
     wp.website_session_id,
     wp.pageview_url as billing_version_seen,
     o.order_id,
     o.price_usd
      from website_pageviews wp left join orders o on wp.website_session_id = o.website_session_id
      where wp.created_at between '2012-09-10' and '2012-11-10'
      and wp.pageview_url in ('/billing', '/billing-2')) as billing_pageviews_and_order_data
      group by  billing_version_seen;
      
    /* 
    Conclusion: $22.83 revenue per billing page seen for the old version
				$31.34 for the new one
                Lift: $8.51 per billing page view
    */  
    
Select 
   count(website_session_id) as billing_sessions_past_month
  from website_pageviews
  where pageview_url in ('/billing', '/billing-2')
  and created_at between '2012-10-27' and '2012-11-27'; -- past month
     -- 1193 billing sessions past month
     -- Lift: $8.51 per billing page view
     -- Value of Billing test: $10152 (1193*8.51)over past month
  
    
