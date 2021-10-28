--Module 15 - Setup
USE master;
GO

DROP database if exists Adventureworks;
GO

RESTORE DATABASE [AdventureWorks] FROM  DISK = N'D:\SetupFiles\AdventureWorks_15.bak' WITH  REPLACE,
MOVE N'AdventureWorks_Data' TO N'$(SUBDIR)SetupFiles\AdventureWorks_Data.mdf', 
MOVE N'AdventureWorks_Log' TO N'$(SUBDIR)SetupFiles\AdventureWorks_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::AdventureWorks TO [ADVENTUREWORKS\Student];
GO

IF EXISTS(SELECT * FROM sys.sysdatabases WHERE name = 'MarketDev')
BEGIN
	DROP DATABASE MarketDev
END
GO

RESTORE DATABASE [MarketDev] FROM  DISK = N'D:\SetupFiles\MarketDev_15.bak' WITH  REPLACE,
MOVE N'MarketDev' TO N'$(SUBDIR)SetupFiles\MarketDev.mdf', 
MOVE N'MarketDev_Log' TO N'$(SUBDIR)SetupFiles\MarketDev_log.ldf'
GO
ALTER AUTHORIZATION ON DATABASE::MarketDev TO [ADVENTUREWORKS\Student];
GO


USE MarketDev;
GO

CREATE SCHEMA DirectMarketing AUTHORIZATION dbo;
GO

CREATE TABLE DirectMarketing.Competitor
( CompetitorID INT NOT NULL PRIMARY KEY,
  CompetitorName NVARCHAR(30) NOT NULL,
  StreetAddress NVARCHAR(MAX) NOT NULL,
  DateEntered DATE NOT NULL,
  StrengthOfCompetition NVARCHAR(8) NOT NULL,
  Comments NVARCHAR(MAX) NULL
);
GO

CREATE TABLE DirectMarketing.City
( CityID INT NOT NULL PRIMARY KEY,
  CityName NVARCHAR(25) NOT NULL
);
GO

CREATE TABLE DirectMarketing.TVStation
( TVStationID INT NOT NULL PRIMARY KEY,
  TVStationName NVARCHAR(15) NOT NULL,
  CityID INT NOT NULL,
  CostPerAdvertisement DECIMAL(12,2) NOT NULL
);
GO

CREATE TABLE DirectMarketing.TVAdvertisement
( TVAdvertisementID INT NOT NULL PRIMARY KEY,
  TVStationID INT NOT NULL,
  ScreeningTime DATETIME NOT NULL
);
GO

CREATE TABLE DirectMarketing.CampaignResponse
( CampaignResponseID INT NOT NULL PRIMARY KEY,
  ResponseReceived DATETIME NOT NULL,
  ProspectID INT NOT NULL,
  ResponseMethodCode CHAR(1) NOT NULL,
  ChargeFromReferrer DECIMAL(12,2) NOT NULL,
  RevenueReceived DECIMAL(12,2) NOT NULL
);
GO     

CREATE SCHEMA WebStock AUTHORIZATION dbo;
GO

CREATE VIEW WebStock.OnlineProducts
AS
SELECT p.ProductID, 
       p.ProductName, 
       p.ProductNumber, 
       COALESCE(p.Color,'N/A') AS Color, 
       CASE p.DaysToManufacture
         WHEN 0 THEN 'Instock'
         WHEN 1 THEN 'Overnight'
         WHEN 2 THEN 'Fast'
         ELSE 'Call'
       END AS Availability,
       p.Size, 
       p.SizeUnitMeasureCode AS UnitOfMeasure,
       p.ListPrice AS Price, 
       p.Weight
FROM Marketing.Product AS p
WHERE p.SellEndDate IS NULL
AND p.SellStartDate IS NOT NULL;
GO

CREATE VIEW WebStock.AvailableModels
AS
SELECT p.ProductID,
       p.ProductName,
       pm.ProductModelID,
       pm.ProductModel,
       COALESCE(ed.Description,id.Description) AS CatalogDescription
FROM Marketing.Product AS p
INNER JOIN Marketing.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID 
LEFT OUTER JOIN Marketing.ProductDescription AS ed
ON pm.ProductModelID = ed.ProductModelID 
AND ed.LanguageID = 'en'
LEFT OUTER JOIN Marketing.ProductDescription as id
ON pm.ProductModelID = id.ProductModelID 
AND id.LanguageID = ''
WHERE p.SellEndDate IS NULL
AND p.SellStartDate IS NOT NULL;
GO

CREATE SCHEMA Relationship AUTHORIZATION dbo;
GO

CREATE VIEW Relationship.Contacts
AS
SELECT p.ProspectID AS ContactID,
       p.FirstName,
       p.MiddleName,
       p.LastName,
       'PROSPECT' AS ContactRole
FROM Marketing.Prospect AS p
UNION ALL 
SELECT sp.SalespersonID,
       sp.FirstName,
       sp.MiddleName,
       sp.LastName,
       'SALESPERSON'
FROM Marketing.Salesperson AS sp;
GO

CREATE PROCEDURE Reports.GetProductColors
WITH EXECUTE AS OWNER
AS
SELECT DISTINCT p.Color
FROM Marketing.Product AS p
WHERE p.Color IS NOT NULL
ORDER BY p.Color;
GO

CREATE PROCEDURE Reports.GetProductsAndModels
WITH EXECUTE AS OWNER
AS
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
GO

CREATE PROCEDURE Reports.GetProductsByColor
@Color nvarchar(16)
WITH EXECUTE AS OWNER
AS
SELECT p.ProductID, 
       p.ProductName, 
       p.ListPrice AS Price, 
       p.Color, 
       p.Size,
       p.SizeUnitMeasureCode AS UnitOfMeasure
FROM Marketing.Product AS p
WHERE (p.Color = @Color) OR (p.Color IS NULL AND @Color IS NULL)
ORDER BY ProductName;
GO

USE MarketDev;
GO

CREATE TYPE StringList AS TABLE(StringValue nvarchar(1000) NOT NULL);
GO

CREATE PROCEDURE Reports.GetProductsByColorList_Test
(@ColorList StringList READONLY)
AS
SELECT p.ProductID, 
       p.ProductName, 
       p.ListPrice AS Price, 
       p.Color, 
       p.Size,
       p.SizeUnitMeasureCode AS UnitOfMeasure
FROM Marketing.Product AS p
INNER JOIN @ColorList AS cl
ON p.Color = cl.StringValue  
ORDER BY p.ProductName;
GO

CREATE TYPE dbo.SalespersonList 
AS TABLE (SalespersonID int NOT NULL,
          FirstName nvarchar(50) NULL,
          MiddleName nvarchar(50) NULL,
          LastName nvarchar(50) NULL,
          BadgeNumber nvarchar(15) NULL,
          EmailAlias nvarchar(256) NULL,
          SalesTerritoryID int NULL);
GO
                                    
CREATE PROCEDURE Marketing.SalespersonMerge
(@SalespersonDetails SalespersonList READONLY)
AS BEGIN
  MERGE INTO Marketing.Salesperson AS sp
  USING @SalespersonDetails AS spd
  ON sp.SalespersonID = spd.SalespersonID 
  WHEN MATCHED THEN
    UPDATE SET 
      sp.FirstName = COALESCE(spd.FirstName, sp.FirstName),
      sp.MiddleName = COALESCE(spd.MiddleName, sp.MiddleName),
      sp.LastName = COALESCE(spd.LastName, sp.LastName),
      sp.BadgeNumber = COALESCE(spd.BadgeNumber, sp.BadgeNumber),
      sp.EmailAlias = COALESCE(spd.EmailAlias, sp.EmailAlias),
      sp.SalesTerritoryID = COALESCE(spd.SalesTerritoryID, sp.SalesTerritoryID)
  WHEN NOT MATCHED THEN
    INSERT (SalespersonID, 
            FirstName,
            MiddleName,
            LastName,
            BadgeNumber,
            EmailAlias,
            SalesTerritoryID)
    VALUES (spd.SalespersonID, 
            spd.FirstName,
            spd.MiddleName,
            spd.LastName,
            spd.BadgeNumber,
            spd.EmailAlias,
            spd.SalesTerritoryID)
  OUTPUT $action AS Action, inserted.SalespersonID;
END;
GO

CREATE PROCEDURE Marketing.MoveCampaignBalance_Test
( @FromCampaignID int,
  @ToCampaignID int,
  @BalanceToMove decimal(18,2)
)
AS BEGIN
  DECLARE @RetriesRemaining int = 5;
  
  SET XACT_ABORT ON;
  
  WHILE (@RetriesRemaining > 0) BEGIN
    BEGIN TRY
      BEGIN TRANSACTION 
        UPDATE Marketing.CampaignBalance 
          SET RemainingBalance -= @BalanceToMove
          WHERE CampaignID = @FromCampaignID;
        UPDATE Marketing.CampaignBalance
          SET RemainingBalance += @BalanceToMove
          WHERE CampaignID = @ToCampaignID;
      COMMIT TRANSACTION;
      SET @RetriesRemaining = 0;
    END TRY
    BEGIN CATCH
      IF (ERROR_NUMBER() = 1205) BEGIN
        SET @RetriesRemaining -=1;
        PRINT 'Warning: deadlock retry';
        WAITFOR DELAY '00:00:05';
      END ELSE BEGIN
        SET @RetriesRemaining = 0; -- exit the retry loop
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        PRINT 'Unable to move balance';
        RETURN 1;
      END;
    END CATCH;
  END;
END;
GO

CREATE FUNCTION dbo.FormatPhoneNumber
( @PhoneNumberToFormat nvarchar(16)
)
RETURNS nvarchar(16)
AS BEGIN
  DECLARE @Digits nvarchar(16) = '';
  DECLARE @Remaining nvarchar(16) = @PhoneNumberToFormat;
  DECLARE @Character nchar(1);
  
  IF LEFT(@Remaining,1) = N'+' RETURN @Remaining;
  
  WHILE (LEN(@Remaining) > 0) BEGIN
    SET @Character = LEFT(@Remaining,1);
    SET @Remaining = SUBSTRING(@Remaining,2,LEN(@Remaining));
    IF (@Character >= N'0') AND (@Character <= N'9') 
      SET @Digits += @Character;  
  END;

  RETURN CASE LEN(@Digits)
           WHEN 10 THEN N'(' + SUBSTRING(@Digits,1,3) + N') '
                        + SUBSTRING(@Digits,4,3) + N'-'
                        + SUBSTRING(@Digits,7,4)
           WHEN 8 THEN SUBSTRING(@Digits,1,4) + N'-' 
                       + SUBSTRING(@Digits,5,4)
           WHEN 6 THEN SUBSTRING(@Digits,1,3) + N'-' 
                       + SUBSTRING(@Digits,4,3)
           ELSE @Digits
         END;
END;
GO

CREATE FUNCTION dbo.IntegerListToTable
( @InputList nvarchar(MAX),
  @Delimiter nchar(1) = N',')
RETURNS @OutputTable TABLE (PositionInList int IDENTITY(1, 1) NOT NULL,
                            IntegerValue int)
AS BEGIN
   DECLARE @RemainingString nvarchar(MAX) = @InputList;
   DECLARE @DelimiterPosition int;
   DECLARE @CurrentToken nvarchar(8);
   
   WHILE LEN(@RemainingString) > 0 
   BEGIN
     SET @DelimiterPosition = CHARINDEX(@Delimiter, @RemainingString);
     IF (@DelimiterPosition = 0) SET @DelimiterPosition = LEN(@RemainingString) + 1;
     IF (@DelimiterPosition > 8) SET @DelimiterPosition = 8;
     SET @CurrentToken = SUBSTRING(@RemainingString,1,@DelimiterPosition - 1);
     
     INSERT INTO @OutputTable (IntegerValue)
       VALUES(CAST(@CurrentToken AS int));
       
     SET @RemainingString = SUBSTRING(@RemainingString,@DelimiterPosition + 1,LEN(@RemainingString));
  END;
  RETURN;
END;
GO

ALTER TABLE Marketing.Yield
  ALTER COLUMN ProspectID int NOT NULL;
GO

ALTER TABLE Marketing.Yield
  ALTER COLUMN LanguageID nchar(6) NOT NULL;
GO

ALTER TABLE Marketing.Yield
  ALTER COLUMN YieldOutcome int NOT NULL;
GO

ALTER TABLE Marketing.Yield
  ALTER COLUMN RowID uniqueidentifier NOT NULL;
GO

ALTER TABLE Marketing.Yield
  ALTER COLUMN LastUpdate datetime2 NOT NULL;
GO

ALTER TABLE Marketing.Yield
  ADD CONSTRAINT PK_Yield PRIMARY KEY CLUSTERED (ProspectID, LanguageID);
GO

ALTER TABLE Marketing.Yield
  ADD CONSTRAINT FK_Yield_Prospect
  FOREIGN KEY (ProspectID) REFERENCES Marketing.Prospect(ProspectID);
GO

ALTER TABLE Marketing.Yield
  ADD CONSTRAINT FK_Yield_Language
  FOREIGN KEY (LanguageID) REFERENCES Marketing.Language(LanguageID);
GO

ALTER TABLE Marketing.Yield
  ADD CONSTRAINT DF_Yield_YieldOutcome
  DEFAULT (0) FOR YieldOutcome;
GO

ALTER TABLE Marketing.Yield
  ADD CONSTRAINT DF_Yield_RowID
  DEFAULT (NEWID()) FOR RowID;
GO

ALTER TABLE Marketing.Yield
  ADD CONSTRAINT DF_Yield_LastUpdate
  DEFAULT (SYSDATETIME()) FOR LastUpdate;
GO

CREATE PROCEDURE WebStock.GetAvailableModelsAsXML
AS BEGIN
  SELECT p.ProductID,
         p.ProductName,
         p.ListPrice,
         p.Color,
         p.SellStartDate, 
         pm.ProductModelID,
         pm.ProductModel
  FROM Marketing.Product AS p
  INNER JOIN Marketing.ProductModel AS pm
  ON p.ProductModelID = pm.ProductModelID 
  WHERE p.SellStartDate IS NOT NULL
  AND p.SellEndDate IS NULL
  ORDER BY p.SellStartDate, p.ProductName 
  FOR XML RAW('AvailableModel'), ROOT('AvailableModels');
END;
GO

CREATE PROCEDURE Marketing.UpdateSalesTerritoriesByXML
( @SalespersonMods xml
)
AS BEGIN
  DECLARE @Handle int;
  EXEC master.dbo.sp_xml_preparedocument @Handle OUTPUT, @SalespersonMods;
  
  UPDATE sp
  SET sp.SalesTerritoryID = spm.SalesTerritoryID
  FROM Marketing.Salesperson AS sp
  INNER JOIN OPENXML(@Handle,'SalespersonMods/SalespersonMod/Mods/Mod',1)
             WITH (SalesTerritoryID int '@SalesTerritoryID',
                   SalespersonID int '../../@SalespersonID') AS spm
  ON sp.SalespersonID = spm.SalespersonID;

  EXEC master.dbo.sp_xml_removedocument @Handle;
END;
GO

-- USE master

USE master;
GO




