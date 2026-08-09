/*
==================================================================================
---                     SUBQUERIES
==================================================================================
*/


-- Find the products that are greater than the average price of all products
SELECT *
FROM
	(
		SELECT 
		ProductID,
		Price,
		AVG(Price) OVER() AvgPrice
		FROM Sales.Products
	) tbl
WHERE Price > AvgPrice;


/*
=======================================================
-- SUBQUERY ON FROM CLAUSE
-- Rank customers based on their total amount of sales
=======================================================*/
SELECT *,
RANK() OVER(ORDER BY TotalSales DESC) AS RankCustomerSales
FROM
	(
		SELECT 
		CustomerID,
		SUM(Sales) AS TotalSales
		FROM Sales.Orders
		GROUP BY CustomerID
	) tbl

/*
=======================================================
-- SUBQUERY ON SELECT CLAUSE

-- Show the product IDs, product names, prices and total
-- number of orders
=======================================================*/

SELECT 
ProductID,
Product,
Price,
(SELECT COUNT(*) TotalOrders FROM Sales.Orders) TotalOrders
FROM Sales.Products

/*=======================================================
-- JOIN SUBQUERY 

-- Show all customer details and find the total orders of 
-- each customer
=======================================================*/
SELECT c.CustomerID,
COUNT(s.OrderID) AS OrdersByCustomer
FROM Sales.Customers c
LEFT JOIN Sales.Orders s
ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID

SELECT c.CustomerID,
s.TotalOrders
FROM Sales.Customers c
LEFT JOIN (
			SELECT CustomerID,  COUNT(*) TotalOrders FROM Sales.Orders GROUP BY CustomerID
		  ) s
ON c.CustomerID = s.CustomerID

/*=======================================================
-- SUBQUERY IN WHERE CLAUSE

=======================================================*/
-- Find the products that have a higher price than the 
-- average price of all products

SELECT 
	ProductID, 
	Price 
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) AvgPrice FROM Sales. Products)

-- Show the details of orders made by customer in Germany

SELECT * FROM Sales.Orders
WHERE CustomerID 
	IN (SELECT CustomerID FROM Sales.Customers WHERE Country = 'Germany')

-- Find female employees whose salaries are greather than the salaries of any male employees

SELECT EmployeeID, Salary FROM Sales.Employees
WHERE Gender = 'F' and  Salary  > ANY (SELECT Salary FROM SAles.Employees WHERE Gender = 'M')

-- Find female employees whose salaries are greather than the salaries of all male employees
SELECT EmployeeID, Salary FROM Sales.Employees
WHERE Gender = 'F' and  Salary  > ALL (SELECT Salary FROM SAles.Employees WHERE Gender = 'M')

/*=======================================================
-- EXISTS SUBQUERY
-- Show the details of orders made by customers made in Germany
=========================================================*/
SELECT * FROM SAles.Orders o
WHERE EXISTS (
          SELECT 1 FROM Sales.Customers c WHERE Country = 'Germany'
		  AND c.CustomerID = o.CustomerID)



/*=======================================================
-- DEPENDENCY - CORRELATED SUBQUERIES

-- A subquery that relies on values from the main query
=========================================================*/
-- Show all customer details and find the total orders of each customers

