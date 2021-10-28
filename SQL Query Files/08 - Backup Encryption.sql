USE master
GO

-- Create a master key for your instance if you haven't already
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass@w0rd1'
GO

-- Create a certificate for backup encryption in the master database
CREATE CERTIFICATE BackupCert WITH SUBJECT = 'Backup Certificate'
GO

-- Export the Certificate for safety
USE master
GO
BACKUP CERTIFICATE BackupCert TO FILE = 'C:\temp\MyBackupCert.cert'
WITH PRIVATE KEY (
FILE = 'C:\temp\MyPriv.key',
ENCRYPTION BY PASSWORD = 'Pass@word2')

-- Create an encrypted backup of AdventureWorksDW through SSMS

-- Create an encrypted backup of AdventureWorksDW with compression
BACKUP DATABASE AdventureWorksDW
TO DISK = 'c:\temp\AWDW_Enc_Comp.bak' 
WITH INIT, COMPRESSION,
ENCRYPTION (
ALGORITHM = AES_256,
SERVER CERTIFICATE = BackupCert)
GO

-- Look at the backup file sizes

