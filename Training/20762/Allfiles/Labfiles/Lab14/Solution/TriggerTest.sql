UPDATE Production.Product
SET ListPrice=3978.00
WHERE ProductID BETWEEN 749 and 753;
GO
SELECT * FROM Production.ProductAudit
GO