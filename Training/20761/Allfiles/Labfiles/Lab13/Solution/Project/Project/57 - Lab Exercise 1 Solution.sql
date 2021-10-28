---------------------------------------------------------------------
-- LAB 13
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
---------------------------------------------------------------------

SELECT 
	orderid, 
	orderdate,
	val,
	ROW_NUMBER() OVER (ORDER BY orderdate) AS rowno
FROM Sales.OrderValues;

---------------------------------------------------------------------
-- Task 2
---------------------------------------------------------------------

SELECT 
	orderid, 
	orderdate,
	val,
	ROW_NUMBER() OVER (ORDER BY orderdate) AS rowno,
	RANK() OVER (ORDER BY orderdate) AS rankno
FROM Sales.OrderValues;

---------------------------------------------------------------------
-- Task 3
---------------------------------------------------------------------

SELECT 
	orderid, 
	orderdate,
	custid,
	val,
	RANK() OVER (PARTITION BY custid ORDER BY val DESC) AS orderrankno
FROM Sales.OrderValues;

---------------------------------------------------------------------
-- Task 4
---------------------------------------------------------------------

SELECT 
	custid,
	val,
	YEAR(orderdate) as orderyear,
	RANK() OVER (PARTITION BY custid, YEAR(orderdate) ORDER BY val DESC) AS orderrankno
FROM Sales.OrderValues;

---------------------------------------------------------------------
-- Task 5
---------------------------------------------------------------------

SELECT
	s.custid,
	s.orderyear,
	s.orderrankno,
	s.val
FROM
(
	SELECT 
		custid,
		val,
		YEAR(orderdate) as orderyear,
		RANK() OVER (PARTITION BY custid, YEAR(orderdate) ORDER BY val DESC) AS orderrankno
	FROM Sales.OrderValues
) AS s
WHERE s.orderrankno <= 2;

