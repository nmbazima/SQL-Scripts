-- Demonstration 3B - Replacing Triggers with Computed Columns

-- Step A: Open a new query window 
--         and use the tempdb database

USE tempdb;
GO

-- Step B: Create the dbo.SellingPrice table

CREATE TABLE dbo.SellingPrice
(
	SellingPriceID int IDENTITY(1,1) 
	  CONSTRAINT PK_SellingPrice PRIMARY KEY,
	SubTotal decimal(18,2) NOT NULL,
	TaxAmount decimal(18,2) NOT NULL,
	FreightAmount decimal(18,2) NOT NULL,
	ExtendedAmount decimal(18,2) NULL
);
GO

-- Step C: Create a trigger to maintain the ExtendedAmount column

CREATE TRIGGER TR_SellingPrice_InsertUpdate
ON dbo.SellingPrice
AFTER INSERT, UPDATE AS BEGIN
  SET NOCOUNT ON;
  UPDATE sp
  SET sp.ExtendedAmount = sp.SubTotal 
                        + sp.TaxAmount 
                        + sp.FreightAmount
  FROM dbo.SellingPrice AS sp
  INNER JOIN inserted AS i
  ON sp.SellingPriceID = i.SellingPriceId;
END;
GO

-- Step D: Test the trigger by inserting some rows
--         and selecting the values inserted

INSERT INTO dbo.SellingPrice
  (SubTotal, TaxAmount, FreightAmount)
  VALUES (12.3, 1.23, 10), (5, 1, 2);
GO

SELECT * FROM dbo.SellingPrice;
GO
 
-- Step E: Drop the table and recreate it with a computed column

DROP TABLE dbo.SellingPrice;
GO

CREATE TABLE dbo.SellingPrice
(
	SellingPriceID int IDENTITY(1,1) 
	  CONSTRAINT PK_SellingPrice PRIMARY KEY,
	SubTotal decimal(18,2) NOT NULL,
	TaxAmount decimal(18,2) NOT NULL,
	FreightAmount decimal(18,2) NOT NULL,
	ExtendedAmount AS (SubTotal + TaxAmount + FreightAmount) PERSISTED
);
GO

-- Step F: Reinsert the data to ensure the behavior is maintained
--         Note that it would now be more efficient

INSERT INTO dbo.SellingPrice
  (SubTotal, TaxAmount, FreightAmount)
  VALUES (12.3, 1.23, 10), (5, 1, 2);
GO

SELECT * FROM dbo.SellingPrice;
GO

-- Step G: Drop the table

DROP TABLE dbo.SellingPrice;
GO

