-- Комментарий, необходим пробел после "--"
# Комментарий как в Python
/* Это
Многострочный 
Комментарий*/

-- 1. Создание базы данных (БД)
# CREATE DATABASE seminar1; -- Создание БД с именем seminar1, но при этом повторно ее создать нельзя, будет ошибка
CREATE DATABASE IF NOt EXISTS seminar1; -- Создание БД с именем seminar1, если она до этого не была создана
-- ошибки не будет, просто появится предупреждение 

-- 2. Подключение к БД 
USE seminar1;

-- 3. Создание таблиц - student
DROP TABLE IF EXISTS student; -- удаляю таблицу student, если она существует 
CREATE TABLE student -- создаю таблицу student 
(
	-- имя_столбца тип_данных ограничения
	id INT PRIMARY KEY AUTO_INCREMENT, -- столбец id - целое число, первичный ключ, авто инкремент (id++)
	firstname VARCHAR(45),
    phone VARCHAR(20),
    email VARCHAR(45) -- VARCHAR(45) - это строка на 45 символов
);

-- 4. Таблица есть, а где данные?
INSERT student (firstname, phone, email) -- заполняю 3 столбца
VALUES -- 3 столбца = 3 значения 
	("Антон", "+7-999-888-77-66", "anton@gmail.com"),       -- id = 1 (id++) 
	("Андрей", "+7-999-888-77-66", "andrey@gmail.com"),     -- id = 2 (id++)
    ("Артём", "+7-699-888-77-66", "artyom@gmail.com"),      -- id = 3 (id++)
    ("Александр", "+7-989-888-77-66", "alex@gmail.com"),    -- id = 4 (id++)
    ("Анастасия", "+7-999-888-77-66", "nastya@gmail.com"),  -- id = 5 (id++)
    ("Виктор", "+7-777-888-77-66", "victor@gmail.com");     -- id = 6 (id++)
    
-- 5. Увидим наши труды
SELECT * FROM student; -- "*" - считается дурным тоном, указываем столбцы через ","

-- 6. Увидим только 2 столбца: почта и имя 
SELECT firstname, email
FROM student;

-- 7. Получить почту студента по имени "Антон"
SELECT firstname, email
FROM student
WHERE firstname = "Антон"; -- регистр не имеет значение, множно было написать и "АНТОН"

-- 8. Получить почты всех студентов, исключив бедного "Антона"
SELECT firstname, email
FROM student
WHERE firstname != "Антон"; -- "<>" и "!=" - одинаковые вещи 

-- 9. Получить почты стедентов, имена которых начинаются на букву "А"
SELECT firstname, email
FROM student
WHERE firstname LIKE "А%";

-- 10.
SELECT firstname, email
FROM student
WHERE firstname LIKE "А%н%";