-- Module 13 Demo 2 File 1

USE master
GO

IF EXISTS ( SELECT * FROM sys.server_principals WHERE name = N'Trusted_Assembly_Login' )
	DROP LOGIN [Trusted_Assembly_Login]

IF EXISTS ( SELECT * FROM sys.asymmetric_keys WHERE name = N'ClrDemo_Key')
	DROP ASYMMETRIC KEY ClrDemo_Key

CREATE ASYMMETRIC KEY ClrDemo_Key
FROM EXECUTABLE FILE = 'D:\Demofiles\Mod13\ClrDemo\ClrDemo\bin\Debug\ClrDemo.dll';

GO

CREATE LOGIN Trusted_Assembly_Login FROM ASYMMETRIC KEY ClrDemo_Key
GO

GRANT UNSAFE ASSEMBLY TO Trusted_Assembly_Login
GO