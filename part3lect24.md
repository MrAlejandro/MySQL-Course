```sql
SELECT `contract`.`archive_code`
FROM `contract`
--      IGNORE INDEX (idx_acrchive_code_deleted_flag_date)
WHERE 1=1
  AND `contract`.`archive_code` = 'DA970'
  AND `contract`.`deleted_flag` = 0
  AND `contract`.`sign_date` >= '1990-01-01'
;

-- no index - 168ms
-- index - 0.4ms

SELECT `contract`.`archive_code`
FROM `contract`
--      IGNORE INDEX (idx_acrchive_code_deleted_flag_date)
WHERE 1=1
  AND `contract`.`archive_code` = 'DA970'
  AND `contract`.`deleted_flag` = 0
;

-- no index - 90ms
-- index - 0.5ms

ALTER TABLE contract ADD INDEX idx_acrchive_code_deleted_flag_date (archive_code, deleted_flag, sign_date);
```
