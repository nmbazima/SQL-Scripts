-- MyAudit c:\temp
--	DATABASE_ROLE_MEMBER_CHANGE_GROUP

CREATE LOGIN Hacker 
WITH PASSWORD = 'YouDontKnow1mHere' 
GO
USE people
GO
CREATE USER Hacker FOR LOGIN Hacker
GO
EXEC sp_addrolemember 'db_datareader', 'Hacker'
GO



SELECT event_time,action_id,succeeded,session_id,
session_server_principal_name,server_instance_name,
database_name,[schema_name],[object_name],[statement] 
FROM sys.fn_get_audit_file ('C:\temp\MyAudit*.sqlaudit',default,default);
GO
