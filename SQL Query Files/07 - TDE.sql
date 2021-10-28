USE master
GO

-- Take a compressed backup of the database before we start
BACKUP DATABASE AdventureWorksDW
TO DISK = 'c:\temp\AWDW_Comp.bak' WITH INIT, COMPRESSION
GO

-- Create a master key for your instance if you haven't already
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass@word1'
GO

-- Create a certificate for backup encryption in the master database
DROP CERTIFICATE tdeCert
GO
CREATE CERTIFICATE tdeCert WITH SUBJECT = 'TDE Certificate'
GO

-- Create an encryption key in the AdventureWorksDW database using the certificate
USE AdventureWorksDW
GO
DROP DATABASE ENCRYPTION KEY
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDECert
GO

-- View the encryption state
SELECT db_name(database_id) AS 'DB Name', encryption_state
FROM sys.dm_database_encryption_keys

-- 1 = Unencrypted
-- 2 = Encryption in progress
-- 3 = Encrypted
-- 4 = Decryption in progress

-- Enable TDE on the database
ALTER DATABASE AdventureWorksDW SET ENCRYPTION ON

-- View the encryption state. Talk about tempdb
SELECT db_name(database_id) AS 'DB Name', encryption_state
FROM sys.dm_database_encryption_keys

-- Back up the database without compression
BACKUP DATABASE AdventureWorksDW 
TO  DISK = 'c:\temp\AWDW_TDE.bak' WITH INIT
GO
-- Back up the database with compression
BACKUP DATABASE AdventureWorksDW
TO DISK = 'c:\temp\AWDW_TDE_Comp.bak' WITH INIT, COMPRESSION
GO

-- Look at backup sizes in c:\temp

-- Turn encryption off
ALTER DATABASE AdventureWorksDW SET ENCRYPTION OFF
GO
USE AdventureWorksDW
GO
DROP DATABASE ENCRYPTION KEY
GO

