/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "13 - CLR".
*/

USE WideWorldImporters;

exec sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

exec sp_configure 'clr enabled', 1;
exec sp_configure 'clr strict security', 0;
GO

ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON;

CREATE ASSEMBLY CLRFun FROM 'C:\Users\acer\source\repos\HW14-CLR\bin\Debug\HW14-CLR.dll'
WITH PERMISSION_SET = SAFE; 
GO

CREATE FUNCTION [dbo].SplitString(@text [nvarchar](max), @delimiter [nchar](1))
RETURNS TABLE (
textfield nvarchar(max),
id int
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME CLRFun.[HW14_CLR.UserDefinedFunctions].SplitString;


SELECT * FROM dbo.SplitString((SELECT [VehicleRegistration] FROM [WideWorldImporters].[Warehouse].[VehicleTemperatures] WHERE VehicleTemperatureID = '64652'), '-')