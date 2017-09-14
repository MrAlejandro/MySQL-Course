* Always use `UNION ALL` unless you need to explude duplicated rows
* Union without `ALL` will apply distinct option based on every column, which is pretty expencive
* Union always creates a tomporary table and then reads it again even though it is necessary
