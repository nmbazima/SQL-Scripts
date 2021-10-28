--Step 1 - Use the InternetSales database
USE InternetSales
GO

--Step 2 - Add items to cart
DECLARE @now DATETIME = GETDATE();
EXEC dbo.AddItemToCart
	@SessionID = 3,
	@TimeAdded = @now,
	@CustomerKey = 2,
	@ProductKey = 3,
	@Quantity = 1;

EXEC dbo.AddItemToCart  
	@SessionID = 3,
	@TimeAdded = @now,
	@CustomerKey = 2,
	@ProductKey = 4,
	@Quantity = 1;

--Step 3 - Select items in cart	
SELECT * FROM dbo.ShoppingCart;

--Step 4 - Delete item from cart
EXEC dbo.DeleteItemFromCart 
	@SessionID = 3, 
	@ProductKey = 4;

--Step 5 - Select items in cart		
SELECT * FROM dbo.ShoppingCart;

--Step 6 - Empty cart	
EXEC dbo.EmptyCart 
	@SessionID = 3;
	
--Step 7 - Select items in cart	
SELECT * FROM dbo.ShoppingCart;