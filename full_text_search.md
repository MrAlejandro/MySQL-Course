* MySQL supports Full-Text Search, for MyISAM and from 5.6 (?) for InnoDB
* The search is based on fulltext index
* `ALTER TABLE sakila.film_text ADD FULLTXT KEY(tite);`
* To check the index 

```sql
SHOW INDEX FROM sakila.film_text;
```

Table | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment
--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---
film_text | 0 | PRIMARY | 1 | film_id | A | 1000 | NULL | NULL |  | BTREE |  | 
film_text | 1 | idx_title_description | 1 | title | NULL | 1000 | NULL | NULL |  | FULLTEXT |  | 
film_text | 1 | idx_title_description | 2 | description | NULL | 1000 | NULL | NULL | YES | FULLTEXT |  | 

* To search

```sql
SELECT film_id, title, RIGHT(description, 25),
    MATCH(title, description) AGAINST('factory casualties') AS relevnce
FROM sakila.film_text
WHERE MATCH(title, description) AGAINST('factory casualties');
```

film_id | title | RIGHT(description, 25) | relevnce
--- | --- | --- | ---
831 | SPIRITED CASUALTIES | a Car in A Baloon Factory | 8.640907287597656
126 | CASUALTIES ENCINO | Face a Boy in A Monastery | 6.364917278289795
193 | CROSSROADS CASUALTIES | a Composer in The Outback | 6.364917278289795
3 | ADAPTATION HOLES | rjack in A Baloon Factory | 2.275989532470703
103 | BUCKET BROTHERHOOD | rjack in A Baloon Factory | 2.275989532470703
110 | CABIN FLASH | Shark in A Baloon Factory | 2.275989532470703
186 | CRAFT OUTFIELD | rator in A Baloon Factory | 2.275989532470703
187 | CRANES RESERVOIR | ogist in A Baloon Factory | 2.275989532470703

# Boolean binary search
* `newyork` - row containing *newyork* ranked higher
* `~newyork` - row containing *newyork* ranked lower
* `+newyork` - row must contain *newyork*
* `-newyork` - row must NOT contain *newyork*
* `new*` - row containing words that bing with *new* rank higher

* so the following query will find only one row

```sql
SELECT film_id, title, RIGHT(description, 25)
FROM sakila.film_text
WHERE MATCH(title, description) AGAINST('+factory +casualties' IN BOOLEAN MODE);
```

film_id | title | RIGHT(description, 25)
--- | --- | --- 
831 | SPIRITED CASUALTIES | a Car in A Baloon Factory

# Phrase search 
* Can be performed by quoting multible words
* Tends to be quiet slow

```sql
SELECT film_id, title, RIGHT(description, 25)
FROM sakila.film_text
WHERE MATCH(title, description) AGAINST('"spirited casualties"' IN BOOLEAN MODE);
```
