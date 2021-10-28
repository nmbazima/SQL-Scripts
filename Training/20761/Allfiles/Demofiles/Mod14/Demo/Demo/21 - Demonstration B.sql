-- Demonstration A
-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO


-- Step 2: Setup objects for demo
IF OBJECT_ID('Sales.CategorySales','V') IS NOT NULL DROP VIEW Sales.CategorySales
GO
CREATE VIEW Sales.CategorySales
AS
SELECT  c.categoryname AS Category,
        o.empid AS Emp,
        o.custid AS Cust,
        od.qty AS Qty,
        YEAR(o.orderdate) AS Orderyear
FROM    Production.Categories AS c
        INNER JOIN Production.Products AS p ON c.categoryid=p.categoryid
        INNER JOIN Sales.OrderDetails AS od ON p.productid=od.productid
        INNER JOIN Sales.Orders AS o ON od.orderid=o.orderid
WHERE c.categoryid IN (1,2,3) AND o.custid BETWEEN 1 AND 5; --limits results for slides
GO


-- Step 3: Show query without use of grouping sets
SELECT Category, NULL AS Cust, SUM(Qty) AS TotalQty
FROM Sales.CategorySales
GROUP BY category
UNION ALL 
SELECT  NULL, Cust, SUM(Qty) AS TotalQty
FROM Sales.CategorySales
GROUP BY cust 
UNION ALL
SELECT NULL, NULL, SUM(Qty) AS TotalQty
FROM Sales.CategorySales;


-- Step 4: Query with grouping sets
SELECT Category, Cust, SUM(Qty) AS TotalQty
FROM Sales.CategorySales
GROUP BY 
GROUPING SETS((Category),(Cust),())
ORDER BY Category, Cust;


-- Step 5: Query with CUBE
SELECT Category, Cust, SUM(Qty) AS TotalQty
FROM Sales.CategorySales
GROUP BY CUBE(Category,Cust)
ORDER BY Category, Cust;


-- Step 6: With ROLLUP
SELECT Category, Cust, SUM(Qty) AS TotalQty
FROM Sales.CategorySales
GROUP BY ROLLUP(Category,Cust)
ORDER BY Category, Cust;


-- Step 7: Using GROUPING_ID
SELECT	GROUPING_ID(Category)AS grpCat, GROUPING_ID(Cust) AS grpCust, 
		Category, Cust, SUM(Qty) AS TotalQty
FROM Sales.CategorySales
GROUP BY CUBE(Category,Cust)
ORDER BY Category, Cust;


-- Step 8: Clean up
IF OBJECT_ID('Sales.CategorySales','V') IS NOT NULL DROP VIEW Sales.CategorySales
GO
