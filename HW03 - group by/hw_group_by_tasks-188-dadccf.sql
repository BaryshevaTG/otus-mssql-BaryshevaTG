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
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

TODO: 

SELECT 
		MONTH(A.InvoiceDate) as [InvoiceMonth]
		,YEAR(A.InvoiceDate) as [InvoiceYear]
		,AVG(B.[UnitPrice]) as [Average]
		,SUM(B.[UnitPrice]) as [Proceeds]
  FROM 
		[WideWorldImporters].[Sales].[Invoices] A
  LEFT JOIN 
		[WideWorldImporters].[Sales].[InvoiceLines] B
  ON A.InvoiceID = B.InvoiceID
  GROUP BY 
		MONTH(A.InvoiceDate),YEAR(A.InvoiceDate)
  ORDER BY 
		[InvoiceMonth],  [InvoiceYear];

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

TODO: 

SELECT 
		MONTH(A.InvoiceDate) as [InvoiceMonth]
		,YEAR(A.InvoiceDate) as [InvoiceYear]
		,AVG(B.[UnitPrice]) as [Average]
		,SUM(B.[UnitPrice]*B.[Quantity]) as [Proceeds]
  FROM 
		[WideWorldImporters].[Sales].[Invoices] A
  LEFT JOIN 
		[WideWorldImporters].[Sales].[InvoiceLines] B
  ON A.InvoiceID = B.InvoiceID
  GROUP BY 
		MONTH(A.InvoiceDate),YEAR(A.InvoiceDate)
  HAVING 
		SUM(B.[UnitPrice]*B.[Quantity])> 10000
  ORDER BY 
		[InvoiceMonth],  [InvoiceYear];

/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

TODO: 

SELECT 
		YEAR(A.InvoiceDate) as [InvoiceYear]
		,MONTH(A.InvoiceDate) as [InvoiceMonth]
		,C.StockItemName 
		,SUM(B.[UnitPrice]*B.[Quantity]) as [Proceeds]
		,MIN(A.InvoiceDate) as [FirstDate]
		,SUM(B.[Quantity]) as [QuantitySold]
  FROM 
		[WideWorldImporters].[Sales].[Invoices] A
  LEFT JOIN 
		[WideWorldImporters].[Sales].[InvoiceLines] B
  ON A.InvoiceID = B.InvoiceID
  JOIN 
		[WideWorldImporters].[Warehouse].[StockItems] C
  ON B.StockItemID = C.StockItemID
  GROUP BY 
		MONTH(A.InvoiceDate),YEAR(A.InvoiceDate), C.StockItemName 
  HAVING 
		SUM(B.[Quantity]) < 50
  ORDER BY 
		[InvoiceMonth],  [InvoiceYear];

-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/

