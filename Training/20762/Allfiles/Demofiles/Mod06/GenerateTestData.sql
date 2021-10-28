-- GenerateTestData
-- Make AdventureWorksLT the current database

--------------------------------------------------------------------------------
-- Create a larger Product table
-- Takes about 2:30 minutes
--------------------------------------------------------------------------------

IF OBJECT_ID(N'SalesLT.TempProduct', N'U') IS NOT NULL
	DROP TABLE SalesLT.TempProduct;
GO

DECLARE @t TABLE
(
	id int
);

INSERT INTO @t (id)
VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);


WITH TempCTE(id1, id2) AS
(
	SELECT *
		FROM @t AS T1
			CROSS JOIN @t AS T2
)
SELECT *
	INTO SalesLT.TempProduct
	FROM SalesLT.Product
		CROSS JOIN TempCTE;
GO


--------------------------------------------------------------------------------
-- Create a clustered index on the TempProduct table
-- Takes about 2:30 minutes
--------------------------------------------------------------------------------
		
CREATE CLUSTERED INDEX PK_TempProduct
	ON SalesLT.TempProduct(ProductID, id1, id2);
GO


--------------------------------------------------------------------------------
-- Display the records in the new table
--------------------------------------------------------------------------------

SELECT *
	FROM SalesLT.TempProduct;
GO


