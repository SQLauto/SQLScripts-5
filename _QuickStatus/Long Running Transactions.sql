USE [DBA]
GO

CREATE PROCEDURE [dbo].[usp_LongRunningTranAlert]
  @tran_len_mins int = 15
  , @sendEmail char(1) = 'Y'
  , @emailProfile varchar(20) = 'DBA_HTML'
AS
BEGIN -- procedure
  SET NOCOUNT ON;
  SET XACT_ABORT ON;

  DECLARE @err int; -- error number
  DECLARE @sev int; -- error severity
  DECLARE @msg nvarchar(1000);  -- error message
  DECLARE @emailSubject nvarchar(200); -- email subject line
  DECLARE @emailMessage nvarchar(4000); -- email message body
  DECLARE @serverName varchar(50)

  SET @serverName = CAST(SERVERPROPERTY('ServerName') as varchar(50))
  SET @emailSubject = @serverName + ': Long Running Transaction(s) Detected';

  BEGIN TRY

    TRUNCATE TABLE [dbo].[open_transactions_sample]

    INSERT INTO [dbo].[open_transactions_sample] (
      [session_id],[login_name],[database_name],[capture_time]
      ,[tran_start_time],[log_records],[log_bytes],[log_reserved]
      ,[last_sql_stmt],[last_exec_plan]
    )
    SELECT 
      s_tst.[session_id]
      ,s_es.[login_name] AS [Login Name]
      ,DB_NAME (s_tdt.database_id) AS [Database]
      ,GETDATE() as [capture_time]
      ,s_tdt.[database_transaction_begin_time] AS [Begin Time]
      ,s_tdt.[database_transaction_log_record_count] AS [Log Records]
      ,s_tdt.[database_transaction_log_bytes_used] AS [Log Bytes]
      ,s_tdt.[database_transaction_log_bytes_reserved] AS [Log Rsvd]
      ,s_est.[text] AS [Last T-SQL Text]
      ,s_eqp.[query_plan] AS [Last Plan]
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
    WHERE s_tst.[session_id] != @@SPID
    ORDER BY [Begin Time] ASC;

    IF EXISTS (
        SELECT 1
        FROM [DBA].[dbo].[open_transactions_sample]
        WHERE DATEDIFF(mi,[tran_start_time],GETDATE()) > @tran_len_mins
      )
    BEGIN -- long running trans found
      IF @sendEmail = 'Y'
      BEGIN -- email results

        SET @emailMessage = CAST((
              SELECT
                td = [sample_id], '', td = [session_id],''
                , td = [login_name],'', td = [database_name],''
                , td = [capture_time], '', td = [tran_start_time], ''
                , td = [log_records], '', td = [log_bytes], ''
                , td = [log_reserved], '', td = LEFT([last_sql_stmt], 100) + '...', ''
              FROM [dbo].[open_transactions_sample]
              ORDER BY [tran_start_time]
              FOR XML PATH('tr'), TYPE  
            ) AS NVARCHAR(MAX) )

        SET @emailMessage = N'<BODY><H3>Long Running Transactions on ' 
          + @serverName + N'</H3><table border="1"><tr><th>sample_id]</th>'
          + N'<th>session_id]</th><th>login_name]</th>'
          + N'<th>database_name]</th><th>capture_time]</th>'
          + N'<th>tran_start_time]</th><th>log_records]</th>'
          + N'<th>log_bytes]</th><th>log_reserved]</th>'
          + N'<th>last_sql_stmt]</th></tr>' + @emailMessage
          + N'</table></BODY>';

        EXEC [dbo].[usp_SendEmail]
          @EmailProfile = @emailProfile
          , @Subject = @emailSubject
          , @MsgBody = @emailMessage
      
      END -- email results
      ELSE
      BEGIN -- list results
        SELECT 
          [sample_id],[session_id],[login_name],[database_name]
          ,[capture_time],[tran_start_time],[log_records]
          ,[log_bytes],[log_reserved],[last_sql_stmt],[last_exec_plan]
        FROM [dbo].[open_transactions_sample]
        ORDER BY [session_id],[login_name],[database_name],[tran_start_time]

      END -- list results
    
    END -- long running trans found
    ELSE
    BEGIN -- no long running trans
      PRINT CONVERT(varchar(30), GETDATE(),120) + ' - No long running transactions on ' + @serverName

    END -- no long running trans
  
  END TRY
  BEGIN CATCH
    -- is transaction in commitable state
    IF XACT_STATE() = -1
      ROLLBACK TRAN;

    SET @err = ERROR_NUMBER();
    SET @sev = ERROR_SEVERITY();
    SET @msg = ISNULL(ERROR_MESSAGE(),'< no message text>');
    SET @msg = 'ERROR: ' + CAST(ISNULL(@err,0) as varchar(10)) + ' - ' + @msg
    RAISERROR(@msg, @sev, 1) WITH LOG, NOWAIT;
  
  END CATCH

END -- procedure
GO  