# Isolating the column

The column should not be a part of an expression, so the following where statemen has an expression (so not isolated) so the index cannot be used

```sql
SELECT * FROM products WHERE product_id + 1 = 5;
```

# Prefix index and selectivity

Index on long character columns are very lanrge and slow, so the solution might be an index on limited number of symbols on a column

```sql
CREATE TABLE sakila.city_demo (city VARCHAR(50) NOT NULL);

INSERT INTO sakila.city_demo(city) SELECT city FROM sakila.city;

INSERT INTO sakila.city_demo(city) SELECT city FROM sakila.city_demo;
INSERT INTO sakila.city_demo(city) SELECT city FROM sakila.city_demo;
INSERT INTO sakila.city_demo(city) SELECT city FROM sakila.city_demo;
INSERT INTO sakila.city_demo(city) SELECT city FROM sakila.city_demo;
INSERT INTO sakila.city_demo(city) SELECT city FROM sakila.city_demo;

UPDATE sakila.city_demo SET city = (SELECT city FROM sakila.city ORDER BY RAND() LIMIT 1);
```

Gather some "statistics"

```sql
SELECT COUNT(*) AS cnt, city FROM sakila.city_demo GROUP BY city ORDER BY cnt DESC LIMIT 10
```
cnt | city
--- | ---
65 | London
51 | Pathankot
47 | Batman
46 | Nakhon Sawan
46 | Tabriz
46 | Palghat (Palakkad)
46 | San Miguel de Tucumn
45 | Hunuco
45 | Fontana
45 | Sorocaba

Gather some "statistics" on how many of different prefixes we have

```sql
SELECT COUNT(*) AS cnt, LEFT(city, 3) AS prefix FROM sakila.city_demo GROUP BY prefix ORDER BY cnt DESC LIMIT 10;
```

cnt | prefix
--- | ---
441 | San
175 | Cha
172 | Sou
171 | al-
161 | Tan
147 | Sal
147 | Man
146 | Bat
131 | Hal
131 | Shi

And compare against the 7-letters long prefix

```sql
SELECT COUNT(*) AS cnt, LEFT(city, 7) AS prefix FROM sakila.city_demo GROUP BY prefix ORDER BY cnt DESC LIMIT 10;
```

cnt | prefix
--- | ---
65 | London
55 | Valle d
55 | Santiag
52 | San Fel
51 | Pathank
47 | Batman
46 | Palghat
46 | Tabriz
46 | Nakhon
46 | San M

So in the second case (7 letters) selectivity is much better

There is another method to calculat proper prefix length, first find full column's selectivity

```sql
SELECT COUNT(DISTINCT city)/COUNT(*) AS selectivity FROM sakila.city_demo;
```

selectivity |
--- |
0.0312 |

Then choose the lethth for the closest selectivity from the followin query

```sql
SELECT 
    COUNT(DISTINCT LEFT(city, 3))/COUNT(*) AS sel3,
    COUNT(DISTINCT LEFT(city, 4))/COUNT(*) AS sel4,
    COUNT(DISTINCT LEFT(city, 5))/COUNT(*) AS sel5,
    COUNT(DISTINCT LEFT(city, 6))/COUNT(*) AS sel6,
    COUNT(DISTINCT LEFT(city, 7))/COUNT(*) AS sel7
FROM sakila.city_demo;
```

The higher selectivity the better

```sql
ALTER TABLE sakila.city_demo ADD KEY (city(7));
```

# Multicolumn indexes

## Common mistakes
* Create index for every column (separately) or create index for "columns that apper in the `WHERE` clause", is bad approach, even though MySQL starting from 5.0 can use so called, *index merge* strategy, and use multiple indexes.

```sql
EXPLAIN SELECT film_id, actor_id FROM sakila.film_actor WHERE actor_id = 1 OR film_id = 1
```

id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
 1 | SIMPLE | film_actor | index_merge | PRIMARY,idx_fk_film_id | PRIMARY,idx_fk_film_id | 2,2 | NULL | 29 | Using union(PRIMARY,idx_fk_film_id); Using where
 
# Choosing column order (B-Tree index)
* The index in sorted by first, then second (etc) column in the index
* It is good (but not crucial) to place the most selective column as the leftmost column in the index. This approach is good to satisfy the condition in the `WHERE` clause, without sorting or grouping.
 
What order is better for the following query
 
```sql
SELECT * FROM `payment` WHERE staff_id = 2 AND customer_id = 584;
```
 
```
  SELECT SUM(staff_id = 2), SUM(customer_id = 584) FROM payment;
```

SUM(staff_id = 2) | SUM(customer_id = 584) 
--- | ---
7992  | 30

We have higher cardinality for `customer_id` wihin `staff_id = 2` but for another request the overall picture might significally differs, from this one, so if we optimize query for this, particular query the other queries migth start suffering from our changes, so it is a good idea to confirm the changes, by calculating general selectivity of the columns

```sql
SELECT 
    COUNT(DISTINCT staff_id)/COUNT(*) AS staff_selectivity,
    COUNT(DISTINCT customer_id)/COUNT(*) AS customer_selectivity,
    COUNT(*)
FROM payment;
```

staff_selectivity | customer_selectivity | COUNT(*) 
--- | --- | ---
0.0001 | 0.0373 | 16049 

So the following optimization seems to be a good one

```sql
ALTER TABLE payment ADD KEY(customer_id, staff_id);
```

# Clustered indexes (focused on InnoDB)

* Rows and with adjasent key values are stored close to each other
* Only one clustered index per table is avilable
* InnoDB clusters the data by the primary key (or unique unnullable index, if PK does not exist)
* Data access is fast
* Insert speer depends on insertion order
* Updating is expepensive
* Page split if data not fits into one page
* Slow full table scan
* Nonclustered indexed can be larger
* Secondary index accesses require two index lookups

# Covering indexes

This is not a separate type of index, it just mean that the query is able to fetch the data right from the index itself, instead of fetching a row. It can be checked by examining the `Extra` column in `EXPLAIN`, if the value is `Using index` - the magic has happed.

```sql
EXPLAIN SELECT store_id, film_id FROM sakila.inventory;
```

id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
1 | SIMPLE | inventory | index | NULL | idx_store_id_film_id | 3 | NULL | 4581 | Using index

# Indexies and Locking

InnoDB sometimes can lock rows that not even fall in the end result set (in the frames on one uncommited transaction). Ex:

```sql
SET AUTOCOMMIT=0;
BEGIN;
SELECT actor_id FROM sakila.actor WHERE actor_id < 5 AND actor_id <> 1 FOR UPDATE;
```

The query above, will lock rows from 2 up to 4, and additionaly it will lock the first row. This happens because MySQL did not tell InnoDB that it have to exclude the first row, and will exclude it by itself applying another part of the where caluse `actor_id <> 1`, it can be verified by looking at the explain

```sql
EXPLAIN SELECT actor_id FROM sakila.actor WHERE actor_id < 5 AND actor_id <> 1 FOR UPDATE;
```

id | select_type | table | type | possible_keys | key | key_len | ref | rows | Extra
--- | --- | --- | --- | --- | --- | --- | --- | --- | ---
1 | SIMPLE | actor | range | PRIMARY | PRIMARY | 2 | NULL | 3 | Using where; Using index

The `Extra` column sais it used both index and where, index was used for fetching (and lock) first four rows, and the where clause to filter out the first row.
The second way to confirm the aasumption of locking the first row is to run the following query from another session.

```sql
SET AUTOCOMMIT=0;
BEGIN;
SELECT actor_id FROM sakila.actor WHERE actor_id = 1 FOR UPDATE;
```

The query above won't be finished untill the query in the first session is uncommited (`COMMIT;`), because the first row is locked for update.

# Avoiding Multiple Range Conditions

* MySQL can use one of the range conditions (if respective index exists of course)

```sql
WHERE col1 IN (1, 2, 3) /** not range condition **/
    AND date > DATE_SUB(NOW(), INTERVAL 7 DAY) /** first range condition **/
    AND age BETWEEN 18 AND 25 /** second range condition won't be used **/
```

The `EXPLAIN` shows `type` as `range` for conditions like inequality, `BETWEEN` etc., but on the other hand it also shows the same `range` for `IN()` caluse, even though it is multiple equality condition.

In the exaple above, the last condition can be raplaced with `IN (18, 19, 20, 21, 22, 23, 24, 25)`, it will allow the index to be used, but it worth noting, that lots of in statementes, can behave badly when the number of combinations (generated by `IN` statements) approaches thousands
