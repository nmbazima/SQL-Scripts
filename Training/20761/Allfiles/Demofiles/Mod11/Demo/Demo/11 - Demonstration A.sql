-- Demonstration A

-- Step 1: Open a new query window to the TSQL database
USE TSQL;
GO

-- Step 2: Simple views
-- Select and execute the following to create a simple view
CREATE VIEW HR.EmpPhoneList
AS
SELECT empid, lastname, firstname, phone
FROM HR.Employees;
GO

-- Select from the new view
SELECT empid, lastname, firstname, phone
FROM HR.EmpPhoneList;
GO

-- Step 3: Complex views
-- Create a view using a multi-table join
CREATE VIEW Sales.OrdersByEmployeeYear
AS
    SELECT  emp.empid AS employee ,
            YEAR(ord.orderdate) AS orderyear ,
            SUM(od.qty * od.unitprice) AS totalsales
    FROM    HR.Employees AS emp
            JOIN Sales.Orders AS ord ON emp.empid = ord.empid
            JOIN Sales.OrderDetails AS od ON ord.orderid = od.orderid
    GROUP BY emp.empid ,
            YEAR(ord.orderdate)
GO
-- Select from the view
SELECT employee, orderyear, totalsales
FROM Sales.OrdersByEmployeeYear
ORDER BY employee, orderyear;


-- Step 4: Clean up
DROP VIEW Sales.OrdersByEmployeeYear;
DROP VIEW HR.EmpPhoneList;
