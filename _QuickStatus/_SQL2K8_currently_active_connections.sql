select 
  sess.[session_id], sess.[login_name], sess.[host_name]
  , sess.[host_process_id], db_name(er.database_id) as [db_name] 
  , sess.[last_request_start_time], sess.[last_request_end_time]
  , er.[blocking_session_id], er.[last_wait_type], er.[wait_time] 
  , er.[cpu_time], er.[reads], er.[writes], er.[logical_reads] 
  , txt.[text], pln.[query_plan]
from sys.dm_exec_sessions sess 
  left join sys.dm_exec_requests er 
  on sess.session_id = er.session_id 
    outer apply sys.dm_exec_sql_text(er.[sql_handle]) txt 
    outer apply sys.dm_exec_query_plan(er.[plan_handle]) pln 
where sess.is_user_process = 1


SELECT s_tst.[session_id],
   s_es.[login_name] AS [Login Name],
   DB_NAME (s_tdt.database_id) AS [Database],
   s_tdt.[database_transaction_begin_time] AS [Begin Time],
   s_tdt.[database_transaction_log_record_count] AS [Log Records],
   s_tdt.[database_transaction_log_bytes_used] AS [Log Bytes],
   s_tdt.[database_transaction_log_bytes_reserved] AS [Log Rsvd],
   s_est.[text] AS [Last T-SQL Text],
   s_eqp.[query_plan] AS [Last Plan]
FROM sys.dm_tran_database_transactions s_tdt
   JOIN sys.dm_tran_session_transactions s_tst
      ON s_tst.[transaction_id] = s_tdt.[transaction_id]
   JOIN sys.[dm_exec_sessions] s_es
      ON s_es.[session_id] = s_tst.[session_id]
   JOIN sys.dm_exec_connections s_ec
      ON s_ec.[session_id] = s_tst.[session_id]
   LEFT OUTER JOIN sys.dm_exec_requests s_er
      ON s_er.[session_id] = s_tst.[session_id]
   CROSS APPLY sys.dm_exec_sql_text (s_ec.[most_recent_sql_handle]) AS s_est
   OUTER APPLY sys.dm_exec_query_plan (s_er.[plan_handle]) AS s_eqp
ORDER BY [Begin Time] ASC;