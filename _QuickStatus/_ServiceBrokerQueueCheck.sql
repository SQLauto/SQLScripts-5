
SELECT 
  sq.[name] as [queue_name]
  , CASE WHEN sq.[is_activation_enabled] = 1 THEN 'Yes' ELSE 'No' END as [Activated]
  , CASE WHEN sq.[is_receive_enabled]	= 1 THEN 'Yes' ELSE 'No' END as [CanReceive]
  , CASE WHEN sq.[is_enqueue_enabled]	= 1 THEN 'Yes' ELSE 'No' END as [CanQueue]
  , CASE WHEN sq.[is_retention_enabled]	= 1 THEN 'Yes' ELSE 'No' END as [Retention]
  , CASE WHEN bqm.state IS NULL THEN '--' ELSE bqm.state END AS [Queue_State]
  , CASE WHEN bqm.tasks_waiting IS NULL THEN '--' ELSE CONVERT(VARCHAR, bqm.tasks_waiting) END AS [tasks_waiting]
  --, bqm.last_activated_time
  , CASE WHEN bqm.last_activated_time IS NULL THEN '--' 
        ELSE CONVERT(varchar(30), CAST(SWITCHOFFSET(CAST(bqm.[last_activated_time] as datetimeoffset), '+10:00') as datetime), 120) 
      END as [last_activated_time]
  --, bqm.last_empty_rowset_time
  , CASE WHEN bqm.last_empty_rowset_time IS NULL THEN '--' 
        ELSE CONVERT(varchar(30), CAST(SWITCHOFFSET(CAST(bqm.[last_empty_rowset_time] as datetimeoffset), '+10:00') as datetime), 120) 
      END AS [last_empty_rowset_time]
  , (SELECT COUNT([message_sequence_number]) FROM sys.transmission_queue WITH(NOLOCK)) as [Msgs_In_Queue]
  , (SELECT COUNT([message_sequence_number]) FROM sys.transmission_queue WITH(NOLOCK) WHERE [is_conversation_error] = 1) as [Queue_Errors]
  , CASE WHEN ce.[far_service] IS NULL THEN '--' ELSE ce.[far_service] END AS [far_service]
  , CASE WHEN ce.[conversation_group_id] IS NULL THEN '--' ELSE CAST(ce.[conversation_group_id] as varchar(40)) END AS [conversation_group]
  , CASE WHEN ce.[conversation_handle] IS NULL THEN '--' ELSE CAST(ce.[conversation_handle] as varchar(40)) END AS [conversation_handle]
  , CASE WHEN ce.[state_desc] IS NULL THEN '--' ELSE ce.[state_desc] END AS [conv_state]
  , CASE WHEN ce.[is_initiator]	= 1 THEN 'Yes' ELSE 'No' END as [is_initiator]
  , CASE WHEN ce.[lifetime] IS NULL THEN '--' ELSE CONVERT(varchar(30), ce.[lifetime], 120) END as [lifetime]
FROM sys.services s WITH (nolock)
  INNER JOIN sys.service_queues sq ON s.service_queue_id = sq.object_id
    LEFT OUTER JOIN sys.dm_broker_queue_monitors bqm ON sq.object_id = bqm.queue_id  AND bqm.database_id = DB_ID()
  LEFT JOIN sys.conversation_endpoints ce WITH (nolock) ON ce.[service_id] = s.[service_id]
  LEFT JOIN sys.service_contracts sc WITH (nolock) ON ce.[service_contract_id] = sc.[service_contract_id]
WHERE sq.is_ms_shipped = 0

