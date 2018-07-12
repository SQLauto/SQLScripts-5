
if object_id('tempdb..#tempbackup') is not null drop table #tempbackup
create table #tempbackup (database_name nvarchar(128), [type] char(1), backup_finish_date datetime)
insert into #tempbackup select database_name, [type], max(backup_finish_date) from msdb..backupset where [type] = 'D' or [type] = 'L' or [type]='I' group by database_name, [type]

if object_id('tempdb..#tmplog') is not null drop table #tmplog
create table #tmplog (dbname sysname null, log_size float null, log_space_used float null, status int)
INSERT INTO #tmplog EXEC ('DBCC SQLPERF(LOGSPACE)')


SELECT
  dtb.name AS [Database_Name]
  , suser_sname(dtb.sid) AS [Database_Owner]
  , dtb.crdate AS [Database_CreateDate]
  , DATABASEPROPERTYEX(dtb.name, 'Recovery') AS [Database_RecoveryModel]
  , dtb.cmptlevel AS [Database_CompatibilityLevel]
  , (select backup_finish_date from #tempbackup where type = 'D' and database_name = dtb.name) AS [Database_LastBackupDate]
  , (select backup_finish_date from #tempbackup where type = 'L' and database_name = dtb.name) AS [Database_LastLogBackupDate]
  , CAST((select sum(((size * 8.0)/1024.0)) as [Size_MB] from dbo.sysaltfiles where dbid = dtb.dbid and groupid = 1) AS float) AS [Data_Size_MB]
  , t.log_size as [Log_size_MB]
  , DATABASEPROPERTYEX(dtb.name, 'UserAccess') AS [UserAccess]
  , case when DATABASEPROPERTY(dtb.name,'IsReadOnly') = 0 then 'NO' else 'YES' end AS [ReadOnly]
  , case when DATABASEPROPERTY(dtb.name,'IsInLoad') = 0 then 'NO' else 'YES' end as [InLoad]
  , case when DATABASEPROPERTY(dtb.name,'IsInRecovery') = 0 then 'NO' else 'YES' end as [InRecovery]
  , case when DATABASEPROPERTY(dtb.name,'IsNotRecovered') = 0 then 'NO' else 'YES' end as [NotRecovered]
  , case when DATABASEPROPERTY(dtb.name,'IsSuspect') = 0 then 'NO' else 'YES' end as [Suspect]
  , case when DATABASEPROPERTY(dtb.name,'IsOffline') = 0 then 'NO' else 'YES' end as [Offline]
  , case when DATABASEPROPERTY(dtb.name,'IsInStandBy') = 0 then 'NO' else 'YES' end as [InStandBy]
  , case when DATABASEPROPERTY(dtb.name,'IsShutDown') = 0 then 'NO' else 'YES' end as [ShutDown]
  , case when DATABASEPROPERTY(dtb.name,'IsEmergencyMode') = 0 then 'NO' else 'YES' end as [EmergencyMode]
FROM
  master.dbo.sysdatabases AS dtb
  LEFT OUTER JOIN #tmplog t ON t.dbname = dtb.name
--WHERE
--  (CAST(case when dtb.name in ('master','model','msdb','tempdb') then 1 else category & 16 end AS bit)=0 
--  and (case
--          -- if all these are false then we are in the Normal state
--          -- except some return NULL if it's AutoClosed
--          when (DATABASEPROPERTY(dtb.name,'IsInLoad') = 0 
--            and (DATABASEPROPERTY(dtb.name,'IsInRecovery') = 0 or DATABASEPROPERTY(dtb.name,'IsInRecovery') is null) 
--            and (DATABASEPROPERTY(dtb.name,'IsNotRecovered') = 0 or DATABASEPROPERTY(dtb.name,'IsNotRecovered') is null) 
--            and DATABASEPROPERTY(dtb.name,'IsSuspect') = 0 
--            and DATABASEPROPERTY(dtb.name,'IsOffline') = 0 
--            and DATABASEPROPERTY(dtb.name,'IsInStandBy') = 0 
--            and (DATABASEPROPERTY(dtb.name,'IsShutDown') = 0 or DATABASEPROPERTY(dtb.name,'IsShutDown') is null) 
--            and DATABASEPROPERTY(dtb.name,'IsEmergencyMode') = 0) then 1 else 0 end |
--          case
--            when DATABASEPROPERTY(dtb.name,'IsInLoad') = 1 then 2 else 0 end |
--          case
--            when DATABASEPROPERTY(dtb.name,'IsInRecovery') = 1 
--              and DATABASEPROPERTY(dtb.name,'IsNotRecovered') = 1 then 4 else 0 end |
--          case
--            when DATABASEPROPERTY(dtb.name,'IsInRecovery') = 1 then 8 else 0 end |
--          case
--            when DATABASEPROPERTY(dtb.name,'IsSuspect') = 1 then 16 else 0 end |
--          case
--            when DATABASEPROPERTY(dtb.name,'IsOffline') = 1 then 32 else 0 end |
--          case
--            when DATABASEPROPERTY(dtb.name,'IsInStandBy') = 1 then 64 else 0 end |
--          case
--            when DATABASEPROPERTY(dtb.name,'IsShutDown') = 1 then 128
--            when DATABASEPROPERTY(dtb.name,'IsShutDown') is null then (512 + 128) else 0 end |
--          case
--            when DATABASEPROPERTY(dtb.name,'IsEmergencyMode') = 1 then 256 else 0 end
--      ) & (62)=0)
ORDER BY
  [Database_Name] ASC

