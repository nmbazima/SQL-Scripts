---------------------------------------------------------------------
-- LAB 18
--
-- copy-paste text about lab from doc file
--
-- Exercise 2
---------------------------------------------------------------------

USE TSQL;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- The IT department has provided T-SQL code that is similar to the code in the previous exercise.
--
-- Execute only the SELECT statement.
--
-- Observe and compare the results that you got with the desired results shown in the file 62 - Lab Exercise 2 - Task 1_1 result.txt. Notice the number of employees in the HR.Employees table.
--
-- Execute the part of the T-SQL code that starts with a BEGIN TRAN statement and ends with the COMMIT TRAN statement. You will get a conversion error in the second INSERT statement. 
--
-- Again execute only the SELECT statement.
--
-- Observe and compare the results that you got with the desired results shown in the file 63 - Lab Exercise 2 - Task 1_2 Result.txt. Notice that although you got an error inside the transaction block, one new row was added to the HR.Employees table based on the first INSERT statement.
---------------------------------------------------------------------
SELECT empid, lastname, firstname
FROM HR.Employees
ORDER BY empid DESC;

GO

BEGIN TRAN;

INSERT INTO HR.Employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
VALUES (N'Johnson', N'Test 1', N'Sales Manager', N'Mr.', '19700101', '20110101', N'Some Address 18', N'Ljubljana', NULL, N'1000', N'Slovenia', N'(386) 113322', 2);

INSERT INTO HR.Employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
VALUES (N'Robertson', N'Test 2', N'Sales Representative', N'Mr.', '19850101', '10110601', N'Some Address 22', N'Ljubljana', NULL, N'1000', N'Slovenia', N'(386) 553344', 10);

COMMIT TRAN;

GO




---------------------------------------------------------------------
-- Task 2
-- 
-- Execute the provided T-SQL code to delete the row inserted from the previous task.
-- Note that this is a cleanup code that will not be explained in this course.
---------------------------------------------------------------------

DELETE HR.Employees
WHERE empid IN (10, 11);
DBCC CHECKIDENT ('HR.Employees', RESEED, 9);




---------------------------------------------------------------------
-- Task 3
-- 
-- Modify the provided T-SQL code to include a TRY / CATCH block that rolls back the entire transaction if any of the INSERT statements throws an error:
--
-- In the CATCH block, include a PRINT statement that prints the message “Rollback the transaction…” if an error occurred and the message “Commit the transaction…” if no error occurred. 
--
-- Execute the modified T-SQL code.
--
-- Observe and compare the results that you got with the recommended result shown in the file 64 - Lab Exercise 2 - Task 3_1 Result.txt.
--
-- Write a SELECT statement against the HR.Employees table to see if any new rows were inserted (like you did in exercise 1). Execute the SELECT statement.
--
-- Observe and compare the results that you got with the recommended result shown in the file 65 - Lab Exercise 2 - Task 3_2 Result.txt.
---------------------------------------------------------------------

BEGIN TRAN;

INSERT INTO HR.Employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
VALUES (N'Johnson', N'Test 1', N'Sales Manager', N'Mr.', '19700101', '20110101', N'Some Address 18', N'Ljubljana', NULL, N'1000', N'Slovenia', N'(386) 113322', 2);

INSERT INTO HR.Employees (lastname, firstname, title, titleofcourtesy, birthdate, hiredate, address, city, region, postalcode, country, phone, mgrid)
VALUES (N'Robertson', N'Test 2', N'Sales Representative', N'Mr.', '19850101', '10110601', N'Some Address 22', N'Ljubljana', NULL, N'1000', N'Slovenia', N'(386) 553344', 10);

COMMIT TRAN;





---------------------------------------------------------------------
-- Task 4
-- 
-- Execute the provided T-SQL code.
---------------------------------------------------------------------

DBCC CHECKIDENT ('HR.Employees', RESEED, 9);
