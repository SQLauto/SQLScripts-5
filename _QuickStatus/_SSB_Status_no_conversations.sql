
SELECT 
  s.[name] as [local_service]
  , CASE WHEN sq.[is_activation_enabled] = 1 THEN 'Yes' ELSE 'No' END as [Activated]
  , CASE WHEN sq.[is_receive_enabled]	= 1 THEN 'Yes' ELSE 'No' END as [CanReceive]
  , CASE WHEN sq.[is_enqueue_enabled]	= 1 THEN 'Yes' ELSE 'No' END as [CanQueue]
  , CASE WHEN sq.[is_retention_enabled]	= 1 THEN 'Yes' ELSE 'No' END as [Retention]
  , CASE WHEN bqm.state IS NULL THEN '--' ELSE bqm.state END AS [Queue_State]
  , CASE WHEN bqm.tasks_waiting IS NULL THEN '--' ELSE CONVERT(VARCHAR, bqm.tasks_waiting) END AS [tasks_waiting]
  , CASE WHEN bqm.last_activated_time IS NULL THEN '--' 
        ELSE CONVERT(varchar(30), CAST(SWITCHOFFSET(CAST(bqm.[last_activated_time] as datetimeoffset), '+10:00') as datetime), 120) 
      END as [last_activated_time]
  , CASE WHEN bqm.last_empty_rowset_time IS NULL THEN '--' 
        ELSE CONVERT(varchar(30), CAST(SWITCHOFFSET(CAST(bqm.[last_empty_rowset_time] as datetimeoffset), '+10:00') as datetime), 120) 
      END AS [last_empty_rowset_time]
  , (SELECT COUNT([message_sequence_number])FROM sys.transmission_queue WITH(NOLOCK)) as [Msgs_In_Queue]
  , (SELECT COUNT([message_sequence_number])FROM sys.transmission_queue WITH(NOLOCK)WHERE [is_conversation_error] = 1) as [Queue_Errors]
FROM sys.services s WITH (nolock)
  INNER JOIN sys.service_queues sq ON s.service_queue_id = sq.object_id
    LEFT OUTER JOIN sys.dm_broker_queue_monitors bqm ON sq.object_id = bqm.queue_id  AND bqm.database_id = DB_ID()
WHERE sq.is_ms_shipped = 0
