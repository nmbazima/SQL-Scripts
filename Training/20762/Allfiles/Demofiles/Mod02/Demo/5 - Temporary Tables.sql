-- Demonstration 5 - Working with Temporary Tables

-- Step 1: Select and execute the following query 
-- Mention that the session cannot see this table because it is local to the other session
-- Remind students that a single hash character '#' denotes a local temporary table
-- Leave this query window open
-- Return to [4 - Temporary Tables.sql], Step 3
USE AdventureWorks;
GO

SELECT	* 
FROM	#ProductList


-- Step 2: Select and execute the following query 
-- Mention that the session can see this table because it is global
-- Remind students that a double hash character '##' denotes a global temporary table
-- Return to [4 - Temporary Tables.sql], Step 5

SELECT	* 
FROM	##ProductList