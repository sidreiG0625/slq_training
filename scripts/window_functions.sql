/*
=======================================================================
----------                  WINDOW FUNCTIONS			---------------
=======================================================================

*/

/*
=======================================================================
---------		AGGREGATE FUNCTIONS IN WINDOWS FUNCTIONS      ---------
=======================================================================
*/

USE SalesDB
SELECT * FROM Sales.Orders
SELECT * FROM Sales.OrdersArchive


				--- 1. COUNT() FUNCTIONS ---
SELECT
	OrderID
	, COUNT(*) OVER(PARTITION BY OrderID) check_dup
FROM Sales.Orders

-- Checking duplicate records in Orders table
SELECT * 
FROM 
	( SELECT
		OrderID
		, COUNT(*) OVER(PARTITION BY OrderID) check_dup
	FROM Sales.OrdersArchive ) t
WHERE check_dup > 1

			--- 2. SUM() FUNCTIONS ---
-- Find the total sales across all orders
-- Find the total sales for each product in orders table
-- Provide additional details such as OrderID, OrderDate

SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER() total_sales,
	SUM(Sales) OVER(PARTITION BY ProductID) sales_by_product
FROM Sales.Orders

-- Find the percentage contribution of each products total sales to the overall total sales
SELECT
	OrderID,
	OrderDate,
	ProductID,
	SUM(Sales) OVER() total_sales,
	SUM(Sales) OVER(PARTITION BY ProductID) sales_by_product,
	ROUND(CAST(SUM(Sales) OVER(PARTITION BY ProductID) AS FLOAT) / CAST(SUM(Sales) OVER() AS FLOAT) * 100, 0) PercentContribution
FROM Sales.Orders

-- Rank the Products based on their total sales.
SELECT 
	ProductID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) RankByProducts
FROM Sales.Orders
GROUP BY ProductID

-- Rank the Customers based on their total sales
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) RankByCustomers
FROM Sales.Orders
GROUP BY CustomerID

			--- 3. AVG() FUNCTIONS ---
-- Find the average sales of orders
-- Find the average sales for each products
-- Provide additional details such as OrderID, OrderDate

SELECT
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER() AvgSales,
	AVG(Sales) OVER(PARTITION BY ProductID) AvgSalesByProduct
FROM Sales.Orders

-- Find the average scores of customers
-- Provide details such as CustomerID and LastName

SELECT * FROM Sales.Customers

SELECT
	CustomerID,
	LastName,
	Score,
	COALESCE(Score, 0) CoalesceCustomerScore,		-- converts NULL to 0 in the score column
	AVG(Score) OVER() AvgScoresWithNull,
	AVG(COALESCE(Score, 0)) OVER() AvgScoresNoNull	-- computes the average of the score column with NULL converted to zero using COALESCE()
FROM Sales.Customers

-- Find all orders where sales are higher than the average sales across all orders

SELECT 
*
FROM
	(
		SELECT 
			OrderID,
			Sales,
			AVG(Sales) OVER() AvgSales
		FROM Sales.Orders
	) tbl
WHERE Sales > AvgSales

			--- 4. MIN() FUNCTIONS ---
-- Find the highest and lowest sales of all orders
-- Find the highest and lowest sales for each product
-- Find the deviation of each sales from the minimun and maximum sales amount
-- Provide additional details such as orderId, orderDate

SELECT 
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	MAX(Sales) OVER() HighestSalesByOrders,
	MAX(Sales) OVER(PARTITION BY ProductID) HighestSalesByProduct,
	MIN(Sales) OVER() LowestSalesByOrders,
	MIN(Sales) OVER(PARTITION BY ProductID) LowestSalesByProduct,  
	Sales - MIN(Sales) OVER() VarianceSalesFromMin,
	Sales - MAX(Sales) OVER() VarianceSalesFromMax
FROM Sales.Orders

-- Show the employess who have the highest salaries
SELECT * FROM Sales.Employees

SELECT 
*
FROM
	(	SELECT
			*,
			MAX(Salary) OVER() HighestSalary
		FROM Sales.Employees
	
	) tbl
Where Salary = HighestSalary

-- Calculate the moving average of sales for each product over time
-- Calculate the moving average of sales for each product overtime, including only the next order

SELECT 
	ProductID,
	OrderID,
	OrderDate,
	Sales,
	AVG(Sales) OVER(ORDER BY OrderDate) AvgSales,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders

/*
=======================================================================
---------		RANKING WITH WINDOWS FUNCTIONS      ---------
=======================================================================
*/

			--- ROW_NUMBER() --> Unique ranking and Does Not Handle Ties, No Gaps in Ranking ---

-- Rank the Orders based on sales from highest to lowest
SELECT 
	OrderID,
	OrderDate,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) RankByRowNumber   -- ranks the sales in descending order without any gaps
FROM Sales.Orders


			--- RANK()  --> Shared Ranking, Handles Ties, Gaps in Ranks ---   
-- Rank the Orders based on sales from highest to lowest
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) RankByRowNumber,
	RANK() OVER(ORDER BY Sales DESC) SalesRank_byRank   -- ranks the sales in descending order with gaps/skips if there are ties
FROM Sales.Orders

			--- DENSE_RANK() --> Shared Ranking, No Gaps In Ranks ---
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	ROW_NUMBER() OVER(ORDER BY Sales DESC) RankByRowNumber,
	RANK() OVER(ORDER BY Sales DESC) SalesRank_byRank,  
	DENSE_RANK() OVER(ORDER BY Sales DESC) SalesRank_DenseRank	-- shared ranking , no skipping of rank
FROM Sales.Orders

		--- TOP-N ANALYSIS ---

-- FInd the top highest sales for each product
SELECT * FROM
	(SELECT 
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(PARTITION BY ProductID Order BY Sales DESC) RankByRowNumber_Highest
	FROM Sales.Orders) tbl
WHERE RankByRowNumber_Highest = 1

		--- BOTTOM-N ANALYSIS ---
-- Find the lowest 2 customers based on their total sales

SELECT TOP 2
	CustomerID,

	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales) ASC) RankLowestSales
FROM Sales.Orders
GROUP BY CustomerID

		--- GENERATE UNIQUE IDs ---

-- Assign unique IDs to the rows of the Orders Archive table
SELECT 
	ROW_NUMBER() OVER(ORDER BY OrderDate) UniqueID,
	*
FROM Sales.OrdersArchive

		-- IDENTIFY DUPLICATES --
-- Identify duplicate rows in the table 'Orders Arhive' table and return a clean result without any duplicates
SELECT *
FROM Sales.OrdersArchive
SELECT * FROM 
	(
		SELECT 
	
			ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) RankCreatedTime,
			*
		FROM Sales.OrdersArchive
	) tbl
WHERE RankCreatedTime = 1

			-- NTILE --
-- USE CASE 1: Segmentation by Customers
-- Segment all orders into 3 categories: high, medium and low sales

SELECT
*,
CASE
	WHEN Buckets = 1 THEN 'High'
	WHEN Buckets = 2 THEN 'Medium'
	WHEN Buckets = 3 THEN 'Low'
END Categories

FROM
	(
		SELECT 
			OrderID,
			CustomerID,
			Sales,
			NTILE(3) OVER(ORDER BY Sales DESC) Buckets
		FROM Sales.Orders
	) tbl

		-- USE CASE 2: NTILE FUNCTION: LOAD BALANCING --
-- As a data engineer, NTILE FUNCTION is very useful especially if you want to load large datasets into your target database.
-- Instead of loading the entire large data, you can divide the data into smaller chunks using NTILE function. This will help enhance
-- the loading processing time to complete the load. There are instances that loading the whole table in the database takes time and sometimes during
-- the course of loading the data in the database sometimes break and you have to re-do all over again. This is an inefficient way and load balancing
-- is a good solution for an efficient load process.


-- In order to export the data, divide the orders in 2 groups

SELECT 
	NTILE(2) OVER(ORDER BY OrderID) Batches,
	*
FROM Sales.Orders

		--- PERCENTAGE_BASED RANKING WINDOW FUNCTION ---

      ---  CUME_DIST() and PERCENT_RANK() ---

-- Find the products that fall within the highest 40% of the prices
SELECT * FROM
	(
		SELECT *,
			CUME_DIST() OVER(ORDER BY Price DESC) PricePct_cm,
			PERCENT_RANk() OVER(ORDER BY Price DESC) PricePct_pr
		FROM SAles.Products
	) tbl
WHERE PricePct_cm <= 0.4  AND PricePct_pr <= 0.4

/*
=================================================================
------   VALUE ANALYTIC FUNCTIONS in WINDOW FUNCTIONS        -----------
=================================================================
*/


  --------------  1. LEAD() FUNCTIONS  --> returns the value for the next row
  -- Analyze customer royalty by ranking customers based on the average number of days between orders
	SELECT 
		CustomerID, 
		AVG(DurationDays) AvgDays,
		RANK() OVER(ORDER BY COALESCE(AVG(DurationDays), 9999)) CustomerRank
	FROM
		(SELECT
			OrderID,
			CustomerID,
			OrderDate CurrentOrder,
			LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
			DATEDIFF(DAY, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) DurationDays
			
		  FROM Sales.Orders
		  ) tbl
		  GROUP BY CustomerID
		
	


  -------------  2. LAG() FUNCTIONS  --> returns the value of the previous row       
  -- Analyze the month-over-month performance by finding the percentage change 
  -- in sales between the current and previous months
  SELECT *,
	CurrentMonthSales - PrevMonthSales AS MOMChange,
	ROUND((CurrentMonthSales - PrevMonthSales) / PrevMonthSales * 100, 2) PctChange
  FROM
	(
		  SELECT 
			MONTH(OrderDate) OrderMonth,
			CAST(SUM(Sales) AS FLOAT) CurrentMonthSales,
			LAG(SUM(Sales)) OVER(ORDER BY MONTH(OrderDate) ASC) PrevMonthSales
			FROM Sales.Orders
		  GROUP BY MONTH(OrderDate)
	  ) tbl




  SELECT 
	  MONTH(OrderDate) OrderMonth,
	  Sales,
	  --SUM(Sales) TotalSales,
	  LAG(Sales) OVER(PARTITION BY MONTH(OrderDate) ORDER BY MONTH(OrderDate) ASC) PrevMonthSales
  FROM Sales.Orders
  --GROUP BY MONTH(OrderDate)

  -------------  3. FIRST_VALUE() FUNCTIONS  --> access a value from the first row within a window
  -------------  4. LAST_VALUE() FUNCTIONS  --> access a value from the last row within a window
  -- Find the lowest and highest sales of each product.
   
  SELECT 
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales

  FROM Sales.Orders
  Order BY ProductID
