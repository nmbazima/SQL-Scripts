USE baseline
GO

SELECT w1.wait_type,
	CASE WHEN (w2.wait_time_ms - w1.wait_time_ms) = 0
		THEN 0
		ELSE w2.wait_time_ms - w1.wait_time_ms END AS wait_time_ms,
	CASE WHEN (w2.signal_wait_time_ms - w1.signal_wait_time_ms) = 0
		THEN 0
		ELSE w2.signal_wait_time_ms - w1.signal_wait_time_ms END AS signal_wait_time_ms,
	CASE WHEN (w2.waiting_tasks_count - w1.waiting_tasks_count) = 0
		THEN 0
		ELSE w2.waiting_tasks_count - w1.waiting_tasks_count END AS waiting_tasks_count
FROM baseline.dbo.waits w1
INNER JOIN baseline.dbo.waits w2
	ON w1.wait_type = w2.wait_type
	AND w1.collection_id = 1
	AND w2.collection_id = 2
WHERE w1.wait_type IN (
	N'THREADPOOL',
	N'PAGELATCH_SH',
	N'WRITELOG',
	N'SOS_SCHEDULER_YIELD',
	N'PAGEIOLATCH_UP',
	N'PAGELATCH_EX',
	N'PAGELATCH_UP',
	N'PAGELATCH_DT',
	N'PAGEIOLATCH_NL',
	N'PAGEIOLATCH_KP',
	N'PAGEIOLATCH_SH',
	N'LOGMGR',
	N'CMEMTHREAD',
	N'CXPACKET')
ORDER BY wait_time_ms DESC