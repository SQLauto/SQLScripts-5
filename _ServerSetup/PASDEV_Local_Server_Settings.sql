EXEC sys.sp_configure N'show advanced options', N'1'  
RECONFIGURE WITH OVERRIDE
GO

IF CAST(SERVERPROPERTY('ServerName') as varchar(50)) LIKE 'KFA5%SQL2K8R2'
BEGIN -- correct DB

  EXEC sys.sp_configure N'max server memory (MB)', N'2048'
  ALTER SERVER CONFIGURATION SET PROCESS AFFINITY CPU = 0,2
  EXEC sys.sp_configure N'affinity I/O mask', N'10'
  EXEC sys.sp_configure N'affinity64 I/O mask', N'10'
  EXEC sys.sp_configure N'max worker threads', N'128'
  EXEC sys.sp_configure N'backup compression default', N'1'
  EXEC sys.sp_configure N'max degree of parallelism', N'1'
  RECONFIGURE

END -- correct DB
ELSE
BEGIN
  RAISERROR('ERROR: This should only be run on the local Developer machines.', 16, 0) WITH NOWAIT;
END
GO
EXEC sys.sp_configure N'show advanced options', N'0'  
RECONFIGURE WITH OVERRIDE
GO