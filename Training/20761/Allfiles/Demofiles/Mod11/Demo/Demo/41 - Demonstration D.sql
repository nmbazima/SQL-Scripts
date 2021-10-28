-- Demonstration D

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO
-- Step 2: Common Table Expressions
-- -- Select this query and execute it to show CTE Examples
WITH CTE_year AS
	(
	SELECT YEAR(orderdate) AS orderyear, custid
	FROM Sales.Orders
	)
SELECT orderyear, COUNT(DISTINCT custid) AS cust_count
FROM CTE_year
GROUP BY orderyear;

-- Step 3 (Optional) Recursive CTE (for demonstration at trainer's discretion)
WITH EmpOrg_CTE AS
(SELECT empid, mgrid, lastname, firstname --anchor query
	FROM HR.Employees
WHERE empid = 5 -- starting "top" of tree. Change this to show other root employees

UNION ALL
SELECT child.empid, child.mgrid, child.lastname, child.firstname -- recursive member which refers back to CTE
	FROM EmpOrg_CTE AS parent
	JOIN HR.Employees AS child
	ON child.mgrid=parent.empid
)
SELECT empid, mgrid, lastname, firstname
FROM EmpOrg_CTE;