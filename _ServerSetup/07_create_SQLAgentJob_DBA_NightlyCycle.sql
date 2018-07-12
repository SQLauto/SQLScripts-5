USE [msdb]
GO

/****** Object:  Job [DBA - Nightly Cycle]    Script Date: 02/21/2012 09:21:18 ******/
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'DBA - Nightly Cycle')
  EXEC msdb.dbo.sp_delete_job @job_name = N'DBA - Nightly Cycle', @delete_unused_schedule=1
GO

/****** Object:  Job [DBA - Nightly Cycle]    Script Date: 02/21/2012 09:17:41 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
DECLARE @SavePath nvarchar(500);
DECLARE @CmdText nvarchar(max);
DECLARE @CrLf CHAR(2);
DECLARE @Ver nvarchar(20);
DECLARE @subsys nvarchar(128);
DECLARE @dbName nvarchar(128);
DECLARE @BackupDirectory VARCHAR(100) 

SET @CrLf = CHAR(13) + CHAR(10);
SET @ReturnCode = 0;
SET @Ver = cast(serverproperty('productVersion') as nvarchar(128));
SET @ver = LEFT(@ver, charindex('.',@ver)-1)

EXEC master..xp_instance_regread 
  @rootkey='HKEY_LOCAL_MACHINE' 
  ,@key='Software\Microsoft\MSSQLServer\MSSQLServer'
  ,@value_name='BackupDirectory'
  ,@BackupDirectory=@BackupDirectory OUTPUT 

/****** Object:  JobCategory [Database Maintenance]    Script Date: 02/21/2012 09:17:41 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
  EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
  IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode = msdb.dbo.sp_add_job 
    @job_name=N'DBA - Nightly Cycle', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Nightly Cycle of error logs, script jobs, etc...', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'DBA', 
		@job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [SampleErrorLog]    Script Date: 02/21/2012 09:17:41 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep 
    @job_id=@jobId, 
    @step_name=N'SampleErrorLog', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dbo.usp_sample_ErrorLogEvents', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CycleSQLErrorLog]    Script Date: 02/21/2012 09:17:42 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep 
    @job_id=@jobId, 
    @step_name=N'CycleSQLErrorLog', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dbo.sp_cycle_errorlog', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [CycleSQLAgentLog]    Script Date: 02/21/2012 09:17:42 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep 
    @job_id=@jobId, 
    @step_name=N'CycleSQLAgentLog', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec dbo.usp_Cycle_SQLAgentLog', 
		@database_name=N'DBA', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ScriptLogins]    Script Date: 02/21/2012 09:17:42 ******/

SET @SavePath = @BackupDirectory + '\SQLLogins\';
SET @subsys = N'TSQL';
SET @dbName = N'DBA';
SET @CmdText = N'exec [dbo].[usp_Script_Logins] @outputDir = ''' + @SavePath + '''';

EXEC @ReturnCode = msdb.dbo.sp_add_jobstep 
    @job_id=@jobId, 
    @step_name=N'ScriptLogins', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, 
		@subsystem=@subsys, 
		@command=@CmdText, 
		@database_name=@dbName, 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

/****** Object:  Step [ScriptJobs]    Script Date: 02/21/2012 09:17:42 ******/

SET @SavePath = @BackupDirectory + '\SQLJobs\';

IF CAST(@Ver as int) > 9
BEGIN
  -- SQL 2008 and higher use Powershell
  SET @subsys = N'PowerShell'
  SET @dbName = N'DBA'
  SET @CmdText = N'[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null'
    + @CrLf + '$outDir = "' + @SavePath + N'"' + @CrLf
    + '$server = "' + CAST(SERVERPROPERTY('ServerName') as nvarchar(256)) + N'"' + @CrLf
    + @CrLf + '$serverPath = $server -replace "\\", "$"' + @CrLf
    + '$srv = New-Object Microsoft.SqlServer.Management.Smo.Server("$server") ' + @CrLf
    + @CrLf + '#create scripter object and set options' + @CrLf
    + '$scrp = New-Object Microsoft.SqlServer.Management.Smo.Scripter($srv) ' + @CrLf
    + '$scrp.Options.DriAll=$False' + @CrLf
    + '$scrp.Options.IncludeHeaders=$False' + @CrLf
    + '$scrp.Options.WithDependencies=$False' + @CrLf
    + @CrLf + '$jobs = $srv.JobServer.get_Jobs() ' + @CrLf
    + '$jobs = $jobs | Where-Object {$_.Name -notlike "sys*"}     ' + @CrLf
    + @CrLf + 'foreach($job in $jobs) {   ' + @CrLf
    + '  $jobName = $job.Name' + @CrLf
    + '  if (($jobName -match ("[?:\\/*""<>|]")) -eq "true"){' + @CrLf
    + '    $jobName = $jobName -replace ("[?:\\/*""<>|]"), "#"  ' + @CrLf
    + '  }' + @CrLf
    + '  $jobOutputFile = $outDir + $serverPath  + "_SQLAgentJob_" + $jobName + ".sql"' + @CrLf
    + '  "Scripting SQL Agent Job: $job to $jobOutputFile"' + @CrLf
    + '  if ((Test-Path -Path "$jobOutputFile") -eq "true"){' + @CrLf
    + '    Remove-Item $jobOutputFile -Force -Recurse' + @CrLf
    + '  }' + @CrLf
    + '  #script job drop' + @CrLf
    + '  $scrp.Options.ScriptDrops=$True;' + @CrLf
    + '  $scrp.Options.IncludeIfNotExists=$True;' + @CrLf
    + '  $jobScript = $scrp.Script($job)' + @CrLf
    + '  $jobScript >> $jobOutputFile' + @CrLf
    + @CrLf + '#script job creation' + @CrLf
    + '  $scrp.Options.ScriptDrops=$False;' + @CrLf
    + '  $scrp.Options.IncludeIfNotExists=$False;' + @CrLf
    + '  $jobScript = $scrp.Script($job)' + @CrLf
    + '  #set @enabled=0 so job is disabled when script is run' + @CrLf
    + '  $jobScript = $jobScript -replace "@enabled=1","@enabled=0"' + @CrLf
    + '  $jobScript >> $jobOutputFile' + @CrLf
    + '} ' + @CrLf
END
ELSE
BEGIN
  -- SQL 2005 and lower use VBScript
  SET @subsys = N'ActiveScripting'
  SET @dbName = N'VBScript'
  SET @CmdText = N'option explicit' + @CrLf
    + @CrLf + 'Dim oSrvr, srvrName, oFso, oFile, oJB, SQLDMOScript_Drops' + @CrLf
    + 'Dim jobScript, jobName, outputFile, basePath' + @CrLf
    + @CrLf + 'srvrName = "' + CAST(SERVERPROPERTY('ServerName') as nvarchar(256)) + N'"' + @CrLf
    + 'basePath = "' + @SavePath + N'"' + @CrLf
    + 'outputFile = ""' + @CrLf
    + 'jobName = ""' + @CrLf
    + 'SQLDMOScript_Drops = 1' + @CrLf
    + @CrLf + 'set oFso = CreateObject("Scripting.FileSystemObject")' + @CrLf
    + 'Set oSrvr = CreateObject("SQLDMO.SQLServer")' + @CrLf
    + 'oSrvr.LoginSecure = True' + @CrLf
    + 'oSrvr.Connect srvrName' + @CrLf
    + @CrLf + 'For Each oJB in oSrvr.JobServer.Jobs' + @CrLf
    + '  jobName = oJB.Name' + @CrLf
    + '  jobName = Replace(jobName, "\", "")' + @CrLf
    + '  jobName = Replace(jobName, "/", "")' + @CrLf
    + '  jobName = Replace(jobName, ":", "")' + @CrLf
    + '  jobName = Replace(jobName, "*", "")' + @CrLf
    + '  jobName = Replace(jobName, "?", "")' + @CrLf
    + '  jobName = Replace(jobName, "''", "")' + @CrLf
    + '  jobName = Replace(jobName, "<", "")' + @CrLf
    + '  jobName = Replace(jobName, ">", "")' + @CrLf
    + '  jobName = Replace(jobName, "|", "")' + @CrLf
    + '	outputFile = basePath & srvrName & "_sqlagent_" & jobName & ".sql"' + @CrLf
    + @CrLf + '  jobScript = "--========================================--" & vbCrLf' + @CrLf
    + '  jobScript = jobScript & "-- SCRIPTING JOB: " & jobName & vbCrLf' + @CrLf
    + '  jobScript = jobScript & "--------------------------------------------" & vbCrLf' + @CrLf
    + '  jobScript = jobScript & oJB.Script(SQLDMOScript_Drops) & vbCrLf' + @CrLf
    + '  jobScript = jobScript & "--------------------------------------------" & vbCrLf' + @CrLf
    + '  jobScript = jobScript & oJB.Script() & vbCrLf' + @CrLf
    + '  jobScript = jobScript & "--------------------------------------------" & vbCrLf' + @CrLf
    + '  jobScript = jobScript & "-- Disable Job" & vbCrLf' + @CrLf
    + '  jobScript = jobScript & "--------------------------------------------" & vbCrLf' + @CrLf
    + '  jobScript = jobScript & "exec msdb..sp_update_job @job_name = ''" & jobName & "'', @enabled = 0" & vbCrLf' + @CrLf
    + '  jobScript = jobScript & "--========================================--" & vbCrLf' + @CrLf
    + @CrLf + '  jobScript = Replace(jobScript, "@server_name = N''' 
    + CAST(SERVERPROPERTY('ServerName') as nvarchar(256)) + N'''", "@server_name = @@SERVERNAME")' + @CrLf
    + '  jobScript = Replace(jobScript, "@server = N''' + CAST(SERVERPROPERTY('ServerName') as nvarchar(256)) 
    + N'''", "@server = @@SERVERNAME")' + @CrLf
    + '  jobScript = Replace(jobScript, "@owner_login_name = ", "@owner_login_name = ''sa''--")' + @CrLf
    + @CrLf + '  set oFile = oFso.CreateTextFile(outputFile, True)' + @CrLf
    + '  oFile.Write (jobScript)' + @CrLf
    + '  oFile.Close' + @CrLf
    + @CrLf + 'Next' + @CrLf + 'oSrvr.Close' + @CrLf 
    + 'set oSrvr = Nothing' + @CrLf
    + 'Set oFso = Nothing' + @CrLf

END
    
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep 
    @job_id=@jobId, 
    @step_name=N'ScriptJobs', 
	  @cmdexec_success_code=0, 
	  @on_success_action=3, 
	  @on_success_step_id=0, 
	  @on_fail_action=3, 
	  @on_fail_step_id=0, 
	  @retry_attempts=0, 
	  @retry_interval=0, 
	  @os_run_priority=0, 
	  @subsystem=@subsys, 
	  @command=@CmdText, 
	  @database_name=@dbName, 
	  @flags=0

IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO


