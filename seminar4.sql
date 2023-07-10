DROP DATABASE IF EXISTS seminar4;
CREATE DATABASE seminar4;
USE seminar4;
DROP TABLE IF EXISTS teacher;
CREATE TABLE teacher
(	
	id INT NOT NULL PRIMARY KEY,
    surname VARCHAR(45),
    salary INT
);

INSERT teacher
VALUES
	(1,"Авдеев", 17000),
    (2,"Гущенко",27000),
    (3,"Пчелкин",32000),
    (4,"Питошин",15000),
    (5,"Вебов",45000),
    (6,"Шарпов",30000),
    (7,"Шарпов",40000),
    (8,"Питошин",30000);
    
SELECT * from teacher; 
DROP TABLE IF EXISTS lesson;
CREATE TABLE lesson
(	
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    course VARCHAR(45),
    teacher_id INT,
    FOREIGN KEY (teacher_id)  REFERENCES teacher(id)
);
INSERT INTO lesson(course,teacher_id)
VALUES
	("Знакомство с веб-технологиями",1),
    ("Знакомство с веб-технологиями",2),
    ("Знакомство с языками программирования",3),
    ("Базы данных и SQL",4),
    ("Нейронные сети", NULL); -- Учитель, который ведет данный предмет, временно отстутствует
    
-- Вывести учителей с предметами, которые они ведут (это INNER JOIN)
SELECT
	t.surname,  -- t.surname = teacher.surname
    l.course  -- l.course = lesson.course
FROM teacher t
JOIN lesson l  -- INNER JOIN = JOIN
ON l.teacher_id = t.id;

-- Вывести всех учителей даже если они уроки не ведут (это LEFT JOIN)
SELECT
	t.*,  -- * получить все данный из таблицы t = teacher
    l.*  -- * получить все данный из таблицы l = lesson
FROM teacher t
LEFT JOIN lesson l 
ON l.teacher_id = t.id;

-- Вывести учителей, которые предметы не ведут 
SELECT
	t.*,  -- * получить все данный из таблицы t = teacher
    l.*  -- * получить все данный из таблицы l = lesson
FROM teacher t
LEFT JOIN lesson l 
ON l.teacher_id = t.id
WHERE l.teacher_id IS NULL;

-- Вывести учителей, которые ведут уроки по курсу "Знакомство с веб-технологиями" 
SELECT
	t.*,  -- * получить все данный из таблицы t = teacher
    l.*  -- * получить все данный из таблицы l = lesson
FROM teacher t
LEFT JOIN lesson l 
ON l.teacher_id = t.id
WHERE l.course = "Знакомство с веб-технологиями";

-- С помощью подзапроса вывести учителей, которые ведут уроки по курсу "Знакомство с веб-технологиями"
SELECT
	t.*,
    web_lesson.*  -- course, teacher_id
FROM (SELECT course, teacher_id FROM lesson WHERE course = "Знакомство с веб-технологиями") web_lesson  -- подзапрос, результат которого будет в табличке web_lesson
JOIN teacher t
ON web_lesson.teacher_id = t.id;  -- условие соединения таблиц teacher и web_lesson

-- Выборка данных по пользователю: город, ФИО, название фото (из базы seminar3_dop)
USE seminar3_dop;

SELECT
	u.firstname,  -- u = users
    u.lastname,
    p.hometown AS city,  -- p = profiles
    m.filename AS media_name
FROM users u
JOIN `profiles` p ON u.id = p.user_id
JOIN media m ON p.photo_id = m.id;

-- Получим список медиафайлов конкретного человека с указанием количества лайков и выведем ТОП-3
-- по популярности

SELECT
	CONCAT(u.firstname, " ", u.lastname) AS fullname,  -- объеденяем  в один столбец имя и фамилию через пробел
    m.filename AS media_name,  -- название медиа файла
    COUNT(*) AS total_likes
FROM media m
JOIN users u ON u.id = m.user_id   -- получили все медиа файлы конкретного человека
JOIN likes l ON l.media_id = m.id -- соединяем все лайки с медиа файлами
GROUP BY m.id  -- группируем по id медиа файлы
ORDER BY total_likes DESC  -- отсортировали в порядке убывания
LIMIT 3;  -- берем первые 3 позиции
