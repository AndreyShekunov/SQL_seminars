USE lesson2;

-- CREATE TABLE - создает таблицу 
CREATE TABLE Customer
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
    Age INT,
    FirstName VARCHAR(20),
    LastName VARCHAR(20)
);

SELECT * FROM Customer;

-- Арифмитические операции: 
-- Сложение 
SELECT 3+5;

-- Вычитание  
SELECT 3-5;

-- Умножение 
SELECT 3*5;

-- Деление 
SELECT 3/5;


USE lesson2;

-- Создание таблицы Product
CREATE TABLE Product
(
	Id INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(30) NOT NULL,
    Manufacturer VARCHAR(20) NOT NULL,
    ProductCount INT DEFAULT 0,
    Price DECIMAL
);

-- Заполнение таблицы Product данными 
INSERT INTO Product (ProductName, Manufacturer, ProductCount, Price)
VALUES
	('iPhone X', 'Apple', 3, 76000),
	('iPhone 8', 'Apple', 2, 51000),
	('Galaxy S9', 'Samsung', 2, 56000),
	('Galaxy S8', 'Samsung', 1, 41000),
	('P20 Pro', 'Huawei', 5, 36000);
    
-- Выведем все товары из таблички Product
SELECT * FROM Product;

-- Выберем продукты компании Apple и Samsung из таблицы Product
SELECT * FROM Product
WHERE Manufacturer IN ("Apple", "Samsung");

-- Выберем все продукты компаний, которые не Apple и не Samsung из таблицы Product
SELECT * FROM Product
WHERE NOT Manufacturer IN ("Apple", "Samsung");