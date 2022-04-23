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