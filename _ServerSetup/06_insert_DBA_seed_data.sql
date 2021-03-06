USE [DBA]
GO

IF NOT EXISTS (select 1 from dbo.nums)
BEGIN
  DECLARE @rows INT

  SET @rows = 1000000
  -- prime the table
  INSERT INTO dbo.nums VALUES (1)

  -- loop around while rows are being inserted
  WHILE @@rowcount > 0
  BEGIN
    INSERT dbo.nums
    SELECT t.n + x.MaxRowNum   FROM dbo.nums t
      CROSS JOIN (SELECT MAX(n) MaxRowNum FROM dbo.nums) x
    WHERE t.n <= @rows - x.MaxRowNum
  END
END  
GO

IF NOT EXISTS (select [ProfileName] from [dbo].[EMailProfiles] where [ProfileName] = 'DBA')
BEGIN
  INSERT [dbo].[EMailProfiles] (
    [ProfileName], [DBMailProfile], [FromName], [FromAddress]
    , [ReplyToAddress], [ToAddress], [SMTPServer], [SMTPPort]
    , [TimeoutMS], [Priority], [ContentType], [HTMLStyleCSS], [ForSMS]
  ) VALUES (
    N'DBA', N'default', @@SERVERNAME, N'do-not-reply@au.knightfrank.com'
    , N'do-not-reply@au.knightfrank.com', N'sqlalerting@au.knightfrank.com'
    , NULL, NULL, NULL, N'HIGH', N'TEXT', NULL, 0
  )
END

IF NOT EXISTS (select [ProfileName] from [dbo].[EMailProfiles] where [ProfileName] = 'DBA_HTML')
BEGIN
  INSERT [dbo].[EMailProfiles] (
    [ProfileName], [DBMailProfile], [FromName], [FromAddress]
    , [ReplyToAddress], [ToAddress], [SMTPServer], [SMTPPort]
    , [TimeoutMS], [Priority], [ContentType], [HTMLStyleCSS], [ForSMS]
  ) VALUES (
    N'DBA_HTML', N'default', @@SERVERNAME, N'do-not-reply@au.knightfrank.com'
    , N'do-not-reply@au.knightfrank.com', N'sqlalerting@au.knightfrank.com'
    , NULL, NULL, NULL, N'HIGH', N'HTML'
    , N'<STYLE>body,table,div,span{font-family: Arial, Helvetica, sans-serif;font-size: small;color: #000000;}</STYLE>', 0
  )
END

IF NOT EXISTS (select [ProfileName] from [dbo].[EMailProfiles] where [ProfileName] = 'SDESK')
BEGIN
  INSERT [dbo].[EMailProfiles] (
    [ProfileName], [DBMailProfile], [FromName], [FromAddress]
    , [ReplyToAddress], [ToAddress], [SMTPServer], [SMTPPort]
    , [TimeoutMS], [Priority], [ContentType], [HTMLStyleCSS], [ForSMS]
  ) VALUES (
    N'SDESK', N'ServiceDesk', @@SERVERNAME, N'do-not-reply@au.knightfrank.com'
    , N'do-not-reply@au.knightfrank.com', N'servicedesk@au.knightfrank.com'
    , NULL, NULL, NULL, N'HIGH', N'TEXT', NULL, 0
  )
END

IF NOT EXISTS (select [ProfileName] from [dbo].[EMailProfiles] where [ProfileName] = 'SDESK_HTML')
BEGIN
  INSERT [dbo].[EMailProfiles] (
    [ProfileName], [DBMailProfile], [FromName], [FromAddress]
    , [ReplyToAddress], [ToAddress], [SMTPServer], [SMTPPort]
    , [TimeoutMS], [Priority], [ContentType], [HTMLStyleCSS], [ForSMS]
  ) VALUES (
    N'SDESK_HTML', N'ServiceDesk', @@SERVERNAME, N'do-not-reply@au.knightfrank.com'
    , N'do-not-reply@au.knightfrank.com', N'servicedesk@au.knightfrank.com'
    , NULL, NULL, NULL, N'HIGH', N'HTML'
    , N'<STYLE>body,table,div,span{font-family: Arial, Helvetica, sans-serif;font-size: small;color: #000000;}</STYLE>', 0
  )
END
GO

IF NOT EXISTS (select [latest_date] from [dbo].[error_log_latestDate])
BEGIN
  INSERT INTO [dbo].[error_log_latestDate] ([latest_date]) 
  VALUES ('01 Jan 1900')
END
GO

IF NOT EXISTS (select [OptionCode] from [dbo].[CTConfig] where [OptionCode] = 'DatabaseVersion')
BEGIN
  INSERT INTO [dbo].[CTConfig] ([OptionCode],[OptionValue]) 
  VALUES ('DatabaseVersion', '2');
END
GO

IF NOT EXISTS (select 1 from [dbo].[CTDateDimension])
BEGIN
  DECLARE @theDate datetime;
  SET @theDate = '2000-01-01';

  INSERT INTO [dbo].[CTDateDimension] (
    [CalendarDate],[DayOfWeekNum],[DayOfWeekName]
    ,[DayOfMonthNum],[DayOfYearNum],[WeekInYearNum]
    ,[MonthInYearNum],[MonthName]
  )  
  SELECT 
    DATEADD(dd,n.n-1,@theDate) as [CalendarDate]
    , DATEPART(DW,DATEADD(dd,n.n-1,@theDate)) as [DayOfWeekNum]
    , DATENAME(DW,DATEADD(dd,n.n-1,@theDate)) as [DayOfWeekName]
    , DATEPART(DD,DATEADD(dd,n.n-1,@theDate)) as [DayOfMonthNum]
    , DATEPART(DY,DATEADD(dd,n.n-1,@theDate)) as [DayOfYearNum]
    , DATEPART(WW,DATEADD(dd,n.n-1,@theDate)) as [WeekInYearNum]
    , DATEPART(MM,DATEADD(dd,n.n-1,@theDate)) as [MonthInYearNum]
    , DATENAME(MM,DATEADD(dd,n.n-1,@theDate)) as [MonthName]
  FROM dbo.nums n
  WHERE n.n <= 18628; -- 50 years

END
GO

