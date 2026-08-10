
/*=============================================================
--------------        VIEWS                       -------------

-- is a virtual table based on the result of a set of query 
-- without storing the data in the database
-- Views are persisted SQL queries in the database
-- Views are better than CTE because it improves reusability in multiple queries

-- USE CASE 1: Store central complex business logic to be reused
-- USE CASE 2: Hide Complexity by offering friendly views to users
-- USE CASE 3: Use views to enforce security and protect sensitive data, by hiding 
	columns and/or rows from tables
-- USE CASE 4: Flexibility and dynamic
-- USE CASE 5: Offers multiple languages
-- USE CASE 6: Virtual DataMArts in DWH
=============================================================*/

IF OBJECT_ID('Sales.V_Sales_Summary', 'V') IS NOT NULL
	DROP VIEW Sales.V_Sales_Summary;
GO

CREATE VIEW Sales.V_Sales_Summary AS (
	SELECT 
		DATETRUNC(month, OrderDate) OrderMonth,
		SUM(Sales) TotalSales,
		COUNT(OrderID) TotalQty
	FROM Sales.Orders
	GROUP BY DATETRUNC(month, OrderDate)
)

SELECT * FROM Sales.V_Sales_Summary

-- USE CASE 2: Hide Complexity
-- Provide a view that combines details from orders, products, customers and employees
IF OBJECT_ID('Sales.V_Orders_Summary', 'V') IS NOT NULL
	DROP VIEW Sales.V_Orders_Summary;
GO
CREATE VIEW Sales.V_Orders_Summary AS (
	SELECT 
		o.OrderID,
		p.Product,
		p.Category,
		CONCAT(c.FirstName, ' ', c.LastName) CustomerName,
		c.Country CustomerCountry,
		CONCAT(e.FirstName, ' ', e.lastName) EmployeeName,
		e.Department, 
		o.Quantity,
		o.Sales,
		o.OrderDate
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	LEFT JOIN Sales.Employees e
	ON o.SalesPersonID = e.EmployeeID
)

SELECT * FROM Sales.V_Orders_Summary

-- USE CASE 3: Use views to enforce security and protect sensitive data, by hiding 
	columns and/or rows from tables

CREATE VIEW Sales.V_Orders_Summary_EU AS (
	SELECT 
		o.OrderID,
		p.Product,
		p.Category,
		CONCAT(c.FirstName, ' ', c.LastName) CustomerName,
		c.Country CustomerCountry,
		CONCAT(e.FirstName, ' ', e.lastName) EmployeeName,
		e.Department, 
		o.Quantity,
		o.Sales,
		o.OrderDate
	FROM Sales.Orders o
	LEFT JOIN Sales.Products p
	ON o.ProductID = p.ProductID
	LEFT JOIN Sales.Customers c
	ON o.CustomerID = c.CustomerID
	LEFT JOIN Sales.Employees e
	ON o.SalesPersonID = e.EmployeeID
	WHERE c.Country = 'Germany'
)

