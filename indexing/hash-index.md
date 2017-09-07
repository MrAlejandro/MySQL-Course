# Hash index

## Example

```sql
CREATE TABLE `Hash_index` (
  `last_name` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  KEY `first_name` (`first_name`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

## What is good for
* Very compact and generally fast

## Limitations
* Does not contain the value itself in the index, so MySQL have to read the rows.
* Bad for sortings.
* Have to match only whole value (no partial key matching).
* Support only equality comparison (`=`, `IN()`, `<=>`) not `<>`, `>`, etc. 
* Many values with the same hash (collisions), reduces the speed.

## Custom hash indexes

```sql
CREATE TABLE `custom_hash_index` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  `url_crc` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELIMITER //

CREATE TRIGGER custom_hash_index_crc_ins BEFORE INSERT ON custom_hash_index FOR EACH ROW BEGIN SET NEW.url_crc=crc32(NEW.url);
END;
//

CREATE TRIGGER custom_hash_index_crc_upd BEFORE UPDATE ON custom_hash_index FOR EACH ROW BEGIN SET NEW.url_crc=crc32(NEW.url);
END;
//

DELIMITER ;

INSERT INTO custom_hash_index SET url = 'https://google.com';

SELECT * FROM custom_hash_index WHERE url = 'https://google.com' AND url_crc = CRC32('https://google.com');
```
