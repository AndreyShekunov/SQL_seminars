USE lesson1;  # Подключаемся к БД lesson1
SELECT * FROM test;  # Выводим всех студентов из нашей таблицы test

# Выведем студента по логину и выведем конкретные столбцы
SELECT name, password
FROM test
WHERE login = "test1234";

SELECT name, password, email
FROM test;