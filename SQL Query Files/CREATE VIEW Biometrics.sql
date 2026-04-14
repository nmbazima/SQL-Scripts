CREATE VIEW [dbo].[EdadminImport] AS
SELECT 
    EmployeeID AS PersonID,
    authDateTime AS AttStamp,
    CASE 
        WHEN Direction = 'IN' THEN 'ON'
        WHEN Direction = 'OUT' THEN 'OFF'
        ELSE Direction
    END AS AttDirectionBio,
    deviceName AS DeviceName,
    deviceSN AS DeviceID,
    NULL AS CreatedOn,
    NULL AS CreatedBy,
    NULL AS UpdatedOn,
    NULL AS UpdatedBy
FROM 
    thirdparty.dbo.attlog
WHERE 
    ISNUMERIC(EmployeeID) = 1;
GO