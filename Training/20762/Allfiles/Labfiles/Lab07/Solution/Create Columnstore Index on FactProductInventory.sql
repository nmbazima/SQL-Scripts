/************************************************************************
 * Step 1																*
 *																		*
 * Create an additional non-clustered columnstore index on the table.	*
 *																		*
 ************************************************************************/

SET STATISTICS TIME OFF
GO

/****** Add a non-clustered index ******/
CREATE NONCLUSTERED COLUMNSTORE INDEX NCI_FactProductInventory_UnitCost_UnitsOut ON FactProductInventory
(
	ProductKey,
	DateKey,
	UnitCost,
	UnitsOut
)
GO

