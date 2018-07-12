USE [master]
GO
IF DB_ID('DBA') IS NULL
  CREATE DATABASE [DBA];
ELSE
BEGIN
  PRINT 'DBA database already exists!!';
  SET NOEXEC ON;
END  
GO

-- check if we've just created db
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE [name] = 'DBA'
      AND [create_date] > DATEADD(mi, -5, GETDATE())
  )
BEGIN  
  ALTER DATABASE [DBA] MODIFY FILE (NAME=N'DBA', NEWNAME=N'DBA_data');
  ALTER DATABASE [DBA] MODIFY FILE (NAME = N'DBA_data', SIZE = 5120KB , FILEGROWTH = 2048KB);
  ALTER DATABASE [DBA] MODIFY FILE (NAME = N'DBA_log', MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB);
  ALTER DATABASE [DBA] SET RECOVERY SIMPLE;
END  
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

EXEC sp_changedbowner 'sa';
GO

CREATE USER [dba_monitor] FOR LOGIN [dba_monitor];
GO

EXEC sp_addrolemember N'db_datareader', N'dba_monitor'
GO

EXEC sp_addrolemember N'db_datawriter', N'dba_monitor'
GO

SET NOEXEC OFF;
GO