sp_who2 active

select [spid], [blocked], [waittime]
  , [lastwaittype], [waitresource], [dbid]
  , [cpu], [physical_io], [memusage], [login_time]
  , [last_batch], [open_tran], [status]
  , ltrim(rtrim([hostname])) as [hostname]
  , ltrim(rtrim([program_name])) as [program_name]
  , ltrim(rtrim([loginame])) as [loginame]
from master..sysprocesses
where [spid] > 51
  and ([blocked] > 0 or [waittime] > 0)
order by [blocked], spid
  
  
DECLARE @Handle binary(20)
DECLARE @stmtStart int
DECLARE @stmtEnd int
SELECT 
  @Handle = sql_handle 
  , @stmtStart = [stmt_start]
  , @stmtEnd = [stmt_end]
FROM master..sysprocesses 
WHERE spid = 79
SELECT @Handle as [sql_handle], @stmtStart as [stmt_start], @stmtEnd as [stmt_end]
SELECT [text] as [full_text], substring([text], @stmtStart, @stmtEnd-@stmtStart) as [stmt_text]
FROM ::fn_get_sql(@Handle)



