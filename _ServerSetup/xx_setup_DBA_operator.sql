
-- create DBA operator
USE [msdb]
GO
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
    , @email_address=N'sqlalerting@au.knightfrank.com'
    , @category_name=N'[Uncategorized]'
GO

-- set fail-safe operator
USE [msdb]
GO
EXEC master.dbo.sp_MSsetalertinfo 
  @failsafeoperator=N'DBA'
  , @notificationmethod=1
GO
