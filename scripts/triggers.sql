
/* ===================================================================================
						      - TRIGGERS -
===================================================================================== */

-- USE CASE 1: Maintaining the logs
-- STEP 1: Create Logs table
IF OBJECT_ID('EmployeeLogs', 'U') IS NOT NULL
	DROP TABLE Sales.EmployeeLogs;
GO

CREATE TABLE Sales.EmployeeLogs (
	LogID INT NOT NULL,
	EmployeeID INT,
	LogMessage NVARCHAR(255),
	LogDate DATETIME,
	CONSTRAINT p_key PRIMARY KEY (LogID)
);

-- Drop the trigger if it already exists
--IF OBJECT_ID('trg_AfterInsertEmployee', 'TR') IS NOT NULL
IF EXISTS(SELECT 1 FROM sys.triggers WHERE name = trg_AfterInsertEmployee AND parent_id = OBJECT_ID(Sales.Employees))
	DROP TRIGGER trg_AfterInsertEmployee;
GO

-- Create new trigger
CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID,
		'New Employee Added: ' + CAST(EmployeeID AS NVARCHAR),
		GETDATE()
	FROM INSERTED;
END;

SELECT * FROM Sales.Employees
SELECT * FROM EmployeeLogs

DELETE Sales.Employees
WHERE EmployeeID = 6



INSERT INTO Sales.Employees 
VALUES
(6, 'Sofia', 'Gacus', 'Engineering', '2016-11-03', 'F', 20000, 2)



























