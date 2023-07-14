USE seminar3;

SELECT * FROM staff;

DROP PROCEDURE IF EXISTS get_status;
DELIMITER $$
CREATE PROCEDURE get_status
(
	IN staff_number INT, -- Входящий параметр, его передаем в процедуру
	OUT staff_status VARCHAR(45) -- Запись статуса конкетного возращаться
)
BEGIN
	DECLARE salary_limit DOUBLE;
	SELECT salary INTO salary_limit -- salary_limit - ЗП сотрудника по id
	FROM staff
	WHERE id = staff_number; -- staff_number = 3, получаем ЗП сотрудника с id = 3

	IF salary_limit BETWEEN 0 AND 49999 
		THEN SET staff_status = "Средн-я";

	ELSEIF salary_limit BETWEEN 50000 AND 69999 
		THEN SET staff_status = "ЗП выше средней";

	ELSEIF salary_limit >= 70000 
		THEN SET staff_status = "Высокая ЗП";
	END IF;
END $$

-- Вызов процедуры
CALL get_status(4, @res_out); -- Статус для сотрудника 4: Саша Сасин с зп 50000.00
SELECT @res_out; -- Результат хранится в переменной @res_out


-- Функция для вычисления возраста человека
-- Передаем в функцию дату рождения и текущую дату

SELECT NOW(); -- 2023-07-14 20:31:43 - получаем текущую дату и время

DROP FUNCTION IF EXISTS get_age;
CREATE FUNCTION get_age
(
	date_birth DATE, -- "YYYY-MM-DD" : "2020-06-23"
	current_t DATETIME -- 2023-06-23 20:41:49 -> "YYYY-MM-DD HH:MM:SS"
)
RETURNS INT
DETERMINISTIC -- с помощью данной команды сохраняем результат в кеш, чтобы при повторном запросе не выполнять снова расчет
RETURN (YEAR(current_t) - YEAR(date_birth)); -- 2023 - 2000 = 23

-- Вызвать функцию
SELECT get_age("1983-09-04", NOW());

USE seminar3_dop;
-- Cсылка: https://file.notion.so/f/s/ed99f11a-a5b6-4c6a-8e0b-4b33b70f2af9/vk_db.sql?id=9c3cfb24-07a0-4295-ba9a-2eedc941e695&table=block&spaceId=7cb6e072-1d0a-4d86-8d20-84738dadbe46&expirationTimestamp=1687629340123&signature=IzuGKG3PzR0YsDnKVsIUTkoCccjqHhRSFN_uLdsnMxI&downloadName=vk_db.sql

-- Создание процедуры для добавления нового пользователя с использованием COMMIT / ROLLBACK
DROP PROCEDURE IF EXISTS user_add;
DELIMITER $$ 
CREATE PROCEDURE user_add
(
	firstname VARCHAR(50), lastname VARCHAR(50), email VARCHAR(50), -- данные из таблицы users БД seminar3_dop
    phone VARCHAR(50), hometown VARCHAR(50), photo_id INT, birthday DATE, -- данные из таблицы profiles
    OUT result VARCHAR(300) -- в result будет помещен либо результат либо ошибка
)
BEGIN
	DECLARE _rollback BIT DEFAULT 0; -- _rollback (_rollback = 1) - откат; commit - сохранить (_rollback = 0)
	DECLARE code_error VARCHAR(300); --  код ошибки
	DECLARE error_text VARCHAR(300); --  текст ошибки
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		SET _rollback = 1; -- Найдена ошибка, данные в бд НЕ СОХРАНЯЕМ 
        GET STACKED DIAGNOSTICS CONDITION 1
			code_error = RETURNED_SQLSTATE, error_text = MESSAGE_TEXT;
	END;
    
    START TRANSACTION;

	INSERT INTO users (firstname, lastname, email) -- Имена столбцов
	VALUES (firstname, lastname, email); -- Параметры процедуры
	

	INSERT INTO profiles (user_id, hometown, birthday, photo_id) -- Имена столбцов
	VALUES (last_insert_id(), hometown, birthday, photo_id); -- Параметры процедуры
	
    IF _rollback THEN -- _rollback == 1, то есть ошибка в заполнее данных 
		SET result = CONCAT("Упс! Ошибка: ", code_error, " .Текст ошибки: ", error_text);
        ROLLBACK; -- Откат изменений , так как у нас есть ошибка 
	ELSE -- _rollback = 0, все ок
		SET result = "O k!";
        COMMIT;
    END IF;

END $$
DELIMITER ;

-- Вызов процедуры 
CALL user_add
	("New", "User", "new_user@gmail.com","0390123", "Moscow", -1, "1998-01-01", @procedure_result);
SELECT @procedure_result;

CALL user_add
	("New", "User", "new_user@gmail.com","0390123", "Moscow", 10, "1998-01-01", @procedure_result);
SELECT @procedure_result;

DELIMITER ;
-- '$$ -- Конец процедуры, причем, для сервера' at line 23 0.000 sec

DROP PROCEDURE IF EXISTS print_numbers;
DELIMITER //
CREATE PROCEDURE print_numbers
(
	IN input_numbers INT -- N
)
BEGIN
	DECLARE n INT;
	DECLARE result VARCHAR(45) DEFAULT "";
	SET n = input_numbers;

	REPEAT
		SET result = CONCAT(result, n, ",");
		SET n = n - 1;
		UNTIL n <= 0 -- Условие выхода из цикла: когда n - отрицательное или равно 0
	END REPEAT;
	SELECT result;
END //

CALL print_numbers(4);