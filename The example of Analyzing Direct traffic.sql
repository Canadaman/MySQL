-- Analyzing Direct traffic

  Select 
   case when ws.http_referer is null then 'direct_type_in'
		when ws.http_referer = 'https://www.gsearch.com'  and ws.utm_source is null then 'gsearch_organic'
        when ws.http_referer = 'https://www.bsearch.com'  and ws.utm_source is null then 'bsearch_organic'
        else 'other' end as reffers,
        count(distinct ws.website_session_id) as sessions
  From website_sessions ws
   where ws.website_session_id between 100000 and 115000 -- arbitrary range
 -- and ws.utm_source is null
  group by reffers
  order by  sessions desc;
  

  