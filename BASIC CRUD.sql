2.
SELECT *
FROM departments;

3.
SELECT d.name
FROM departments AS d;

4.
SELECT `first_name`, `last_name`, `salary`
FROM employees;

5.
SELECT `first_name`, `middle_name`, `last_name`
FROM employees;

6.
SELECT CONCAT(`first_name`, '.',`last_name`, '@softuni.bg') AS 'full_email_adrress'
FROM employees;

7.
SELECT DISTINCT e.salary
FROM employees AS e;

8.
SELECT *
FROM `employees` AS e
WHERE(STRCMP(e.job_title,'Sales Representative') = 0);

9.
SELECT `first_name`, `last_name`, `job_title`
FROM employees AS e
WHERE(e.salary BETWEEN 20000 AND 30000);

10.
SELECT CONCAT(`first_name`, ' ', `middle_name`, ' ', `last_name`) AS 'full_name'
FROM employees AS e
WHERE e.salary IN (25000, 14000, 12500, 23600);

11.
SELECT `first_name`, `last_name`
FROM `employees` AS e
WHERE (e.manager_id IS NULL);

12.
SELECT `first_name`, `last_name`, `salary`
FROM `employees` AS e
WHERE (e.salary > 50000)
ORDER BY e.salary DESC;

13.
SELECT `first_name`, `last_name`
FROM `employees` AS e
ORDER BY e.salary DESC
LIMIT 5;

14.
SELECT `first_name`, `last_name`
FROM `employees` AS e
WHERE(e.department_id != 4);

15.
SELECT *
FROM `employees` AS e
ORDER BY e.salary DESC, e.first_name, e.last_name DESC, e.middle_name;

16.
CREATE VIEW `v_employees_salaries` AS
SELECT `first_name`, `last_name`, `salary`
FROM employees;

17.
CREATE VIEW `v_employees_job_titles` AS
SELECT CONCAT(`first_name`, ' ', IF(`middle_name` IS NULL, '', `middle_name`), ' ', `last_name`) AS 'full_name', `job_title`
FROM employees;

18.
SELECT DISTINCT `job_title`
FROM employees
ORDER BY `job_title`;

19.
SELECT *
FROM projects AS p
ORDER BY p.start_date, p.name
LIMIT 10;

20.
SELECT `first_name`,`last_name`,`hire_date`
FROM employees AS e
ORDER BY e.hire_date DESC
LIMIT 7;

21.
UPDATE employees AS e SET e.salary = e.salary * 0.12 + e.salary
WHERE e.department_id IN (1, 2, 4, 11);
SELECT `salary`
FROM `employees` AS e;

22.
SELECT peaks.peak_name
FROM peaks
ORDER BY peaks.peak_name;

23.
SELECT c.country_name, c.population
FROM countries AS c
WHERE (c.continent_code = 'EU')
ORDER BY c.population DESC, c.country_name
LIMIT 30;

24.
SELECT `country_name`, `country_code`, IF(`currency_code` = 'EUR', 'Euro', 'Not Euro') AS `currency`
FROM countries AS c
ORDER BY c.country_name;

25.
SELECT c.name
FROM characters AS c
ORDER BY c.name;