# LIMIT optimization

* The query like `LIMIT 10000 20` will generate 10020 rows and then throw first 10000 away

For example the following query

```sql
SELECT film_id, description FROM sakila.film ORDER BY title LIMIT 50, 5;
```

requires filesort which is slow

id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
1 | SIMPLE | film | ALL | NULL | NULL | NULL | NULL | 1000 | Using filesort

so it is better to use the following query 

```sql
SELECT film.film_id, film.description
FROM sakila.film
    INNER JOIN (
        SELECT film_id FROM sakila.film
        ORDER BY title LIMIT 50, 5
    ) AS lim USING(film_id);
```

which allows to use the index without accessing rows, and then join them against the full table

id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
1 | PRIMARY | <derived2> | ALL | NULL | NULL | NULL | NULL | 55 | NULL
1 | PRIMARY | film | eq_ref | PRIMARY | PRIMARY | 2 | lim.film_id | 1 | NULL
2 | DERIVED | film | index | NULL | idx_title | 767 | NULL | 1000 | Using index
