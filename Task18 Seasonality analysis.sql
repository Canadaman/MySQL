use mavenfuzzyfactory;

SELECT 
    YEAR(ws.created_at) AS year_at,
    week(ws.created_at) AS week_at,
    min(date(ws.created_at)) as start_week,
    COUNT(ws.website_session_id) AS sessions,
    COUNT(o.order_id) AS orders
FROM
    website_sessions ws
        LEFT JOIN
    orders o ON ws.website_session_id = o.website_session_id
WHERE
    ws.created_at < '2013-01-01'
GROUP BY year_at , week_at;
 
 -- to care out this query with more detailed information 
 
 
 
