CREATE DATABASE IF NOT EXISTS homework2;

USE homework2;

-- 1. Используя операторы языка SQL, создайте таблицу “sales”. Заполните ее данными.

DROP TABLE IF EXISTS sales;
CREATE TABLE sales
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    order_data DATE NOT NULL,
    count_product INT NOT NULL
);

INSERT INTO sales (order_data, count_product)
VALUES
	('2021-01-01', 156),
    ('2021-01-02', 180),
    ('2021-01-03', 21),
    ('2021-01-04', 124),
    ('2021-01-05', 341);

SELECT * FROM sales;

-- 2. Разделите  значения поля "bucket" на 3 сегмента: 
		-- меньше 100 ("Маленький заказ"), 
		-- 100-300 ("Средний заказ") 
		-- больше 300 ("Большой заказ")

SELECT
	id,
    order_data,
CASE
	WHEN count_product < 100
		THEN "Маленький заказ"
	WHEN count_product BETWEEN 100 AND 300
		THEN "Средний заказ"
	WHEN count_product > 300
		THEN "Большой заказ"
	ELSE "Error"
END AS bucket
FROM sales;

-- 3. Создайте таблицу "orders", заполните ее значениями. Выберите все заказы.
-- В зависимости от поля order_status выведите столбец full_order_status:
	-- OPEN - "Order is in open state";
    -- CLOSED - "Order is closed";
    -- CANCELLED - "Order is cancelled"

DROP TABLE IF EXISTS orders;
CREATE TABLE orders
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id CHAR(3) NOT NULL,
    amount DECIMAL(5,2) NOT NULL,
    order_status VARCHAR(10) NOT NULL
);

INSERT INTO orders (employee_id, amount, order_status)
VALUES
	('e03', 15.00, "OPEN"),
    ('e01', 25.50, "OPEN"),
    ('e05', 100.70, "CLOSED"),
    ('e02', 22.18, "OPEN"),
    ('e04', 9.50, "CANCELLED");

SELECT * FROM orders;

SELECT
	id,
    order_status,
CASE
	WHEN order_status = "OPEN"
		THEN "Order is in open state."
	WHEN order_status = "CLOSED"
		THEN "Order is closed."
	WHEN order_status = "CANCELLED"
		THEN "Order is cancelled."
	ELSE "Error!"
END AS full_order_status
FROM orders;