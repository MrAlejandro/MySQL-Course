# Query Optimizer Hints

* *HIGH_PRIORITY* and *LOW_PRIORITY* - allows to prioritize statement relative to other statements. Pretty obsolete for InnoDB.
* *DELAYED* - if applied to `INSERT` or `REPLACE` query, allows to store the query in buffer and execute lately.
* *STRAIGHT_JOIN* - preserves the `JOIN`s order specified in the query
* *SQL_SMALL_RESULT* and *SQL_BIG_RESULT* - are used with `SELECT` query, the first tells the the result will be small, 
and temporary index table can be used, and the second tells that it is better to use temporary table on disk with sorting.
* *SQL_BUFFER_RESULT* - allows to put result into a temporary table, and release table locks. Use some extra server memory.
* *SQL_CACHE* and *SQL_NO_CACHE* - defines is the query is a candidate for caching in the query cache.
