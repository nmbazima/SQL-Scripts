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

DEL %SUBDIR%TSQL_or_managed_code.docx
COPY %SUBDIR%\Setup\TSQL_or_managed_code.docx %SUBDIR%TSQL_or_managed_code.docx

IF EXIST %SUBDIR%ClrPractice (RMDIR %SUBDIR%ClrPractice /S /Q)
XCOPY %SUBDIR%Setup\ClrPractice %SUBDIR%ClrPractice /S /E /Q /I /Y

DEL %SUBDIR%Create_asymmetric_key.sql
COPY %SUBDIR%\Setup\Create_asymmetric_key.sql %SUBDIR%Create_asymmetric_key.sql





