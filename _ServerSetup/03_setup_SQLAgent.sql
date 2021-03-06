USE [msdb]
GO

-- set job history
EXEC msdb.dbo.sp_purge_jobhistory  
  @oldest_date='2011-04-12T13:37:29'
GO

EXEC msdb.dbo.sp_set_sqlagent_properties 
	@jobhistory_max_rows=100000
	, @jobhistory_max_rows_per_job=100
	, @email_save_in_sent_folder=1
	, @cpu_poller_enabled=1
	, @alert_replace_runtime_tokens=1
	, @databasemail_profile=N'default'
	, @use_databasemail=1
GO


---- set SQLAgent mail session
--EXEC master.dbo.xp_instance_regwrite 
--  N'HKEY_LOCAL_MACHINE'
--  , N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent'
--  , N'UseDatabaseMail'
--  , N'REG_DWORD'
--  , 1
--GO
--EXEC master.dbo.xp_instance_regwrite 
--  N'HKEY_LOCAL_MACHINE'
--  , N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent'
--  , N'DatabaseMailProfile'
--  , N'REG_SZ'
--  , N'default'
--GO

-- Add SQLAlerts operator
IF NOT EXISTS (SELECT name FROM msdb.dbo.sysoperators WHERE name = N'SQLAlerts')
  EXEC msdb.dbo.sp_add_operator 
    @name=N'SQLAlerts'
    , @enabled=1
    , @weekday_pager_start_time=90000
    , @weekday_pager_end_time=180000
    , @saturday_pager_start_time=90000
    , @saturday_pager_end_time=180000
    , @sunday_pager_start_time=90000
    , @sunday_pager_end_time=180000
    , @pager_days=0
    , @email_address=N'sqlalerting@au.knightfrank.com'
    , @category_name=N'[Uncategorized]'
ELSE
	PRINT 'SQLAlerts operator exists'
GO

-- Add SQLAlerts operator
IF NOT EXISTS (SELECT name FROM msdb.dbo.sysoperators WHERE name = N'DBA')
  EXEC msdb.dbo.sp_add_operator 
    @name=N'DBA'
    , @enabled=1
    , @weekday_pager_start_time=90000
    , @weekday_pager_end_time=180000
    , @saturday_pager_start_time=90000
    , @saturday_pager_end_time=180000
    , @sunday_pager_start_time=90000
    , @sunday_pager_end_time=180000
    , @pager_days=0
    , @email_address=N'phil.carter@au.knightfrank.com'
    , @category_name=N'[Uncategorized]'
ELSE
	PRINT 'DBA operator exists'
GO

-- set fail-safe operator
EXEC master.dbo.sp_MSsetalertinfo 
  @failsafeoperator=N'DBA'
  , @notificationmethod=1
GO


-- Add default set of Alerts
DECLARE @job_id uniqueidentifier;
DECLARE @alrt int;
DECLARE @alrtNm sysname;
SET @alrt = 17;
SET @alrtNm = 'Severity_' + cast(@alrt as nvarchar(10));


WHILE @alrt <= 25
BEGIN
  
  IF NOT EXISTS (
	  SELECT id 
	  FROM msdb.dbo.sysalerts
	  WHERE name = @alrtNm
	)
  BEGIN -- add alert
	exec msdb.dbo.sp_add_alert 
		@name = @alrtNm
		, @severity = @alrt
		, @enabled=1
		, @delay_between_responses=60
		, @include_event_description_in=7
		, @job_id=N'00000000-0000-0000-0000-000000000000'

	exec msdb.dbo.sp_add_notification 
		@alert_name=@alrtNm
		, @operator_name=N'SQLAlerts'
		, @notification_method = 1;

	PRINT 'Alert ' + @alrtNm + ' created'

  END -- add alert
  ELSE
	PRINT 'Alert ' + @alrtNm + ' exists'

  SET @alrt = @alrt + 1;
  SET @alrtNm = 'Severity_' + cast(@alrt as nvarchar(10));

END

-- add disk i/o alerts
IF NOT EXISTS (
  SELECT id 
  FROM msdb.dbo.sysalerts
  WHERE name = N'Error_823'
)
BEGIN -- add alert
	EXEC msdb.dbo.sp_add_alert 
		@name=N'Error_823'
		, @message_id=823
		, @severity = 0
		, @enabled=1
		, @delay_between_responses=60
		, @include_event_description_in=7
		, @job_id=N'00000000-0000-0000-0000-000000000000'

	exec msdb.dbo.sp_add_notification 
		@alert_name=N'Error_823'
		, @operator_name=N'SQLAlerts'
		, @notification_method = 1;

END

IF NOT EXISTS (
  SELECT id 
  FROM msdb.dbo.sysalerts
  WHERE name = N'Error_824'
)
BEGIN -- add alert
	EXEC msdb.dbo.sp_add_alert 
		@name=N'Error_824'
		, @message_id=824
		, @severity = 0
		, @enabled=1
		, @delay_between_responses=60
		, @include_event_description_in=7
		, @job_id=N'00000000-0000-0000-0000-000000000000'

	exec msdb.dbo.sp_add_notification 
		@alert_name=N'Error_824'
		, @operator_name=N'SQLAlerts'
		, @notification_method = 1;

END

IF NOT EXISTS (
  SELECT id 
  FROM msdb.dbo.sysalerts
  WHERE name = N'Error_825'
)
BEGIN -- add alert
	EXEC msdb.dbo.sp_add_alert 
		@name=N'Error_825'
		, @message_id=825
		, @severity = 0
		, @enabled=1
		, @delay_between_responses=60
		, @include_event_description_in=7
		, @job_id=N'00000000-0000-0000-0000-000000000000'

	exec msdb.dbo.sp_add_notification 
		@alert_name=N'Error_825'
		, @operator_name=N'SQLAlerts'
		, @notification_method = 1;

END
	

	USE [msdb]
GO

GO

