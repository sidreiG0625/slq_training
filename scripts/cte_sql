/*
/*=============================================================
-- COMMON TABLE EXPRESSIONS (CTE)
-- Temporary, named result set (virtual table), that can be
-- used multiple times within your query

TYPES OF CTE:
NON-RECURSIVE CTE --> is executed only once without repetition
  - STANDALONE CTE = Defined and used independently.
  - MULTIPLE STANDALONE CTE = 2 or more combined standalone CTE
                             separated by comma (,)  

RECURSIVE CTE --> is a self-referencing query that repeatedly processes
	data until a specific condition is met

 -- CTE BEST PRACTICES
   1. Rethink and refactor your CTEs before building new CTE
   2. Dont use more than 5 CTEs in one query, otherwise your code
   will be hard to understand and maintain
=============================================================*/
-- STANDALONE CTE
-- STEP 1: Find the total sales per customer
WITH CTE_Total_Sales AS 
	(
		SELECT CustomerID,  SUM(Sales) TotalSales
		FROM Sales.Orders
		GROUP BY CustomerID
	)

-- MULTIPLE STANDALONE CTE
-- STEP 2: Find the last order date for each customer
, CTE_Last_Order AS 
	(
		SELECT
		CustomerID,
		MAX(OrderDate) LastOrder
		FROM Sales.Orders
		GROUP BY CustomerID

	)


/*=============================================================
 -- NESTED CTE 
     = CTE inside another CTE
	 = a nested CTE uses the result of another CTE so it can't run 
	 independently            
=============================================================*/
-- STEP 3: Rank customers based on Total Sales per customer
, CTE_Customer_Rank AS
	(
		SELECT CustomerID,
		TotalSales,
		RANK() OVER(ORDER BY TotalSales DESC) CustomerRank
		FROM CTE_Total_Sales
	)
-- STEP 4: Segment customers based on their total sales 
, CTE_Customer_Segment AS
	(
		SELECT
			CustomerID,
			TotalSales,
			CASE WHEN TotalSales > 100 THEN 'High'
				WHEN TotalSales > 80 THEN 'Medium'
				ELSE 'Low'
			END AS CustomerSegment
		FROM CTE_Total_Sales
	)
--SELECT * FROM CTE_Customer_Segment
-- Main Query
SELECT 
c.CustomerID, c.FirstName, c.LastName, cts.TotalSales, clo.LastOrder, ctr.CustomerRank, ctcs.CustomerSegment
FROM Sales.Customers c 
LEFT JOIN CTE_Total_Sales cts
ON c.CustomerID = cts.CustomerID
LEFT JOIN CTE_Last_Order clo
ON c.CustomerID = clo.CustomerID
LEFT JOIN CTE_Customer_Rank ctr
ON c.CustomerID = ctr.CustomerID
LEFT JOIN CTE_Customer_Segment ctcs
ON c.CustomerID = ctcs.CustomerID

/*=====================================================
-- RECURSIVE CTE
=====================================================*/
-- Generate a sequence of numbers from 1 to 20

WITH CTE_Generate_Number AS
(
	-- Anchor Query
	SELECT 1 AS MyNumber
	UNION ALL
	-- Recursive Query
	SELECT 
		MyNumber + 1 
	FROM CTE_Generate_Number 
	WHERE MyNumber < 20

)
SELECT * FROM CTE_Generate_Number*/

-- Using Recursive CTE, show the employee hierarchy by displaying 
-- each employees level within the organization


-- Anchor Query
WITH CTE_Employee_Level AS 
(
	SELECT 
		EmployeeID,
		Department,
		ManagerID,
		1 AS EmployeeLevel
	FROM Sales.Employees
	WHERE ManagerID IS NULL

	UNION ALL
	SELECT 
		e.EmployeeID,
		e. Department,
		e. ManagerID,
		EmployeeLevel + 1
	FROM Sales.Employees e
	INNER JOIN CTE_Employee_Level ctl
	ON e.ManagerID = ctl.EmployeeID
)
SELECT * FROM CTE_Employee_Level 





