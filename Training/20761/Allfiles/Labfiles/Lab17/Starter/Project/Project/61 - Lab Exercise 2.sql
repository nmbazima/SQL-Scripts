USE TSQL;
GO

--Task 1: Re-throw the existing error back to a client
DECLARE @num varchar(20) = '0';
BEGIN TRY
PRINT 5. / CAST(@num AS numeric(10,4));
END TRY
BEGIN CATCH

END CATCH;

--Task 2: Add an error handling routine
DECLARE @num varchar(20) = '0';
BEGIN TRY
PRINT 5. / CAST(@num AS numeric(10,4));
END TRY
BEGIN CATCH
EXECUTE dbo.GetErrorInfo;
	THROW;
END CATCH;

--Task 3: Add a different error handling routine
DECLARE @msg AS varchar(2048);
SET @msg = 'You are doing the exercise for Module 17 on ' + 
	FORMAT(CURRENT_TIMESTAMP, 'MMMM d, yyyy', 'en-US') + 
	'. It''s not an error but it means that you are near the final module!';

--Task 4: Remove the stored procedure
DROP  PROCEDURE dbo.GetErrorInfo