USE TempDB
GO


INSERT INTO Sales.Customers
(
companyname,
contactname,
contacttitle,
address,
city,
region,
postalcode,
country,
phone,
fax
)

OUTPUT INSERTED.*

SELECT companyname,
	contactname,
	contacttitle,
	address,
	city,
	region,
	postalcode,
	country,
	phone,
	fax
 FROM dbo.PotentialCustomers;