-- Demonstration -- Live Query Statistics


-- Step 1: Connect to AdventureWorks
-- Select and execute the following query to use AdventureWorks2016
USE AdventureWorks;
GO


-- Step 2: Run a Query before enabling Live Query Statistics
-- Select and execute the following query 
-- Point out the Results window just shows results and messages
SELECT * FROM [Sales].[vStoreWithContacts]


-- Step 3: Enable Live Query Statistics
-- On the Query menu, click Include Live Query Statistics.


-- Step 4: Run the query again
-- Select and execute the following query 
-- Point out the Results window now includes the Live Query Statistics
SELECT * FROM [Sales].[vStoreWithContacts]


-- Step 5: Disable Live Query Statistics
-- On the Query menu, click Include Live Query Statistics.






