USE InternetSales
GO
INSERT INTO dbo.ShoppingCart 
	(
	SessionID, 
	TimeAdded, 
	CustomerKey, 
	ProductKey, 
	Quantity
	)
VALUES 
	(
	1, 
	GETDATE(), 
	2, 
	3, 
	1
	);
	
INSERT INTO dbo.ShoppingCart 
	(
	SessionID, 
	TimeAdded, 
	CustomerKey, 
	ProductKey, 
	Quantity
	)
VALUES 
	(
	1, 
	GETDATE(), 
	2, 
	4, 
	1
	);
	
SELECT * FROM dbo.ShoppingCart;