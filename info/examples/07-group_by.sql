USE WideWorldImporters

-- Простейший GROUP BY по одному полю
-- Исходная таблица
SELECT   
  s.SupplierID,
  s.SupplierName,
  c.SupplierCategoryID,
  c.SupplierCategoryName
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c ON c.SupplierCategoryID = s.SupplierCategoryID

-- GROUP BY
SELECT 
  c.SupplierCategoryName [Category],
  count(*) as [Suppliers Count]
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c 
  ON c.SupplierCategoryID = s.SupplierCategoryID
GROUP BY c.SupplierCategoryName

-- Группировка по нескольким полям, по функции, ORDER BY по агрегирующей функции
-- Сколько заказов собрал сотрудник по годам
SELECT 
  year(o.OrderDate) as OrderDate, 
  p.FullName as PickedBy,
  count(*) as OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
GROUP BY year(o.OrderDate), p.FullName
ORDER BY year(o.OrderDate), p.FullName

-- Добавили ContactPersonID. Не работает. Почему?
SELECT 
  year(o.OrderDate) as OrderDate, 
  o.ContactPersonID as ContactPersonID, -- <===============
  p.FullName as PickedBy,
  count(*) as OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
GROUP BY year(o.OrderDate), p.FullName
ORDER BY year(o.OrderDate), p.FullName

 -- HAVING
SELECT 
  year(o.OrderDate) as OrderDate, 
  p.FullName as PickedBy,
  count(*) as OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
GROUP BY year(o.OrderDate), p.FullName
HAVING count(*) > 1200 -- <========
ORDER BY count(*) DESC

-- GROUPING SETS
-- -- Что это такое - аналог с UNION
SELECT TOP 3 o.ContactPersonID AS ContactPersonID, null OrderYear, count(*) AS ContactPersonCount
FROM Sales.Orders o
GROUP BY o.ContactPersonID

UNION

SELECT TOP 3 null, year(o.OrderDate) AS OrderYear, count(*) AS OrderCountPerYear
FROM Sales.Orders o
GROUP BY year(o.OrderDate)

-- -- GROUPING SETS 
SELECT TOP 10
	o.ContactPersonID, 
	year(o.OrderDate) AS OrderYear, 
	count(*) AS [Count]
FROM Sales.Orders o
GROUP BY GROUPING SETS (o.ContactPersonID, year(o.OrderDate))

-- ROLLUP
-- -- запрос для проверки итоговых значений
SELECT 
  year(o.OrderDate) as OrderDate, 
  count(*) as OrdersCount  
FROM Sales.Orders o
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY year(o.OrderDate)
ORDER BY year(o.OrderDate)

-- -- rollup
SELECT 
  year(o.OrderDate) as OrderDate, 
  p.FullName as PickedBy,
  count(*) as OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY ROLLUP (year(o.OrderDate), p.FullName)
ORDER BY year(o.OrderDate), p.FullName
GO

-- ROLLUP, GROUPING
SELECT 
  grouping(year(o.OrderDate)) as OrderDate_GROUPING,
  grouping(p.FullName) as PickedBy_GROUPING,
  year(o.OrderDate) as OrderDate, 
  p.FullName as PickedBy,
  count(*) as OrdersCount,
  -- -------
  CASE grouping(year(o.OrderDate)) 
    WHEN 1 THEN CAST('Total' as NCHAR(5))
    ELSE CAST(year(o.OrderDate) as NCHAR(5))
  END as Count_GROUPING,

  CASE grouping(p.FullName) 
    WHEN 1 THEN 'Total'
    ELSE p.FullName 
  END as PickedBy_GROUPING,

  count(*) as OrdersCount
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY ROLLUP (year(o.OrderDate), p.FullName)
ORDER BY year(o.OrderDate), p.FullName

-- CUBE (тот же ROLLUP, но для всех комбинаций групп)
SELECT 
  year(o.OrderDate) as OrderDate, 
  p.FullName as PickedBy,
  count(*) as OrdersCount  
FROM Sales.Orders o
JOIN Application.People p ON p.PersonID = o.PickedByPersonID
WHERE o.PickedByPersonID IS NOT NULL
GROUP BY CUBE (year(o.OrderDate), p.FullName)
ORDER BY year(o.OrderDate), p.FullName

-- Функция STRING_AGG (с 2017)
SELECT 
  c.SupplierCategoryName
FROM Purchasing.SupplierCategories c 

SELECT 
  STRING_AGG(c.SupplierCategoryName, ', ') AS Categories
FROM Purchasing.SupplierCategories c 
GO

SELECT 
  c.SupplierCategoryName AS Category,
  STRING_AGG(s.SupplierName, ', ') AS Suppliers
FROM Purchasing.Suppliers s 
JOIN Purchasing.SupplierCategories c 
  ON c.SupplierCategoryID = s.SupplierCategoryID
GROUP BY c.SupplierCategoryName