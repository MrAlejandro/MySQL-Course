### Shows current ```AUTOCOMMIT``` settings' value
```sql
SHOW VARIABLES LIKE 'AUTOCOMMIT';
```

### Shows current ```TRANSACTION ISOLATION``` settings' value
```sql
SHOW VARIABLES LIKE '%ISOL%';
```

### Changes current ```TRANSACTION ISOLATION``` settings' value, for current session
```sql
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SHOW VARIABLES LIKE '%ISOL%';
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SHOW VARIABLES LIKE '%ISOL%';
```

### Shows the status of a particular table
```sql
SHOW TABLE STATUS LIKE 'blog_posts';
```
