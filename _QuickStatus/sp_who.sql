sp_who2

select 
  prc.[spid]
  , prc.[status]
  , prc.[blocked]
  , prc.[loginame]
  , prc.[hostname]
  , db_name(prc.[dbid]) as [db_name]
  , prc.[cmd]
  , prc.[cpu]
  , prc.[physical_io]
  , prc.[login_time]
  , prc.[last_batch]
  , prc.[program_name]
from sys.sysprocesses prc
where prc.[last_batch] < DATEADD(hh, -48, getdate())
  and spid > 50
  and NOT (prc.[program_name] like '%SQLAgent%')
  and prc.[loginame] = 'julian.barons'
  
