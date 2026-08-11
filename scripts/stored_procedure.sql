/* ===================================================================================
						      - STORE PROCEDURE -
===================================================================================== */


-- =============================================================================
-- STEP 1: Write a query
-- ============================================================================
-- For US Customers, find the total number of customers and the average scores

 SELECT
	COUNT(CustomerID) TotalCustomers,
	AVG(Score) AvgScores
 FROM Sales.Customers
 WHERE Country = 'USA'

 -- STEP 2: Turning the query into a stored procedure
 IF OBJECT_ID('GetCustomerSummary', 'U') IS NOT NULL
	DROP PROCEDURE GetCustomerSummary;
GO

-- STORED PROCEDURES: Using Parameters
 ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS

BEGIN
	BEGIN TRY	
		DECLARE @TotalCustomers INT, @AvgScores FLOAT

		-- =================================================
		-- Step 3: Prepare and Clean the data
		-- =================================================
		IF EXISTS(SELECT 1 FROM Sales.Customers	WHERE Score IS NULL AND Country = @Country)
			BEGIN
				PRINT ('Updating NULL values to 0');
				UPDATE Sales.Customers
				SET Score = 0
				WHERE Score IS NULL AND Country = @Country;
			END
		ELSE
			BEGIN
				PRINT ('No NULL values')
			END;
	
		-- ==================================================
		-- Step 4: Generating reports
		-- ==================================================
		-- Calculate the Total Customers and Average Score for a specifi country
		SELECT
			@TotalCustomers = COUNT(*),
			@AvgScores = AVG(Score)

		FROM Sales.Customers
	 WHERE Country = @Country;

	 PRINT 'Total customer from ' + @Country + ':' + ' ' + CAST(@TotalCustomers AS NVARCHAR);
	 PRINT 'Average score from ' + @Country + ':' + ' ' + CAST(@AvgScores AS NVARCHAR);

		-- Calculate the total number of orders and tola sales for a specific country
		SELECT
			COUNT(OrderID) TotalOrders,
			SUM(Sales) TotalSales,
			1/0
		FROM Sales.Orders o
		LEFT JOIN Sales.Customers c
		ON o.CustomerID = c.CustomerID
		WHERE c.Country = @Country

	END TRY
	BEGIN CATCH
	    -- ====================================================
		-- ERROR HANDLING
		-- ====================================================
		PRINT('An error occured!');
		PRINT('Error Message: ' + ERROR_MESSAGE());
		PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
		PRINT('Error Procedure: ' + ERROR_PROCEDURE())
	END CATCH
END



-- STEP 5: Execute the stored procedures
EXEC GetCustomerSummary
EXEC GetCustomerSummary @Country = 'Germany'

SELECT * FROM Sales.Customers
