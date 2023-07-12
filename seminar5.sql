USE seminar3;

SELECT * FROM staff;

-- Ранжирование - это постановка всех возможны рейтингов (ТОП-500 известных людей, ТОП-50 самых богатых людей и т.д.)

-- Вывести список всех сотрудников и указать место в рейтинге по зарплатам
SELECT
	salary,  -- зарплата
    post,  -- занимая должность
    CONCAT(firstname, " ", lastname) AS fullname, -- ФИО
    DENSE_RANK() OVER(ORDER BY salary DESC) AS `dense_rank`
FROM staff;

-- Усложним - Вывести список всех сотрудников и указать место в рейтинге по зарплатам
-- НО по каждой должности
SELECT
	salary,  -- зарплата
    post,  -- занимая должность
    CONCAT(firstname, " ", lastname) AS fullname, -- ФИО
    DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS `dense_rank`
FROM staff;

-- Найдем самых высокооплачиваемых сотрудников
SELECT *  -- salary, post, fullname, dense_rank
FROM (SELECT
		salary,  -- зарплата
		post,  -- занимая должность
		CONCAT(firstname, " ", lastname) AS fullname, -- ФИО
		DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS `dense_rank`
	FROM staff) rank_salary
WHERE `dense_rank` = 1;

-- Найдем ТОП-2 самых высокооплачиваемых сотрудников
SELECT *  -- salary, post, fullname, dense_rank
FROM (SELECT
		salary,  -- зарплата
		post,  -- занимая должность
		CONCAT(firstname, " ", lastname) AS fullname, -- ФИО
		DENSE_RANK() OVER(PARTITION BY post ORDER BY salary DESC) AS `dense_rank`
	FROM staff) rank_salary
WHERE `dense_rank` IN (1, 2); -- или `dense_rank` = 1 OR `dense_rank` = 2

-- Агрегации
-- Найдем:
		-- суммарную зарплату внутри отдела (1)
		-- среднюю зарплату внутри отдела (2)
		-- процентное соотношение отдельно взятой заработной платы к суммарной зарплате внутри отдела (3)
SELECT
	salary,  -- зарплата
	post,  -- занимая должность
	CONCAT(firstname, " ", lastname) AS fullname, -- ФИО
    SUM(salary) OVER w AS sum_salary,  -- w - автоматически понимаем что это (PARTITION BY post) (1)
    ROUND(AVG(salary) OVER w, 2) AS avg_salary, -- (2)
    ROUND(salary * 100 / SUM(salary) OVER w, 2) AS percent_sum_salary -- (3)
FROM staff
WINDOW w AS (PARTITION BY post);

-- предыдущий запрос можно записать и без псевданима w, но он будет длинее
SELECT
	salary,
	post,
	CONCAT(firstname, " ", lastname) AS fullname,
	SUM(salary) OVER (PARTITION BY post) AS sum_salary,
	AVG(salary) OVER (PARTITION BY post) AS avg_salary,
	ROUND(salary * 100 / SUM(salary) OVER (PARTITION BY post) , 2) AS percent_sum_salary
FROM staff;

-- Представления - VIEW - виртуальные таблицы
-- Найдем кол-во сотрудников внутри должности и среднюю зарплату и сделаем соритровка по возрастанию кол-ва сотрудников
SELECT 
	COUNT(*) AS count_staff,
    post,
    AVG(salary) AS `avg`
FROM staff
GROUP BY post
ORDER BY count_staff;

-- если запрос делается часто, то его можно положить в представление:
CREATE OR REPLACE VIEW count_post  -- создаем представление с именем count_post
AS SELECT 
	COUNT(*) AS count_staff,
    post,
    AVG(salary) AS `avg`
FROM staff
GROUP BY post
ORDER BY count_staff;

SELECT *  -- count_staff, post, `avg`
FROM count_post;  -- обращаемся к представлению с именем count_post
