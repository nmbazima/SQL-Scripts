@Echo Off
ECHO Preparing the lab environment...

REM - Get current directory
SET SUBDIR=%~dp0

REM - Restart SQL Server Service to force closure of any open connections
NET STOP MSSQLLaunchpad
NET STOP SQLSERVERAGENT
NET STOP MSSQLSERVER
NET START MSSQLSERVER
NET START SQLSERVERAGENT
NET START MSSQLLaunchpad



REM - Run SQL Script to prepare the database environment
ECHO Preparing Databases...
SQLCMD -E -i %SUBDIR%Setup\Setup.sql > NUL

IF EXIST %SUBDIR%ClrDemo (RMDIR %SUBDIR%ClrDemo /S /Q)








