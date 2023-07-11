USE lesson5;

-- Создание таблицы
DROP TABLE shop;
CREATE TABLE IF NOT EXISTS shop 
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    shopping_day DATE,
    department VARCHAR(40),
    count INT
);

-- Заполнение таблицы данными
INSERT shop (shopping_day, department, count)
VALUES
	('2022-12-21', 'Бытовая техника', 3),
	('2022-12-21', 'Свежая выпечка', 4),
    ('2022-12-21', 'Напитки', 4),
    ('2022-12-22', 'Бытовая техника', 1),
    ('2022-12-22', 'Свежая выпечка', 3),
    ('2022-12-22', 'Напитки', 3),
    ('2022-12-22', 'Замороженные продукты', 1),
    ('2022-12-23', 'Бытовая техника', 2),
    ('2022-12-23', 'Напитки', 4),
	('2022-12-23', 'Замороженные продукты', 4);
    
SELECT * FROM shop;

-- откроем окно OVER и найдем сумму и количество покупок:
SELECT 
	shopping_day, 
	department,
    count,
	SUM(count) OVER() AS 'Sum',
	COUNT(count) OVER() AS 'Count' 
FROM shop;

-- Для группировка используется  PARTITION BY , которая определяет столбец для группировки в окне:
SELECT 
	shopping_day, 
    department, 
    count,
	SUM(count) OVER(PARTITION BY shopping_day) AS 'Sum' 
FROM shop;

-- Добавим к PARTITION BY сортировку по столбцу «department» (ORDER BY department). 
-- В данной ситуации мы будем считать нарастающий итог: 
-- для каждого значения «count» мы ищем сумму всех значений с предыдущими.
SELECT 
	shopping_day, 
    department, 
    count,
	SUM(count) OVER(PARTITION BY shopping_day ORDER BY department) AS 'Sum' 
FROM shop;

-- Создание таблицы staff
CREATE TABLE IF NOT EXISTS staff 
(
    id INT PRIMARY KEY,
    first_name VARCHAR(30),
    post VARCHAR(30),
    discipline VARCHAR(30),
    salary INT
);

-- Заполнение таблицы данными
INSERT staff (id, first_name, post, discipline, salary)
VALUES
	(100,'Антон', 'Преподаватель', 'Программирование', 50),
	(101,'Василий', 'Преподаватель', 'Программирование', 60),
	(103,'Александр', 'Ассистент', 'Программирование', 25),
	(104,'Владимир', 'Профессор', 'Математика', 120),
	(105,'Иван', 'Профессор', 'Математика', 120),
	(106,'Михаил', 'Доцент', 'Физика', 70),
	(107, 'Анна', 'Доцент', 'Физика', 70),
	(108, 'Вероника', 'Доцент', 'ИКТ', 30),
	(109,'Григорий', 'Преподаватель', 'ИКТ', 25),
	(110,'Георгий', 'Ассистент', 'Программирование', 30);

-- проставить ранги по убыванию ЗП (самая маленькая ЗП - самый маленький ранг)
SELECT 
	DENSE_RANK() OVER W AS `rank`, -- W = OVER(ORDER BY salary DESC)
    first_name, 
    discipline, 
    salary
FROM staff
WINDOW  w AS (ORDER BY salary DESC)
ORDER BY `rank`, id;

-- Пусть целью моего запроса будет проставить ранг по возрастанию зарплаты, а сортировка - по убыванию:
SELECT 
	DENSE_RANK() OVER W AS `rank`, 
	first_name, 
    discipline, 
    salary
FROM staff
WINDOW w AS (ORDER BY salary ASC)
ORDER BY salary DESC;

-- Агрегирующие функции
SELECT 
	shopping_day,
	department, 
    count,
	SUM(count) OVER(PARTITION BY shopping_day) AS 'Sum' ,
	COUNT(count) OVER(PARTITION BY shopping_day) AS 'Count' ,
	AVG(count) OVER(PARTITION BY shopping_day) AS 'Avg' ,
	MAX(count) OVER(PARTITION BY shopping_day) AS 'Max' ,
	MIN(count) OVER(PARTITION BY shopping_day) AS 'Min' 
FROM shop;

-- Давайте узнаем, какой процент от суммарной ЗП по отделу получает каждый педагог.
SELECT
  first_name, 
  discipline, 
  salary,
  SUM(salary) OVER w AS payment_fund,
  ROUND(salary * 100.0 / SUM(salary) OVER w) AS percentage 
FROM staff
WINDOW  w AS (PARTITION BY discipline)
ORDER BY discipline, salary, id;

-- Функции смещения
SELECT 
	shopping_day, 
    department, 
    count, 
	LAG(count) OVER(PARTITION BY shopping_day ORDER BY shopping_day) AS 'Lag' ,
	LEAD(count) OVER(PARTITION BY shopping_day ORDER BY shopping_day) AS 'Lead' ,
	FIRST_VALUE(count) OVER(PARTITION BY shopping_day ORDER BY shopping_day) AS 'First_Value' ,
	LAST_VALUE(count) OVER(PARTITION BY shopping_day ORDER BY shopping_day) AS 'Last_Value'
FROM shop;

-- Представления (VIEW) или «виртуальные таблицы»
-- Попробуем реализовать запрос, который выводит дисциплины и количество преподавателей, 
-- которые эти предметы ведут:
SELECT
	discipline,
    count(first_name)
FROM staff
GROUP BY discipline
ORDER BY count(first_name) DESC;

-- Сделаем этот запрос представлением:
CREATE OR REPLACE VIEW count_teacher AS
SELECT
	discipline, 
    count(first_name) AS res
FROM staff
GROUP BY discipline
ORDER BY count(first_name) DESC;
-- "OR REPLACE" заменяет представление, если оно существует

-- Теперь вместо указания какого - либо сложного запроса можно вызвать представление:
SELECT * FROM count_teacher;

-- Исключим математиков
ALTER VIEW count_teacher AS
SELECT
	discipline, 
    count(first_name) AS res
FROM staff
WHERE discipline!="Математика"
GROUP BY discipline
ORDER BY count(first_name) DESC;
-- Показ
SELECT * FROM count_teacher;