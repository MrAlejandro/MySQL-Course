# Optimizer limitations

## Correlated Subqueries

* For example the `IN()` clause behaves badly inside subquery, may behave badly in earlier MySQL versions

```sql
EXPLAIN EXTENDED SELECT * FROM sakila.film
WHERE film_id IN(
    SELECT film_id FROM sakila.film_actor WHERE actor_id = 1);
```

* This is how the optimizer reworked the query

```sql
SHOW WARNINGS;
```
will output 

```
/* select#1 */ select `film`.`film_id` AS `film_id`,`film`.`title` AS `title`,`film`.`description` AS `description`,`film`.`release_year` AS `release_year`,`film`.`language_id` AS `language_id`,`film`.`original_language_id` AS `original_language_id`,`film`.`rental_duration` AS `rental_duration`,`film`.`rental_rate` AS `rental_rate`,`film`.`length` AS `length`,`film`.`replacement_cost` AS `replacement_cost`,`film`.`rating` AS `rating`,`film`.`special_features` AS `special_features`,`film`.`last_update` AS `last_update` from `sakila`.`film_actor` join `sakila`.`film` where ((`film`.`film_id` = `film_actor`.`film_id`) and (`film_actor`.`actor_id` = 1))
```

* And this shows how it should have been writter initially - using `JOIN`

```sql
SELECT * FROM sakila.film
INNER JOIN sakila.film_actor USING(film_id)
WHERE actor_id = 1;
```

or using `EXISTS` caluse, which sometimes works better

```sql
SELECT * FROM sakila.film
WHERE EXISTS(
    SELECT * FROM sakila.film_actor WHERE actor_id = 1
        AND film_actor.film_id = film.film_id);
```

or even fetch all film_ids in the separate query, and pass them in the second one

## Update and Select on the same table

Lets create a copy of sakila's customer table and add a new column that will contain the names cuantity

```sql
INSERT INTO customer_copy SELECT * FROM customer;
ALTER TABLE customer_copy ADD COLUMN fname_count TINYINT(3) AFTER first_name;
```

The following query will fail because of the specified limitation

```sql
UPDATE customer_copy AS outer_table
    SET fname_count = (
        SELECT COUNT(*) FROM customer_copy AS inner_table
        WHERE inner_tbl.first_name = outer_table.first_name
    );
    
SHOW WARNINGS;
```

Level | Code | Message
--- | --- | ---
Error | 1093 | You can't specify target table 'outer_table' for update in FROM clause

Here is a workaround for this limitation

```sql
UPDATE customer_copy 
    INNER JOIN(
        SELECT first_name, COUNT(*) AS cnt
        FROM customer_copy
        GROUP BY first_name
    ) AS der USING(first_name)
SET customer_copy.fname_count = der.cnt;

SELECT first_name, fname_count FROM customer_copy WHERE fname_count > 1 ORDER BY first_name DESC LIMIT 3;
```

first_name | fname_count
--- | ---
WILLIE | 2
WILLIE | 2
TRACY | 2
