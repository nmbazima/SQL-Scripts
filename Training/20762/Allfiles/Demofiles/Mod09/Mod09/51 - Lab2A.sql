-- Step 1 Change to the MarketDev database
Use MarketDev;
GO

-- Step 2 Create the Marketing.GetProductsByColor stored procedure
CREATE PROCEDURE Marketing.GetProductsByColor
@Color nvarchar(16)
AS
SET NOCOUNT ON;
BEGIN
	SELECT p.ProductID,
	p.ProductName,
	p.ListPrice AS Price,
	p.Color,
	p.Size,
	p.SizeUnitMeasureCode AS UnitOfMeasure
	FROM Marketing.Product AS p
	WHERE (p.Color = @Color) OR (p.Color IS NULL AND @Color IS NULL)
	ORDER BY ProductName;
END
GO

-- Step 3 Exceute the Marketing.GetProductsByColor stored procedure for color blue
EXEC Marketing.GetProductsByColor 'Blue';
GO

-- Step 4 Exceute the Marketing.GetProductsByColor stored procedure with no color
EXEC Marketing.GetProductsByColor NULL;
GO
