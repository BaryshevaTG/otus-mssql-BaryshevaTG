/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

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
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

TODO: 

SELECT 
		[StockItemID]
		,[StockItemName]
  FROM 
		[WideWorldImporters].[Warehouse].[StockItems]
  WHERE
		[StockItemName] like '%urgent%'
		or
		[StockItemName] like 'Animal%';

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

TODO:

SELECT 
		A.[SupplierID]
		,[SupplierName]
  FROM 
		[WideWorldImporters].[Purchasing].[Suppliers] A
  LEFT JOIN 
		[WideWorldImporters].[Purchasing].[PurchaseOrders] B
  ON A.[SupplierID] = B.[SupplierID]
  WHERE 
		PurchaseOrderID is null;

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

TODO: 

--first 
SELECT	
		A.[OrderID]
		,CONVERT(varchar,[OrderDate], 104) as [OrderDate]
		,DATEPART(mm,[OrderDate]) as [MonthName]
		,DATEPART(qq,[OrderDate]) as[Quarter]
		,CASE
			 WHEN MONTH([OrderDate]) BETWEEN 1 and 4 THEN 1
			 WHEN MONTH([OrderDate]) BETWEEN 5 and 8 THEN 2
			 ELSE 3
		END AS [ThirdPartOfYear]
		,CustomerName
  FROM 
		[WideWorldImporters].[Sales].[Orders] A
  INNER JOIN --PickingCompletedWhen is not null
		[WideWorldImporters].[Sales].[OrderLines] B
  ON A.OrderID = B.OrderID
  LEFT JOIN 
		[WideWorldImporters].[Sales].[Customers] C
  ON A.CustomerID = C.CustomerID
  WHERE
		UnitPrice > 100
		or
		Quantity > 20;

  --second
  SELECT	
		A.[OrderID]
		,CONVERT(varchar,[OrderDate], 104) as [OrderDate]
		,DATEPART(mm,[OrderDate]) as [MonthName]
		,DATEPART(qq,[OrderDate]) as [Quarter]
		,CASE
			 WHEN MONTH([OrderDate]) BETWEEN 1 and 4 THEN 1
			 WHEN MONTH([OrderDate]) BETWEEN 5 and 8 THEN 2
			 ELSE 3
		END AS [ThirdPartOfYear]
		,CustomerName
  FROM 
		[WideWorldImporters].[Sales].[Orders] A
  INNER JOIN 
		[WideWorldImporters].[Sales].[OrderLines] B
  ON A.OrderID = B.OrderID
  LEFT JOIN 
		[WideWorldImporters].[Sales].[Customers] C
  ON A.CustomerID = C.CustomerID
  WHERE
		UnitPrice > 100
		or
		Quantity > 20
  ORDER BY
		[Quarter], [ThirdPartOfYear], [OrderDate]
  OFFSET 1000 ROWS FETCH FIRST 100 ROWS ONLY;

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

TODO:

SELECT 
		DeliveryMethodName
		,ExpectedDeliveryDate
		,[SupplierName]
		,FullName as [ContactPerson]
  FROM [WideWorldImporters].[Purchasing].[Suppliers] A
  JOIN 
		[WideWorldImporters].[Purchasing].[PurchaseOrders] B
  ON A.SupplierID =B.SupplierID
  LEFT JOIN 
		[WideWorldImporters].[Application].[DeliveryMethods] C
  ON B.DeliveryMethodID = C.DeliveryMethodID
  LEFT JOIN 
		[WideWorldImporters].[Application].[People] D
  ON B.ContactPersonID = D.PersonID
  WHERE
		YEAR(ExpectedDeliveryDate) = 2013
		and
		DeliveryMethodName like '%Air Freight'
		and
		IsOrderFinalized = 1;

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

TODO: 

SELECT TOP(10)
		[OrderID]
		,[OrderDate]
		,FullName as [SalesPersonName]
		,CustomerName
  FROM 
		[WideWorldImporters].[Sales].[Orders] A
  LEFT JOIN 
		[WideWorldImporters].[Sales].[Customers] B
  ON A.CustomerID = B.CustomerID
  LEFT JOIN 
		[WideWorldImporters].[Application].[People] C
  ON A.SalespersonPersonID =C.PersonID
  ORDER BY OrderDate DESC

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

TODO: 

SELECT 
		StockItemName
		,C.CustomerID
		,CustomerName
		,PhoneNumber
  FROM 
		[WideWorldImporters].[Sales].[OrderLines] A
  LEFT JOIN 
		[WideWorldImporters].[Warehouse].[StockItems] B
  ON A.StockItemID = B.StockItemID
  JOIN 
		[WideWorldImporters].[Sales].[Orders] C
  ON A.OrderID =C.OrderID
  JOIN 
		[WideWorldImporters].[Sales].[Customers] D
  ON C.CustomerID =D.CustomerID
  WHERE
		StockItemName = 'Chocolate frogs 250g'
