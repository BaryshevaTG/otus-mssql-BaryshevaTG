/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

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
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

TODO:

--вложенный запрос
SELECT 
	[PersonID]
	,[FullName]
FROM 
	[WideWorldImporters].[Application].[People]
WHERE
	IsSalesperson = 1
	and
	(SELECT 
			Count([InvoiceID]) as TotalSales
		FROM 
			[WideWorldImporters].[Sales].[Invoices]
		WHERE
			Invoices.SalespersonPersonID = People.PersonID
			and
			InvoiceDate = '2015-07-04') = 0;

--WITH
WITH TotalInvoicesCTE (SalespersonPersonID, TotalSales) as
	(SELECT 
		SalespersonPersonID,
		Count([InvoiceID]) as TotalSales
	FROM 
		[WideWorldImporters].[Sales].[Invoices]
	WHERE
		InvoiceDate = '2015-07-04'
	GROUP BY
		SalespersonPersonID)
SELECT 
	People.PersonID,
	People.FullName
FROM
	Application.People
LEFT JOIN
	TotalInvoicesCTE
	ON People.PersonID = TotalInvoicesCTE.SalespersonPersonID
WHERE
	IsSalesperson = 1
	and
	TotalInvoicesCTE.TotalSales is null
	;


/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

TODO: 

--1 вариант
SELECT 
	StockItemID
	,StockItemName
	,UnitPrice
FROM
	Warehouse.StockItems
WHERE
	UnitPrice <= ALL(
					SELECT
						UnitPrice
					FROM
						Warehouse.StockItems);

--2 вариант
SELECT
	StockItemID
	,StockItemName
	,UnitPrice
FROM
	Warehouse.StockItems
WHERE
	UnitPrice = 
				(SELECT
					Min(UnitPrice)
				FROM
					Warehouse.StockItems);


/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/

TODO:

--CTE
WITH MaxTransactionsCTE (CustomerID) as
	(SELECT TOP 5 
			CustomerID
		FROM
			Sales.CustomerTransactions
		ORDER BY 
			CustomerTransactions.TransactionAmount desc)
SELECT
	Customers.CustomerID,
	Customers.PhoneNumber,
	Customers.CustomerName
FROM
	Sales.Customers
JOIN
	MaxTransactionsCTE
ON
	MaxTransactionsCTE.CustomerID = Customers.CustomerID;

--вложенный - in
SELECT
	Customers.CustomerID,
	Customers.PhoneNumber,
	Customers.CustomerName
FROM
	Sales.Customers
WHERE 
	Customers.CustomerID IN
		(SELECT TOP 5 
			CustomerID
		FROM
			Sales.CustomerTransactions
		ORDER BY 
			CustomerTransactions.TransactionAmount desc);

--вложенный ANY
SELECT
	Customers.CustomerID,
	Customers.PhoneNumber,
	Customers.CustomerName
FROM
	Sales.Customers
WHERE 
	Customers.CustomerID = ANY
		(SELECT TOP 5 
			CustomerID
		FROM
			Sales.CustomerTransactions
		ORDER BY 
			CustomerTransactions.TransactionAmount desc);

/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/

TODO: 

WITH LookForCityIDCTE (CityID) as

--ищем город покупателя
(SELECT
		[Customers].PostalCityID
	FROM
		[Sales].[Customers]
	WHERE
		[Customers].CustomerID IN
								--ищем покупателя по номеру заказа, отбирем по уникальным значениям
								(SELECT DISTINCT
									[Invoices].CustomerID
								FROM
									[Sales].[Invoices]
								WHERE
									[Invoices].InvoiceID IN
														--ищем позиции заказов, соответствующие позициям товаров
														(SELECT
															[InvoiceLines].InvoiceID
														FROM
															[Sales].[InvoiceLines]
														WHERE
															[InvoiceLines].StockItemID IN 
																						--ищем товары, которые входят в тройку по самой высокой цене (таких 4)
																						(SELECT TOP 3 with ties
																							StockItems.StockItemID
																						FROM
																							Warehouse.StockItems
																						ORDER BY
																							StockItems.UnitPrice
																						)
														)
								)
	)
--присоединяем по идентификатору города
SELECT 
	[Cities].[CityID],
	[Cities].[CityName]
FROM
	[Application].[Cities]
JOIN
	LookForCityIDCTE
ON
	[Cities].[CityID] = LookForCityIDCTE.CityID;


-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос

TODO: 

SET STATISTICS TIME ON
--было
--запрос показывает доставленные заказы, общая фактическая сумма которых больше 27000
--дату данного заказа, имя сотрудника и предполагаемая изначально сумма за товары.
SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSum AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSum
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSum DESC;

--стало. попытка 1
WITH InvoicesCTE (OrderId, InvoiceID, SalesPersonName, InvoiceDate, SalesTotals) as
	(
		SELECT
				Invoices.OrderId as OrderId,
				Invoices.InvoiceID as InvoiceID, 
				Invoices.InvoiceDate as InvoiceDate,
					(SELECT People.FullName
						FROM Application.People
						WHERE People.PersonID = Invoices.SalespersonPersonID
					) AS SalesPersonName,
					(SELECT
						SUM(InvoiceLines.Quantity*InvoiceLines.UnitPrice) AS TotalSum
					FROM Sales.InvoiceLines
					WHERE InvoiceLines.InvoiceID = Invoices.InvoiceID 
					) AS SalesTotals
			FROM
				Sales.Invoices 
	)
SELECT 
	InvoicesCTE.InvoiceID,
	InvoicesCTE.InvoiceDate,
	InvoicesCTE.SalesPersonName,
	InvoicesCTE.SalesTotals as TotalSumByInvoice,
	(SELECT	
		SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
	FROM
		Sales.OrderLines
	WHERE Orders.OrderId = OrderLines.OrderID
	) AS TotalSumForPickedItems
FROM [Sales].[Orders]
JOIN
	InvoicesCTE
ON 
	InvoicesCTE.OrderId = Orders.OrderID
WHERE 
	Orders.PickingCompletedWhen IS NOT NULL
	and
	InvoicesCTE.SalesTotals > 27000
ORDER BY InvoicesCTE.SalesTotals DESC;

--стало. попытка 2
--я пыталась красиво напсиать, но 50 а 50 по процентам оставалось.
--как получилось, уже сбилась со счета который день сижу.
--подозреваю надо было вынести расчет SalesTotals отдельно, но как бы я не выносила, результат не менялся, только двойное одинаковое условие дает мне уменьшение процентов.
WITH InvoicesCTE (InvoiceID, InvoiceDate, SalesPersonName, TotalSumForPickedItems, SalesTotals) as
	(
		SELECT
				Invoices.InvoiceID as InvoiceID, 
				Invoices.InvoiceDate as InvoiceDate,
					(SELECT People.FullName
						FROM Application.People
						WHERE People.PersonID = Invoices.SalespersonPersonID
					) AS SalesPersonName,
					(SELECT	
						SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
					FROM
						Sales.OrderLines
					WHERE Invoices.OrderId = OrderLines.OrderID
					) AS TotalSumForPickedItems,
					(SELECT
						SUM(InvoiceLines.Quantity*InvoiceLines.UnitPrice) AS TotalSum
					FROM Sales.InvoiceLines
					WHERE InvoiceLines.InvoiceID = Invoices.InvoiceID 
					) AS SalesTotals
			FROM
				Sales.Invoices 
			WHERE
				Invoices.OrderId IN (SELECT Orders.OrderId FROM Sales.Orders WHERE Orders.PickingCompletedWhen IS NOT NULL)
				and
				(SELECT	SUM(InvoiceLines.Quantity*InvoiceLines.UnitPrice) FROM Sales.InvoiceLines WHERE InvoiceLines.InvoiceID = Invoices.InvoiceID) > 27000
	)
SELECT 
	InvoicesCTE.InvoiceID,
	InvoicesCTE.InvoiceDate,
	InvoicesCTE.SalesPersonName,
	InvoicesCTE.TotalSumForPickedItems,
	InvoicesCTE.SalesTotals as TotalSumByInvoice
FROM InvoicesCTE
WHERE 
	InvoicesCTE.SalesTotals > 27000
ORDER BY InvoicesCTE.SalesTotals DESC;

SET STATISTICS TIME OFF
