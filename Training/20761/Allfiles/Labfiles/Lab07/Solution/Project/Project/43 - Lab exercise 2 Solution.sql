USE TempDB
GO

-- Note, if no update is made then swap the titles around ;-)

UPDATE Sales.Customers
SET contacttitle='Sales Consultant'

OUTPUT	INSERTED.ContactName	AS	'New Name'
,		DELETED.contactname		AS	'Old Name'
,		INSERTED.Contacttitle	AS	'New Title'
,		DELETED.Contacttitle	AS	'Old Title'
,		INSERTED.city			AS	'New City'
,		DELETED.city			AS	'Old City'


WHERE city='Berlin'
AND contacttitle='Sales Representative';
select * from sales.customers where city = 'berlin'

