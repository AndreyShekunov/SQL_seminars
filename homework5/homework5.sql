CREATE DATABASE IF NOT EXISTS homework5; 
USE homework5;

-- Создание таблицы cars
CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    `name` VARCHAR(45),
    cost INT
);

-- Заполнение таблицы cars
INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT *
FROM cars;

-- 1. Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов
CREATE OR REPLACE VIEW view_cars 
AS SELECT *
FROM cars 
WHERE cost < 25000
ORDER BY cost;
SELECT * FROM view_cars;

-- 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор OR REPLACE)
ALTER VIEW view_cars 
AS SELECT *
FROM cars 
WHERE cost < 30000
ORDER BY cost;
SELECT * FROM view_cars;

-- 3. Создайте представление, в котором будут только автомобили марки 'Шкода' и 'Ауди'
CREATE OR REPLACE VIEW cars_skoda_audi 
AS SELECT *
FROM cars 
WHERE `name` IN ('Skoda', 'Audi')
ORDER BY `name`;
SELECT * FROM cars_skoda_audi;

-- Создание таблицы cars train_schedule
DROP TABLE IF EXISTS train_schedule;
CREATE TABLE train_schedule
(
     train_id_integer INT,
     station_character_varying VARCHAR(45),
     station_time TIME
);

-- Заполнение таблицы train_schedule
INSERT INTO train_schedule (train_id_integer, station_character_varying, station_time)
VALUES
 (110, 'San Francisco', '10:00:00'),
 (110, 'Redwood City', '10:54:00'),
 (110, 'Palo Alto', '11:02:00'),
 (110, 'San Jose', '12:35:00'),
 (120, 'San Francisco', '11:00:00'),
 (120, 'Palo Alto', '12:49:00'),
 (120, 'San Jose', '13:30:00');
SELECT *
FROM train_schedule;

-- 4. Добавьте новый столбец под названием «время до следующей станции». 
-- Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
-- Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. 
-- Проще это сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной строки со следующей строкой, 
-- чтобы получить результат. В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.
SELECT 
	train_id_integer, 
    station_character_varying, 
    station_time,
    TIMEDIFF(LEAD(station_time) OVER (PARTITION BY train_id_integer), station_time) AS time_to_next_station
FROM train_schedule;