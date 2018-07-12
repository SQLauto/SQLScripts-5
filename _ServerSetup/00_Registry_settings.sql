
USE [master]
GO

exec xp_cmdshell 'MD F:\SQLData'
exec xp_cmdshell 'MD L:\SQLLogs'

EXEC xp_instance_regwrite 
	N'HKEY_LOCAL_MACHINE'
	,N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer'
	,N'DefaultData'
	,REG_SZ
	,N'F:\SQLData'
GO
EXEC xp_instance_regwrite 
	N'HKEY_LOCAL_MACHINE'
	,N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer'
	,N'DefaultLog'
	,REG_SZ
	,N'L:\SQLLogs'
GO

EXEC xp_instance_regwrite 
	N'HKEY_LOCAL_MACHINE'
	,N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer'
	,N'FullTextDefaultPath'
	,REG_SZ
	,N'F:\SQLData'
GO
EXEC xp_instance_regwrite 
	N'HKEY_LOCAL_MACHINE'
	,N'SOFTWARE\Microsoft\MSSQLServer\MSSQLServer'
	,N'BackupDirectory'
	,REG_SZ
	,N'\\pasvfile02\Backups'
GO

EXEC xp_instance_regwrite 
  N'HKEY_LOCAL_MACHINE'
  , N'Software\Microsoft\MSSQLServer\MSSQLServer'
  , N'NumErrorLogs'
  , REG_DWORD
  , 31
GO

EXEC sys.sp_configure N'show advanced options', N'1'
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'max degree of parallelism', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure N'show advanced options', N'0'
RECONFIGURE WITH OVERRIDE
GO
