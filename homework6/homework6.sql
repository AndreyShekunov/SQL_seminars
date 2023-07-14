CREATE DATABASE IF NOT EXISTS homework6; 
USE homework6;

-- 1. Создайте функцию, которая принимает кол-во сек и формат их в кол-во дней, часов, минут и секунд.
		-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

DROP FUNCTION IF EXISTS translation_of_seconds;
DELIMITER $$
CREATE FUNCTION translation_of_seconds(sec INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
	DECLARE days INT;
	DECLARE hours INT;
	DECLARE minutes INT;
	DECLARE seconds INT;

	SET days = sec DIV (24 * 3600);
	SET sec = sec % (24 * 3600);
	SET hours = sec DIV 3600;
	SET sec = sec % 3600;
	SET minutes = sec DIV 60;
	SET sec = sec % 60;
	RETURN CONCAT(days, ' days ', hours, ' hours ', minutes, ' minutes ', sec, ' seconds');    
END $$
DELIMITER ;

SELECT translation_of_seconds(123456);

-- 2. Выведите только четные числа от 1 до 10 (Через цикл).
		-- Пример: 2,4,6,8,10

DROP PROCEDURE IF EXISTS get_even_numbers;
DELIMITER $$
CREATE PROCEDURE get_even_nums
(
	IN input_num INT  
)
BEGIN
	DECLARE n INT;
    DECLARE result VARCHAR(45) DEFAULT "";
    SET n = input_num;
	WHILE n <= 10 DO
		IF n % 2 = 0 THEN
			SET result = CONCAT(result, n, " ");
			SET n = n + 1;
        ELSEIF n % 2 = 1 THEN
			SET n = n + 1;
		END IF;
	END WHILE;
	SELECT result;
END $$

CALL get_even_nums(1);

-- Дополнительное задание:
-- 1. Создать процедуру, которая решает следующую задачу
        -- Выбрать для одного пользователя 5 пользователей в случайной комбинации, которые удовлетворяют хотя бы одному критерию:
            -- а) из одного города
            -- б) состоят в одной группе
            -- в) друзья друзей

-- 2. Создать функцию, вычисляющей коэффициент популярности пользователя (по количеству друзей)

-- 3. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от 
--   текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 
--   функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
DROP FUNCTION IF EXISTS hello;
DELIMITER $$
CREATE FUNCTION hello(current_t TIME)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    IF current_t BETWEEN "6:00:00" AND "11:59:59" 
		THEN RETURN "Доброе утро";
	ELSEIF current_t BETWEEN "12:00:00" AND "17:59:59" 
		THEN RETURN "Доброе день";
    ELSEIF current_t BETWEEN "18:00:00" AND "23:59:59" 
		THEN RETURN "Добрый вечер";
	ELSEIF current_t BETWEEN "00:00:00" AND "05:59:59" 
		THEN RETURN "Доброй ночи";
	END IF;
END $$

SELECT hello(NOW());

-- 4. (по желанию)***Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, communities
--   и messages в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа. (Триггеры*)
