# Access types

* The types are: *full table scan*, *index stan*, *range scan*, *unique index lookup*, *constants* - ordered from slower to faster
* The `type` column in the `EXPLAIN`'s output describes which type was used, and `rows` column - how many rows must be accessed

```sql
EXPLAIN SELECT * FROM sakila.film_actor WHERE film_id = 1;
```

id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
1 | SIMPLE | film_actor | ref | idx_fk_film_id | idx_fk_film_id | 2 | const | 10 | NULL
