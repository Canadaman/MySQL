-- Conversion Funnel Test Results
-- first, find the start point to frame the analysis


-- first_pv_id = 53550

-- first we'll look at this without orders, then we'll as in orders
Select 
     billing_version_seen,
     count(distinct website_session_id) as sessions,
     count(distinct order_id) as orders,
     (count(distinct order_id)/ count(distinct website_session_id))*100 as billing_to_order_rt
   from (
    -- subquery
	select 
		wp.website_session_id,
		wp.pageview_url as billing_version_seen,
		o.order_id
       from website_pageviews wp left join orders o on wp.website_session_id = o.website_session_id
	   where wp.website_pageview_id >=  53550-- (select min(wp.website_pageview_id)   from website_pageviews wp   where pageview_url= '/billing-2')
      and wp.created_at < '2012-11-10'
      and wp.pageview_url in ('/billing', '/billing-2')) as billing_sessions_url
      group by billing_version_seen;