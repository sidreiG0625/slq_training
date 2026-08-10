
/*===================================================================================
						      - CTAS and TEMP TABLES -
-- CTAS (Create Table AS SELECT)

USE CASE 1: Optimize performance
USE CASE 2: Creating a snapshot

=====================================================================================*/
-- Total Number of Sales for each month
IF OBJECT_ID('Sales.MonthlySales', 'U') IS NOT NULL
	DROP TABLE Sales.MonthlySales;
GO

SELECT 
	LEFT(CAST(DATENAME(MONTH, OrderDate) AS NVARCHAR), 3) + '-' + RIGHT(CAST(YEAR(OrderDate) AS NVARCHAR),2) OrderMonth,
	COUNT(OrderID) TotalOrders,
	SUM(Sales) TotalSales,
	SUM(Quantity) TotalQty
INTO Sales.MonthlySales
FROM Sales.Orders
GROUP BY LEFT(CAST(DATENAME(MONTH, OrderDate) AS NVARCHAR), 3) + '-' + RIGHT(CAST(YEAR(OrderDate) AS NVARCHAR),2)

SELECT * FROM Sales.MonthlySales

-- USE CASE 2: Creating a Snapshot

 -- TEMPORARY TABLES - they store intermediate results in a temporary storage within
 -- the database during the session. The database will automatically drop the table
 -- once the session ends

 IF OBJECT_ID('#Orders', 'U') IS NOT NULL
	DROP TABLE #Orders;
GO
SELECT
*
INTO #Orders
FROM Sales.Orders






















