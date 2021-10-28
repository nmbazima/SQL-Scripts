-- Demonstration 4A

-- Step A. Use the master database

USE master;
GO

-- Step B. Create a test login

CREATE LOGIN TestContext 
  WITH PASSWORD = 'P@ssw0rd',
       CHECK_POLICY = OFF;
GO

-- Step C. Switch to the AdventureWorks database and create a user for the login

USE AdventureWorks;
GO

CREATE USER TestContext FOR LOGIN TestContext;
GO

-- Step D. Create a user-defined function that uses the default execution context and query it.
-- The query returns a list of user tokens.
-- Note: Copy these results for later comparison. For example, you might copy and paste into notepad

CREATE FUNCTION dbo.CheckContext()
RETURNS TABLE
AS
RETURN ( SELECT * FROM sys.user_token
       );
GO

SELECT * FROM dbo.CheckContext();
GO

-- Step E. Try to alter the function to include the WITH EXECUTE AS clause. 
--         NOTE: This will fail as WITH EXECUTE AS cannot be used on inline 
--         table-valued functions

ALTER FUNCTION dbo.CheckContext()
RETURNS TABLE
WITH EXECUTE AS 'TestContext'
AS
RETURN ( SELECT * FROM sys.user_token
       );
GO

-- Step F. Drop and recreate the function as a multi-statement table-valued function

DROP FUNCTION dbo.CheckContext;
GO

CREATE FUNCTION dbo.CheckContext()
RETURNS @UserTokenList TABLE (principal_id int, 
                              sid varbinary(85), 
                              type nvarchar(128), 
                              usage nvarchar(128),
                              name nvarchar(128))
WITH EXECUTE AS 'TestContext'
AS BEGIN
  INSERT @UserTokenList 
    SELECT principal_id,
           sid,
           type,
           usage,
           name 
    FROM sys.user_token;
  RETURN 
END;
GO

-- Step G. SELECT from the function. A list of user tokens will be returned.
--         Note that the
--         list of tokens is now different.

SELECT * FROM dbo.CheckContext();
GO

-- Step H. Drop the objects you created

DROP FUNCTION dbo.CheckContext;
GO
DROP USER TestContext;
GO
DROP LOGIN TestContext;
GO
