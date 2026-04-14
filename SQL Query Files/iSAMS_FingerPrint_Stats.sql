WITH interval_fingerprint_stats AS
(
    SELECT 
        cur_stats.batch_text, 
        SUBSTRING (
            cur_stats.batch_text, 
            (cur_stats.sample_statement_start_offset/2) + 1, 
            (
                (
                    CASE cur_stats.sample_statement_end_offset 
                        WHEN -1 THEN DATALENGTH(cur_stats.batch_text)
                        WHEN 0 THEN DATALENGTH(cur_stats.batch_text)
                        ELSE cur_stats.sample_statement_end_offset 
                    END 
                    - cur_stats.sample_statement_start_offset
                )/2
            ) + 1
        ) AS statement_text, 
        -- If we don't have a prior snapshot, and if the plan has been around since before the start of the interval, 
        -- amortize the cost of the query over its lifetime so that we don't make the (typically incorrect) assumption 
        -- that the cost was all accumulated within the just-completed interval. 
        CASE 
            WHEN DATEDIFF (second, CASE WHEN (@previous_collection_time IS NULL) OR (prev_stats.plan_fingerprint IS NULL AND cur_stats.creation_time < @previous_collection_time) THEN cur_stats.creation_time ELSE @previous_collection_time END, @current_collection_time) > 0
            THEN DATEDIFF (second, CASE WHEN (@previous_collection_time IS NULL) OR (prev_stats.plan_fingerprint IS NULL AND cur_stats.creation_time < @previous_collection_time) THEN cur_stats.creation_time ELSE @previous_collection_time END, @current_collection_time)
            ELSE 1 -- protect from divide by zero
        END AS interval_duration_sec, 
        cur_stats.query_fingerprint, 
        cur_stats.plan_fingerprint, 
        cur_stats.sample_sql_handle, 
        cur_stats.sample_plan_handle, 
        cur_stats.sample_statement_start_offset, 
        cur_stats.sample_statement_end_offset, 
        cur_stats.plan_count, 
        -- If a plan is removed from cache, then reinserted, it is possible for it to seem to have negative cost.  The 
        -- CASE statements below handle this scenario. 
        CASE WHEN (cur_stats.execution_count - ISNULL (prev_stats.execution_count, 0)) < 0 
            THEN cur_stats.execution_count 
            ELSE (cur_stats.execution_count - ISNULL (prev_stats.execution_count, 0)) 
        END AS interval_executions, 
        cur_stats.execution_count AS total_executions, 
        CASE WHEN (cur_stats.total_worker_time_ms - ISNULL (prev_stats.total_worker_time_ms, 0)) < 0 
            THEN cur_stats.total_worker_time_ms
            ELSE (cur_stats.total_worker_time_ms - ISNULL (prev_stats.total_worker_time_ms, 0)) 
        END AS interval_cpu_ms, 
        CASE WHEN (cur_stats.total_physical_reads - ISNULL (prev_stats.total_physical_reads, 0)) < 0 
            THEN cur_stats.total_physical_reads
            ELSE (cur_stats.total_physical_reads - ISNULL (prev_stats.total_physical_reads, 0)) 
        END AS interval_physical_reads, 
        CASE WHEN (cur_stats.total_logical_writes - ISNULL (prev_stats.total_logical_writes, 0)) < 0 
            THEN cur_stats.total_logical_writes 
            ELSE (cur_stats.total_logical_writes - ISNULL (prev_stats.total_logical_writes, 0)) 
        END AS interval_logical_writes, 
        CASE WHEN (cur_stats.total_logical_reads - ISNULL (prev_stats.total_logical_reads, 0)) < 0 
            THEN cur_stats.total_logical_reads 
            ELSE (cur_stats.total_logical_reads - ISNULL (prev_stats.total_logical_reads, 0)) 
        END AS interval_logical_reads, 
        CASE WHEN (cur_stats.total_elapsed_time_ms - ISNULL (prev_stats.total_elapsed_time_ms, 0)) < 0 
            THEN cur_stats.total_elapsed_time_ms 
            ELSE (cur_stats.total_elapsed_time_ms - ISNULL (prev_stats.total_elapsed_time_ms, 0)) 
        END AS interval_elapsed_time_ms, 
        cur_stats.total_completed_execution_time_ms AS total_completed_execution_time_ms,
        cur_stats.dbname
    FROM #am_fingerprint_stats_snapshots AS cur_stats
    LEFT OUTER JOIN #am_fingerprint_stats_snapshots AS prev_stats
        ON prev_stats.collection_time = @previous_collection_time
        AND prev_stats.plan_fingerprint = cur_stats.plan_fingerprint AND prev_stats.query_fingerprint = cur_stats.query_fingerprint
    WHERE cur_stats.collection_time = @current_collection_time
)
SELECT 
    SUBSTRING (statement_text, 1, 200) AS [Query], 
    /* Begin hidden grid columns */
    statement_text, 
    -- We must convert these to a hex string representation because they will be stored in a DataGridView, which can't  
    -- handle binary cell values (assumes anything binary is an image) 
    master.dbo.fn_varbintohexstr(query_fingerprint) AS query_fingerprint, 
    master.dbo.fn_varbintohexstr(plan_fingerprint) AS plan_fingerprint,     
    master.dbo.fn_varbintohexstr(sample_sql_handle) AS sample_sql_handle,   
    master.dbo.fn_varbintohexstr(sample_plan_handle) AS sample_plan_handle, 
    sample_statement_start_offset,
    sample_statement_end_offset,  
    /* End hidden grid columns */
    interval_executions * 60 / interval_duration_sec AS [Executions/min], 
    interval_cpu_ms / interval_duration_sec AS [CPU (ms/sec)], 
    interval_physical_reads / interval_duration_sec AS [Physical Reads/sec], 
    interval_logical_writes / interval_duration_sec AS [Logical Writes/sec], 
    interval_logical_reads / interval_duration_sec AS [Logical Reads/sec], 
    CASE total_executions 
        WHEN 0 THEN 0
        ELSE total_completed_execution_time_ms / total_executions 
    END AS [Average Duration (ms)], 
    plan_count AS [Plan Count], 
    dbname AS [Database Name]
FROM interval_fingerprint_stats;

-- Step 4: Delete all but the most recent snapshot; we no longer need any older data

