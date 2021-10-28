USE baseline
GO

SELECT TOP 10
        wait_type ,
        max_wait_time_ms wait_time_ms ,
        signal_wait_time_ms ,
        wait_time_ms - signal_wait_time_ms AS resource_wait_time_ms ,
        CASE WHEN wait_time_ms = 0 THEN 0 ELSE 100.0 * wait_time_ms / SUM(wait_time_ms) OVER ( ) END
                                    AS percent_total_waits ,
        CASE WHEN signal_wait_time_ms = 0 THEN 0 ELSE 100.0 * signal_wait_time_ms / SUM(signal_wait_time_ms) OVER ( ) END
                                    AS percent_total_signal_waits ,
        CASE WHEN wait_time_ms = 0 THEN 0 ELSE 100.0 * ( wait_time_ms - signal_wait_time_ms )
        / SUM(wait_time_ms) OVER ( ) END AS percent_total_resource_waits
FROM    dbo.waits
WHERE   waits.collection_id= (select max(collection_id) from waits) AND wait_time_ms > 0 -- remove zero wait_time
        AND wait_type NOT IN -- filter out additional irrelevant waits
( 'SLEEP_TASK', 'BROKER_TASK_STOP', 'BROKER_TO_FLUSH',
  'SQLTRACE_BUFFER_FLUSH','CLR_AUTO_EVENT', 'CLR_MANUAL_EVENT', 
  'LAZYWRITER_SLEEP', 'SLEEP_SYSTEMTASK', 'SLEEP_BPOOL_FLUSH',
  'BROKER_EVENTHANDLER', 'XE_DISPATCHER_WAIT', 'FT_IFTSHC_MUTEX',
  'CHECKPOINT_QUEUE', 'FT_IFTS_SCHEDULER_IDLE_WAIT', 
  'BROKER_TRANSMITTER', 'FT_IFTSHC_MUTEX', 'KSOURCE_WAKEUP',
  'LAZYWRITER_SLEEP', 'LOGMGR_QUEUE', 'ONDEMAND_TASK_QUEUE',
  'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BAD_PAGE_PROCESS',
  'DBMIRROR_EVENTS_QUEUE', 'BROKER_RECEIVE_WAITFOR',
  'PREEMPTIVE_OS_GETPROCADDRESS', 'PREEMPTIVE_OS_AUTHENTICATIONOPS',
  'WAITFOR', 'DISPATCHER_QUEUE_SEMAPHORE', 'XE_DISPATCHER_JOIN',
  'RESOURCE_QUEUE','QDS_PERSIST_TASK_MAIN_LOOP_SLEEP','QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
  'CLR_SEMAPHORE','SQLTRACE_INCREMENTAL_FLUSH_SLEEP','HADR_FILESTREAM_IOMGR_IOCOMPLETION','DIRTY_PAGE_POLL' )
ORDER BY wait_time_ms DESC