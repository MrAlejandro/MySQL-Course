```sql
-- ANALYZE TABLE sample_staff.employee;

SELECT /* Select all indexes from table 'employee' and their size */
  SUM(`stat_value`) AS pages,
  `index_name` AS index_name,
  SUM(`stat_value`) * @@innodb_page_size / 1024 / 1024 AS size_mb
FROM `mysql`.`innodb_index_stats`
WHERE 1=1
  AND `table_name` = 'employee'
  AND `database_name` = 'sample_staff'
  AND `stat_description` = 'Number of pages in the index'
GROUP BY
  `index_name`
;

-- ALTER TABLE sample_staff.employee ADD INDEX idx_personal_code_2chars (personal_code(2));

-- EXPLAIN
SELECT id
FROM sample_staff.employee AS employee
WHERE 1=1
  AND employee.personal_code = 'AA-751492'
;

-- EXPLAIN
SELECT id
FROM sample_staff.employee AS employee
  USE INDEX (idx_personal_code_2chars)
WHERE 1=1
  AND employee.personal_code = 'AA-751492'
;
```
