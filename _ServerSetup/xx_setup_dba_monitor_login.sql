USE [master]
GO

IF SUSER_ID('dba_monitor') IS NULL 
BEGIN
  CREATE LOGIN [dba_monitor] 
  WITH PASSWORD=N'[DB@R3p0s1t0ry]'
    , DEFAULT_DATABASE=[DBA]
    , CHECK_EXPIRATION=OFF
    , CHECK_POLICY=OFF
END
GO

USE [DBA]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'dba_monitor')
CREATE USER [dba_monitor] 
  FOR LOGIN [dba_monitor] 
  WITH DEFAULT_SCHEMA=[dbo]
GO

USE [DBA]
GO
EXEC sp_addrolemember N'db_ddladmin', N'dba_monitor'
GO
USE [DBA]
GO
EXEC sp_addrolemember N'db_datawriter', N'dba_monitor'
GO
USE [DBA]
GO
EXEC sp_addrolemember N'db_datareader', N'dba_monitor'
GO
