USE TempDB
GO

/***************************************************************
Task 1

Write an INSERT statement to add a record to the Employees table 
with the following values:
•Title: Sales Representative
•Titleofcourtesy: Mr
•FirstName: Laurence
•Lastname: Grider
•Hiredate: 04/04/2016
•Birthdate: 10/25/1975
•Address: 1234 1st Ave. S.E.
•City: Seattle
•Country: USA
•Phone: (206)555-0105
*****************************************************************/

INSERT INTO HR.Employees
(
Title,
titleofcourtesy,
FirstName,
Lastname,
hiredate,
birthdate,
address,
city,
country,
phone
)

OUTPUT INSERTED.* 

VALUES
(
'Sales Representative',
'Mr',
'Laurence',
'Grider',
'04/04/2016',
'10/25/1975',
'1234 1st Ave. S.E.',
'Seattle',
'USA',
'(206)555-0105');

