/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

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
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/
--customers
INSERT INTO Sales.Customers
	([CustomerID], [CustomerName], [BillToCustomerID], [CustomerCategoryID], [BuyingGroupID], [PrimaryContactPersonID], [AlternateContactPersonID], [DeliveryMethodID]
      ,[DeliveryCityID], [PostalCityID], [CreditLimit], [AccountOpenedDate], [StandardDiscountPercentage], [IsStatementSent], [IsOnCreditHold], [PaymentDays]
      ,[PhoneNumber], [FaxNumber], [DeliveryRun], [RunPosition], [WebsiteURL], [DeliveryAddressLine1], [DeliveryAddressLine2], [DeliveryPostalCode], [DeliveryLocation]
      ,[PostalAddressLine1], [PostalAddressLine2], [PostalPostalCode], [LastEditedBy], [ValidFrom], [ValidTo])
VALUES
	(NEXT VALUE FOR [Sequences].[CustomerID], 'Adele Fon', NEXT VALUE FOR [Sequences].[CustomerID], 5, NULL, 2043, NULL, 3, 22090, 22090, 1400,'2016-09-04', 0, 0, 0, 7, '(206) 455-0100', '(206) 455-0101', NULL, NULL,
	'http://www.microsoft.com/', 'Shop 23', '1235 Lana Lane', 90708, 0xE6100000010CF66E3D5464434040B2BAD573D26D59C0, 'PO Box 13', 'Ackerly', 90708, 1, DEFAULT, DEFAULT),
	(NEXT VALUE FOR [Sequences].[CustomerID], 'George', NEXT VALUE FOR [Sequences].[CustomerID], 4, NULL, 2044, NULL, 3, 25608, 25608, 1600,'2015-05-04', 0, 0, 0, 7, '(207) 355-0200', '(207) 355-0200', NULL, NULL,
	'http://www.microsoft.com/', 'Shop 10', '652 Victoria Lane', 90650, 0xE6100000010CF2182F27B2A740401695C3DD0F4B56C0, 'PO Box 3235', 'Ackerman', 90650, 1, DEFAULT, DEFAULT),
	(NEXT VALUE FOR [Sequences].[CustomerID], 'Bella Ford', NEXT VALUE FOR [Sequences].[CustomerID], 7, NULL, 2045, NULL, 3, 10483, 10483, 1000,'2013-02-03', 0, 0, 0, 7, '(217) 305-0200', '(217) 305-0200', NULL, NULL,
	'http://www.microsoft.com/', 'Shop 1', '80 Hudson Boulevard', 90727, 0xE6100000010CA55A5540EB8C444008814BB6708752C0, 'PO Box 974', 'Airmont', 90727, 10, DEFAULT, DEFAULT),
	(NEXT VALUE FOR [Sequences].[CustomerID], 'Angelina Dark', NEXT VALUE FOR [Sequences].[CustomerID], 3, NULL, 2046, NULL, 3, 1326, 1326, 1050,'2016-05-23', 0, 0, 0, 11, '(202) 300-0200', '(202) 300-0200', NULL, NULL,
	'http://www.microsoft.com/', 'Shop 21', '1045 Margherita Lane', 90104, 0xE6100000010CE3EEBD09CF244040AE788FD893005CC0, 'PO Box 9930', 'Ak Chin', 90104, 4, DEFAULT, DEFAULT),
	(NEXT VALUE FOR [Sequences].[CustomerID], 'Maria Petrova', NEXT VALUE FOR [Sequences].[CustomerID], 6, NULL, 2047, NULL, 3, 7668, 7668, 1550,'2016-06-21', 0, 0, 0, 6, '(100) 100-0200', '(100) 100-0200', NULL, NULL,
	'http://www.microsoft.com/', 'Shop 2', '732 Petrov Avenue', 90064, 0xE6100000010CB562C966588C4540B7FC76C8039953C0, 'PO Box 5181', 'Alabama', 90064, 1, DEFAULT, DEFAULT);

--SELECT * FROM Sales.Customers;

--suppliers
INSERT INTO Purchasing.Suppliers
	([SupplierID], [SupplierName], [SupplierCategoryID], [PrimaryContactPersonID], [AlternateContactPersonID], [DeliveryMethodID], [DeliveryCityID], [PostalCityID], [SupplierReference], [BankAccountName], [BankAccountBranch]
      ,[BankAccountCode], [BankAccountNumber], [BankInternationalCode], [PaymentDays], [InternalComments], [PhoneNumber], [FaxNumber], [WebsiteURL], [DeliveryAddressLine1], [DeliveryAddressLine2]
      ,[DeliveryPostalCode], [DeliveryLocation], [PostalAddressLine1], [PostalAddressLine2], [PostalPostalCode], [LastEditedBy], [ValidFrom], [ValidTo])
VALUES
	(NEXT VALUE FOR [Sequences].[SupplierID], 'FurFur, LLC', 2, 1, 2, 10, 259, 259, 7347487387, 'Bank Money', 'Bank Money Alabama', 786598, 3747238782, 67456, 30, NULL, '(201) 105-0105', '(201) 105-0105',
	'http://www.furfur.com', 'Level 1', '345 King Street', 27906, 0xE6100000010CC4B46FEEAFFE3F4053E68B62DE8C55C0, 'PO Box 30', 'Grady', 07860, 1, DEFAULT, DEFAULT),
	(NEXT VALUE FOR [Sequences].[SupplierID], 'Trade Company', 8, 2, 3, 9, 10560, 10560, 7347487387, 'Bank №1', 'Bank №1 Alabama', 578457, 3343438948, 46637, 1, NULL, '(100) 105-0105', '(100) 105-0105',
	'http://www.tradecompany.com', 'Level 3', '300 Street of Freedom', 57564, 0xE6100000010C74E3271FCCA04040456D76FFB3F255C0, 'PO Box 31', 'Elrod', 56474, 1, DEFAULT, DEFAULT),
	(NEXT VALUE FOR [Sequences].[SupplierID], 'Ben and friends', 7, 3,4, 8, 38110, 38110, 7347487387, 'Bank 23', 'Bank 23 California', 989854, 3728478387, 54473, 4, NULL, '(150) 100-0105', '150) 100-0105',
	'http://www.benandfriends.com', 'Level 10', '150 White Street', 34352, 0xE6100000010C3326B330FA91434026A36F777B675EC0, 'PO Box 304543', 'Yuba City', 32354, 1, DEFAULT, DEFAULT),
	(NEXT VALUE FOR [Sequences].[SupplierID], 'Water', 5, 4, 5, 7, 30428, 30428, 7347487387, 'The best Bank', 'The best Bank Colorado', 237382, 2948938289, 23675, 15, NULL, '(100) 200-1000', '(100) 200-1000',
	'http://www.furfur.com', 'Level 10', '345 Green Street', 37267, 0xE6100000010C534C947318934240E99D0AB867595AC0, 'PO Box 304', 'San Pablo', 34833, 1, DEFAULT, DEFAULT),
	(NEXT VALUE FOR [Sequences].[SupplierID], 'Solt and Sugar', 2, 5, 6, 6, 139, 139, 3534534343, 'Bank Do Not Stop', 'Bank Do Not Stop Georgia', 454533, 3534543543, 34522, 23, NULL, '(300) 301-3000', '(300) 301-3000',
	'http://www.furfur.com', 'Level 2', '300 First Street', 34232, 0xE6100000010C5D1CF0541B233F402E84E6841ADB54C0, 'PO Box 6868', 'Adel', 34533, 1, DEFAULT, DEFAULT); 
	
	--(NEXT VALUE FOR [Sequences].[PersonID], 'FurFur, LLC', 2, 1, 2, 10, 18557, 30378, 7347487387, 'Bank Money', 'Bank Money California', 786598, 3747238782, 67456, 30, NULL, '(201) 105-0105', '(201) 105-0105',
	--'http://www.furfur.com', 'Level 1', '345 King Street', 27906, 0xE6100000010C6C4E14D7E78F4440C74ED3C2C0B552C0, 'PO Box 30', 'Arlington', 07860, 1, DEFAULT, DEFAULT); 

--SELECT*FROM Purchasing.Suppliers;


/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

DELETE FROM Sales.Customers
WHERE CustomerID = 1078;

/*
3. Изменить одну запись, из добавленных через UPDATE
*/
SELECT*FROM Sales.Customers;

Update Sales.Customers
SET 
	CreditLimit = 1400,
	PhoneNumber = '(415) 555-0102',
	FaxNumber = '(415) 555-0103'
OUTPUT inserted.CreditLimit as NewLimit, inserted.PhoneNumber as NewPhone, inserted.FaxNumber as NewFax, deleted.CreditLimit as OldLimit, deleted.PhoneNumber as OldPhone, deleted.FaxNumber as OldFax
WHERE CustomerID = 1077;

/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/

--SELECT * FROM Sales.Customers;

WITH MergeDemoCTE ([CustomerID], [CustomerName], [BillToCustomerID], [CustomerCategoryID], [BuyingGroupID], [PrimaryContactPersonID], [AlternateContactPersonID], [DeliveryMethodID]
      ,[DeliveryCityID], [PostalCityID], [CreditLimit], [AccountOpenedDate], [StandardDiscountPercentage], [IsStatementSent], [IsOnCreditHold], [PaymentDays]
      ,[PhoneNumber], [FaxNumber], [DeliveryRun], [RunPosition], [WebsiteURL], [DeliveryAddressLine1], [DeliveryAddressLine2], [DeliveryPostalCode], [DeliveryLocation]
      ,[PostalAddressLine1], [PostalAddressLine2], [PostalPostalCode], [LastEditedBy]) as
	(
	SELECT DISTINCT
		1079 as [CustomerID],
		'Bill Forest' as [CustomerName],
		1079 as [BillToCustomerID],
		5 as [CustomerCategoryID],
		NULL as [BuyingGroupID],
		2043 as [PrimaryContactPersonID],
		NULL as [AlternateContactPersonID],
		3 as [DeliveryMethodID],
		22090 as [DeliveryCityID],
		22090 as [PostalCityID],
		1400 as [CreditLimit],
		'2016-09-05' as [AccountOpenedDate],
		0 as [StandardDiscountPercentage],
		0 as [IsStatementSent],
		0 as [IsOnCreditHold],
		7 as [PaymentDays],
		'(206) 455-0100' as [PhoneNumber],
		'(206) 455-0101' as [FaxNumber],
		NULL as [DeliveryRun],
		NULL as [RunPosition],
		'http://www.microsoft.com/' as [WebsiteURL],
		'Shop 22' as [DeliveryAddressLine1],
		'1235 Lana Lane' as [DeliveryAddressLine2],
		90708 as  [DeliveryPostalCode],
		0xE6100000010CF66E3D5464434040B2BAD573D26D59C0,
		'PO Box 14' as [DeliveryLocation],
		'Ackerly' as [PostalAddressLine1],
		90708 as [PostalAddressLine2],
		1 as [PostalPostalCode]
	FROM
		Sales.Customers)
MERGE Sales.Customers as Target
USING MergeDemoCTE ON Target.CustomerID = MergeDemoCTE.CustomerID
WHEN MATCHED THEN 
	UPDATE SET
			[CustomerID] = MergeDemoCTE.[CustomerID], 
			[CustomerName] = MergeDemoCTE.[CustomerName], 
			[BillToCustomerID] = MergeDemoCTE.[BillToCustomerID], 
			[CustomerCategoryID] = MergeDemoCTE.[CustomerCategoryID], 
			[BuyingGroupID] = MergeDemoCTE.[BuyingGroupID], 
			[PrimaryContactPersonID] = MergeDemoCTE.[PrimaryContactPersonID], 
			[AlternateContactPersonID] = MergeDemoCTE.[AlternateContactPersonID], 
			[DeliveryMethodID] = MergeDemoCTE.[DeliveryMethodID],
			[DeliveryCityID] = MergeDemoCTE.[DeliveryCityID], 
			[PostalCityID] = MergeDemoCTE.[PostalCityID], 
			[CreditLimit] = MergeDemoCTE.[CreditLimit], 
			[AccountOpenedDate] = MergeDemoCTE.[AccountOpenedDate], 
			[StandardDiscountPercentage] = MergeDemoCTE.[StandardDiscountPercentage], 
			[IsStatementSent] = MergeDemoCTE.[IsStatementSent], 
			[IsOnCreditHold] = MergeDemoCTE.[IsOnCreditHold], 
			[PaymentDays] = MergeDemoCTE.[PaymentDays],
			[PhoneNumber] = MergeDemoCTE.[PhoneNumber], 
			[FaxNumber] = MergeDemoCTE.[FaxNumber], 
			[DeliveryRun] = MergeDemoCTE.[DeliveryRun], 
			[RunPosition] = MergeDemoCTE.[RunPosition], 
			[WebsiteURL] = MergeDemoCTE.[WebsiteURL], 
			[DeliveryAddressLine1] = MergeDemoCTE.[DeliveryAddressLine1], 
			[DeliveryAddressLine2] = MergeDemoCTE.[DeliveryAddressLine2], 
			[DeliveryPostalCode] = MergeDemoCTE.[DeliveryPostalCode], 
			[DeliveryLocation] = MergeDemoCTE.[DeliveryLocation],
			[PostalAddressLine1] = MergeDemoCTE.[PostalAddressLine1], 
			[PostalAddressLine2] = MergeDemoCTE.[PostalAddressLine2], 
			[PostalPostalCode] = MergeDemoCTE.[PostalPostalCode], 
			[LastEditedBy] = MergeDemoCTE.[LastEditedBy]
		WHEN NOT MATCHED THEN
			INSERT
				([CustomerID], [CustomerName], [BillToCustomerID], [CustomerCategoryID], [BuyingGroupID], [PrimaryContactPersonID], [AlternateContactPersonID], [DeliveryMethodID]
				  ,[DeliveryCityID], [PostalCityID], [CreditLimit], [AccountOpenedDate], [StandardDiscountPercentage], [IsStatementSent], [IsOnCreditHold], [PaymentDays]
				  ,[PhoneNumber], [FaxNumber], [DeliveryRun], [RunPosition], [WebsiteURL], [DeliveryAddressLine1], [DeliveryAddressLine2], [DeliveryPostalCode], [DeliveryLocation]
				  ,[PostalAddressLine1], [PostalAddressLine2], [PostalPostalCode], [LastEditedBy], [ValidFrom], [ValidTo])
			VALUES (MergeDemoCTE.[CustomerID], MergeDemoCTE.[CustomerName], MergeDemoCTE.[BillToCustomerID], MergeDemoCTE.[CustomerCategoryID], MergeDemoCTE.[BuyingGroupID], MergeDemoCTE.[PrimaryContactPersonID], MergeDemoCTE.[AlternateContactPersonID], MergeDemoCTE.[DeliveryMethodID]
				  ,MergeDemoCTE.[DeliveryCityID], MergeDemoCTE.[PostalCityID], MergeDemoCTE.[CreditLimit], MergeDemoCTE.[AccountOpenedDate], MergeDemoCTE.[StandardDiscountPercentage], MergeDemoCTE.[IsStatementSent], MergeDemoCTE.[IsOnCreditHold], MergeDemoCTE.[PaymentDays]
				  ,MergeDemoCTE.[PhoneNumber], MergeDemoCTE.[FaxNumber], MergeDemoCTE.[DeliveryRun], MergeDemoCTE.[RunPosition], MergeDemoCTE.[WebsiteURL], MergeDemoCTE.[DeliveryAddressLine1], MergeDemoCTE.[DeliveryAddressLine2], MergeDemoCTE.[DeliveryPostalCode], MergeDemoCTE.[DeliveryLocation]
				  ,MergeDemoCTE.[PostalAddressLine1], MergeDemoCTE.[PostalAddressLine2], MergeDemoCTE.[PostalPostalCode], MergeDemoCTE.[LastEditedBy], DEFAULT, DEFAULT);


/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

EXEC sp_configure 'show advanced options', 1;  
GO  
-- To update the currently configured value for advanced options.  
RECONFIGURE;  
GO  
-- To enable the feature.  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
-- To update the currently configured value for this feature.  
RECONFIGURE;  
GO 

-- sp_helpserver
select @@VERSION
select @@SERVERNAME

exec master..xp_cmdshell 'bcp [WideWorldImporters].[Application].[Cities] out "C:\1\colors.xls" -T -w -t, -S localhost'
select * from application.Cities

CREATE TABLE [Application].[Cities_BulkDemo](
	[CityID] [int] NOT NULL,
	[CityName] [nvarchar](50) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[Location] geography NULL,
	[LatestRecordedPopulation] [bigint] NULL,
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] datetime2(7) NOT NULL,
	[ValidTo] datetime2(7) NOT NULL
 CONSTRAINT [DF_Application_Cities_CityID_BulkDemo] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA]
) ON [USERDATA]

BULK INSERT [WideWorldImporters].[Application].[Cities_BulkDemo]
				FROM "C:\1\colors.xls"
				WITH 
					(
					BATCHSIZE = 1000, 
					DATAFILETYPE = 'widechar',
					FIELDTERMINATOR = ',',
					KEEPNULLS,
					TABLOCK        
					);