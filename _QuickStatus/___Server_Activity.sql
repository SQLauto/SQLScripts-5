  sp_who2 active

SELECT 
    (total_logical_reads/execution_count) AS avg_logical_reads
    , (total_logical_writes/execution_count) AS avg_logical_writes
    , (total_physical_reads/execution_count) AS avg_phys_reads
    , execution_count
    , last_execution_time
    , statement_start_offset as stmt_start_offset
    , (SELECT SUBSTRING(text, statement_start_offset/2 + 1,
          (CASE WHEN statement_end_offset = -1
            THEN LEN(CONVERT(nvarchar(MAX),text)) * 2
                ELSE statement_end_offset
            END - statement_start_offset)/2)
          FROM sys.dm_exec_sql_text(sql_handle)
        ) AS query_text
    ,(SELECT query_plan from sys.dm_exec_query_plan(qs.plan_handle)) as query_plan
FROM sys.dm_exec_query_stats qs
ORDER BY (total_logical_reads + total_logical_writes) DESC
  

select top 10
  t1.session_id
  , t1.request_id
  , t1.task_alloc
  , t1.task_dealloc
  , (
      SELECT 
        SUBSTRING(text, t2.statement_start_offset/2 + 1,(CASE WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max),text)) * 2 ELSE statement_end_offset END - t2.statement_start_offset)/2)
      FROM sys.dm_exec_sql_text(sql_handle)
    ) AS query_text
  , (
      SELECT 
        query_plan 
      from sys.dm_exec_query_plan(t2.plan_handle)
    ) as query_plan
from (
  Select 
    session_id
    , request_id
    , sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count) as task_alloc
    , sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count) as task_dealloc
  from sys.dm_db_task_space_usage
  group by 
    session_id
    , request_id
  ) as t1
  inner join sys.dm_exec_requests as t2
  on t1.session_id = t2.session_id 
  and t1.request_id = t2.request_id
where
  t1.session_id > 50
order by 
  t1.task_alloc DESC
  