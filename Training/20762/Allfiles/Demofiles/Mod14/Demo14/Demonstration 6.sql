-- Demonstration 6

-- Step 1 - Open a new query window to the AdventureWorks database

USE AdventureWorks;
GO

-- Step 2 - Execute the following query to show the students the 
--          contents of the dbo.DatabaseLog table

SELECT * FROM dbo.DatabaseLog;
GO

-- Step 3 - Click on the XmlEvent column to show the XML document 
--          contained and describe the format of the XML. Mention 
--          that this is the EVENTDATA structure that is returned by 
--          DDL and LOGON triggers. (It is also the same structure that 
--          is passed in Event Notifications -> an advanced topic not 
--          discussed in this course). Leave the XML window open for 
--          reference in the next step.

-- Step 4 - Execute the command that was shown in the previous topic 
--          to show how it is processed. Map the resulting columns 
--          to the source XML. (You may have to provide a brief overview 
--          of CROSS APPLY if the students are not sufficiently familiar with the operator)

SELECT EventDetail.value('PostTime[1]','datetime2') AS PostTime,
       EventDetail.value('SPID[1]', 'int') AS SPID,
       EventDetail.value('ObjectType[1]','sysname') AS ObjectType,
       EventDetail.value('ObjectName[1]','sysname') AS ObjectName
FROM dbo.DatabaseLog AS dl
CROSS APPLY dl.XmlEvent.nodes('/EVENT_INSTANCE') AS EventInfo(EventDetail)
ORDER BY PostTime;

-- Step 5 - Modify the command to show that you can also include 
--          columns from the left-hand table

SELECT dl.DatabaseLogID,
       EventDetail.value('PostTime[1]','datetime2') AS PostTime,
       EventDetail.value('SPID[1]', 'int') AS SPID,
       EventDetail.value('ObjectType[1]','sysname') AS ObjectType,
       EventDetail.value('ObjectName[1]','sysname') AS ObjectName,
       dl.TSQL 
FROM dbo.DatabaseLog AS dl
CROSS APPLY dl.XmlEvent.nodes('/EVENT_INSTANCE') AS EventInfo(EventDetail)
ORDER BY PostTime;

-- Step 6 - The below replicates the same results as above, using OPENXML instead
-- one of the downsides is that it's not easy to run OPENXML against multiple XML documents.

DECLARE @xmldoc AS int, @xml AS xml;
SELECT @xml=XmlEvent FROM dbo.DatabaseLog;
SELECT @xml;
EXEC sp_xml_preparedocument @xmldoc OUTPUT, @xml; 
 
SELECT * FROM OPENXML(@xmldoc, '/EVENT_INSTANCE', 2)
WITH (
  [PostTime] datetime2
, [SPID] int 
, [ObjectType] sysname
, [ObjectName] sysname
); 
 
EXEC sp_xml_removedocument @xmldoc;

