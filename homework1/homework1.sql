USE homework1;

-- 1. Вывод созданной таблицы phone
SELECT * FROM phone;

-- 2. Выведите название, производителя и цену для товаров, количество которых превышает 2 (SQL - файл, скриншот, либо сам код)
SELECT ProductName, Manufacturer, ProductCount
FROM phone
WHERE ProductCount > 2;

-- 3. Выведите весь ассортимент товаров марки “Samsung”
SELECT ProductName, Manufacturer, ProductCount, Price
FROM phone
WHERE Manufacturer = "Samsung";

-- 4. Выведите информацию о телефонах, где суммарный чек больше 100 000 и меньше 145 000**
SELECT ProductName, Manufacturer, ProductCount, Price
FROM phone
WHERE ProductCount*Price BETWEEN 100000 AND 145000;

-- 5.*** С помощью регулярных выражений найти (можно использовать операторы “LIKE”, “RLIKE” для 5.3):
-- 5.1. Товары, в которых есть упоминание "Iphone"
SELECT ProductName, Manufacturer, ProductCount, Price
FROM phone
WHERE ProductName LIKE "%iPhone%";

-- 5.2. "Galaxy"
SELECT ProductName, Manufacturer, ProductCount, Price
FROM phone
WHERE ProductName LIKE "%Galaxy%";

-- 5.3.  Товары, в которых есть ЦИФРЫ
SELECT ProductName, Manufacturer, ProductCount, Price
FROM phone
WHERE ProductName RLIKE "[0-9]";

-- 5.4.  Товары, в которых есть ЦИФРА "8"
SELECT ProductName, Manufacturer, ProductCount, Price
FROM phone
WHERE ProductName LIKE "%8%";