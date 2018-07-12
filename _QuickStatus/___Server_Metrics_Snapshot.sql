-- 1. SIGNAL WAITS PERCENTAGE < 25
SELECT (100.0 * SUM(signal_wait_time_ms)/SUM (wait_time_ms)) AS [SignalWaitPct]
FROM sys.dm_os_wait_stats
WHERE wait_type NOT IN (
'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP', 'RESOURCE_QUEUE', 'SLEEP_TASK',
'SLEEP_SYSTEMTASK', 'SQLTRACE_BUFFER_FLUSH', 'WAITFOR', 'LOGMGR_QUEUE',
'CHECKPOINT_QUEUE', 'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT',
'BROKER_TO_FLUSH', 'BROKER_TASK_STOP', 'CLR_MANUAL_EVENT', 'CLR_AUTO_EVENT',
'DISPATCHER_QUEUE_SEMAPHORE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
'XE_DISPATCHER_WAIT', 'XE_DISPATCHER_JOIN', 'BROKER_EVENTHANDLER',
'TRACEWRITE', 'FT_IFTSHC_MUTEX', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
'BROKER_RECEIVE_WAITFOR', 'ONDEMAND_TASK_QUEUE', 'DBMIRROR_EVENTS_QUEUE',
'DBMIRRORING_CMD', 'BROKER_TRANSMITTER', 'SQLTRACE_WAIT_ENTRIES',
'SLEEP_BPOOL_FLUSH', 'SQLTRACE_LOCK')
AND wait_time_ms <> 0

-- 2. SQL COMPILATION PERCENTAGE < 10
SELECT 1.0*cntr_value /
(SELECT 1.0*cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec')
AS [SQLCompilationPct]
FROM sys.dm_os_performance_counters
WHERE counter_name = 'SQL Compilations/sec'

SELECT 1.0*cntr_value /
(SELECT 1.0*cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec')
AS [SQLReCompilationPct]
FROM sys.dm_os_performance_counters
WHERE counter_name = 'SQL Re-Compilations/sec'


-- 3. PAGE LOOKUPS PERCENTAGE < 100
SELECT 1.0*cntr_value /
(SELECT 1.0*cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec') 
AS [PageLookupPct]
FROM sys.dm_os_performance_counters
WHERE counter_name = 'Page lookups/sec'

-- 4. AVERAGE TASK COUNTS < 10
SELECT AVG(current_tasks_count) AS [Avg Task Count],
AVG(runnable_tasks_count) AS [Avg Runnable Task Count],
AVG(pending_disk_io_count) AS [Avg Pending DiskIO Count]
FROM sys.dm_os_schedulers WITH (NOLOCK)
WHERE scheduler_id < 255 OPTION (RECOMPILE)

-- 5. BUFFER POOL I/O RATE, compare to daily/hourly rates
SELECT (1.0*cntr_value/128) /
(SELECT 1.0*cntr_value
FROM sys.dm_os_performance_counters
WHERE object_name like '%Buffer Manager%'
AND lower(counter_name) = 'Page life expectancy')
AS [BufferPoolRate]
, (235520.0/3600.0) as hourly_rate
, (235520.0/86400.0) as daily_rate
FROM sys.dm_os_performance_counters
WHERE object_name like '%Buffer Manager%'
AND counter_name = 'Target Pages'


