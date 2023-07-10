CREATE DATABASE IF NOT EXISTS lesson4;  -- создание БД если она не существует 

USE lesson4;

DROP TABLE IF EXISTS Customers;  
CREATE TABLE Customers  # создаем таблицу клиентов нашего банка 
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    AccountSum DECIMAL
);
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees  # создаем таблицу сотрудников нашего банка 
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL
);

INSERT INTO Customers(FirstName, LastName, AccountSum)
VALUES
	('Tom', 'Smith', 2000),
    ('Sam', 'Brown', 3000),
    ('Mark', 'Adams', 2500),
    ('Paul', 'Ins', 4200),
    ('John', 'Smith', 2800),
    ('Tim', 'Cook', 2800);
    
INSERT INTO Employees(FirstName, LastName)
VALUES
	('Homer', 'Simpson'),
    ('Tom', 'Smith'),
    ('Nick', 'Svensson'),
    ('Mark', 'Adams');

-- Оператор UNION - данный опереатор удаляет повторяющиеся значения (в этом его минус)
-- Выберем имена и фамилии из табличек Customers и Employees, соеденив их в одну таблицу 
SELECT FirstName, LastName
FROM Customers
UNION SELECT FirstName, LastName FROM Employees;

-- UNION и сортировка с помощью ORDER BY
SELECT FirstName, LastName
FROM Customers
UNION SELECT FirstName, LastName FROM Employees
ORDER BY FirstName DESC;  # сортируем по полю имя первой выборки по убыванию

-- Ошибка в UNION: если в одной выборке больше столбцов, чем в другой,
-- то они не могут быть объединены

-- Oператор UNION ALL - при использовании данного оператора удаление дубликатов не происходит 
SELECT FirstName, LastName
FROM Customers
UNION ALL SELECT FirstName, LastName 
FROM Employees;

-- добавим сортировку по полю FirstName
SELECT FirstName, LastName
FROM Customers
UNION ALL SELECT FirstName, LastName 
FROM Employees
ORDER BY FirstName;

-- можно применять UNION в пределах одной таблицы. Начисление процентов на вклад:
SELECT FirstName, LastName, AccountSum + AccountSum * 0.1 AS TotalSum
FROM Customers WHERE AccountSum < 3000
UNION SELECT FirstName, LastName, AccountSum + AccountSum * 0.3 AS TotalSum
FROM Customers WHERE AccountSum >= 3000;

-- Создаем новые таблицы Products, Customers, Orders
DROP TABLE IF EXISTS Products;  
CREATE TABLE Products
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(30) NOT NULL,
    Manufacturer VARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price DECIMAL NOT NULL
);
INSERT INTO Products (ProductName, Manufacturer, ProductCount, Price)
VALUES
	('iPhone X', 'Apple', 3, 76000),
    ('iPhone 8', 'Apple', 3, 56000),
    ('Galaxy S9', 'Samsung', 6, 56000),
    ('Galaxy S8', 'Samsung', 2, 46000),
    ('Honor 10', 'Huawei', 3, 26000);

DROP TABLE IF EXISTS Customers;  
CREATE TABLE Customers 
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS Orders;  
CREATE TABLE Orders 
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductId INT NOT NULL,
    CustomerId INT NOT NULL,
    CreatedAt DATE NOT NULL,
    ProductCount INT DEFAULT 1,
    Price DECIMAL NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE CASCADE,
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id) ON DELETE CASCADE
);

-- с помощью INNER JOIN выведем все заказы и информацию о товарах
SELECT Orders.CreatedAt, Orders.ProductCount, Products.ProductName
FROM Orders
JOIN Products ON Products.Id = Orders.ProductId;

-- OUTER JOIN
-- LEFT OUTER JOIN, пример: 
SELECT FirstName, CreatedAt, ProductCount, Price, ProductId
FROM Orders LEFT JOIN Customers
ON Orders.CustomerId = Customers.Id;

-- RIGHT OUTER JOIN, пример:
SELECT FirstName, CreatedAt, ProductCount, Price
FROM Customers RIGHT JOIN Orders
ON Orders.CustomerId = Customers.Id;

-- FULL JOIN - в MySQL его нет, но его можно заменить через оператор UNION, пример: 


-- CROSS JOIN или декартовое произведение, беоем строку из левой таблицы и умножаем на все строки правой таблицыALTER

-- Подзапросы 
-- Оператор IN
-- выберем все товары из таблицы Products на которые есть заказы в таблице Orders
SELECT * FROM Products
WHERE Id IN (SELECT ProductId FROM Orders);

-- Можем выбрать те товары, на которые нет заказов в таблице Orders:
SELECT * FROM Products
WHERE Id NOT IN (SELECT ProductId FROM Orders);

-- Оператор EXISTS
SELECT * FROM Products
WHERE EXISTS
(SELECT * FROM Orders WHERE Orders.ProductId = Products.Id)

-- CREATE TABLE SELECT - создать и склонировать таблицу 
-- CREATE TABLE названиеВашейТаблицы SELECT * FROM названиеВашейОригинальнойТаблицы


