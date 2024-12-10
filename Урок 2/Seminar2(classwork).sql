/* Задача 1
Реализуем пример запроса VALUE_COUNTS, который возвращает количество для
каждого элемента. Давайте посмотрим сколько среди наших клиентов мужчин
и женщин. А затем посмотрим как люди разбиты по образованию.
Не забываем, что в таком запросе нам важно получить отсортированный список,
чтобы сверху были самые популярные экземпляры.
*/

SELECT 
	sex,
	COUNT(*) AS cnt
FROM Clusters c 
GROUP BY sex 
ORDER BY cnt DESC  

SELECT 
	education,
	COUNT(*) AS cnt
FROM Clusters c 
GROUP BY education 
ORDER BY cnt DESC 

/* Задача 2.
Теперь необходимо сравнить распределение по полу
и образованию (отдельно) для клиентов и не клиентов банка.
Продумать, какая сортировка будет оптимальной.
*/

SELECT 
	sex,
	is_client,
	COUNT(*) AS cnt
FROM Clusters c 
GROUP BY sex, is_client 
ORDER BY cnt DESC 

SELECT 
	education ,
	is_client,
	COUNT(*) AS cnt
FROM Clusters c 
GROUP BY education, is_client 
ORDER BY cnt DESC 

/* Задача 3.
Давайте посмотрим образование клиентов с разбивкой по
полу и определим, какое образование самое непопулярное у них (меньше всего ).
То есть отфильтруем по количеству меньше 40
*/
SELECT 
	education, 
	sex,
	COUNT(*) 
FROM Clusters c 
GROUP BY education, sex
HAVING COUNT(*) < 40


/* Задача 4.
Давайте посмотрим тоже самое, но только среди
клиентов банка.
*/
SELECT 
	education, 
	sex,
	COUNT(*) AS cnt
FROM Clusters c 
WHERE is_client = 1
GROUP BY education, sex
HAVING cnt < 40

/* Задача 5.
Получить среднюю величину запрашиваемого кредита
и дохода клиентов для клиентов банка в разрезе
образования и пола клиентов
*/

SELECT 
	ROUND(AVG(credit_amount), 2), 
	ROUND(AVG(income), 2),
	sex,education
FROM Clusters c 
WHERE is_client = 1
GROUP BY education, sex
ORDER BY education, sex

/* Задача 6.
Получить максимальную и минимальную сумму
кредита в разрезе пола и Хороших клиентов для
клиентов с высшим/неполным высшим образованием.
В чем особенность плохих и хороших клиентов?
*/

SELECT 
	sex, bad_client_target,
	max(credit_amount),
	min(credit_amount)
FROM Clusters c 
WHERE education  LIKE '%higher%'
GROUP BY sex, bad_client_target

/* Задача 7.
Получить распределение (min, max, avg) возрастов
клиентов в зависимости от пола и оператора связи.
*/

SELECT
	sex, phone_operator,
	MIN(age),
	MAX(age),
	AVG(age) 
FROM Clusters c 
GROUP BY sex, phone_operator 

/* Задача 8.
Давайте поработаем с колонкой cluster. Для начала
посмотрим сколько кластеров у нас есть и сколько
людей попало в каждый кластер
*/

SELECT 
	cluster,
	COUNT(*) 
FROM Clusters c
GROUP BY cluster 
ORDER BY cluster 

/* Задача 9.
Видим, что есть большие кластеры 0, 4, 3. Остальные маленькие.
Давайте маленькие кластеры объединим в большой и посмотрим
средний возраст, доход, кредит и пол в больших кластерах
(с помощью функции CASE). 
*/

SELECT 
	CASE 
		WHEN cluster IN (1,2,5,6) THEN -1
		ELSE cluster 
	END AS common_cluster,
	COUNT(*),
	AVG(age),
	AVG(income),
	AVG(credit_amount),
	AVG(
		CASE
			WHEN sex='male' THEN 1.0
			ELSE 0
		END
	) AS avg_sex
FROM Clusters c
GROUP BY common_cluster
ORDER BY common_cluster 

/* Задача 10.
Давайте сейчас проверим гипотезу, что доход
клиентов связан с регионом проживания.
*/

SELECT 
	region,
	avg(income) AS average
FROM Clusters c 
GROUP BY region 
ORDER BY average

/* Задача 11.
С помощью подзапроса получите заказы товаров
из 4 и 6 категории (подзапрос в подзапросе).
Таблицы OrderDetails, Products 
*/

SELECT *
FROM Orders o 
WHERE OrderID IN (SELECT OrderID from OrderDetails od
WHERE ProductID IN (SELECT ProductID from Products p
WHERE CategoryID IN (4,6) ))

/* Задача 12.
В какие страны доставляет товары
компания Speedy_Express

*/

SELECT DISTINCT Country 
FROM Customers c 
WHERE CustomerID IN (SELECT CustomerID FROM Orders o
WHERE ShipperID IN (SELECT ShipperID FROM Shippers s
WHERE ShipperName = 'Speedy_Express'))


/* Задача 13.
Получите 3 страны, где больше всего
клиентов (таблица Customers).
*/

SELECT 
	country, 
	count(*) as cnt 
FROM Customers
GROUP BY country
ORDER BY cnt DESC
LIMIT 3

/* Задача 14.
Назовите три самых популярных города и название
страны среди трех популярных стран (где больше
всего клиентов)
*/

SELECT 
	city, 
	country, 
	count(*) as cnt
FROM Customers
	where country in (SELECT country
FROM Customers
GROUP BY country
ORDER BY count(*) DESC
)
group by city, country
order by cnt desc
LIMIT 3 