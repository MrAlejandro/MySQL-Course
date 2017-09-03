### Using Percona Toolkit Query Digest
```bash
sudo cp -rf /var/log/mysql/slow.log ~/profile
sudo chmod 777 slow.log
pt-query-digest slow.log >> 1.txt
```
This tool's output gives an offset like 289141
```
# Query 1: 0.67 QPS, 0.01x concurrency, ID 0x8FA22108FF85434C at byte 289141
```
that can be used for inspecting the query in the original log
```
tail -c +289141 ./slow.log | head -n100
```

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

### Using SHOW STATUS (not really profiling)
```sql
FLUSH STATUS;
SELECT * FROM cs_cart.cscart_products;
SHOW STATUS WHERE Variable_name LIKE 'Handler%'
    OR Variable_name LIKE 'Created%';
```

### Using the Performance Schema
The following query shows the top 5 reasons that cause the system to wait
```sql
SELECT event_name, count_star, sum_timer_wait
FROM performance_schema.events_waits_summary_global_by_event_name
ORDER BY sum_timer_wait DESC LIMIT 5;
```

### Using SHOW GLOBAL STATUSЕ
The following commant show 3 columns (every 1 second): queries per second, threads connected and threads running (currently exequting)
```bash
mysqladmin -uroot -p ext -i1 | awk '
    /Queries/{q=$4-qp;qp=$4}
    /Threads_connected/{tc=$4}
    /Threads_running/{printf "%5d %5d %5d\n", q, tc, $4}'
```

### Using SHOW PROCESSLIST
```bash
mysql -uroot -p -e 'SHOW PROCESSLIST\G' | grep State: | sort | uniq -c | sort -rn
````

### Using slow query log
```bash
awk '/^# Time:/{print $3, $4, c;c=0}/^# User/{c++}' slow.log
```
