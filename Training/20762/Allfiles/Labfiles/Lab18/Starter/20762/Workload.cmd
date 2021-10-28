@Echo Off
ECHO Preparing the demo environment...

REM - Get current directory
SET SUBDIR=%~dp0
SQLCMD -E -i %SUBDIR%Workload.sql 
exit