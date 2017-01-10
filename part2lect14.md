```sql
CREATE OR REPLACE VIEW sample_staff.v_user_login AS

  SELECT
    user_login.id,
    user_login.user_id,
    user.name,
    user_login.ip_address,
    INET_ATON(user_login.ip_address) AS valid_ip_address,
    user_login.login_dt
  FROM user_login

  LEFT JOIN sample_staff.user ON 1=1
    AND user_login.user_id = user.id

  WHERE 1=1
    AND user_login.deleted_flag = 0

  ORDER BY user_login.id DESC
;
```
