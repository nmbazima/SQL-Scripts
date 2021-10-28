-- Demonstration A

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO

-- Step 2: Creating Windows with OVER

-- Setup views for demo
IF OBJECT_ID('Production.CategorizedProducts','V') IS NOT NULL DROP VIEW Production.CategorizedProducts
GO
CREATE VIEW Production.CategorizedProducts
AS
    SELECT  Production.Categories.categoryid AS CatID,
			Production.Categories.categoryname AS CatName,
            Production.Products.productname AS ProdName,
            Production.Products.unitprice AS UnitPrice
    FROM    Production.Categories
            INNER JOIN Production.Products ON Production.Categories.categoryid=Production.Products.categoryid;
GO
IF OBJECT_ID('Sales.CategoryQtyYear','V') IS NOT NULL DROP VIEW Sales.CategoryQtyYear
GO
CREATE VIEW Sales.CategoryQtyYear
AS
SELECT  c.categoryname AS Category,
        SUM(od.qty) AS Qty,
        YEAR(o.orderdate) AS Orderyear
FROM    Production.Categories AS c
        INNER JOIN Production.Products AS p ON c.categoryid=p.categoryid
        INNER JOIN Sales.OrderDetails AS od ON p.productid=od.productid
        INNER JOIN Sales.Orders AS o ON od.orderid=o.orderid
GROUP BY c.categoryname, YEAR(o.orderdate);
GO

-- Step 3: Using OVER with ordering
-- Rank products by price from high to low
SELECT CatID, CatName, ProdName, UnitPrice,
	RANK() OVER(ORDER BY UnitPrice DESC) AS PriceRank
FROM Production.CategorizedProducts
ORDER BY PriceRank; 

-- Rank products by price in descending order in each category.
-- Note the ties.
SELECT CatID, CatName, ProdName, UnitPrice,
	RANK() OVER(PARTITION BY CatID ORDER BY UnitPrice DESC) AS PriceRank
FROM Production.CategorizedProducts
ORDER BY CatID; 

-- Step 4: Use framing to create running total
-- Display a running total of quantity per product category. 
-- This uses framing to set boundaries at the start
-- of the set and the current row, for each partition
SELECT Category, Qty, Orderyear,
	SUM(Qty) OVER (
		PARTITION BY category
		ORDER BY orderyear
		ROWS BETWEEN UNBOUNDED PRECEDING
		AND CURRENT ROW) AS RunningQty
FROM Sales.CategoryQtyYear;


-- Display a running total of quantity per year. 
SELECT Category, Qty, Orderyear,
	SUM(Qty) OVER (
		PARTITION BY orderyear
		ORDER BY Category
		ROWS BETWEEN UNBOUNDED PRECEDING
		AND CURRENT ROW) AS RunningQty
FROM Sales.CategoryQtyYear;

-- Show both side-by-side per category and per-year

SELECT Category, Qty, Orderyear,
	SUM(Qty) OVER (PARTITION BY orderyear ORDER BY Category	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotalByYear,
	SUM(Qty) OVER (PARTITION BY Category ORDER BY OrderYear	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotalByCategory
FROM Sales.CategoryQtyYear
ORDER BY Orderyear, Category;

-- Step 5: Clean up
IF OBJECT_ID('Production.CategorizedProducts','V') IS NOT NULL DROP VIEW Production.CategorizedProducts
IF OBJECT_ID('Sales.CategoryQtyYear','V') IS NOT NULL DROP VIEW Sales.CategoryQtyYear
GO
