## Isolating the column

The column should not be a part of an expression, so the following where statemen has an expression (so not isolated) so the index cannot be used

```sql
SELECT * FROM products WHERE product_id + 1 = 5;
```

# Prefix index and selectivity

Index on long character columns are very lanrge and slow
