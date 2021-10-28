
-- Script 14.21 FOR XML AUTO

USE AdventureWorks;
GO

SELECT ProductID, Name, ListPrice 
FROM Production.Product 
FOR XML AUTO;
GO

-- Script 14.22 ELEMENTS with RAW mode
SELECT ProductID, Name, ListPrice 
FROM Production.Product
FOR XML RAW, ELEMENTS;
GO

-- Script 14.23 NULL columns with ELEMENTS
SELECT ProductID, Name, Color
FROM Production.Product
FOR XML AUTO, ELEMENTS XSINIL;
GO

-- Script 14.24 Note the effect of the column alias compared to 14.23
SELECT ProductID, Name, Color
FROM Production.Product AS Product
FOR XML AUTO, ELEMENTS XSINIL;
GO

-- Script 14.25 Inline XSD schema
SELECT ProductID, Name, ListPrice
FROM Production.Product AS Product
FOR XML AUTO, XMLSCHEMA;
GO

-- Script 14.26 Nested XML with TYPE
SELECT ProductID, 
       Name, ListPrice, ProductModelID,
       (SELECT Description.ProductDescriptionID,
               Description.Description  
        FROM Production.ProductDescription AS Description
        WHERE Description.ProductDescriptionID = Product.ProductModelID
        FOR XML AUTO, ELEMENTS, TYPE) As Description
FROM Production.Product AS Product
WHERE ProductModelID IS NOT NULL 
	AND ProductModelID IN 
	(SELECT Description.ProductDescriptionID 
	FROM Production.ProductDescription AS Description);
GO

-- Script 14.27 PATH mode
SELECT ProductID AS "@ProductID",
       Name AS "*",
       Size AS "Description/@Size",
       Color AS "Description/text()"
FROM Production.Product AS Product
FOR XML PATH ;
GO

-- Script 14.28 ROOT directive
SELECT ProductID, Name, ListPrice
FROM Production.Product AS Product
FOR XML AUTO, ROOT('AvailableItems');
GO

-- Script 14.29 Named element in RAW modes
SELECT ProductID, Name, ListPrice
FROM Production.Product AS Product
FOR XML RAW('AvailableItem');
GO
