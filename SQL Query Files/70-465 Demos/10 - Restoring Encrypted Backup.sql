-- You need to have run Demo 8 before this
-- Remove the Backup Cert to simulate a new server
USE master
GO
DROP CERTIFICATE BackupCert
GO

-- Restore the database from backup (it will fail)
RESTORE DATABASE AdventureWorksDW 
FROM DISK = 'c:\temp\AWDW_Enc_Comp.bak' 

-- Restore the certificate from the earlier backup 
USE master
GO
CREATE CERTIFICATE BackupCert 
FROM FILE = 'C:\temp\MyBackupCert.cert'
WITH PRIVATE KEY (FILE = 'C:\temp\MyPriv.key',
DECRYPTION BY PASSWORD = 'Pass@word2')
GO

-- Restore the database successfully
RESTORE DATABASE AdventureWorksDW 
FROM DISK = 'c:\temp\AWDW_Enc_Comp.bak' 
