-- Demonstration 1 - Creating a Partitioned Table

-- Step 1 - Open a new query window to the master database
-- Select and execute the following query to connect to master
USE master;
GO



-- Step 2 - Create new filegroups
-- Select and execute the following query to create the new filegroups

-- Add filegroup 1
ALTER DATABASE AdventureWorks2016
ADD FILEGROUP FileGroup1;
GO
-- Add file to filegroup 1
ALTER DATABASE AdventureWorks2016 
ADD FILE 
(
    NAME = AdventureWorks1,
    FILENAME = 'D:\Demofiles\Mod03\SetupFiles\AdventureWorks1.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup1;

-- Add filegroup 2
ALTER DATABASE AdventureWorks2016
ADD FILEGROUP FileGroup2;
GO
-- Add file to filegroup 2
ALTER DATABASE AdventureWorks2016 
ADD FILE 
(
    NAME = AdventureWorks2,
    FILENAME = 'D:\Demofiles\Mod03\SetupFiles\AdventureWorks2.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup2;

-- Add filegroup 3
ALTER DATABASE AdventureWorks2016
ADD FILEGROUP FileGroup3;
GO
-- Add file to filegroup 3
ALTER DATABASE AdventureWorks2016 
ADD FILE 
(
    NAME = AdventureWorks3,
    FILENAME = 'D:\Demofiles\Mod03\SetupFiles\AdventureWorks3.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup3;

-- Add filegroup 4
ALTER DATABASE AdventureWorks2016
ADD FILEGROUP FileGroup4;
GO
-- Add file to filegroup 4
ALTER DATABASE AdventureWorks2016 
ADD FILE 
(
    NAME = AdventureWorks4,
    FILENAME = 'D:\Demofiles\Mod03\SetupFiles\AdventureWorks4.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP FileGroup4;



-- Step 3 - Connect to AdventureWorks
-- Select and execute the following query to connect to the AdventureWorks database
USE AdventureWorks2016;
GO



-- Step 4 - Create partition function
-- Select and execute the following script to create a new partition function
-- Point out to the students the use of RANGE LEFT, and that three partitions have been specified
CREATE PARTITION FUNCTION YearlyPartitionFunction (datetime) 
AS RANGE LEFT 
FOR VALUES ('2011-12-31 00:00:00.000', '2012-12-31 00:00:00.000',  '2013-12-31 00:00:00.000');
GO



-- Step 5 - Create partition scheme
-- Select and execute the following script to create a new partition scheme
-- Point out that four filegroups were needed because SQL Server always creates an additional partition for data outside of the set boundaries
CREATE PARTITION SCHEME OrdersByYear 
AS PARTITION YearlyPartitionFunction 
TO (FileGroup1, FileGroup2, FileGroup3, FileGroup4);
GO



-- Step 6 - Create partitioned table
-- Select and execute the following query to create a copy of the SalesOrderHeader table
-- Highlight the use of the OrdersByYear scheme for the ON filegroup clause, and the OrderDate for the partitioning
CREATE TABLE Sales.SalesOrderHeader_Partitioned
(
	SalesOrderID int NOT NULL,
	RevisionNumber tinyint NOT NULL DEFAULT (0),
	OrderDate datetime NOT NULL DEFAULT GETDATE(),
	DueDate datetime NOT NULL,
	ShipDate datetime NULL,
	[Status] tinyint NOT NULL DEFAULT(1),
	OnlineOrderFlag dbo.Flag NOT NULL DEFAULT (1),
	SalesOrderNumber nvarchar(25),
	PurchaseOrderNumber dbo.OrderNumber NULL,
	AccountNumber dbo.AccountNumber NULL,
	CustomerID int NOT NULL,
	SalesPersonID int NULL,
	TerritoryID int NULL,
	BillToAddressID int NOT NULL,
	ShipToAddressID int NOT NULL,
	ShipMethodID int NOT NULL,
	CreditCardID int NULL,
	CreditCardApprovalCode varchar(15) NULL,
	CurrencyRateID int NULL,
	SubTotal money NOT NULL DEFAULT(0.00),
	TaxAmt money NOT NULL DEFAULT (0.00),
	Freight money NOT NULL DEFAULT (0.00),
	TotalDue money,
	Comment nvarchar(128) NULL,
	rowguid uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT NEWID(),
	ModifiedDate datetime NOT NULL DEFAULT GETDATE()

) 
-- Filegroup scheme
ON OrdersByYear(OrderDate);
GO



-- Step 7 - Copy data into the partitioned table
-- Select and execute the following query to copy data into the partitioned table
INSERT INTO Sales.SalesOrderHeader_Partitioned
		(SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, [Status], OnlineOrderFlag, SalesOrderNumber, PurchaseOrderNumber,
		AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode,
		CurrencyRateID, SubTotal, TaxAmt, Freight, TotalDue, Comment, rowguid, ModifiedDate)
SELECT	SalesOrderID, RevisionNumber, OrderDate, DueDate, ShipDate, [Status], OnlineOrderFlag, SalesOrderNumber, PurchaseOrderNumber,
		AccountNumber, CustomerID, SalesPersonID, TerritoryID, BillToAddressID, ShipToAddressID, ShipMethodID, CreditCardID, CreditCardApprovalCode,
		CurrencyRateID, SubTotal, TaxAmt, Freight, TotalDue, Comment, rowguid, ModifiedDate
FROM	Sales.SalesOrderHeader



-- Step 8 - Show the distribution of rows in the partitions
-- Select and execute the following query to show the number of rows for each year, which should be reflected in the partitions, and the actual number
-- of rows in each partition of the table

-- Count of rows per year - the partitions should match this
SELECT	DISTINCT DATEPART(YEAR, OrderDate) AS [Year], COUNT(*) AS TotalOrders
FROM	Sales.SalesOrderHeader_Partitioned
GROUP	BY DATEPART(YEAR, OrderDate)
ORDER	BY 1
-- Count of rows per partition - the numbers should be the same as the query above
SELECT	s.name AS SchemaName,
		t.name AS TableName,
		COALESCE(f.name, d.name) AS [FileGroup], 
		SUM(p.rows) AS [RowCount],
		SUM(a.total_pages) AS DataPages
FROM	sys.tables AS t
INNER	JOIN sys.indexes AS i ON i.object_id = t.object_id
INNER	JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id = i.index_id
INNER	JOIN sys.allocation_units AS a ON a.container_id = p.partition_id
INNER	JOIN sys.schemas AS s ON s.schema_id = t.schema_id
LEFT	JOIN sys.filegroups AS f ON f.data_space_id = i.data_space_id
LEFT	JOIN sys.destination_data_spaces AS dds ON dds.partition_scheme_id = i.data_space_id AND dds.destination_id = p.partition_number
LEFT	JOIN sys.filegroups AS d ON d.data_space_id = dds.data_space_id
WHERE	t.[type] = 'U' AND i.index_id IN (0, 1) AND t.name LIKE 'SalesOrderHeader_Partitioned'
GROUP	BY s.NAME, COALESCE(f.NAME, d.NAME), t.NAME, t.object_id
ORDER	BY t.name
