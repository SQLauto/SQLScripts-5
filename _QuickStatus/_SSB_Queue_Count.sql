:setvar inSQLCMD "OK"
GO

IF ('$(inSQLCMD)' = '$' + '(inSQLCMD)')
BEGIN
    RAISERROR ('This script must be run in SQLCMD mode.', 16, 1);
    SET NOEXEC ON;
END
GO

:connect UATMRISQL01

  SELECT [sample_date], [message_type_name], sum([msg_count])
  FROM (
      SELECT GETDATE() as sample_date, 0 as msg_count
        , 'TOTAL TargetQueue' as message_type_name
      UNION ALL
      SELECT GETDATE(), 0, 'TOTAL InitiatorQueue'
      UNION ALL
      SELECT GETDATE(), 0, 'TOTAL OutboundQueue'
      UNION ALL
      SELECT GETDATE(), count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN 'TOTAL TargetQueue' ELSE [message_type_name] END
      FROM [KFProd].[dbo].[KnightVision_SourceDB_TargetQueue] WITH(NOLOCK)
      GROUP BY message_type_name with cube
      UNION ALL
      SELECT GETDATE(), count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN 'TOTAL InitiatorQueue' ELSE [message_type_name] END
      FROM [KFProd].[dbo].[KnightVision_SourceDB_InitiatorQueue] WITH(NOLOCK)
      GROUP BY message_type_name with cube
      UNION ALL
      SELECT GETDATE(), count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN 'TOTAL OutboundQueue' ELSE [message_type_name] END as message_type_name
      FROM [KFProd].[dbo].[OutboundQueue] WITH(NOLOCK)
      GROUP BY message_type_name with cube
    ) as cnt
  GROUP BY sample_date, message_type_name;
GO

:connect UATVSSQL01\SQL2K8R2
  
  SELECT [sample_date], [message_type_name], sum([msg_count])
  FROM (
      SELECT GETDATE() as sample_date, 0 as msg_count
        , 'TOTAL TargetQueue' as message_type_name
      UNION ALL
      SELECT GETDATE(), 0, 'TOTAL InitiatorQueue'
      UNION ALL
      SELECT GETDATE(), 0, 'TOTAL OutboundQueue'
      UNION ALL
      SELECT GETDATE(), count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN 'TOTAL TargetQueue' ELSE [message_type_name] END
      FROM [KnightVision].[dbo].[KnightVision_BackendDB_TargetQueue] WITH(NOLOCK)
      GROUP BY message_type_name with cube
      UNION ALL
      SELECT GETDATE(), count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN 'TOTAL InitiatorQueue' ELSE [message_type_name] END
      FROM [KnightVision].[dbo].[KnightVision_BackendDB_InitiatorQueue] WITH(NOLOCK)
      GROUP BY message_type_name with cube
      UNION ALL
      SELECT GETDATE(), count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN 'TOTAL OutboundQueue' ELSE [message_type_name] END as message_type_name
      FROM [KnightVision].[dbo].[OutboundQueue] WITH(NOLOCK)
      GROUP BY message_type_name with cube
    ) as cnt
  GROUP BY sample_date, message_type_name

GO