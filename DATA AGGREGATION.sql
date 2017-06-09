1.
SELECT COUNT(*)
FROM `wizzard_deposits`;

2.
SELECT MAX(w.magic_wand_size) AS 'longest_magic_wand'
FROM `wizzard_deposits` AS `w`;

3.
SELECT w.deposit_group, MAX(w.magic_wand_size) AS 'longest_magic_wand'
FROM `wizzard_deposits` AS `w`
GROUP BY w.deposit_group
ORDER BY `longest_magic_wand`;

4.
SELECT `group`
FROM 
(
SELECT AVG(w.magic_wand_size) AS 'size', w.deposit_group AS 'group'
FROM `wizzard_deposits` AS `w`
) x

5.
SELECT w.deposit_group, SUM(w.deposit_amount) AS 'sum'
FROM `wizzard_deposits` AS `w`
GROUP BY w.deposit_group
ORDER BY `sum`;

6.
SELECT w.deposit_group, SUM(w.deposit_amount) AS 'sum'
FROM `wizzard_deposits` AS `w`
WHERE(w.magic_wand_creator='Ollivander family')
GROUP BY w.deposit_group;

7.
SELECT w.deposit_group, SUM(w.deposit_amount) AS 'sum'
FROM `wizzard_deposits` AS `w`
WHERE(w.magic_wand_creator='Ollivander family')
GROUP BY w.deposit_group
HAVING `sum` < 150000
ORDER BY `sum` DESC;

8.
SELECT w.deposit_group, w.magic_wand_creator, MIN(w.deposit_charge)
FROM wizzard_deposits AS `w`
GROUP BY w.deposit_group, w.magic_wand_creator
ORDER BY w.magic_wand_creator ASC, w.deposit_group;

9.
SELECT CASE WHEN w.age >= 0 AND w.age < 11 THEN '[0-10]' WHEN w.age >= 11 AND w.age < 21 THEN '[11-20]' WHEN w.age >= 21 AND w.age < 31 THEN '[21-30]' WHEN w.age >= 31 AND w.age < 41 THEN '[31-40]' WHEN w.age >= 41 AND w.age < 51 THEN '[41-50]' WHEN w.age >= 51 AND w.age < 61 THEN '[51-60]' WHEN w.age >= 61 THEN '[61+]' END AS 'age_group', COUNT(w.age) AS 'wizard_count'
FROM wizzard_deposits AS `w`
GROUP BY `age_group`;

10.
SELECT
LEFT(w.first_name,1) AS 'f'
FROM wizzard_deposits AS `w`
WHERE(w.deposit_group = 'Troll Chest')
GROUP BY `f`
ORDER BY `f`;

11.
SELECT w.deposit_group, w.is_deposit_expired, AVG(w.deposit_interest) AS 'average_interest'
FROM wizzard_deposits AS `w`
WHERE(w.deposit_start_date > '1985-01-01 00:00:00')
GROUP BY w.deposit_group, w.is_deposit_expired
ORDER BY w.deposit_group DESC, w.is_deposit_expired;

12.
SELECT SUM(host_wizard_deposit - guest_wizard_deposit)
FROM 
(
SELECT w.first_name AS 'host_wizard', w.deposit_amount AS 'host_wizard_deposit', 
w2.first_name AS 'guest_wizard', w2.deposit_amount AS 'guest_wizard_deposit'
FROM wizzard_deposits AS `w`, wizzard_deposits AS `w2`
WHERE(w2.id = w.id + 1)
) AS x;

13.
SELECT e.department_id, MIN(e.salary) AS 'minimum_salary'
FROM employees AS `e`
WHERE(YEAR(e.hire_date) > 2000)
GROUP BY e.department_id
HAVING (e.department_id = 2 || e.department_id = 5 || e.department_id = 7);

14.
CREATE TABLE opalq LIKE employees;
INSERT INTO opalq
SELECT *
FROM employees AS `e`
WHERE(e.salary > 30000);
DELETE
FROM opalq
WHERE opalq.manager_id = 42;
UPDATE opalq SET opalq.salary = opalq.salary + 5000
WHERE opalq.department_id = 1;
SELECT opalq.department_id, AVG(opalq.salary)
FROM opalq
GROUP BY opalq.department_id;

15.
SELECT e.department_id, MAX(e.salary)
FROM employees AS `e`
GROUP BY e.department_id
HAVING MAX(e.salary) < 30000 OR MAX(e.salary) > 70000;

16.
SELECT COUNT(e.salary)
FROM employees AS `e`
WHERE e.manager_id IS NULL;

17.
SELECT e2.department_id, MAX(e2.salary)
FROM employees AS `e2`, (
SELECT e1.department_id AS 'dpid2', MAX(e1.salary) AS 'maxsal2', e1.first_name
FROM employees AS `e1`, (
SELECT e.department_id AS 'dpid', MAX(e.salary) AS 'maxsal', e.first_name
FROM employees AS `e`
GROUP BY e.department_id
) AS `first_sal`
WHERE(e1.department_id = dpid AND e1.salary < maxsal)
GROUP BY e1.department_id) AS second_sal
WHERE(e2.department_id = dpid2 AND e2.salary < maxsal2)
GROUP BY e2.department_id

18.
SELECT e1.first_name, e1.last_name, e1.department_id
FROM employees AS `e1`, (
SELECT e.department_id AS 'dpid', AVG(e.salary) AS 'avgsal'
FROM employees AS `e`
GROUP BY e.department_id) AS avg_sal
WHERE e1.department_id = dpid AND e1.salary > avgsal
ORDER BY e1.department_id
LIMIT 10;


19.
SELECT e.department_id, SUM(e.salary)
FROM employees AS `e`
GROUP BY e.department_id;
