-- Step 1 - Use the MemDemo database
USE MemDemo

-- Step 2 - Create a native stored proc
CREATE PROCEDURE dbo.InsertData
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')
	DECLARE @Memid int = 1
	WHILE @Memid <= 500000
	BEGIN
		INSERT INTO dbo.MemoryTable VALUES (@Memid, GETDATE())
		SET @Memid += 1
	END
END;
GO

-- Step 3 - Use the native stored proc
/* Note how long it has taken for the stored procedure to execute. 
This should be significantly lower than the time that it takes to 
insert data into the memory-optimized table by using a Transact-SQL INSERT statement.
*/
EXEC dbo.InsertData;

-- Step 4 - Verify MemoryTable contents
-- Confirm that the table now contains 500,000 rows.
SELECT COUNT(*) FROM dbo.MemoryTable;