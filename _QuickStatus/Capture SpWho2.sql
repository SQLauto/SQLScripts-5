USE [DBA]
GO

/****** Object:  StoredProcedure [dbo].[Log_SpWho2]    Script Date: 30/01/2014 1:48:32 PM ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log_SpWho2]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Log_SpWho2]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log_SpWho2]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[Log_SpWho2]
AS
BEGIN -- procedure
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[results_spwho2]'') AND type in (N''U''))
	BEGIN
		CREATE TABLE [dbo].[results_spwho2](
			[RecID] bigint IDENTITY(1,1) PRIMARY KEY,
			[ServerName] varchar(100) DEFAULT(CONVERT(varchar(100),SERVERPROPERTY(''ServerName''))),
			[SampleDate] datetime DEFAULT(GETDATE()),
			[SPID] int NOT NULL,
			[Status] [varchar](50) NOT NULL,
			[Login] [varchar](100) NOT NULL,
			[HostName] [varchar](100) NOT NULL,
			[BlkBy] [varchar](10) NOT NULL,
			[DBName] [varchar](128) NULL,
			[Command] [varchar](128) NOT NULL,
			[CPUTime] int NOT NULL,
			[DiskIO] int NOT NULL,
			[LastBatch] [varchar](20) NOT NULL,
			[ProgramName] [varchar](150) NOT NULL,
			[SPID2] int NOT NULL,
			[REQUESTID] [varchar](50) NOT NULL
		);
	END

	INSERT INTO [dbo].[results_spwho2](
		[SPID],[Status],[Login],[HostName],[BlkBy],[DBName],[Command]
		,[CPUTime],[DiskIO],[LastBatch],[ProgramName],[SPID2],[REQUESTID]
	)
	EXEC SP_WHO2;

END -- procedure' 
END
GO

USE [msdb]
GO

/****** Object:  Job [DBA - Capture SpWho2]    Script Date: 30/01/2014 1:48:00 PM ******/
IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA - Capture SpWho2')
EXEC msdb.dbo.sp_delete_job @job_name = N'DBA - Capture SpWho2', @delete_unused_schedule=1
GO

/****** Object:  Job [DBA - Capture SpWho2]    Script Date: 30/01/2014 1:48:00 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 30/01/2014 1:48:00 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
select @jobId = job_id from msdb.dbo.sysjobs where (name = N'DBA - Capture SpWho2')
if (@jobId is NULL)
BEGIN
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - Capture SpWho2', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END
/****** Object:  Step [sample]    Script Date: 30/01/2014 1:48:01 PM ******/
IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobsteps WHERE job_id = @jobId and step_id = 1)
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sample', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC dbo.Log_SpWho2', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Hourly', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20140130, 
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

