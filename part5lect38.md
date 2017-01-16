```sql
SET @target_date := '2000-01-01';

SET @company_average_salary := (
  SELECT
    ROUND(AVG(salary_amount), 2)
  FROM salary
  WHERE 1=1
    AND from_date > @target_date
)
;

SELECT @company_average_salary;

SELECT
  depertment_id,
  department_name,
  department_average_salary,
  @company_average_salary AS company_average_salary,
  CASE
    WHEN @company_average_salary < department_average_salary THEN 'higher'
    WHEN @company_average_salary = department_average_salary THEN 'same'
    ELSE 'lower'
  END AS department_vs_company

FROM (
  SELECT
    department.id AS depertment_id,
    department.name AS department_name,
    ROUND(AVG(salary.salary_amount), 2) AS department_average_salary
  FROM salary

  LEFT JOIN department_employee_rel ON 1=1
    AND department_employee_rel.employee_id = salary.employee_id

  LEFT JOIN department ON 1=1
    AND department.id = department_employee_rel.department_id

  WHERE 1=1
    AND salary.from_date > @target_date

  GROUP BY
    department.id,
    department.name
) AS xTMP
;
```
