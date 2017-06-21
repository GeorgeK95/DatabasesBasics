1.
CREATE PROCEDURE usp_get_employees_salary_above_35000 () BEGIN
SELECT e.first_name, e.last_name
FROM employees AS `e`
WHERE(e.salary > 35000)
ORDER BY e.first_name, e.last_name; END

2.
CREATE PROCEDURE usp_get_employees_salary_above(number DECIMAL(19,4)) BEGIN
SELECT e.first_name, e.last_name
FROM employees AS `e`
WHERE(e.salary >= number)
ORDER BY e.first_name, e.last_name; END

3.
CREATE PROCEDURE usp_get_towns_starting_with (param VARCHAR(50)) BEGIN
SELECT t.name
FROM towns AS `t`
WHERE t.name LIKE CONCAT(param, '%')
ORDER BY t.name; END

4.
CREATE PROCEDURE usp_get_employees_from_town (townName VARCHAR(50)) BEGIN
SELECT e.first_name, e.last_name
FROM employees AS `e`
JOIN addresses AS `a` ON a.address_id = e.address_id
JOIN towns AS `t` ON t.town_id = a.town_id
WHERE (t.name = townName)
ORDER BY e.first_name, e.last_name; END

5.
CREATE FUNCTION ufn_get_salary_level (salary DECIMAL(19,4)) RETURNS VARCHAR(50) BEGIN DECLARE level_salary VARCHAR(20); IF(salary < 30000) THEN SET level_salary := 'Low'; ELSEIF(salary >= 30000 AND salary <= 50000) THEN SET level_salary := 'Average'; ELSE SET level_salary := 'High'; END IF; RETURN level_salary; END

6.
CREATE PROCEDURE usp_get_employees_by_salary_level(pLevel VARCHAR(50)) BEGIN IF(pLevel = 'Low') THEN
SELECT e.first_name, e.last_name
FROM employees AS `e`
WHERE(e.salary < 30000)
ORDER BY e.first_name DESC, e.last_name DESC; ELSEIF(pLevel = 'Average') THEN
SELECT e.first_name, e.last_name
FROM employees AS `e`
WHERE(e.salary BETWEEN 30000 AND 50000)
ORDER BY e.first_name DESC, e.last_name DESC; ELSEIF(pLevel = 'High') THEN
SELECT e.first_name, e.last_name
FROM employees AS `e`
WHERE(e.salary > 50000)
ORDER BY e.first_name DESC, e.last_name DESC; END IF; END

7.
CREATE FUNCTION ufn_is_word_comprised (set_of_letters VARCHAR(50), word VARCHAR(50)) RETURNS TINYINT(1) BEGIN DECLARE wLength INT; DECLARE counter INT; SET wLength := CHAR_LENGTH(word); SET counter := 1; WHILE (counter <= wLength) DO IF(set_of_letters NOT LIKE CONCAT('%',
RIGHT(LEFT(word,counter),1),'%')) THEN RETURN 0; END IF; SET counter := counter + 1; END WHILE; RETURN 1; END 

8.
DELETE
FROM employees_projects
WHERE employees_projects.employee_id IN
(
SELECT e.employee_id
FROM employees AS `e`
WHERE e.department_id = (
SELECT d.department_id
FROM departments AS `d`
WHERE(d.name = 'Production')) OR e.department_id = (
SELECT d.department_id
FROM departments AS `d`
WHERE(d.name = 'Production Control'))
);
UPDATE employees AS `e` SET e.manager_id = NULL
WHERE e.department_id = (
SELECT d.department_id
FROM departments AS `d`
WHERE(d.name = 'Production')) OR e.department_id = (
SELECT d.department_id
FROM departments AS `d`
WHERE(d.name = 'Production Control')); ALTER TABLE departments MODIFY COLUMN manager_id INT NULL;
UPDATE departments AS `d` SET d.manager_id = NULL
WHERE(d.name = 'Production' OR d.name = 'Production Control'); ALTER TABLE employees
DROP FOREIGN KEY fk_employees_employees;
DELETE
FROM employees
WHERE employees.department_id = (
SELECT d.department_id
FROM departments AS `d`
WHERE(d.name = 'Production')) OR employees.department_id = (
SELECT d.department_id
FROM departments AS `d`
WHERE(d.name = 'Production Control'));
DELETE
FROM departments
WHERE (name = 'Production' OR name = 'Production Control');

9.
CREATE PROCEDURE usp_get_holders_full_name() BEGIN
SELECT CONCAT(ac.first_name, ' ', ac.last_name) AS `full_name`
FROM account_holders AS `ac`
ORDER BY full_name; END

10.
CREATE PROCEDURE usp_get_holders_with_balance_higher_than (pNum DECIMAL(19,4)) BEGIN
SELECT ah.first_name, ah.last_name, SUM(a.balance)
FROM accounts AS `a`
JOIN account_holders AS `ah` ON ah.id = a.account_holder_id
GROUP BY a.account_holder_id
HAVING(SUM(a.balance) > pNum)
ORDER BY ah.first_name, ah.last_name; END

11.
CREATE FUNCTION ufn_calculate_future_value(i DECIMAL(19,2), r DECIMAL(19,2), t INT) RETURNS DECIMAL(19,2) BEGIN RETURN (i * (POW((1 + r), t))); END

12.
CREATE PROCEDURE usp_calculate_future_value_for_account (account_id INT, interest_rate DECIMAL(19,4)) BEGIN DECLARE future_value DECIMAL(19,4); DECLARE balance DECIMAL(19, 4); SET balance := (
SELECT a.balance
FROM accounts AS a
WHERE a.id = account_id); SET future_value := balance * (POW((1 + interest_rate), 5));
SELECT a.id AS account_id, ah.first_name, ah.last_name, a.balance, future_value
FROM accounts AS a
INNER JOIN account_holders AS ah ON a.account_holder_id = ah.id AND a.id = account_id; END;

13.
CREATE PROCEDURE usp_deposit_money (account_id INT, money_amount DECIMAL(19,4)) BEGIN START TRANSACTION; IF(money_amount <= 0 OR account_id > 18 OR account_id < 1) THEN ROLLBACK; ELSE
UPDATE accounts AS `a` SET a.balance = a.balance + money_amount
WHERE(account_id = a.id); COMMIT; END IF; END

14.
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4)) BEGIN START TRANSACTION;
UPDATE accounts AS `a` SET a.balance = a.balance - money_amount
WHERE(account_id = a.id); IF((
SELECT a1.balance
FROM accounts AS `a1`
WHERE account_id = a1.id) < 0) THEN ROLLBACK; END IF; IF(money_amount <= 0 OR account_id > 18 OR account_id < 1) THEN ROLLBACK; END IF; COMMIT; END

15.
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19,4)) BEGIN START TRANSACTION;
UPDATE accounts AS `a` SET a.balance = a.balance - amount
WHERE(a.id = from_account_id);
UPDATE accounts AS `a` SET a.balance = a.balance + amount
WHERE(a.id = to_account_id); IF(from_account_id < 1 OR from_account_id > 18 OR to_account_id < 1 OR to_account_id > 18) THEN ROLLBACK; END IF; IF(amount <= 0) THEN ROLLBACK; END IF; IF((
SELECT a.balance
FROM accounts AS `a`
WHERE a.id = from_account_id) - amount< 0) THEN ROLLBACK; END IF; IF(from_account_id = to_account_id) THEN ROLLBACK; END IF; COMMIT; END

16.
CREATE TABLE LOGS 
(
	log_id INT AUTO_INCREMENT PRIMARY KEY, 
	account_id INT, 
	old_sum DECIMAL(19,4), 
	new_sum DECIMAL(19,4)
);
CREATE TRIGGER after_accounts_update AFTER
UPDATE ON accounts FOR EACH ROW BEGIN
INSERT INTO LOGS (account_id, old_sum, new_sum) VALUES (OLD.id, OLD.balance, NEW.balance); END

17.
CREATE TABLE LOGS 
(
	log_id INT AUTO_INCREMENT PRIMARY KEY, 
	account_id INT, 
	old_sum DECIMAL(19,4), 
	new_sum DECIMAL(19,4)
);
CREATE TABLE notification_emails 
(
	id INT AUTO_INCREMENT PRIMARY KEY, 
	recipient INT, 
	subject VARCHAR(255), 
	body VARCHAR(255)
);
CREATE TRIGGER after_log_insert AFTER
INSERT ON LOGS FOR EACH ROW BEGIN
INSERT INTO notification_emails (recipient, subject, body) VALUES (NEW.account_id, CONCAT('balance change for account: ', NEW.account_id),
INSERT(
INSERT(
INSERT('On your balance was changed from  to .', 4, 0, DATE_FORMAT(NOW(),'%b %d %Y at %T %p ')), 61, 0, NEW.old_sum), CHAR_LENGTH(NEW.old_sum) + 65, 0, NEW.new_sum)); END;
CREATE TRIGGER after_accounts_update AFTER
UPDATE ON accounts FOR EACH ROW BEGIN
INSERT INTO LOGS (account_id, old_sum, new_sum) VALUES (OLD.id, OLD.balance, NEW.balance); END

18.
CREATE PROCEDURE buy_lv_11_12 () BEGIN DECLARE total DECIMAL(19,4); START TRANSACTION;
INSERT INTO user_game_items (user_game_id, item_id)
SELECT (
SELECT ug.id
FROM users_games ug
INNER JOIN games g ON g.id = ug.game_id
INNER JOIN users u ON u.id = ug.user_id
WHERE u.user_name='Stamat' AND g.name='Safflower') AS ug_id, id
FROM items
WHERE min_level BETWEEN 11 AND 12; SET total= 	(
SELECT ug.cash
FROM users_games AS ug
INNER JOIN games g ON g.id = ug.game_id
INNER JOIN users u ON u.id = ug.user_id
WHERE (u.user_name='Stamat' AND g.name='Safflower')) - (
SELECT SUM(price)
FROM items
WHERE min_level BETWEEN 11 AND 12);
UPDATE users_games ug
INNER JOIN games g ON g.id = ug.game_id
INNER JOIN users u ON u.id = ug.user_id SET ug.cash = ug.cash - (
SELECT SUM(price)
FROM items
WHERE min_level BETWEEN 11 AND 12)
WHERE (u.user_name='Stamat' AND g.name='Safflower'); IF(total < 0) THEN ROLLBACK; ELSE COMMIT; END IF; END ;
CREATE PROCEDURE buy_lv_19_21 () BEGIN DECLARE total DECIMAL(19,4); START TRANSACTION;
INSERT INTO user_game_items (user_game_id, item_id)
SELECT (
SELECT ug.id
FROM users_games ug
INNER JOIN games g ON g.id = ug.game_id
INNER JOIN users u ON u.id = ug.user_id
WHERE u.user_name='Stamat' AND g.name='Safflower') AS ug_id, id
FROM items
WHERE min_level BETWEEN 19 AND 21; SET total = 	(
SELECT ug.cash
FROM users_games AS ug
INNER JOIN games g ON g.id = ug.game_id
INNER JOIN users u ON u.id = ug.user_id
WHERE (u.user_name='Stamat' AND g.name='Safflower')) - (
SELECT SUM(price)
FROM items
WHERE min_level BETWEEN 19 AND 21);
UPDATE users_games ug
INNER JOIN games g ON g.id = ug.game_id
INNER JOIN users u ON u.id = ug.user_id SET ug.cash = ug.cash - (
SELECT SUM(price)
FROM items
WHERE min_level BETWEEN 19 AND 21)
WHERE (u.user_name='Stamat' AND g.name='Safflower'); IF(total < 0) THEN ROLLBACK; ELSE COMMIT; END IF; END ;
CREATE PROCEDURE extract_cash_Stamat() BEGIN
SELECT ug.cash
FROM users AS `u`
JOIN users_games AS `ug` ON ug.user_id = u.id
JOIN games AS `g` ON g.id = ug.game_id
WHERE u.user_name = 'Stamat' AND g.name = 'Safflower'; END ;
CREATE PROCEDURE do_select() BEGIN
SELECT i.name
FROM items AS `i`
JOIN user_game_items AS `ugi` ON ugi.item_id = i.id AND ugi.user_game_id = (
SELECT ug.id
FROM users_games AS `ug`
JOIN games AS `g` ON g.id = ug.game_id
WHERE g.name = 'Safflower')
ORDER BY i.name; END;
CREATE PROCEDURE usp_massive_shopping() BEGIN CALL buy_lv_11_12(); CALL buy_lv_19_21(); CALL do_select(); CALL extract_cash_Stamat(); END ;

19.
CREATE PROCEDURE alex_buy_proc(user_id INT, item_name VARCHAR(50)) BEGIN DECLARE curr_cash DECIMAL(19,4); DECLARE level_alex INT; DECLARE wanted_item_lv INT; START TRANSACTION;
INSERT INTO user_game_items(item_id, user_game_id) VALUES((
SELECT i.id
FROM items AS `i`
WHERE i.name = item_name), user_id);
	
	#svalqme cash na usera
UPDATE users_games AS `ug` SET ug.cash = ug.cash - (
SELECT i.price
FROM items AS `i`
WHERE i.name = item_name)
WHERE (id = user_id); SET curr_cash := (
SELECT ug.cash
FROM users_games AS `ug`
JOIN users AS `u` ON u.id = ug.user_id
JOIN games AS `g` ON g.id = ug.game_id
WHERE(u.user_name = 'Alex' AND g.name = 'Edinburgh')); SET level_alex := (
SELECT ug.`level`
FROM users_games AS `ug`
JOIN games AS `g` ON g.id = ug.game_id
JOIN users AS `u` ON u.id = ug.user_id
WHERE(u.user_name = 'Alex' AND g.name = 'Edinburgh')
	); SET wanted_item_lv := (
SELECT i.min_level
FROM items AS `i`
WHERE (i.name = item_name)
	); IF(curr_cash < 0 OR(level_alex < wanted_item_lv)) THEN ROLLBACK; ELSE COMMIT; END IF; END;
CREATE PROCEDURE usp_buy_items_for_alex() BEGIN DECLARE alex_game_id INT; SET alex_game_id = (
SELECT ug.id
FROM users_games AS `ug`
JOIN users AS `u` ON u.id = ug.user_id
JOIN games AS `g` ON g.id = ug.game_id
WHERE(u.user_name = 'Alex' AND g.name = 'Edinburgh')
	); CALL alex_buy_proc(alex_game_id, 'Blackguard'); CALL alex_buy_proc(alex_game_id, 'Bottomless Potion of Amplification'); CALL alex_buy_proc(alex_game_id, 'Eye of Etlich (Diablo III)'); CALL alex_buy_proc(alex_game_id, 'Gem of Efficacious Toxin'); CALL alex_buy_proc(alex_game_id, 'Golden Gorget of Leoric'); CALL alex_buy_proc(alex_game_id, 'Ziggurat Tooth'); CALL alex_buy_proc(alex_game_id, 'The Three Hundredth Spear'); CALL alex_buy_proc(alex_game_id, 'The Short Mans Finger'); CALL alex_buy_proc(alex_game_id, 'Tzo Krins Gaze'); CALL alex_buy_proc(alex_game_id, 'Valtheks Rebuke'); CALL alex_buy_proc(alex_game_id, 'Utars Roar'); CALL alex_buy_proc(alex_game_id, 'Urn of Quickening'); CALL alex_buy_proc(alex_game_id, 'Boots'); CALL alex_buy_proc(alex_game_id, 'Bombardiers Rucksack'); CALL alex_buy_proc(alex_game_id, 'Cloak of Deception'); CALL alex_buy_proc(alex_game_id, 'Hellfire Amulet');
SELECT u.user_name, g.name, ug.cash,i.name
FROM users_games AS `ug`
JOIN games AS `g` ON g.id = ug.game_id
JOIN users `u` ON ug.user_id = u.id
JOIN user_game_items AS `ugi` ON ugi.user_game_id = ug.id
JOIN items AS `i` ON i.id = ugi.item_id
WHERE(g.name = 'Edinburgh')
ORDER BY i.name; END
