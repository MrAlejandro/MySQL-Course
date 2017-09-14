* `SQL_CALC_FOUND_ROWS` is very slow, because it forces server to generate and throw away the rest of the result set, 
instead of stopping thwn it reaches the desired number of rows.
* It is fasetr to use the `COUNT(*), if it can use a covering index.
* Sometimes it appropriate to show something like *more than 1000 recods found*
