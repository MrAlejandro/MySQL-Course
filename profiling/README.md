### Using built in profiler
```sql
-- enable profiling for current session
SET profiling = 1;
SELECT * FROM cs_cart.cscart_products;
-- show list of profiled queries
SHOW PROFILES;
-- show profile info for a specific query
SHOW PROFILE FOR QUERY 3;

SET @query_id = 3;
-- more custom and useful output
SELECT STATE, SUM(DURATION) AS Total_R,
    ROUND(
        100 * SUM(DURATION) /
        (SELECT SUM(DURATION)
        FROM INFORMATION_SCHEMA.PROFILING
        WHERE QUERY_ID = @query_id
        ),
        2
    ) AS Pct_R,
    COUNT(*) AS Calls,
    SUM(DURATION) / COUNT(*) AS "R/Calls"
FROM INFORMATION_SCHEMA.PROFILING
WHERE QUERY_ID = @query_id
GROUP BY STATE
ORDER BY Total_R DESC;
```
