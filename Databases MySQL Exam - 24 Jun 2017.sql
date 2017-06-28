1.
CREATE TABLE users
(
id INT PRIMARY KEY,
username VARCHAR(30) NOT NULL UNIQUE, PASSWORD VARCHAR(30) NOT NULL,
email VARCHAR(50)
);
CREATE TABLE categories
(
id INT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
parent_id INT, CONSTRAINT fk_categories_categories FOREIGN KEY(parent_id) REFERENCES categories(id)
);
CREATE TABLE contests
(
id INT PRIMARY KEY,
name VARCHAR(50) NOT NULL,
category_id INT, CONSTRAINT fk_contests_categories FOREIGN KEY(category_id) REFERENCES categories(id)
);
CREATE TABLE problems
(
id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
points INT NOT NULL,
tests INT DEFAULT 0,
contest_id INT, CONSTRAINT fk_problems_contests FOREIGN KEY(contest_id) REFERENCES contests(id)
);
CREATE TABLE submissions
(
id INT PRIMARY KEY AUTO_INCREMENT,
passed_tests INT NOT NULL,
problem_id INT,
user_id INT, CONSTRAINT fk_submissions_problems FOREIGN KEY(problem_id) REFERENCES problems(id), CONSTRAINT fk_submissions_users FOREIGN KEY(user_id) REFERENCES users(id)
);
CREATE TABLE users_contests
(
user_id INT,
contest_id INT, CONSTRAINT pk_users_contests PRIMARY KEY(user_id,contest_id), CONSTRAINT fk_users_contests_users FOREIGN KEY(user_id) REFERENCES users(id), CONSTRAINT fk_users_contests_contests FOREIGN KEY(contest_id) REFERENCES contests(id)
);

2.
INSERT INTO submissions(passed_tests,problem_id,user_id)
SELECT CEIL(SQRT(POW(CHAR_LENGTH(p.name), 3)) - CHAR_LENGTH(p.name)),
p.id, CEIL((p.id * 3) / 2)
FROM problems AS `p`
WHERE p.id BETWEEN 1 AND 10

3.
UPDATE problems AS `p`
JOIN contests AS `c` ON c.id = p.contest_id
JOIN categories AS `cat` ON cat.id = c.category_id
JOIN submissions AS `s` ON s.problem_id = p.id SET p.tests = 
(CASE p.id % 3 WHEN 0 THEN CHAR_LENGTH(cat.name) WHEN 1 THEN (
SELECT SUM(s1.id)
FROM submissions AS `s1`
WHERE s1.problem_id = p.id) WHEN 2 THEN CHAR_LENGTH(c.name) END)
WHERE p.tests = 0;


4.
DELETE
FROM users
WHERE id IN (
SELECT uid
FROM
(
SELECT u.id AS `uid`
FROM users AS `u`
) AS `all_us`
LEFT JOIN users_contests AS `uc` ON uc.user_id = all_us.uid
WHERE uc.contest_id IS NULL)

5.
SELECT u.id, u.username, u.email
FROM users AS u
ORDER BY u.id ASC

6.
SELECT cat.id, cat.name
FROM categories AS cat
WHERE cat.parent_id IS NULL
ORDER BY cat.id ASC

7.
SELECT p.id, p.name, p.tests
FROM problems AS `p`
WHERE p.tests > p.points AND p.name LIKE '% %'
ORDER BY p.id DESC

8.
SELECT p.id, CONCAT(CONCAT(cat.name, ' - ', c.name), ' - ', p.name) AS `full_path`
FROM problems AS p
JOIN contests AS c ON c.id = p.contest_id
JOIN categories AS cat ON cat.id = c.category_id
ORDER BY p.id ASC

9.
SELECT all_cats.id, all_cats.name
FROM
(
SELECT cat1.id, cat1.name
FROM categories cat1
)
AS `all_cats`
LEFT JOIN
(
SELECT cat.parent_id, cat.name
FROM categories cat
) AS `all_chosen_for_parents` ON all_cats.id = all_chosen_for_parents.parent_id
WHERE all_chosen_for_parents.parent_id IS NULL
ORDER BY all_cats.name ASC, all_cats.id ASC

10.
SELECT u.id, u.username, u.password
FROM users AS u
WHERE u.password IN (
SELECT u1.password
FROM users AS u1
WHERE u1.id != u.id)
ORDER BY u.username ASC, u.id ASC

11.
SELECT *
FROM (
SELECT c.id, c.name, COUNT(u.id) AS COUNT
FROM contests AS c
LEFT JOIN users_contests AS uc ON uc.contest_id = c.id
LEFT JOIN users AS u ON uc.user_id = u.id
GROUP BY c.id, c.name
ORDER BY COUNT DESC
LIMIT 5) AS top
ORDER BY top.count, top.id;

12.
SELECT s.id, u.username, p.name, CONCAT(s.passed_tests, ' / ', p.tests) AS `result`
FROM submissions AS s
JOIN users AS u ON u.id = s.user_id
JOIN problems AS p ON p.id = s.problem_id
WHERE s.user_id = (
SELECT uc.user_id
FROM users_contests AS uc
GROUP BY uc.user_id
ORDER BY COUNT(uc.contest_id) DESC
LIMIT 1)
ORDER BY s.id DESC

13.
SELECT c.id, c.name, SUM(p.points) AS maximum_points
FROM contests AS c
JOIN problems AS p ON p.contest_id = c.id
GROUP BY c.id
ORDER BY SUM(p.points) DESC, c.id ASC

14.
SELECT cn.id, cn.name, COUNT(s.id) submissions
FROM contests AS cn
INNER JOIN problems AS p ON cn.id = p.contest_id
INNER JOIN users_contests AS uc ON cn.id = uc.contest_id
INNER JOIN submissions AS s ON p.id = s.problem_id AND s.user_id = uc.user_id
GROUP BY cn.id, cn.name
ORDER BY submissions DESC, cn.id

15.
CREATE PROCEDURE udp_login(username VARCHAR(50), PASSWORD VARCHAR(50)) BEGIN DECLARE is_found_us INT; DECLARE is_found_pass INT; DECLARE exist_in_logged_users INT; DECLARE us_id INT; DECLARE us_em VARCHAR(50); START TRANSACTION; SET is_found_us = (
SELECT u.id
FROM users AS u
WHERE u.username = username); SET is_found_pass = (
SELECT u.id
FROM users AS u
WHERE u.password = PASSWORD); SET exist_in_logged_users = (
SELECT liu.id
FROM logged_in_users AS liu
WHERE liu.username = username); IF(is_found_us = 0 AND is_found_pass = 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username does not exist!'; ROLLBACK; END IF; IF(is_found_us = 1 AND is_found_pass = 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password is incorrect!'; ROLLBACK; END IF; IF(is_found_us = 1 AND is_found_pass = 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password is incorrect!'; ROLLBACK; END IF; IF(exist_in_logged_users = 1) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User is already logged in!'; ROLLBACK; END IF; SET us_id = (
SELECT u.id
FROM users AS u
WHERE u.username = username); SET us_em = (
SELECT u.email
FROM users AS u
WHERE u.username = username);
INSERT INTO logged_in_users(id, username, PASSWORD, email) VALUES(us_id,username, PASSWORD,us_em); COMMIT; END

16.
CREATE PROCEDURE udp_evaluate (id INT) BEGIN DECLARE is_found INT; DECLARE found_user VARCHAR(100); DECLARE found_problem VARCHAR(100); DECLARE points INT; DECLARE tests INT; DECLARE passed_tests INT; DECLARE res INT; START TRANSACTION; SET is_found = (
SELECT s.id
FROM submissions AS s
WHERE s.id = id); IF(is_found = 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Submission does not exist!'; ROLLBACK; ELSE SET found_user = (
SELECT u.username
FROM submissions AS s
JOIN users AS u ON u.id = s.user_id
WHERE s.id = id); SET found_problem = (
SELECT p.name
FROM submissions AS s
JOIN problems AS p ON p.id = s.problem_id
WHERE s.id = id); SET points = (
SELECT p.points
FROM submissions AS s
JOIN problems AS p ON p.id = s.problem_id
WHERE s.id = id); SET tests = (
SELECT p.tests
FROM submissions AS s
JOIN problems AS p ON p.id = s.problem_id
WHERE s.id = id); SET passed_tests = (
SELECT s.passed_tests
FROM submissions AS s
WHERE s.id = id); SET res = (points / tests) * passed_tests;
INSERT INTO evaluated_submissions(id, problem, USER, result) VALUES(id, found_problem, found_user, res); COMMIT; END IF; END

17.
CREATE TRIGGER trigger_name BEFORE
INSERT ON problems FOR EACH ROW BEGIN
IF(NEW.name NOT LIKE '% %') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The given name is invalid!';
ELSEIF(NEW.points <= 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The problem’s points cannot be less or equal to 0!';
ELSEIF(NEW.tests <= 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The problem’s tests cannot be less or equal to 0!';
END IF; END
