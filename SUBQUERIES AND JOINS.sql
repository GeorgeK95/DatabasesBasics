1.
SELECT e.employee_id, e.job_title, a.address_id, a.address_text
FROM employees AS `e`
JOIN addresses AS `a` ON e.address_id = a.address_id
ORDER BY a.address_id
LIMIT 5;

2.
SELECT e.first_name, e.last_name, t.name, a.address_text
FROM employees AS `e`
JOIN addresses AS `a` ON e.address_id = a.address_id
JOIN towns AS `t` ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;

3.
SELECT e.employee_id,e.first_name, e.last_name, d.name
FROM employees AS `e`
JOIN departments AS `d` ON d.department_id = e.department_id
WHERE(d.name = 'Sales')
ORDER BY e.employee_id DESC;

4.
SELECT e.employee_id,e.first_name, e.salary, d.name
FROM employees AS `e`
JOIN departments AS `d` ON d.department_id = e.department_id
WHERE(e.salary > 15000)
ORDER BY d.department_id DESC
LIMIT 5;

5.
SELECT e.employee_id,e.first_name
FROM employees AS `e`
LEFT OUTER
JOIN employees_projects AS `ep` ON ep.employee_id = e.employee_id
WHERE(ep.project_id IS NULL)
ORDER BY e.employee_id DESC
LIMIT 3;

6.
SELECT e.first_name, e.last_name, e.hire_date, d.name
FROM employees AS `e`
JOIN departments AS `d` ON d.department_id = e.department_id AND d.name IN ('Sales', 'Finance')
WHERE(DATE(e.hire_date) > '1999-01-01')
ORDER BY e.hire_date ASC;

7.
SELECT e.employee_id, e.first_name, nam
FROM employees AS `e`, projects AS `p`, (
SELECT p.name AS `nam`, p.project_id AS `pid`
FROM employees_projects AS `ep`
LEFT OUTER
JOIN projects AS `p` ON p.end_date IS NULL
WHERE (DATE(p.start_date) > '2002-08-13')
GROUP BY p.project_id) AS ui
JOIN employees_projects AS `ep` ON ep.project_id = pid
WHERE(e.employee_id = ep.employee_id AND ui.nam = p.name)
GROUP BY e.employee_id
ORDER BY e.first_name, p.name ASC
LIMIT 5;


8.
SELECT e.employee_id, e.first_name, IF(DATE(p.start_date) >= '2005-01-01', NULL, p.name) AS `project_name`
FROM employees AS `e`
JOIN employees_projects AS `ep` ON ep.employee_id = e.employee_id
JOIN projects AS `p` ON p.project_id = ep.project_id
WHERE(e.employee_id = 24)
ORDER BY p.name ASC;

9.
SELECT e.employee_id, e.first_name, e.manager_id,e1.first_name
FROM employees AS `e`
JOIN employees AS `e1` ON e1.employee_id = e.manager_id
WHERE(e.manager_id = 3 OR e.manager_id = 7)
ORDER BY e.first_name ASC;

10.
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS `employee_name`, CONCAT(e1.first_name, ' ',e1.last_name) AS `manager_name`, d.name AS `department_name`
FROM employees AS `e`
JOIN employees AS `e1` ON e1.employee_id = e.manager_id
JOIN departments AS `d` ON d.department_id = e.department_id
ORDER BY e.employee_id ASC
LIMIT 5;

11.
SELECT MIN(avg_sal.sal)
FROM (
SELECT e.department_id, AVG(e.salary) AS `sal`
FROM employees AS `e`
GROUP BY e.department_id) AS `avg_sal`;

12.
SELECT c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM countries AS `c`
JOIN mountains_countries AS `mc` ON mc.country_code = c.country_code
JOIN mountains AS `m` ON m.id = mc.mountain_id
JOIN peaks AS `p` ON p.mountain_id = m.id
WHERE(p.elevation > 2835 AND c.country_name = 'Bulgaria')
ORDER BY p.elevation DESC;

13.
SELECT c.country_code, COUNT(mc.mountain_id) AS 'mountain_range'
FROM countries AS `c`
JOIN mountains_countries AS `mc` ON mc.country_code = c.country_code
WHERE(c.country_code = 'BG' OR c.country_code = 'RU' OR c.country_code = 'US')
GROUP BY c.country_code
ORDER BY COUNT(mc.mountain_id) DESC;

14.
SELECT c.country_name, r.river_name
FROM countries AS `c`
LEFT JOIN countries_rivers AS `cr` ON cr.country_code = c.country_code
LEFT JOIN rivers AS `r` ON r.id = cr.river_id
WHERE(c.continent_code = 'AF')
ORDER BY c.country_name ASC
LIMIT 5;

15.
SELECT ff.continent_code, ff.currency_code, ff.curr_count
FROM
(
SELECT c.continent_code, c.currency_code, COUNT(c.currency_code) AS `curr_count`
FROM countries AS `c`
GROUP BY c.continent_code, c.currency_code
HAVING curr_count > 1
ORDER BY c.continent_code ASC, curr_count DESC
) AS `ff`
JOIN
(
SELECT maxi.continent_code, maxi.currency_code, MAX(maxi.curr_count) AS `max_count_for_join`
FROM
(
SELECT c.continent_code, c.currency_code, COUNT(c.currency_code) AS `curr_count`
FROM countries AS `c`
GROUP BY c.continent_code, c.currency_code
HAVING curr_count > 1
ORDER BY c.continent_code ASC, curr_count DESC
) AS `maxi`
GROUP BY maxi.continent_code
) AS `ss` ON ff.continent_code = ss.continent_code AND ff.curr_count = ss.max_count_for_join
ORDER BY ff.continent_code ASC, ff.currency_code ASC;

16.
SELECT COUNT(*) - with_mount AS `country_count`
FROM countries AS `c`, (
SELECT COUNT(*) AS `with_mount`
FROM (
SELECT c.country_code AS `code`, mc.country_code
FROM countries AS `c`
JOIN mountains_countries AS `mc` ON mc.country_code <> c.country_code
GROUP BY mc.country_code, mc.country_code) AS `uui`) AS `uui1`;

17.
SELECT c.country_name, p.elevation,r.length
FROM countries AS `c`
JOIN countries_rivers AS `cr` ON cr.country_code = c.country_code
JOIN mountains_countries AS `mc` ON mc.country_code = c.country_code
JOIN rivers AS `r` ON r.id = cr.river_id
JOIN peaks AS `p` ON p.mountain_id = mc.mountain_id
GROUP BY c.country_name
ORDER BY p.elevation DESC, r.length DESC, c.country_name ASC
LIMIT 5;