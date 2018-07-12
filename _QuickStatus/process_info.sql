SELECT 
  sess.session_id
  , CONVERT(CHAR(1), sess.is_user_process) as [user process]
  , sess.login_name
  , ISNULL(db_name(req.database_id), N'') as [db_name]
  , ISNULL(tsk.task_state, N'UNKNOWN') as [state]
  , ISNULL(wait.blocking_session_id, 0) as [blocked_by]
  , CASE 
        WHEN req2.session_id IS NOT NULL AND req.blocking_session_id = 0 THEN 1
        WHEN req.session_id IS NULL THEN 1
        ELSE 0
      END as [head_blocker]
  , sess.cpu_time
  , sess.reads
  , sess.writes
  , sess.memory_usage
  , ISNULL(req.open_transaction_count,0) as [open_tran]
  , ISNULL(req.command, N'') as [command]
  , ISNULL(sess.program_name, N'') as [program_name]
  , sess.login_time
  , sess.last_request_start_time as [last_request]
  , ISNULL(sess.host_name, N'') as [host_name]
  , ISNULL(conn.client_net_address, N'') as [net_address]
  , ISNULL(wait.wait_duration_ms, 0) as [wait_duration_ms]
  , ISNULL(wait.wait_type, N'') as [wait_type]
  , ISNULL(wait.resource_description, N'') as [wait_resource]
FROM sys.dm_exec_sessions sess 
  LEFT OUTER JOIN sys.dm_exec_connections conn 
  ON sess.session_id = conn.session_id
  LEFT JOIN sys.dm_exec_requests req 
  ON sess.session_id = req.session_id
    LEFT JOIN sys.dm_os_tasks tsk 
    ON req.session_id = tsk.session_id 
    AND req.request_id = tsk.request_id
      LEFT JOIN (
          SELECT *, 
            ROW_NUMBER() OVER (PARTITION BY waiting_task_address ORDER BY wait_duration_ms DESC) AS row_num
          FROM sys.dm_os_waiting_tasks 
        ) as wait 
      ON tsk.task_address = wait.waiting_task_address
      AND wait.row_num = 1
    LEFT JOIN sys.dm_exec_requests req2 
    ON req.session_id = req2.blocking_session_id
ORDER BY sess.session_id;
