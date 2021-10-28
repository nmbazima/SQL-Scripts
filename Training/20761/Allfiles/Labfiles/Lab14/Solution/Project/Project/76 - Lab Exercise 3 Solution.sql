---------------------------------------------------------------------
-- LAB 14
--
-- Exercise 3
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT
	country,
	city,
	COUNT(custid) AS noofcustomers
FROM Sales.Customers
GROUP BY
GROUPING SETS 
(
	(country, city),
	(country),
	(city),
	()
);

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT
	YEAR(orderdate) AS orderyear,
	MONTH(orderdate) AS ordermonth,
	DAY(orderdate) AS orderday,
	SUM(val) AS salesvalue
FROM Sales.OrderValues
GROUP BY
CUBE (YEAR(orderdate), MONTH(orderdate), DAY(orderdate));


---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT
	YEAR(orderdate) AS orderyear,
	MONTH(orderdate) AS ordermonth,
	DAY(orderdate) AS orderday,
	SUM(val) AS salesvalue
FROM Sales.OrderValues
GROUP BY
ROLLUP (YEAR(orderdate), MONTH(orderdate), DAY(orderdate));

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT
	GROUPING_ID(YEAR(orderdate), MONTH(orderdate)) as groupid,
	YEAR(orderdate) AS orderyear,
	MONTH(orderdate) AS ordermonth,
	SUM(val) AS salesvalue
FROM Sales.OrderValues
GROUP BY
ROLLUP (YEAR(orderdate), MONTH(orderdate))
ORDER BY groupid, orderyear, ordermonth;












