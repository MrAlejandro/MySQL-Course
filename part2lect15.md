```sql
INSERT INTO bi_data.valid_offers (
  offer_id,
  hotel_id,
  price_usd,
  original_price,
  original_currency_code,
  checkin_date,
  checkout_date,
  breakfast_included_flag,
  valid_from_date,
  valid_to_date
)

SELECT
  offer_cleance_date_fix.id,
  offer_cleance_date_fix.hotel_id,
  offer_cleance_date_fix.sellings_price AS price_usd,
  offer_cleance_date_fix.sellings_price AS original_price,
  offer_cleance_date_fix.checkin_date,
  offer_cleance_date_fix.checkout_date,
  offer_cleance_date_fix.breakfast_included_flag,
  offer_cleance_date_fix.offer_valid_from,
  offer_cleance_date_fix.offer_valid_to
  lst_currency.code AS original_currency_code,
FROM  enterprise_data.offer_cleanse_date_fix AS offer_cleance_date_fix

LEFT JOIN primary_data.lst_currency as lst_currency ON 1=1
  AND lst_currency.id = 1

WHERE 1=1
  AND offer_cleance_date_fix.currency_id = 1
  AND lc.id = 1;
```
