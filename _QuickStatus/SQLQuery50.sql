-- online databases
select count(database_id) as all_db_online 
from sys.databases

-- job failures
select COUNT(jh.instance_id) as [job_failures]
from msdb.dbo.sysjobhistory jh
	inner join msdb.dbo.sysjobs jb on jh.job_id = jb.job_id
where jb.enabled = 1
	and jh.step_id = 0 
	and jh.run_status = 0
	and jh.run_date = CONVERT(varchar(20), GETDATE(), 112)

-- missing full backups
select (select count(database_id) from sys.databases where [state_desc] = 'ONLINE') - count(bk.[backup_set_id]) as [missing_backups]
from [msdb].[dbo].[backupset] bk
	inner join sys.databases db on bk.database_name = db.name
where bk.[type] = 'D'
	and datediff(hh, bk.[backup_finish_date], getdate()) < 24

