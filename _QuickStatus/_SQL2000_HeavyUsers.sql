if object_id('tempdb..#who') is not null drop table #who
CREATE TABLE #who (
	[spid] smallint 
	, [Status] nvarchar(30) 
	, [Login] nvarchar(128) 
	, [HostName] nvarchar(128) 
	, [BlkBy] smallint 
	, [DBName] nvarchar(128)
	, [Command] nvarchar(16) 
	, [CPUTime] int 
	, [DiskIO] bigint
	, [LastBatch] datetime
	, [ProgramName] nvarchar(128)
)

INSERT INTO #who
select 
  [spid], [status], [loginame], [hostname], [blocked]
  , db_name([dbid]) as [DBName], [cmd] as [command]
  , [cpu], [physical_io], [last_batch], [program_name]
from master..sysprocesses
WHERE [spid] > 50
  AND NOT ([program_name] like '%SQLAgent%')

SELECT TOP 10
  [SPID], [Status], [Login], [HostName], [BlkBy], [DBName], [Command], [CPUTime]
  , CAST(([CPUTime] * 1.0)/(agg.[Total_CPUTime] * 1.0) * 100 as decimal(9,2)) as [Percent_of_TotalCPU]
  , [DiskIO]
  , CAST(([DiskIO] * 1.0)/(agg.[Total_DiskIO] * 1.0) * 100 as decimal(9,2)) as [Percent_of_TotalDiskIO]
  , [LastBatch], [ProgramName]
FROM #who
  , (
    select 
      SUM([CPUTime]) as [Total_CPUTime]
      , SUM([DiskIO]) as [Total_DiskIO]
    from #who
  ) as agg
ORDER BY [Percent_of_TotalCPU] DESC
  , [Percent_of_TotalDiskIO] DESC

