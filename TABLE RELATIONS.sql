1.
CREATE TABLE passports 
(
	passport_id INT PRIMARY KEY,
	passport_number VARCHAR(50)
);
CREATE TABLE persons
(
	person_id INT PRIMARY KEY,
	first_name VARCHAR(50),
	salary DECIMAL(7,2),
	passport_id INT UNIQUE, CONSTRAINT FOREIGN KEY(passport_id) REFERENCES passports(passport_id)
);
INSERT INTO passports VALUES (101, 'N34FG21B'), (102, 'K65LO4R7'), (103, 'ZE657QP2');
INSERT INTO persons VALUES (1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101);

2.
CREATE TABLE manufacturers
(
manufacturer_id INT PRIMARY KEY,
name VARCHAR(50),
established_on DATE
);
CREATE TABLE models
(
model_id INT PRIMARY KEY,
name VARCHAR(50),
manufacturer_id INT, FOREIGN KEY(manufacturer_id) REFERENCES manufacturers(manufacturer_id)
);
INSERT INTO manufacturers VALUES
(1, 'BMW', '1916-03-01'),
(2, 'Tesla', '2003-01-01'),
(3, 'Lada', '1966-05-01');
INSERT INTO models VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

3.
CREATE TABLE students
(
student_id INT PRIMARY KEY,
name VARCHAR(50)
);
INSERT INTO students VALUES
(1, 'Mila'),
(2, 'Toni'),
(3, 'Ron');
CREATE TABLE exams
(
exam_id INT PRIMARY KEY,
name VARCHAR(50)
);
INSERT INTO exams VALUES
(101, 'Spring MVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g');
CREATE TABLE students_exams
(
student_id INT,
exam_id INT, CONSTRAINT FOREIGN KEY(student_id) REFERENCES students(student_id), CONSTRAINT FOREIGN KEY(exam_id) REFERENCES exams(exam_id), PRIMARY KEY(student_id, exam_id)
);
INSERT INTO students_exams VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

4.
CREATE TABLE teachers 
(
teacher_id INT PRIMARY KEY,
name VARCHAR(50),
manager_id INT, CONSTRAINT FOREIGN KEY(manager_id) REFERENCES teachers(teacher_id)
);
INSERT INTO teachers VALUES
(101, 'John', NULL),
(106, 'Greta', 101),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(105, 'Mark', 101),
(104, 'Ted', 105);

5.
CREATE TABLE cities
(
city_id INT(11) PRIMARY KEY,
name VARCHAR(50)
);
CREATE TABLE customers
(
customer_id INT(11) PRIMARY KEY,
name VARCHAR(50),
birthday DATE,
city_id INT(11), CONSTRAINT FOREIGN KEY(city_id) REFERENCES cities(city_id)
);
CREATE TABLE orders
(
order_id INT(11) PRIMARY KEY,
customer_id INT(11), CONSTRAINT FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE item_types
(
item_type_id INT(11) PRIMARY KEY,
name VARCHAR(50)
);
CREATE TABLE items
(
item_id INT(11) PRIMARY KEY,
name VARCHAR(50),
item_type_id INT(11), CONSTRAINT FOREIGN KEY(item_type_id) REFERENCES item_types(item_type_id)
);
CREATE TABLE order_items
(
order_id INT(11),
item_id INT(11), CONSTRAINT FOREIGN KEY(order_id) REFERENCES orders(order_id), CONSTRAINT FOREIGN KEY(item_id) REFERENCES items(item_id), CONSTRAINT PRIMARY KEY(order_id, item_id)
);

6.
CREATE TABLE `subjects` (
 `subject_id` INT(11) NOT NULL,
 `subject_name` VARCHAR(50) NULL, PRIMARY KEY (`subject_id`));
CREATE TABLE `majors` (
 `major_id` INT NOT NULL,
 `name` VARCHAR(50) NULL, PRIMARY KEY (`major_id`));
CREATE TABLE `students` (
 `student_id` INT NOT NULL,
 `student_number` VARCHAR(12) NULL,
 `student_name` VARCHAR(50) NULL,
 `major_id` INT(11) NULL, PRIMARY KEY (`student_id`), CONSTRAINT `fk_students_majors` FOREIGN KEY (`major_id`) REFERENCES `majors` (`major_id`));
CREATE TABLE `payments` (
 `payment_id` INT NOT NULL,
 `payment_date` DATE NULL,
 `payment_amount` DECIMAL(8,2) NULL,
 `student_id` INT(11) NULL, PRIMARY KEY (`payment_id`), CONSTRAINT `fk_payments_students` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`));
CREATE TABLE `agenda` (
 `student_id` INT(11) NOT NULL,
 `subject_id` INT(11) NOT NULL, PRIMARY KEY (`student_id`, `subject_id`), CONSTRAINT `fk_agenda_subjects` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`), CONSTRAINT `fk_agenda_students` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`));

9.
SELECT m.mountain_range, p.peak_name, p.elevation
FROM mountains AS `m`
JOIN peaks AS `p` ON m.mountain_range = 'Rila' AND p.mountain_id = 17
ORDER BY p.elevation DESC;