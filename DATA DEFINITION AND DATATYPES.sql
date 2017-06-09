2.
CREATE TABLE minions
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50),
	age INT(3)
);
CREATE TABLE towns
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50)
);

3. ALTER TABLE minions ADD COLUMN town_id INT, ADD FOREIGN KEY fk_town_id(town_id) REFERENCES towns(id);

4.
INSERT INTO towns (id,name) VALUES (1,'Sofia'),(2,'Plovdiv'),(3,'Varna');
INSERT INTO minions (id,name,age,town_id) VALUES (1,'Kevin',22,1),(2,'Bob',15,3),(3,'Steward', NULL,2);

5.
TRUNCATE TABLE minions;

6.
DROP TABLE minions,towns;

7.
CREATE TABLE people 
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(200) NOT NULL,
	picture BLOB,
	height DOUBLE(3,2),
	weight DOUBLE(5,2),
	gender ENUM('f','m') NOT NULL,
	birthdate DATE NOT NULL,
	biography TEXT
);
INSERT INTO people(name, picture, height, weight, gender, birthdate, biography) VALUES ('Ivan', NULL, NULL, NULL, 'm', '1995-08-24', 'malko e shmatka no e ok'),
('Petko', NULL, NULL, NULL, 'm', '1996-08-24', ''),
('Pesho', NULL, NULL, NULL, 'm', '1996-09-24', ''),
('Cenko', NULL, NULL, NULL, 'm', '1976-09-24', ''),
('Cakov', NULL, NULL, NULL, 'm', '1976-09-24', '');

8.
CREATE TABLE users
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(30) NOT NULL, PASSWORD VARCHAR(26) NOT NULL,
	profile_picture BLOB,
	last_login_time DATETIME,
	is_deleted BOOL
);
INSERT INTO users(username, PASSWORD) VALUES ('Ivancho','1234'),
('Petkancho','12534'),
('Traqncho','12364'),
('Slavqncho','12734'),
('Tom','12342');

9. ALTER TABLE users CHANGE id id INT(11) NOT NULL; ALTER TABLE users
DROP PRIMARY KEY; ALTER TABLE users ADD CONSTRAINT pk_users PRIMARY KEY(id,username);

10. ALTER TABLE users CHANGE last_login_time last_login_time DATETIME DEFAULT CURRENT_TIMESTAMP;

11. ALTER TABLE `users`
DROP PRIMARY KEY, ADD PRIMARY KEY (`id`); ALTER TABLE `users` ADD UNIQUE (username);

12.
CREATE DATABASE movies;
CREATE TABLE directors
(
	id INT(11) NOT NULL PRIMARY KEY,
	director_name VARCHAR(50) NOT NULL,
	notes TEXT
);
CREATE TABLE genres
(
	id INT(11) NOT NULL PRIMARY KEY,
	genre_name VARCHAR(50) NOT NULL,
	notes TEXT
);
CREATE TABLE categories 
(
	id INT(11) NOT NULL PRIMARY KEY,
	category_name VARCHAR(50) NOT NULL,
	notes TEXT
);
CREATE TABLE movies 
(
	id INT(11) NOT NULL PRIMARY KEY,
	title VARCHAR(50) NOT NULL,
	director_id VARCHAR(50),
	copyright_year DATE, LENGTH TIME,
	genre_id INT(11), 
	category_id INT(11), 
	rating DOUBLE(2,1),
	notes TEXT
);
INSERT INTO categories(id, category_name) VALUES(1, 'first'),(2, 'first1'),(3, 'first2'),(4, 'first3'),(5, 'first4');
INSERT INTO directors(id, director_name) VALUES(1, 'first'),(3, 'first1'),(4, 'first2'),(5, 'first3'),(6, 'first4');
INSERT INTO genres(id, genre_name) VALUES(1, 'first'),(2, 'first1'),(3, 'first2'),(4, 'first3'),(5, 'first4');
INSERT INTO movies(id, title,	director_id,genre_id,category_id) VALUES(1, 'Titanic',1,1,1),(2, 'Avatar',2,2,2),(3, 'It',3,3,3),(4, 'The Godfather',4,4,4),(5, 'Scarface',4,4,5);
INSERT INTO categories(category_name) VALUES('first'),('first1'),('first2'),('first3'),('first4'), ('first5');
INSERT INTO directors(director_name) VALUES('first'),('first1'),('first2'),('first3'),('first4'), ('first5');
INSERT INTO genres(genre_name) VALUES('first'),('first1'),('first2'),('first3'),('first4'), ('first5');
INSERT INTO movies(title,	director_id,genre_id,category_id) VALUES('Titanic',1,1,1),('Avatar',2,2,2),('It',3,3,3),('The Godfather',4,4,4),('Scarface',4,4,5);

13.
CREATE TABLE categories
(
	id INT(11) AUTO_INCREMENT PRIMARY KEY,
	category VARCHAR(50) NOT NULL,
	daily_rate INT(3),
	weekly_rate INT(3),
	monthly_rate INT(3),
	weekend_rate INT(3)
);
CREATE TABLE cars
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	plate_number VARCHAR(50) NOT NULL,
	make VARCHAR(50),
 model VARCHAR(50),
	car_year INT(4),
	category_id INT(11),
	doors INT(2),
	picture BLOB,
	car_condition VARCHAR(50),
	available BOOL
);
CREATE TABLE employees
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	title VARCHAR(50),
	notes TEXT
);
CREATE TABLE customers
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	driver_licence_number INT(11) NOT NULL,
	full_name VARCHAR(50),
	address VARCHAR(50),
	city VARCHAR(50),
	zip_code INT(5),
	notes TEXT
);
CREATE TABLE rental_orders 
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	employee_id INT(11) NOT NULL,
	customer_id INT(11),
	car_id INT(11) NOT NULL,
	car_condition VARCHAR(50),
	tank_level INT(11),
	kilometrage_start INT(11),
	kilometrage_end INT(11),
	total_kilometrage INT(11),
	start_date DATE,
	end_date DATE,
	total_days INT(11),
	rate_applied INT(3),
	tax_rate INT(11),
	order_status VARCHAR(50),
	notes TEXT
);
INSERT INTO cars(plate_number) VALUES ('123'),('1234'),('12345');
INSERT INTO categories(category) VALUES ('Classic'),('Limuzine'),('Sport');
INSERT INTO customers(driver_licence_number) VALUES ('2232'),('232323'),('111');
INSERT INTO employees(first_name,last_name) VALUES ('Ivan', 'Ivanov'),('Ivan1', 'Ivanov1'), ('Ivan2', 'Ivanov2');
INSERT INTO rental_orders(employee_id,car_id) VALUES (1, 1),(1, 2), (2, 3);

14.
CREATE DATABASE Hotel;
CREATE TABLE employees
(
	id INT(11) AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	title VARCHAR(50),
	notes TEXT
);
CREATE TABLE customers
(
	account_number VARCHAR(50) NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(50),
	emergency_name VARCHAR(50),
	emergency_number VARCHAR(50),
	notes TEXT
);
CREATE TABLE room_status
(
	room_status VARCHAR(50) NOT NULL PRIMARY KEY,
	notes TEXT
);
CREATE TABLE room_types
(
	room_type VARCHAR(50) NOT NULL PRIMARY KEY,
	notes TEXT
);
CREATE TABLE bed_types
(
	bed_type VARCHAR(50) NOT NULL PRIMARY KEY,
	notes TEXT
);
CREATE TABLE rooms
(
	room_number INT(5) NOT NULL PRIMARY KEY,
	room_type VARCHAR(50),
	bed_type VARCHAR(50),
	rate DOUBLE(2,1),
	room_status VARCHAR(50),
	notes TEXT
);
CREATE TABLE payments
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	employee_id INT(11) NOT NULL,
	payment_date DATE,
	account_number VARCHAR(50),
	first_date_occupied DATE,
	last_date_occupied DATE,
	total_days INT(11),
	amount_charged INT(11),
	tax_rate INT(11),
	tax_amount INT(11),
	payment_total INT(11),
	notes TEXT
);
CREATE TABLE occupancies
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	employee_id INT(11) NOT NULL,
	date_occupied DATE,
	account_number VARCHAR(50),
	room_number INT(5),
	rate_applied DOUBLE(2,1),
	phone_charge INT(11),
	notes TEXT
);
INSERT INTO employees(first_name, last_name) VALUES ('Ivan1','Ivanov1'),('Ivan2','Ivanov2'),('Ivan3','Ivanov3');
INSERT INTO customers(account_number, first_name, last_name) VALUES ('22', 'Ivan1','Ivanov1'),('221','Ivan2','Ivanov2'),('122','Ivan3','Ivanov3');
INSERT INTO room_status(room_status) VALUES ('free'),('freee'),('taken');
INSERT INTO room_types(room_type) VALUES ('family'),('two room'),('apartment');
INSERT INTO bed_types(bed_type) VALUES ('big'),('small'),('medium');
INSERT INTO rooms(room_number) VALUES (22),(212),(311);
INSERT INTO payments(employee_id) VALUES (22),(212),(311);
INSERT INTO occupancies(employee_id) VALUES (22),(212),(311);

15.
CREATE DATABASE soft_uni;
CREATE TABLE towns
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);
CREATE TABLE addresses
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	address_text VARCHAR(50) NOT NULL,
	town_id INT, CONSTRAINT fk_town_id FOREIGN KEY (town_id) REFERENCES towns(id)
);
CREATE TABLE departments
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);
CREATE TABLE employees
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	middle_name VARCHAR(50),
	last_name VARCHAR(50) NOT NULL,
	job_title VARCHAR(50),
	department_id INT NOT NULL,
	hire_date DATE,
	salary DECIMAL(6,2),
	address_id INT NOT NULL, CONSTRAINT fk_department_id FOREIGN KEY (department_id) REFERENCES departments(id), CONSTRAINT fk_address_id FOREIGN KEY (address_id) REFERENCES addresses(id)
);

16.
$ mysqldump -u root -p 1234 soft_uni > softuni-backup.sql

17.
INSERT INTO towns(name) VALUES ('Sofia'),('Plovdiv'),('Varna'),('Burgas');
INSERT INTO departments(name) VALUES ('Engineering'),('Sales'),('Marketing'),('Software Development'),('Quality Assurance');
INSERT INTO employees (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`) VALUES ('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', '4', '2013-02-01', '3500.00');
INSERT INTO employees (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`) VALUES ('Petar', 'Petrov', 'Petrov', 'Senior Engineer', '1', '2004-03-02', '4000.00');
INSERT INTO employees (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`) VALUES ('Maria', 'Petrova', 'Ivanova', 'Intern', '5', '2016-08-28', '525.25');
INSERT INTO employees (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`) VALUES ('Georgi', 'Terziev', 'Ivanov', 'CEO', '2', '2007-12-09', '3000.00');
INSERT INTO employees (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`) VALUES ('Peter', 'Pan', 'Pan', 'Intern', '3', '2016-08-28', '599.88');

18.
SELECT *
FROM towns;
SELECT *
FROM departments;
SELECT *
FROM employees;

19.
SELECT *
FROM towns
ORDER BY name ASC;
SELECT *
FROM departments
ORDER BY name ASC;
SELECT *
FROM employees
ORDER BY salary DESC;

20.
SELECT name
FROM towns
ORDER BY name ASC;
SELECT name
FROM departments
ORDER BY name ASC;
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC;

21.
UPDATE employees SET salary = salary * 0.1 + salary
WHERE id = id;
SELECT employees.salary
FROM employees;

22.
UPDATE payments SET payments.tax_rate = payments.tax_rate - payments.tax_rate * 0.03
WHERE id = id;
SELECT payments.tax_rate
FROM payments;

23.
TRUNCATE occupancies;