
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

-- COLUMNSTORE INDEX

CREATE CLUSTERED COLUMNSTORE INDEX idx_dbCustomers_cs ON Sales.Customers         -- clustered columnstore index
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_dbCustomers_cs_FirstName               -- nonclustered columnstore index
ON Sales.Customers(FirstName)

-- =======================================================================================
-- UNIQUE INDEX
  
-- SYNTAX: 
-- CREATE UNIQUE <CLUSTERED | NONCLUSTERED> <COLUMNSTORE> INDEX index_name ON
-- table_name (col1, col2, ....)
-- ========================================================================================

CREATE UNIQUE NONCLUSTERED COLUMNSTORE INDEX idx_dbProducts_uc_Products ON Sales.Products(Products)

-- =======================================================================================
-- FILTERED INDEX 
-- BENEFITS: 1. Targeted optimization, 

-- SYNTAX: 
-- CREATE UNIQUE <CLUSTERED | NONCLUSTERED> <COLUMNSTORE> INDEX index_name ON
-- table_name (col1, col2, ....) WHERE condition1
-- ========================================================================================
CREATE UNIQUE NONCLUSTERED COLUMNSTORE INDEX idx_dbOrders_ufc_Country ON Sales.Orders(Country)
WHERE Country = 'USA'
-- =======================================================================================
-- WHEN AND WHAT TO INDEX TO USE
-- HEAP INDEX - used when writing queries. Fast inserts queries.
-- CLUSTERED INDEX - used for primary keys. If not, then date columns. Applicable for OLTP Systems (Online Transactions Processing)
-- NONCLUSTERED INDEX - for non-PK columns (foreign keys, joins and filters)
-- COLUMNSTORE INDEX 
  -- for analytical queries like datawarehouse, reporting systems that reduce size of large tables. 
  -- Applicable for OLAP Systems (Online Analytical Processing)
-- FILTERED INDEX - to target subset of data, reduce the size of index
-- UNIQUE INDEX - enforce uniqueness and improve speed of the query. Restricts duplicate inserts of the target index
-- ========================================================================================




