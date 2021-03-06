
--
-- RUN ON SECONDARY LOG SHIPPING SERVER
--

declare @dbName nvarchar(128);
set @dbName = N'Knightvision';
declare @theDate datetime;
set @theDate = dateadd(dd, -3, getdate());

SELECT
  bkps.[database_name]
  , bkps.[physical_device_name]
  , bkps.[backup_size_MB]
  , bkps.[backup_finish_date]
  , cpy.[copy_start]
  , datediff(mi, bkps.[backup_finish_date], cpy.[copy_start]) as copy_latency_min
  , cpy.[copy_finish]
  , datediff(mi, cpy.[copy_start], cpy.[copy_finish]) as copy_duration_min
  , case when datediff(mi, cpy.[copy_start], cpy.[copy_finish]) > 1 
      THEN cast((bkps.[backup_size_MB]/datediff(mi, cpy.[copy_start], cpy.[copy_finish])) as decimal(19,2))
      ELSE null end as copy_MB_per_min
  , rst.[restore_date]
  , datediff(mi, cpy.[copy_finish], rst.[restore_date]) as restore_latency_min
  , datediff(mi, bkps.[backup_finish_date], rst.[restore_date]) as total_latency_min
FROM (  
  SELECT
    bkp.database_name
    , bkp.backup_finish_date
    , mf.physical_device_name
    , CAST((bkp.backup_size / 1024.0) / 1024.0 AS decimal(19, 2)) AS backup_size_MB
    , bkp.[backup_set_id]
  FROM [msdb].[dbo].[backupmediafamily] AS mf 
    INNER JOIN [msdb].[dbo].[backupset] AS bkp 
    ON mf.media_set_id = bkp.media_set_id
  WHERE bkp.database_name = @dbName
    AND (bkp.type = 'L') 
    AND (bkp.backup_start_date > @theDate)  
  ) as bkps
  INNER JOIN (
      SELECT
        [physical_filename]
        , max(case when [type] = 'start' then [log_time] else null end) as [copy_start]
        , max(case when [type] = 'finish' then [log_time] else null end) as [copy_finish] 
      FROM (  
        SELECT 
          CASE
            WHEN [message] like '%Copying log backup file to temporary%' THEN 'Start'
            WHEN [message] like '%Renamed temporary work file%' THEN 'Finish'
          END as [type]
          ,[log_time]
          , replace(replace(right([message], len([message]) - charindex('Destination: ', [message])-13), '''', ''), 'wrk', 'trn') as physical_filename
        FROM [msdb].[dbo].[log_shipping_monitor_history_detail]
        where [message] like '%'+@dbName+'%'
          and ([message] like '%Copying log backup file to temporary%'
            or [message] like '%Renamed temporary work file%')
          and [log_time] > @theDate
      ) as a
      group by 
        [physical_filename]
    ) as cpy
   ON bkps.[physical_device_name] = cpy.[physical_filename]
  INNER JOIN ( 
      select hst.[backup_set_id], hst.[restore_date]
      from [msdb].[dbo].[restorehistory] hst
        inner join (
            select [backup_set_id], MIN([restore_history_id]) as [restore_history_id]
            from [msdb].[dbo].[restorehistory]
            where [destination_database_name] = @dbName
            group by [backup_set_id]
          ) mn
        on hst.[restore_history_id] = mn.[restore_history_id]
      where [restore_date] > @theDate
   ) as rst
  ON bkps.[backup_set_id] = rst.[backup_set_id]
  AND datediff(hh, bkps.backup_finish_date, rst.[restore_date]) < 25
  order by 
    bkps.[physical_device_name] DESC

