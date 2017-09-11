# The join optimizer

```sql
EXPLAIN EXTENDED SELECT film.film_id, film.title, film.release_year, actor.actor_id, actor.first_name, actor.last_name
FROM sakila.film
INNER JOIN sakila.film_actor USING(film_id)
INNER JOIN sakila.actor USING(actor_id);
```

id | select_type | table | type | possible_keys | key | key_len | ref | rows | filtered | Extra
--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---
1 | SIMPLE | actor | ALL | PRIMARY | NULL | NULL | NULL | 200 | 100.00 | NULL
1 | SIMPLE | film_actor | ref | PRIMARY,idx_fk_film_id | PRIMARY | 2 | sakila.actor.actor_id | 1 | 100.00 | Using index
1 | SIMPLE | film | eq_ref | PRIMARY | PRIMARY | 2 | sakila.film_actor.film_id | 1 | 100.00 | NULL

```sql
SHOW STATUS LIKE 'Last_query_cost';
```

Variable_name | Value
--- | ---
Last_query_cost | 520.999000

For the previpus query MySQL (after optimizing) will have only 200 index lookups

```sql
EXPLAIN EXTENDED SELECT STRAIGHT_JOIN film.film_id, film.title, film.release_year, actor.actor_id, actor.first_name, actor.last_name
FROM sakila.film
INNER JOIN sakila.film_actor USING(film_id)
INNER JOIN sakila.actor USING(actor_id);
```

id | select_type | table | type | possible_keys | key | key_len | ref | rows | filtered | Extra
--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---
1 | SIMPLE | film | ALL | PRIMARY | NULL | NULL | NULL | 1000 | 100.00 | NULL
1 | SIMPLE | film_actor | ref | PRIMARY,idx_fk_film_id | idx_fk_film_id | 2 | sakila.film.film_id | 1 | 100.00 | Using index
1 | SIMPLE | actor | eq_ref | PRIMARY | PRIMARY | 2 | sakila.film_actor.actor_id | 1 | 100.00 | NULL

```sql
SHOW STATUS LIKE 'Last_query_cost';
```

Variable_name | Value
--- | ---
Last_query_cost | 2611.999000

And the query that was instructed to preceive join orders, will require about 1000 probes into film_actor and actor, one for each row in the first table.

So in most cases it is better to leave the optimization to to the MySQL server.
