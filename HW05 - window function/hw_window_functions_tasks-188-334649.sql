/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "06 - Оконные функции".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters
/*
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом

Пример:
-------------+----------------------------
Дата продажи | Нарастающий итог по месяцу
-------------+----------------------------
 2015-01-29   | 4801725.31
 2015-01-30	 | 4801725.31
 2015-01-31	 | 4801725.31
 2015-02-01	 | 9626342.98
 2015-02-02	 | 9626342.98
 2015-02-03	 | 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/

напишите здесь свое решение

/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/

WITH TotalCTE (InvoiceID, TotalSales) AS
(SELECT
	InvoiceLines.InvoiceID AS InvoiceID,
	Sum(InvoiceLines.UnitPrice*InvoiceLines.Quantity) AS TotalSales
FROM
	Sales.InvoiceLines	
GROUP BY
	InvoiceLines.InvoiceID
)

SELECT [Invoices].InvoiceID,
      (SELECT 
			CustomerName
		FROM
			Sales.Customers
		WHERE
			Customers.CustomerID = Invoices.CustomerID
		) AS [Customer Name],
		Invoices.InvoiceDate,
		TotalCTE.TotalSales,
		Sum(TotalCTE.TotalSales) OVER (PARTITION BY Month(Invoices.InvoiceDate)) AS GrowingTotal 	  
FROM 
	[Sales].[Invoices]
JOIN
	TotalCTE
ON 
	TotalCTE.InvoiceID = Invoices.InvoiceID
WHERE
	Invoices.InvoiceDate >= '2015-01-01';

/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/
WITH QuantityCTE as
(SELECT DISTINCT
	InvoiceLines.[StockItemID] as StockItemID,
	SUM([InvoiceLines].Quantity) as Quantity,
	Month(Invoices.InvoiceDate) as Month
FROM 
	Sales.InvoiceLines
JOIN
	Sales.Invoices
ON
	InvoiceLines.InvoiceID = Invoices.InvoiceID
WHERE
	Year(Invoices.InvoiceDate) = '2016'
GROUP BY 
	InvoiceLines.[StockItemID], Month(Invoices.InvoiceDate)),
TotaQntCTE as
(SELECT
	QuantityCTE.StockItemID as StockItemID,
	QuantityCTE.Month as Month,
	QuantityCTE.Quantity as TotalQuantity,
	RANK() OVER (PARTITION BY QuantityCTE.Month ORDER BY QuantityCTE.Quantity DESC) as TotalRnkByMonth 
FROM
	QuantityCTE)
SELECT
	TotaQntCTE.StockItemID,
	TotaQntCTE.Month,
	TotalQuantity
FROM	
	TotaQntCTE
WHERE
	TotalRnkByMonth <= 2
ORDER BY
	TotaQntCTE.Month, TotaQntCTE.StockItemID;


/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* посчитайте общее количество товаров и выведете полем в этом же запросе
* посчитайте общее количество товаров в зависимости от первой буквы названия товара
* отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/



/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/

напишите здесь свое решение

/*
6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

напишите здесь свое решение

Опционально можете для каждого запроса без оконных функций сделать вариант запросов с оконными функциями и сравнить их производительность. 