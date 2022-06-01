-- Data for customer service 


select 
   hour_at, 
  Round(avg(case when wday=0 then website_sessions else null end),1) as Monday,
  Round(avg(case when wday=1 then website_sessions else null end),1) as Tuesday,
  Round(avg(case when wday=2 then website_sessions else null end),1) as Wednesday,
  Round(avg(case when wday=3 then website_sessions else null end),1) as Thursday,
  Round(avg(case when wday=4 then website_sessions else null end),1) as Friday,
  Round(avg(case when wday=5 then website_sessions else null end),1) as Saturday,
  Round(avg(case when wday=6 then website_sessions else null end),1) as Sunday
  from 
(Select 
 date(ws.created_at) as created_date,
 weekday(ws.created_at) as wday,
 hour(ws.created_at) as Hour_at,
 count(distinct ws.website_session_id) as website_sessions
 from website_sessions ws
 where ws.created_at between '2012-09-15' and '2012-11-15'
 group by created_date, wday, hour_at) as dayly_ourly_sessions
 group by hour_at
 order by hour_at;