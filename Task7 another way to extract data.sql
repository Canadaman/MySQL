select count(distinct website_pageview_id), pageview_url
From website_pageviews
where website_pageview_id = (select wp.website_pageview_id from website_pageviews wp where wp.website_session_id = website_pageviews.website_session_id limit 1)
and website_pageviews.created_at < '2012-06-12'
group by pageview_url