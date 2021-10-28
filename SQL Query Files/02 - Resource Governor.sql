-- Make sure that your instance is set to Mixed Authentication
-- Restrict your instance to 1 CPU and memory to 512MB:

sp_configure 'show advanced', 1
GO
RECONFIGURE
GO
-- use only 1 CPU on demo machine
sp_configure 'affinity mask', 1
GO
-- 512MB is enough for the demo
sp_configure 'min server', 512
GO
sp_configure 'max server', 512
GO
RECONFIGURE
GO

-- Run the following code to create two Resource Pools; one for your main production workload and one for everything else:

CREATE RESOURCE POOL PoolProduction
CREATE RESOURCE POOL PoolAdhoc

-- Now create three workload groups assigning each to one of the above resource pools:

CREATE WORKLOAD GROUP GroupProduction
USING PoolProduction

CREATE WORKLOAD GROUP GroupReporting
USING PoolAdhoc

CREATE WORKLOAD GROUP GroupIT
USING PoolAdhoc
GO

-- Run the script below to create our 3 logins first of all:
CREATE LOGIN UserProductionApp 
WITH PASSWORD = 'Pass@word1', CHECK_POLICY = OFF
CREATE LOGIN UserReporting
WITH PASSWORD = 'Pass@word2', CHECK_POLICY = OFF
CREATE LOGIN UserIT
WITH PASSWORD = 'Pass@word3', CHECK_POLICY = OFF
GO

-- Now create the classifier function as below:

USE master
GO
IF OBJECT_ID('DBO.CLASSIFIER_V1','FN') IS NOT NULL
       DROP FUNCTION DBO.CLASSIFIER_V1
GO
CREATE FUNCTION CLASSIFIER_V1 ()
RETURNS SYSNAME WITH SCHEMABINDING
BEGIN
       DECLARE @val varchar(32)
       SET @val = 'default';
       if  'UserProductionApp' = SUSER_SNAME() 
              SET @val = 'GroupProduction';
       else if 'UserReporting' = SUSER_SNAME()
              SET @val = 'GroupReporting';
       else if 'UserIT' = SUSER_SNAME()
              SET @val = 'GroupIT';
       return @val;
END
GO

-- attach it to the resource governor:

ALTER RESOURCE GOVERNOR 
WITH (CLASSIFIER_FUNCTION = dbo.CLASSIFIER_V1)
GO

-- and make the changes effective:

ALTER RESOURCE GOVERNOR RECONFIGURE
GO

-- Load perfmon and run CPUKiller

-- Modify PoolAdhoc to consume only 50% CPU
ALTER RESOURCE POOL PoolAdhoc WITH (MAX_CPU_PERCENT = 50)
GO
ALTER RESOURCE GOVERNOR RECONFIGURE
GO

-- Modify the reporting group to have a higher importance
ALTER WORKLOAD GROUP GroupReporting WITH (IMPORTANCE = High)
GO
ALTER RESOURCE GOVERNOR RECONFIGURE
GO






