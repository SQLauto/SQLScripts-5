 
select
  s.[session_id]
  , s.[host_name]
  , s.[host_process_id]
  , s.[program_name]
  , s.[login_name]
  , s.[login_time]
  , s.[last_request_end_time]
  , r.[cpu_time] as [CPU]
  , r.[logical_reads] as [logical_io] 
  , r.[reads] as [physical_io]
  , r.[writes]
  , r.[wait_type]
  , r.[wait_time]
  , r.[last_wait_type]
  , r.[wait_resource]
  , substring(h.text, (r.statement_start_offset/2)+1, 
      ((
          case r.statement_end_offset 
            when -1 then datalength(h.text) 
            else r.statement_end_offset 
          end - r.statement_start_offset)/2) + 1
       ) as stmt_text
from sys.dm_exec_sessions s
  left join sys.dm_exec_requests r
  on s.[session_id] = r.[session_id]
    outer apply sys.dm_exec_sql_text(r.sql_handle) h 
where s.[is_user_process] = 1 
  and (not (s.[program_name] like '%SQLAgent%'))
  and (not (s.[program_name] like '%Report Server%'))
order by 
  s.[last_request_end_time]
  


