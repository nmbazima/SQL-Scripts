-- Step 1 - Switch to the AdventureWorks database

USE MarketDev;
GO

-- Step 2 - Create the GetProductColors stored procedure

CREATE PROCEDURE Reports.GetProductColors
AS
SET NOCOUNT ON;
BEGIN
	SELECT DISTINCT p.Color
	FROM Marketing.Product AS p
	WHERE p.Color IS NOT NULL
	ORDER BY p.Color;
END
GO


-- Step 3 Execute the stored procedure
EXEC Reports.GetProductColors;
GO


-- Step 4 Create GetProductsAndModels stored procedure
CREATE PROCEDURE Reports.GetProductsAndModels
AS
SET NOCOUNT ON;
BEGIN
	SELECT p.ProductID,
		   p.ProductName,
		   p.ProductNumber,
		   p.SellStartDate,
		   p.SellEndDate,
		   p.Color,
		   pm.ProductModelID,
		   COALESCE(ed.Description,id.Description,p.ProductName) AS EnglishDescription,
		   COALESCE(fd.Description,id.Description,p.ProductName) AS FrenchDescription,
		   COALESCE(cd.Description,id.Description,p.ProductName) AS ChineseDescription
	FROM Marketing.Product AS p
	LEFT OUTER JOIN Marketing.ProductModel AS pm
	ON p.ProductModelID = pm.ProductModelID
	LEFT OUTER JOIN Marketing.ProductDescription AS ed
	ON pm.ProductModelID = ed.ProductModelID 
	AND ed.LanguageID = 'en'
	LEFT OUTER JOIN Marketing.ProductDescription AS fd
	ON pm.ProductModelID = fd.ProductModelID 
	AND fd.LanguageID = 'fr'
	LEFT OUTER JOIN Marketing.ProductDescription AS cd
	ON pm.ProductModelID = cd.ProductModelID 
	AND cd.LanguageID = 'zh-cht'
	LEFT OUTER JOIN Marketing.ProductDescription AS id
	ON pm.ProductModelID = id.ProductModelID 
	AND id.LanguageID = ''
	ORDER BY p.ProductID,pm.ProductModelID;
END
GO

-- Step 5 Execute GetProductsAndModels stored procedure
EXEC Reports.GetProductsAndModels;
GO