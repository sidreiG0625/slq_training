
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

-- ========================================================================================
                      -- INDEX MANAGEMENT --
-- Monitor Index usage. Drop unused indexes
-- Monitor Missing Indexes
-- Monitor duplicate indexes
-- Update statistics
-- Monitor fragmentation
   -- Reorganize: 
      -- Defragment leaf nodes to keep them sorted
      -- Light operation 
   -- Rebuild
      -- drops the whole index and recreates the whole indexes. Heavy operation
-- ========================================================================================
-- List all indexes on a specific table
sp_helpindex Sales.DBCustomers

-- Monitor index usage
SELECT 
  tbl.name as TableName,
  Name as IndexName,
  type desc as IndexType,
  is_primary_key as PrimaryKey,
  is_uniques as IsUnique,
  is_disabled as IsDisabled
FROM sys.indexes idx
JOIN sys.tables tbl
ON idx.object_id = tbl.object_id
ORDER BY tbl.name, idx.name

-- ========================================================================================
                      -- EXECUTION PLAN --
-- Estimated vs Actual Execution Plans
   -- if the predictions dont match the Actual Execution Plan, this indicate issues like inaccurate
   -- statistics or outdated indexes leading to poor performance
-- ========================================================================================

-- ========================================================================================
                      -- INDEXING STRATEGY --
-- GOLDEN RULE: Avoid overindexing (Less is more!!!) --> 
                -- indexes slows down write performance
                -- Over indexing confuses execution plans --> increasing execution plan time 
-- INDEXING STRATEGY
-- STEP 1: Initiate initial strategy 
     -- OLAP --> Optimize Read Performance (switch large frequently uses tables into a columnstore index)
     -- OLTP --> Optimize Write performance (use clustered column primary keys index)
-- STEP 2: USAGE PATTERNS Indexing
    --  Identify frequently used tables and columns
    -- Choose the right index
    -- Test Index
-- STEP 3: Scenario based indexing
    -- Identify slow queries
    -- Check execution plan
    -- Choose the right index
    -- Test and Compare execution plans
-- STEP 4: Monitoring and Maintenance
    -- Monitor index usage
    -- MOnitor mssing indexes
    -- MOnitor duplicate indexes
    -- Update statistics
    -- Monitor fragmentations
-- ========================================================================================


