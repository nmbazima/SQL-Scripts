-- Needs Internet access

USE master
GO
-- Create a master key for your instance if you haven't already
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pass@w0rd1'
GO
-- Create a certificate for backup encryption in the master database
CREATE CERTIFICATE BackupCert WITH SUBJECT = 'Backup Certificate'
GO

-- Login to the Portal at http://azure.microsoft.com
-- Go to Storage and create an account called mvademo in East Asia (Hong Kong)
-- Talk about Geo-Redundant feature while the space gets allocated (SouthEastAsia Singapore)
-- Click on Manage Access Keys and copy the primary access key into the 
--  credential script below
-- Click on the storage account, go to containers and create a new container
--  called mvademosql marked as private

-- Create a credential
CREATE CREDENTIAL AzureBackups
WITH IDENTITY = 'mvademo',
SECRET = '7z/MXP+zD1FoqFZJQ8XeMu+j2pCDBWOXDvVonHeOl9q67owUB0I+1huvgOb2whYhvQ9XSRHIAmizA8gnqwnqHg=='

-- Backup to URL
BACKUP DATABASE AdventureWorksDW
TO URL = 'https://mvademo.blob.core.windows.net/mvademosql/AdventureWorksDW.bak' 
WITH 
CREDENTIAL = 'AzureBackups',
COMPRESSION,
ENCRYPTION (
ALGORITHM = AES_256,
SERVER CERTIFICATE = BackupCert)
GO