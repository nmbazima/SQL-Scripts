-- Demonstration 1A

-- Step 1 - Switch to the tempdb database

USE tempdb;
GO

-- Step 2 - Query the sys.spatial_reference_systems system view

SELECT * FROM sys.spatial_reference_systems;
GO

-- Step 3 - Drill into the value for srid 4326

SELECT * FROM sys.spatial_reference_systems
WHERE spatial_reference_id = 4326;
GO

-- Step 4 - Query the available measurement systems

SELECT DISTINCT unit_of_measure, unit_conversion_factor 
FROM sys.spatial_reference_systems;
GO



