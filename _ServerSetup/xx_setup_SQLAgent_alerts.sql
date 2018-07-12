USE [msdb];
GO

-- Add SQLAlerts operator
EXEC dbo.sp_add_operator 
  @name=N'SQLAlerts'
  , @enabled=1
  , @email_address=N'sqlalerting@au.knightfrank.com';
GO

-- Add default set of Alerts
DECLARE @alrt int;
DECLARE @alrtNm sysname;
SET @alrt = 17;
SET @alrtNm = 'Severity_' + cast(@alrt as nvarchar(10));


WHILE @alrt < 26
BEGIN
  exec sp_add_alert 
    @name = @alrtNm
    , @severity = @alrt
    , @delay_between_responses=60;

  exec sp_add_notification @alert_name = @alrtNm
    , @operator_name = 'SQLAlerts'
    , @notification_method = 1;  

  SET @alrt = @alrt + 1;
  SET @alrtNm = 'Severity_' + cast(@alrt as nvarchar(10));

END

