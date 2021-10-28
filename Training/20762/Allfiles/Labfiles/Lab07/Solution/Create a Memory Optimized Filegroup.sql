/************************************************************************
 * Step 1																*
 *																		*
 * Create a memory optimized filegroup									*
 *																		*
 ************************************************************************/

ALTER DATABASE AdventureWorksDW
ADD FILEGROUP  AdventureWorksDW_Memory_Optimized_Data CONTAINS MEMORY_OPTIMIZED_DATA
GO

ALTER DATABASE AdventureWorksDW ADD 
FILE (name='AdventureworksDW_MOD', filename='D:\LabFiles\Lab04\Starter\SetupFiles\AdventureworksDW_MOD') 
TO FILEGROUP AdventureWorksDW_Memory_Optimized_Data
GO