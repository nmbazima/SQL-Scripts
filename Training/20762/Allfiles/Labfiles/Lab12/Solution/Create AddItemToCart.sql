USE InternetSales
GO
CREATE PROCEDURE dbo.AddItemToCart
	@SessionID INT, 
@TimeAdded DATETIME, 
@CustomerKey INT, 
@ProductKey INT, 
@Quantity INT
	WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN 
	ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT, LANGUAGE = 'us_english')  
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
	@SessionID, 
	@TimeAdded, 
	@CustomerKey, 
	@ProductKey, 
	@Quantity
	)
END
GO