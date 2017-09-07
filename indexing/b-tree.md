# B-Tree index

## Example

This is the most commonly used type of index

```sql
CREATE TABLE `People` (
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `dob` date NOT NULL,
  `gender` enum('m','f') NOT NULL,
  KEY `idx_btree_example` (`last_name`,`first_name`,`dob`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## What is good for
* *Match full value.* Ex. `Alex Shch 1988-09-17`
* *Match a leftmost prefix.* It means to find a person by his/her lastname
* *Match a column prefix.* It means to find a person whos lastname starts with letter `S` for example.
* *Match a range of values.* To find lsatnames between Jnoes and Shch
* *Match one part exactly and match a range of another.* For exaple I can specify the whol lastname in a where clause, and starting letter of firstname

The order of the columns in the index is important, so I cannot use such an index if I specify only firstname in the wehere clause.

