гщ/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "08 - Выборки из XML и JSON полей".

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
Примечания к заданиям 1, 2:
* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML. 
* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).
* Пример экспорта/импорта в файл https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. В личном кабинете есть файл StockItems.xml.
Это данные из таблицы Warehouse.StockItems.
Преобразовать эти данные в плоскую таблицу с полями, аналогичными Warehouse.StockItems.
Поля: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

Загрузить эти данные в таблицу Warehouse.StockItems: 
существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName). 

Сделать два варианта: с помощью OPENXML и через XQuery.
*/

-- Открытие через openxml
DECLARE @xmlDocument  xml

SELECT @xmlDocument = BulkColumn
FROM OPENROWSET
(BULK 'C:\Users\acer\Desktop\otus-mssql-BaryshevaTG\HW9-xml and json\StockItems-188-1fb5df.xml', 
 SINGLE_CLOB)
as data 

SELECT @xmlDocument as [@xmlDocument]

DECLARE @docHandle int
EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument

--создание временно таблицы
SELECT * INTO TmpCheck
FROM OPENXML(@docHandle, N'/StockItems/Item', 1)
WITH ( 
	[StockItemName] nvarchar(100) '@Name',
	[SupplierID] int  'SupplierID',
	[UnitPackageID] int '//UnitPackageID',
	[OuterPackageID] int '//OuterPackageID',
	[QuantityPerOuter] int '//QuantityPerOuter',
	[TypicalWeightPerUnit] decimal(18,3) '//TypicalWeightPerUnit',
	[LeadTimeDays] int 'LeadTimeDays',
	[IsChillerStock] bit 'IsChillerStock',
	[TaxRate] decimal(18,3) 'TaxRate',
	[UnitPrice] decimal(18,2) 'UnitPrice');

--открытие через xquery
DECLARE @x XML
SET @x = (SELECT * FROM OPENROWSET  (BULK 'C:\Users\acer\Desktop\otus-mssql-BaryshevaTG\HW9-xml and json\StockItems-188-1fb5df.xml', SINGLE_BLOB)  as data)

SELECT  
  t.Item.value('(@Name)[1]', 'nvarchar(100)') as [StockItemName],
  t.Item.value('(SupplierID)[1]', 'int') as [SupplierID],
  t.Item.value('(//UnitPackageID)[1]', 'int') as [UnitPackageID],
  t.Item.value('(//OuterPackageID)[1]', 'int') as [OuterPackageID],
  t.Item.value('(//QuantityPerOuter)[1]', 'int') as [QuantityPerOuter],
  t.Item.value('(//TypicalWeightPerUnit)[1]', 'decimal(18,3)') as [TypicalWeightPerUnit],
  t.Item.value('(LeadTimeDays)[1]', 'int') as [LeadTimeDays],
  t.Item.value('(IsChillerStock)[1]', 'bit') as [IsChillerStock],
  t.Item.value('(TaxRate)[1]', 'decimal(18,3)') as [TaxRate],
  t.Item.value('(UnitPrice)[1]', 'decimal(18,2)') as [UnitPrice]
FROM @x.nodes('/StockItems/Item') as t(Item);

--добавление и обновление строк (используется первый рез-т через openxml)
MERGE Warehouse.StockItems as Target
USING TmpCheck ON Target.[StockItemName] = TmpCheck.[StockItemName]
WHEN MATCHED THEN
	UPDATE SET
		[StockItemName] = TmpCheck.[StockItemName],
		[SupplierID] = TmpCheck.[SupplierID],
		[UnitPackageID] = TmpCheck.[UnitPackageID],
		[OuterPackageID] = TmpCheck.[OuterPackageID],
		[QuantityPerOuter] = TmpCheck.[QuantityPerOuter],
		[TypicalWeightPerUnit] = TmpCheck.[TypicalWeightPerUnit],
		[LeadTimeDays] = TmpCheck.[LeadTimeDays],
		[IsChillerStock] = TmpCheck.[IsChillerStock],
		[TaxRate] = TmpCheck.[TaxRate],
		[UnitPrice] = TmpCheck.[UnitPrice]
WHEN NOT MATCHED THEN
	INSERT([StockItemName],[SupplierID],[UnitPackageID],[OuterPackageID],[QuantityPerOuter],[TypicalWeightPerUnit],[LeadTimeDays],[IsChillerStock],[TaxRate],[UnitPrice], [LastEditedBy])
	VALUES(TmpCheck.[StockItemName],TmpCheck.[SupplierID],TmpCheck.[UnitPackageID],TmpCheck.[OuterPackageID],TmpCheck.[QuantityPerOuter],TmpCheck.[TypicalWeightPerUnit],TmpCheck.[LeadTimeDays],TmpCheck.[IsChillerStock],TmpCheck.[TaxRate],TmpCheck.[UnitPrice], 1)
		;
SELECT * FROM Warehouse.StockItems;

/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

--настройки
EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO   
EXEC sp_configure 'xp_cmdshell', 1;  
GO    
RECONFIGURE;  
GO 

--имя результирующего файла
DECLARE @FileName NVARCHAR(200) = 'C:\1\StockItems_Result.xml'

--временная таблица в необходимом виде
SELECT 
    [StockItemName] AS [StockItemName/@Name],
   	[UnitPackageID] AS [Package/UnitPackageID],
	[OuterPackageID] AS [Package/OuterPackageID],
	[QuantityPerOuter] AS [Package/QuantityPerOuter],
	[TypicalWeightPerUnit] AS [Package/TypicalWeightPerUnit],
	[LeadTimeDays] AS [LeadTimeDays],
	[IsChillerStock] AS [IsChillerStock],
	[TaxRate] AS [TaxRate],
	[UnitPrice] AS [UnitPrice]
INTO TmpstockItems 
FROM Warehouse.StockItems;

--выгрузка с помощью bcp out
DECLARE @Cmd NVARCHAR(4000) = 'bcp ' + '"SELECT * FROM TmpstockItems for XML PATH (''StockItem''), ROOT (''StockItems'')" ' + 'queryout ' + @FileName + ' -w -r -T -S localhost -d WideWorldImporters' 
EXECUTE xp_cmdshell @Cmd

--cheeeck
DECLARE @x XML
SET @x = (SELECT * FROM OPENROWSET  (BULK 'C:\1\StockItems_Result.xml', SINGLE_BLOB)  as data)
SELECT @x AS [@x]

/*
3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)
*/

SELECT 
    StockItemID AS [Id],
    StockItemName AS [StockItemName],
    JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture,
	JSON_VALUE(CustomFields, '$.Tags[0]') AS FirstTag
FROM Warehouse.StockItems;

/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести: 
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%' 
*/

SELECT 
    StockItemID AS [Id],
    StockItemName AS [StockItemName],
    JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture,
	JSON_QUERY(CustomFields, '$.Tags') as Tags,
	SeparatedTags.value as Tag
FROM Warehouse.StockItems
CROSS APPLY STRING_SPLIT(Tags, '"') SeparatedTags
WHERE
	SeparatedTags.value = 'Vintage';


