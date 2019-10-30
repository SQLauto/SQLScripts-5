
select 
	sDb.name as dbName
	, databasepropertyex(sDb.name, 'Status') as dbStatus
	, databasepropertyex(sDb.name, 'Recovery') as dbRecovery
	, database_backup as last_database_backup
	, log_backup as last_tlog_backup
from master.dbo.sysdatabases sDb
  left join (
    select 
	    bs.database_name
	    , max(case when bs.type = 'D' then bs.backup_finish_date else null end) as database_backup
	    , max(case when bs.type = 'L' then bs.backup_finish_date else null end) as log_backup
    from msdb.dbo.backupset bs
      inner join (
	        select database_name, type, max(backup_set_id) as max_id 
	        from msdb.dbo.backupset
	        group by database_name, type
        ) as mx
      on bs.backup_set_id = mx.max_id
    group by
	    bs.database_name
    ) bkp
  on sDb.name = bkp.database_name
where datediff(hh, database_backup, getdate()) > 25
   or (databasepropertyex(sDb.name, 'Recovery') = 'FULL' and log_backup is null)


SELECT 
	[database_name],[type]
	,MAX([backup_start_date]) as [latest_backup]
    ,CAST(AVG((([backup_size]/1024.0)/1024.0)) as decimal(9,2)) as [backup_size_MB]
    ,CAST(AVG((([compressed_backup_size]/1024.0)/1024.0)) as decimal(9,2)) as [compressed_backup_size_MB]
FROM [msdb].[dbo].[backupset]
GROUP BY [database_name],[type]
ORDER BY [database_name],[type]