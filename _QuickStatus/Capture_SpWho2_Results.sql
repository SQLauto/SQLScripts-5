SELECT [ServerName],[HostName],[ProgramName],[Login],[DBName]
	,COUNT(DISTINCT [LastBatch]) as [BatchesStarted]
	,MIN(CONVERT(DateTime, CONVERT(VarChar(4), YEAR(GETDATE())) + '/' + LastBatch)) AS [FirstKnownBatch]
	,MAX(CONVERT(DateTime, CONVERT(VarChar(4), YEAR(GETDATE())) + '/' + LastBatch)) AS [LastestBatch]
	,SUM([CPUTime]) AS [Total_CPUTime]
	,SUM([DiskIO]) AS [Total_DiskIO]
FROM [DBA].[dbo].[results_spwho2]
WHERE [HostName] <> '  .'
	AND [DBName] IS NOT NULL
	AND [ProgramName] NOT LIKE 'SQLAgent%'
	AND [ProgramName] NOT LIKE 'DatabaseMail%'
	AND [ProgramName] NOT LIKE 'SSIS-GatherDBAStats%'
	AND [HostName] NOT LIKE 'KFA500004%'
	AND [DBName] NOT IN ('msdb','master')
	AND NOT ([ServerName] = [HostName] AND [ProgramName] = 'Microsoft SQL Server Management Studio')
GROUP BY [ServerName],[HostName],[ProgramName],[Login],[DBName]
ORDER BY [ServerName],[HostName],[ProgramName],[Login],[DBName]

