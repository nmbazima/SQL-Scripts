USE TempDB
GO

DELETE FROM dbo.PotentialCustomers

OUTPUT DELETED.*

WHERE contactname IN(
'Taylor, Maurice',
'Mallit, Ken',
'Tiano, Mike');


