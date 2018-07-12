USE [DBA]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[open_transactions_sample]') AND type in (N'U'))
DROP TABLE [dbo].[open_transactions_sample]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[open_transactions_sample](
	[session_id] [smallint] NOT NULL,
	[capture_time] [datetime] NOT NULL,
	[host_name] [nvarchar](128) NULL,
	[program_name] [nvarchar](128) NULL,
	[login_name] [nvarchar](128) NOT NULL,
	[login_time] [datetime] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[last_request_end_time] [datetime] NULL,
	[db_name] [nvarchar](128) NULL,
	[status] [nvarchar](30) NOT NULL,
	[command] [nvarchar](16) NOT NULL,
	[blocking_session_id] [smallint] NULL,
	[wait_type] [nvarchar](60) NULL,
	[wait_time] [int] NOT NULL,
	[last_wait_type] [nvarchar](60) NOT NULL,
	[wait_resource] [nvarchar](256) NOT NULL,
	[open_transaction_count] [int] NOT NULL,
	[open_resultset_count] [int] NOT NULL,
	[cpu_time] [int] NOT NULL,
	[total_elapsed_time] [int] NOT NULL,
	[reads] [bigint] NOT NULL,
	[writes] [bigint] NOT NULL,
	[logical_reads] [bigint] NOT NULL,
	[tsql_stmt] [nvarchar](max) NULL,
	[query_plan] [xml] NULL
) ON [PRIMARY]

GO


USE [DBA]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_LongRunningTranAlert]
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
      [session_id],[capture_time],[host_name],[program_name],[login_name],[login_time]
      ,[start_time],[last_request_end_time],[db_name],[status],[command]
      ,[blocking_session_id],[wait_type],[wait_time],[last_wait_type],[wait_resource]
      ,[open_transaction_count],[open_resultset_count],[cpu_time],[total_elapsed_time]
      ,[reads],[writes],[logical_reads],[tsql_stmt],[query_plan]
    )
    SELECT 
      er.[session_id],GETDATE() as [capture_time],es.[host_name],es.[program_name]
      ,es.[login_name],es.[login_time],es.[last_request_start_time],es.[last_request_end_time]
      ,db_name(er.database_id) as [db_name],er.[status],er.[command]
      ,er.[blocking_session_id],er.[wait_type],er.[wait_time],er.[last_wait_type]
      ,er.[wait_resource],er.[open_transaction_count],er.[open_resultset_count]
      ,er.[cpu_time],er.[total_elapsed_time],er.[reads],er.[writes]
      ,er.[logical_reads],est.[text] as [tsql_stmt],eqp.[query_plan]
    FROM sys.dm_exec_requests er
      INNER JOIN sys.dm_exec_sessions es on er.session_id = es.session_id
      CROSS APPLY sys.dm_exec_sql_text (er.[sql_handle]) AS est
      CROSS APPLY sys.dm_exec_query_plan (er.[plan_handle]) AS eqp
    WHERE er.[session_id] != @@SPID;

    IF EXISTS (
        SELECT 1
        FROM [dbo].[open_transactions_sample]
        WHERE [start_time] IS NOT NULL
          AND DATEDIFF(mi,[start_time],GETDATE()) > @tran_len_mins
      )
    BEGIN -- long running trans found
      IF @sendEmail = 'Y'
      BEGIN -- email results

        SET @emailMessage = CAST((
              SELECT 
                td = ISNULL(cast([session_id] as varchar(50)),'NULL'), ''
                ,td = ISNULL(convert(varchar(50),[capture_time],120),'NULL'), ''
                ,td = ISNULL([host_name],'NULL'), ''
                ,td = ISNULL([program_name],'NULL'), ''
                ,td = ISNULL([login_name],'NULL'), ''
                ,td = ISNULL(convert(varchar(50),[start_time],120),'NULL'), ''
                ,td = ISNULL([db_name],'NULL'), ''
                ,td = ISNULL([status],'NULL'), ''
                ,td = ISNULL([command],'NULL'), ''
                ,td = ISNULL(cast([blocking_session_id] as varchar(50)),'NULL'), ''
                ,td = ISNULL(cast([open_transaction_count] as varchar(50)),'NULL'), ''
                ,td = ISNULL(cast([cpu_time] as varchar(50)),'NULL'), ''
                ,td = ISNULL(cast([total_elapsed_time] as varchar(50)),'NULL'), ''
                ,td = ISNULL(cast([reads] as varchar(50)),'NULL'), ''
                ,td = ISNULL(cast([writes] as varchar(50)),'NULL'), ''
                ,td = ISNULL(cast([logical_reads] as varchar(50)),'NULL'), ''
                ,td = ISNULL(LEFT([tsql_stmt], 100) + '...','NULL'), ''
              FROM [dbo].[open_transactions_sample]
              WHERE [start_time] IS NOT NULL
                AND DATEDIFF(mi,[start_time],GETDATE()) > 15--@tran_len_mins
              ORDER BY [start_time]
              FOR XML PATH('tr'), TYPE  
            ) AS NVARCHAR(MAX) );

        SET @emailMessage = N'<BODY><H3>Long Running Transactions on ' 
          + @serverName + N'</H3><table border="1"><tr>'
          + N'<th>session id</th>'
          + N'<th>capture time</th>'
          + N'<th>host name</th>'
          + N'<th>program name</th>'
          + N'<th>login name</th>'
          + N'<th>start time</th>'
          + N'<th>db name</th>'
          + N'<th>status</th>'
          + N'<th>command</th>'
          + N'<th>blocking session id</th>'
          + N'<th>open transaction count</th>'
          + N'<th>cpu time</th>'
          + N'<th>total elapsed time</th>'
          + N'<th>reads</th>'
          + N'<th>writes</th>'
          + N'<th>logical reads</th>'
          + N'<th>tsql stmt</th></tr>' + @emailMessage
          + N'</table></BODY>';

        EXEC [dbo].[usp_SendEmail]
          @EmailProfile = @emailProfile
          , @Subject = @emailSubject
          , @MsgBody = @emailMessage
      
      END -- email results
      ELSE
      BEGIN -- list results
        SELECT 
          [session_id],[capture_time],[host_name],[program_name],[login_name],[login_time]
          ,[start_time],[last_request_end_time],[db_name],[status],[command],[blocking_session_id]
          ,[wait_type],[wait_time],[last_wait_type],[wait_resource],[open_transaction_count]
          ,[open_resultset_count],[cpu_time],[total_elapsed_time],[reads],[writes]
          ,[logical_reads],[tsql_stmt],[query_plan]
        FROM [dbo].[open_transactions_sample]
        ORDER BY [start_time] DESC

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

USE [msdb]
GO

/****** Object:  Job [DBA - Check for Long Running Transactions]    Script Date: 04/16/2012 11:43:27 ******/
IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA - Check for Long Running Transactions')
EXEC msdb.dbo.sp_delete_job @job_name = N'DBA - Check for Long Running Transactions', @delete_unused_schedule=1
GO

USE [msdb]
GO

/****** Object:  Job [DBA - Check for Long Running Transactions]    Script Date: 04/16/2012 11:43:27 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 04/16/2012 11:43:27 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Check for Long Running Transactions', 
		@enabled=0, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'SQLAlerts', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CheckLongRunningTrans]    Script Date: 04/16/2012 11:43:28 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'CheckLongRunningTrans', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC [dbo].[usp_LongRunningTranAlert] 
  @tran_len_mins = 15
  ,@sendEmail = ''Y''
  ,@emailProfile = ''DBA_HTML''', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Every5Mins', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20110712, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


