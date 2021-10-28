USE AdventureWorks
GO

EXEC [dbo].[uspGetEmployeeManagers] 
   @BusinessEntityID = 10
GO

EXEC [dbo].[uspGetBillOfMaterials] 
   @StartProductID = 1
  ,@CheckDate = NULL
GO

EXEC [dbo].[uspGetManagerEmployees] 
   @BusinessEntityID = 10
GO
