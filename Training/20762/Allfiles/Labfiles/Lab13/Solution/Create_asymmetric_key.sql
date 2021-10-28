-- Step 1 - reset database
USE master
GO

IF EXISTS ( SELECT * FROM sys.server_principals WHERE name = N'sign_assemblies' )
	DROP LOGIN sign_assemblies

IF EXISTS ( SELECT * FROM sys.asymmetric_keys WHERE name = N'assembly_key')
	DROP ASYMMETRIC KEY assembly_key

-- Step 2 - create an asymmetic key from D:\Labfiles\Lab13\Starter\strong_name.snk
CREATE ASYMMETRIC KEY assembly_key FROM FILE = 'D:\Labfiles\Lab13\Starter\strong_name.snk';

-- Step 3 - create a login from the asymmetic key
CREATE LOGIN sign_assemblies FROM ASYMMETRIC KEY assembly_key;

-- Step 4 - grant the UNSAFE ASSEMBLY permission to the new login
GRANT UNSAFE ASSEMBLY TO sign_assemblies;
