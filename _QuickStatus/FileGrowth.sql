DECLARE @filename NVARCHAR(1000);

WITH defaultTrace
AS (
	SELECT CAST(value AS NVARCHAR(1000)) as [TraceFile]
	FROM fn_trace_getinfo(DEFAULT) 
	WHERE traceid = 1 
		AND property = 2
)
SELECT @filename = REVERSE(SUBSTRING(REVERSE([TraceFile])
	,CHARINDEX('_',REVERSE([TraceFile]))+1,LEN(REVERSE([TraceFile])))) 
	+ REVERSE(SUBSTRING(REVERSE([TraceFile]),1,CHARINDEX('.',REVERSE([TraceFile]))))
FROM defaultTrace;

SELECT @filename

SELECT 
	te.name AS EventName, ftg.HostName, ftg.ClientProcessID, ftg.ApplicationName, ftg.LoginName
	, ftg.SPID, ftg.Duration, ftg.StartTime, ftg.EndTime, ftg.Reads, ftg.Writes, ftg.CPU
	, ftg.EventSubClass, ftg.EventClass, ftg.ObjectName, ftg.DatabaseName, ftg.FileName, ftg.IsSystem
FROM fn_trace_gettable(@filename, DEFAULT) AS ftg 
	INNER JOIN sys.trace_events AS te ON ftg.EventClass = te.trace_event_id  
--WHERE ftg.StartTime BETWEEN '20140627 16:30' AND '20140627 16:50'
	--AND ApplicationName != 'Microsoft SQL Server Service Broker Activation'
WHERE (ftg.EventClass = 92  -- Data File Auto-grow
    OR ftg.EventClass = 93 -- Log File Auto-grow
    OR ftg.EventClass = 94 -- Data File Shrink
    OR ftg.EventClass = 95) -- Log File Shrink
ORDER BY ftg.StartTime;