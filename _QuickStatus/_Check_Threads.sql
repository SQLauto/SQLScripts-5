select CAST(record as XML)
from sys.dm_os_ring_buffers

SELECT * FROM sys.dm_os_threads

SELECT kernel_time + usermode_time as TotalTime, *
FROM sys.dm_os_threads
ORDER BY kernel_time + usermode_time desc


SELECT yield_count, last_timer_activity,
(SELECT ms_ticks from sys.dm_os_sys_info) - last_timer_activity
AS MSSinceYield, * FROM sys.dm_os_schedulers
WHERE is_online = 1 and is_idle <> 1 and scheduler_id < 255
