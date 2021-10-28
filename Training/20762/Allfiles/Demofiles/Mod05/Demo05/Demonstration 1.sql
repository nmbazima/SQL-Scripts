-- Demonstration 1

-- Step 1: Open a query window to the AdventureWorks database

USE AdventureWorks;
GO

-- Step 2: Query the index physical stats DMV
--         Note that in the query below, the three NULL values are the 
--         object, the index, and the partition. In this case, we are 
--         showing all of these

SELECT obj.name, phys.* FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'LIMITED') as phys
JOIN sys.objects as obj on obj.object_id = phys.object_id
ORDER BY avg_fragmentation_in_percent DESC;

-- Step 3: Note the avg_fragmentation_in_percent returned

-- Step 4: Note that there are choices on the level of detail returned
--         The next choice is SAMPLED.

SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'SAMPLED')
ORDER BY avg_fragmentation_in_percent DESC;

-- Step 5: The final choice is DETAILED.
--         Warning: this option can take a long time on large databases

SELECT * FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'DETAILED')
ORDER BY avg_fragmentation_in_percent DESC;


