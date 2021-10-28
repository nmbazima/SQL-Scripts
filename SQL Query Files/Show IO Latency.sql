/*******************************************************************************

  Script:   Show IO Latency.sql
  Author:   Chris Wye
  Date:     06/01/2014

  Description:
  ------------
  Runs a query to show the IO latency from the dm stats for all DBs on a server

  For further info see:- 
  http://www.sqlskills.com/blogs/paul/how-to-examine-io-subsystem-latencies-from-within-sql-server/

  Details from sys.dm_io_virtual_file_stats are as follows :- 
  
  Column name       Data type   Description
  ----------------- ----------- ------------------------------------------------
  database_id       smallint    ID of database.
  file_id           smallint    ID of file.
  sample_ms         int         Number of milliseconds since the computer was started. 
                                This column can be used to compare different outputs 
                                from this function.
  num_of_reads      bigint      Number of reads issued on the file.
  num_of_bytes_read bigint      Total number of bytes read on this file.
  io_stall_read_ms  bigint      Total time, in milliseconds, that the users waited 
                                for reads issued on the file.
  num_of_writes     bigint      Number of writes made on this file.
  num_of_bytes_written  bigint  Total number of bytes written to the file.
  io_stall_write_ms bigint      Total time, in milliseconds, that users waited 
                                for writes to be completed on the file.
  io_stall          bigint      Total time, in milliseconds, that users waited 
                                for I/O to be completed on the file.
  size_on_disk_bytes  bigint    Number of bytes used on the disk for this file. 
                                For sparse files, this number is the actual number 
                                of bytes on the disk that are used for database snapshots.
  file_handle       varbinary   Windows file handle for this file.

  Interpreting the results
  ------------------------
  


  Amendments:
  -----------

*******************************************************************************/

USE master;
GO

SELECT
    --virtual file latency
    [ReadLatency] =
        CASE WHEN io_stall_read_ms = 0
            THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
    --[ReadLatency_old] =
    --    CASE WHEN [num_of_reads] = 0
    --        THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
    WriteLatency = 
        CASE WHEN io_stall_write_ms = 0
            THEN 0 ELSE (io_stall_write_ms / num_of_writes) END,
    --[WriteLatency_old] =
    --    CASE WHEN [num_of_writes] = 0
    --        THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END,
    [Latency] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) END,
    --avg bytes per IOP
    [AvgBPerRead] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([num_of_bytes_read] / [num_of_reads]) END,
    [AvgBPerWrite] =
        CASE WHEN [io_stall_write_ms] = 0
            THEN 0 ELSE ([num_of_bytes_written] / [num_of_writes]) END,
    [AvgBPerTransfer] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE
                (([num_of_bytes_read] + [num_of_bytes_written]) /
                ([num_of_reads] + [num_of_writes])) END,
    LEFT ([mf].[physical_name], 2) AS [Drive],
    DB_NAME ([vfs].[database_id]) AS [DB],
    --[vfs].*,
    [mf].[physical_name]
FROM
    sys.dm_io_virtual_file_stats (NULL,NULL) AS [vfs]
JOIN sys.master_files AS [mf]
    ON [vfs].[database_id] = [mf].[database_id]
    AND [vfs].[file_id] = [mf].[file_id]
-- WHERE [vfs].[file_id] = 2 -- log files
-- ORDER BY [Latency] DESC
-- ORDER BY [ReadLatency] DESC
ORDER BY [WriteLatency] DESC;
GO
	
/*******************************************************************************
  End of script
*******************************************************************************/


