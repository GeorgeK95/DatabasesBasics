1.
SELECT e.first_name, e.last_name
FROM `employees` AS e
WHERE(e.first_name LIKE 'SA%')

2.
SELECT e.first_name, e.last_name
FROM `employees` AS e
WHERE(e.last_name LIKE '%ei%')

3.
SELECT e.first_name
FROM employees AS e
WHERE(e.hire_date BETWEEN '1995-01-01' AND '2005-12-31' AND (e.department_id = 3 OR e.department_id = 10));

4.
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE(e.job_title NOT LIKE '%engineer%')

5.
SELECT t.name
FROM towns AS t
WHERE(CHAR_LENGTH(t.name) BETWEEN 5 AND 6)
ORDER BY t.name;

6.
SELECT *
FROM towns AS t
WHERE(t.name LIKE 'M%' OR t.name LIKE 'K%' OR t.name LIKE 'B%' OR t.name LIKE 'E%')
ORDER BY t.name;

7.
SELECT *
FROM towns AS t
WHERE(t.name NOT LIKE 'R%' AND t.name NOT LIKE 'D%' AND t.name NOT LIKE 'B%')
ORDER BY t.name;

8.
CREATE VIEW V_employees_hired_after_2000 AS
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE(e.hire_date >= '2001-01-01');

9.
SELECT e.first_name, e.last_name
FROM employees AS e
WHERE(CHAR_LENGTH(e.last_name) = 5);

10.
SELECT c.country_name, c.iso_code /*(LENGTH(c.country_name) - LENGTH( REPLACE ( c.country_name, "a", ""))) as gus*/
FROM countries AS c
WHERE (LENGTH(c.country_name) - LENGTH(
REPLACE (LOWER(c.country_name), "a", ""))) >= 3
ORDER BY c.iso_code;

11.
SELECT p.peak_name,
r.river_name, LOWER(CONCAT(
LEFT(p.peak_name, CHAR_LENGTH(p.peak_name) - 1), '', r.river_name)) AS mix
FROM rivers AS r, peaks AS p
WHERE(
RIGHT(p.peak_name,1) =
LEFT(r.river_name,1))
ORDER BY mix;

12.
SELECT g.name, DATE_FORMAT(g.`start`,'%Y-%m-%d')
FROM games AS g
WHERE(g.`start` BETWEEN '2011-01-01' AND '2012-12-31')
ORDER BY g.`start`, g.is_finished
LIMIT 50;

13.
SELECT u.user_name, SUBSTR(u.email, LOCATE('@',u.email) + 1) AS 'Email Provider'
FROM users AS u
ORDER BY SUBSTR(u.email, LOCATE('@',u.email) + 1), u.user_name;

14.
SELECT u.user_name, u.ip_address
FROM users AS u
WHERE(u.ip_address LIKE '___.1%.%.___')
ORDER BY u.user_name;

15.
SELECT g.name, CASE WHEN DATE_FORMAT(g.`start`,'%H') >= 0 AND DATE_FORMAT(g.`start`,'%H') < 12 THEN 'Morning' WHEN DATE_FORMAT(g.`start`,'%H') >= 12 AND DATE_FORMAT(g.`start`,'%H') < 18 THEN 'Afternoon' WHEN DATE_FORMAT(g.`start`,'%H') >= 18 AND DATE_FORMAT(g.`start`,'%H') < 24 THEN 'Evening' END AS 'Part of the Day', CASE WHEN g.duration BETWEEN 0 AND 3 THEN 'Extra Short' WHEN g.duration BETWEEN 4 AND 6 THEN 'Short' WHEN g.duration BETWEEN 7 AND 10 THEN 'Long' ELSE 'Extra Long' END AS 'Duration'
FROM games AS g;

16.
SELECT o.product_name, 
o.order_date, DATE_ADD(o.order_date, INTERVAL 3 DAY) AS 'pay_due', DATE_ADD(o.order_date, INTERVAL 1 MONTH) AS 'deliver_due'
FROM orders AS o;

17.
SELECT p.name, YEAR(NOW()) - YEAR(p.birthdate) AS 'age_in_years', PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'), DATE_FORMAT(p.birthdate, '%Y%m')) AS 'age_in_months', DATEDIFF(NOW(),p.birthdate) AS 'age_in_days', DATEDIFF(NOW(),p.birthdate) * 1440 AS 'age_in_minutes'
FROM people AS p;