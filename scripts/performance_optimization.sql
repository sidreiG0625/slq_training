/*
-- ========================================================================================
                      -- PERFORMANCE OPTIMIZATION METHODS --
                          -- 1. INDEX MANAGEMENT
                          -- 2. PARTITIONS
                          -- 3. Performance Tips (BEST PRACTICES)
                                -- Always check the execution plan to confirm performance improvement
                                   when optimizing query. If theres no improvement, focus on readibility
                              -- BEST PRACTICES FOR SELECT STATEMENTS *
                                  -- Select only the columns you need
                                  -- Avoid unnecessary DISTINCT and ORDER BY
                                  -- For exploration purposes, limit the rows

                              -- BEST PRACTICES FOR FILTERING * 
                                  -- Create a nonclustered index on frequently used columns in where clause
                                  -- Avoid applying functions to columns in WHERE clause
                                  -- Avoid using leading wildcard as they prevent index usage
                                  -- Use IN instead of multiple OR conditions

                              -- BEST PRACTICES FOR JOINING STATEMENTS * 
                                  -- Understand the speed of joins & Use of INNER JOIN when possible
                                  -- Use explicit joins (ANSI join) instead of implicit joins (non-ANSI Join)
                                  -- Make sure to index the columns used in the ON clause
                                  -- Filter before joining tables
                                  -- Aggregate data before joining tables
                                  -- Use UNION instead of OR in joins
                                  -- Use UNION ALL instead of UNTION if duplicates are acceptable
                                  -- Use UNION ALL and DISTINCT instead of using UNION if duplicates are not acceptable
                                  -- Check for Nested loops and use SQL hints

                              -- BEST PRACTICES FOR AGGREGATIONS * 
                                  -- Use columnstore index for aggregations in large tables
                                  -- Pre-aggregate the data and store it in a new table for reporting

                              -- BEST PRACTICES FOR SUBQUERIES * 
                                  -- Use EXISTS for large tables than JOINS (small tables) on subquery
                                  -- Avoid redundant logic in your query

                              -- BEST PRACTICES FOR CREATING TABLES (DDL) * 
                                  -- Avoid using VARCHAR and TEXT datatypes
                                  -- Avoid using MAX unnecessarily large lengths in data types
                                  -- Use the NOT NULL constraint where applicable
                                  -- Ensure all your tables have a clustered primary key
                                  -- Create a non-clustered index for foreign keys that are frequently used

                              -- BEST PRACTICES FOR INDEXING/PARTITIONING *
                                 -- Avoid overindexing
                                 -- drop unused indexing
                                 -- update index statistics (weekly)
                                 -- reorganize or rebuild indexes
                                 -- partition largem fact tables to improve performance

-- METHOD 1. INDEX MANAGEMENT --
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
-- ======================================================================================== */
                      -- INDEX EXECUTION PLAN --
-- Estimated vs Actual Execution Plans
   -- if the predictions dont match the Actual Execution Plan, this indicate issues like inaccurate
   -- statistics or outdated indexes leading to poor performance
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


                      -- PERFORMANCE OPTIMIZATION METHODS --
-- METHOD 1. SQL PARTITIONS 
-- divides big table into smaller partitions
-- ========================================================================================
