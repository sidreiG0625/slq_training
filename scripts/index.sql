
-- =================================================================
--              INDEX
-- 3 Categories: 1. Structured, 2. Storage, 3. Functions
-- 1. Structured: 1. Clustered, 2. Non-clustered , 3. Composite
-- 2. Storage: 1. Rowstore Index, 2. Columnstore Index (faster than rowstore index)

-- =================================================================

-- STEP 1: Load the customers table in a new table 
SELECT *
INTO Sales.dbCustomers
FROM Sales.Customers

  -- STEP 2: Create a new clustered index OR new non-clustered index
CREATE CLUSTERED INDEX idx_dbCustomers ON Sales.DBCustomers(CustomerID)         -- clustered index by CustomerID (based on Primary Key)
CREATE NONCLUSTERED INDEX idx_dbCustomers_nc ON Sales.dbCustomers(LastName)     -- non-clustered index by LastName (based on a single column)

-- COMPOSITE INDEX --> a non-clustered index applied to multiple columns
CREATE INDEX idx_dbCustomers_CountryScore ON Sales.dbCustomers(Country, Score)   -- non-clustered index applied to Country and Score columns

-- Creating a Columnstore Index 

CREATE CLUSTERED COLUMNSTORE INDEX idx_dbCustomers_cs ON Sales.Customers         -- clustered columnstore index
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_dbCustomers_cs_FirstName                -- nonclustered columnstore index
ON Sales.Customers(FirstName)
 
