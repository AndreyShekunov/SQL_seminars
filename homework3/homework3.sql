-- Создание БД homework3
CREATE DATABASE IF NOT EXISTS homework3;  -- создание БД если она не существует 

-- Подключение к БД homework3
USE homework3;

-- 3. Создание таблицы staff
DROP TABLE IF EXISTS staff;  -- удаляем таблицу staff, если она существует 
CREATE TABLE staff
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(45),
    lastname VARCHAR(45),
    post VARCHAR(45),
    seniority INT,
    salary DECIMAL(8,2),
    age INT
);

-- Заполнение таблицы staff 
INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
	('Вася', 'Петров', 'Начальник', 40, 100000, 60),
	('Петр', 'Власов', 'Начальник', 8, 70000, 30),
	('Катя', 'Катина', 'Инженер', 2, 70000, 25),
	('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
	('Иван', 'Петров', 'Рабочий', 40, 30000, 59),
	('Петр', 'Петров', 'Рабочий', 20, 55000, 60),
	('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
	('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
	('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
	('Максим', 'Петров', 'Рабочий', 2, 11000, 19),
	('Юрий', 'Петров', 'Рабочий', 3, 12000, 24),
	('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);

SELECT * FROM staff; -- проверяем что все работает

-- 1. Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; 
SELECT
	id,
    lastname,
    firstname,
    salary
FROM staff
ORDER BY salary DESC;

-- возрастания
SELECT
	id,
    lastname,
    firstname,
    salary
FROM staff
ORDER BY salary;

-- 2. Выведите 5 максимальных заработных плат (saraly)
SELECT
	id,
    lastname AS Фамилия,
    firstname AS Имя,
    salary AS Зарплата
FROM staff
ORDER BY salary DESC
LIMIT 5;

-- 3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
SELECT
	post AS Специальность,
    SUM(salary) AS Суммарная_зарплата
FROM staff
GROUP BY post;

-- 4. Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
SELECT
	post AS Специальность,
    COUNT(*) AS количество_в_возрасте_от_24_до_49_лет
FROM staff
WHERE post = 'Рабочий' AND age >= 24 AND age <= 49
GROUP BY post;

-- 5. Найдите количество специальностей
SELECT
	COUNT(DISTINCT post) AS Количество_специальностей
FROM staff;

-- 6. Выведите специальности, у которых средний возраст сотрудников меньше 30 лет включительно
SELECT
	post AS Специальность,
    ROUND(AVG(age)) AS Средний_возраст
FROM staff
GROUP BY post
HAVING AVG(age) <= 30;

-- Дополнительное задание:

-- 1. Внутри каждой должности вывести ТОП-2 по ЗП (2 самых высокооплачиваемых сотрудника по ЗП внутри каждой должности)
SELECT
	post,
    lastname,
    firstname,
    salary
FROM
	(SELECT post, firstname, lastname, salary, RANK() OVER (PARTITION BY post ORDER BY salary DESC) AS rnk
    FROM staff) b
WHERE rnk=1 OR rnk=2;

-- 2. Доп по базе данных для ВК(in progress):
    -- 2.1 Посчитать количество документов у каждого пользователя
    -- 2.2 Посчитать лайки для моих документов (моих медиа)
    