@Echo Off
ECHO Preparing the lab environment...

REM - Get current directory
SET SUBDIR=%~dp0

REM - Restart SQL Server Service
NET STOP SQLSERVERAGENT
NET STOP MSSQLLaunchpad
NET STOP MSSQLSERVER
NET START MSSQLSERVER
NET START MSSQLLaunchpad
NET START SQLSERVERAGENT


REM - Run SQL Script to prepare the database environment
ECHO Configuring databases...
SQLCMD -E -i %SUBDIR%SetupFiles\Setup.sql
