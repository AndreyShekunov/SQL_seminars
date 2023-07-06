USE lesson3;

-- Создание таблицы Products
CREATE TABLE Products
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(30) NOT NULL,
    Manufacturer VARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price DECIMAL NOT NULL
);

-- Заполнение таблицы Products данными
INSERT INTO Products (ProductName, Manufacturer, ProductCount, Price)
VALUES
	('iPhone X', 'Apple', 3, 76000),
    ('iPhone 8', 'Apple', 2, 51000),
    ('iPhone 7', 'Apple', 5, 32000),
    ('Galaxy S9', 'Samsung', 2, 56000),
    ('Galaxy S8', 'Samsung', 1, 46000),
    ('Honor 10', 'Huawei', 5, 28000),
    ('Nokia 8', 'HMD Global', 6, 38000);
   
-- Вывод всей таблицы Products с сортировкой по столбцу Price по возрастанию, с использованием оператора ORDER BY:
SELECT * 
FROM Products
ORDER BY Price;

-- Вывод всей таблицы Products с сортировкой по столбцу Price по убыванию, с использованием оператора ORDER BY:
SELECT * 
FROM Products
ORDER BY Price DESC;

-- Агрегатные функции: 
-- 1. Оператор COUNT - получение количества записей из таблицы 
-- получим содержимое таблицы Products узнаем сколько там записей  
SELECT COUNT(*) AS Count
FROM Products;

-- 2. Оператор TOP (LIMIT) - применяется только в MySQL и он эквевалентен оператору LIMIT - позволяет выбрать определенное кол-во записей 
SELECT * FROM Products
LIMIT 5;  				# выбираем первые 5 записей из таблицы Products

SELECT * FROM Products
LIMIT 1, 2;				# начинаем со второй строчки и показываем 2 строчки (2 и 3 строчки)

-- 3. Оператор SUM 
-- Получение суммарной стоимости всех телефонов в магазине 
SELECT SUM(Price) AS totalSum 
FROM Products;

-- 4. Операторы MIN и MAX
-- Выберем минимальную цену из всех телефонов Apple
SELECT MIN(Price) 
FROM Products
WHERE Manufacturer = 'Apple';

-- Получить статистику по телефонам Samsung, ножно получить минимальную цену, максимальную цену и среднюю цену 
SELECT 
	MIN(Price),
	MAX(Price),
    AVG(Price)
FROM Products
WHERE Manufacturer = 'Samsung';

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
SELECT Manufacturer, COUNT(*), Price, ProductCount
FROM Products
WHERE Price > 40000
GROUP BY Manufacturer;