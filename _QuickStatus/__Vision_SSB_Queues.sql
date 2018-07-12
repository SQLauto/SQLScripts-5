 DECLARE @sqlStmt NVARCHAR(max) = '
   SELECT [message_type_name], sum([msg_count])
  FROM (
      SELECT 0 as msg_count
        , ''TOTAL TargetQueue'' as message_type_name
      UNION ALL
      SELECT 0, ''TOTAL InitiatorQueue''
      UNION ALL
      SELECT 0, ''TOTAL OutboundQueue''
      UNION ALL
      SELECT count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN ''TOTAL TargetQueue'' ELSE [message_type_name] END
      FROM ' + CASE 
                WHEN CAST(SERVERPROPERTY('ServerName') as VARCHAR(50)) LIKE '%MRI' THEN '[KFProd].[dbo].[KnightVision_SourceDB_TargetQueue]'
                WHEN CAST(SERVERPROPERTY('ServerName') as VARCHAR(50)) LIKE '%VISION' THEN '[KnightVision].[dbo].[KnightVision_BackendDB_TargetQueue] '
                END
                + 'WITH(NOLOCK)
      GROUP BY message_type_name with cube
      UNION ALL
      SELECT count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN ''TOTAL InitiatorQueue'' ELSE [message_type_name] END
      FROM ' + CASE 
                WHEN CAST(SERVERPROPERTY('ServerName') as VARCHAR(50)) LIKE '%MRI' THEN '[KFProd].[dbo].[KnightVision_SourceDB_InitiatorQueue]'
                WHEN CAST(SERVERPROPERTY('ServerName') as VARCHAR(50)) LIKE '%VISION' THEN '[KnightVision].[dbo].[KnightVision_BackendDB_InitiatorQueue] '
                END
                + ' WITH(NOLOCK)
      GROUP BY message_type_name with cube
      UNION ALL
      SELECT count([queuing_order])
        , CASE WHEN GROUPING([message_type_name]) = 1 THEN ''TOTAL OutboundQueue'' ELSE [message_type_name] END as message_type_name
      FROM ' + CASE 
                WHEN CAST(SERVERPROPERTY('ServerName') as VARCHAR(50)) LIKE '%MRI' THEN '[KFProd].[dbo].[OutboundQueue]'
                WHEN CAST(SERVERPROPERTY('ServerName') as VARCHAR(50)) LIKE '%VISION' THEN '[KnightVision].[dbo].[OutboundQueue] '
                END
                + ' WITH(NOLOCK)
      GROUP BY message_type_name with cube
    ) as cnt
  GROUP BY
    message_type_name
  ORDER BY 
    message_type_name DESC';
 EXEC sp_ExecuteSQL @command = @sqlStmt;