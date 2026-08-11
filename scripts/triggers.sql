
/* ===================================================================================
						      - TRIGGERS -
===================================================================================== */

-- USE CASE 1: Maintaining the logs
-- STEP 1: Create Logs table
CREATE TABLE Sales.EmployeeLogs (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage NVARCHAR(255),
	LogDate DATETIME
)

--SELECT * FROM Sales.EmployeeLogs 
-- STEP 2: Create the trigger
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT 
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs(EmployeeID, LogMessage, LogDate)
	SELECT 
		EmployeeID,
		'New employee has been added: ' + CAST(EmployeeID AS NVARCHAR),
		GETDATE()
	FROM INSERTED;
END


INSERT INTO Sales.Employees 
VALUES
(1, 'Sidrei', 'Gacus', 'Information Systes', '2025-06-08', 'M', 250000, 3),


SELECT * FROM Sales.Employees
SELECT * FROM Sales.EmployeeLogs 

DELETE SAles.Employees
WHERE EmployeeID = 1



























