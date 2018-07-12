SELECT name 
, db.log_reuse_wait_desc 
, ls.cntr_value  AS size_kb 
, lu.cntr_value AS used_kb 
, CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)  
  AS used_percent 
, CASE WHEN CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT) > .5 THEN 
   CASE 
    /* tempdb special monitoring */ 
    WHEN db.name = 'tempdb'  
     AND log_reuse_wait_desc NOT IN ('CHECKPOINT', 'NOTHING') THEN 'WARNING'  
    /* all other databases, monitor foor the 50% fill case */ 
    WHEN db.name <> 'tempdb' THEN 'WARNING' 
    ELSE 'OK' 
    END 
  ELSE 'OK' END 
  AS log_status 
FROM sys.databases db 
JOIN sys.dm_os_performance_counters lu 
 ON db.name = lu.instance_name 
JOIN sys.dm_os_performance_counters ls 
 ON db.name = ls.instance_name 
WHERE lu.counter_name LIKE  'Log File(s) Used Size (KB)%' 
AND ls.counter_name LIKE 'Log File(s) Size (KB)%' 
