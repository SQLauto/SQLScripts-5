/********************************************************************************************
	Post Installation Configuration Script

	Does not handle:
	- Service login accounts
	- Startup trace flags
********************************************************************************************/

USE [master]
GO
EXEC sys.sp_configure 'show advanced', N'1'
GO
RECONFIGURE
GO
EXEC sys.sp_configure N'cost threshold for parallelism', N'35'
GO
EXEC sys.sp_configure N'max degree of parallelism', N'4'
GO
--EXEC sys.sp_configure 'min server memory (MB)', N'1024'
GO
EXEC sys.sp_configure N'max server memory (MB)', N'102400'
GO
EXEC sys.sp_configure N'backup compression default', N'1'
GO
EXEC sys.sp_configure N'optimize for ad hoc workloads', N'1'
GO
EXEC sys.sp_configure 'remote admin connections', N'1'
GO
--EXEC sys.sp_configure N'blocked process threshold (s)', N'20'
GO
--EXEC sys.sp_configure 'EKM provider enabled', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO
EXEC sys.sp_configure 'show advanced', N'0'
GO
RECONFIGURE
GO
DECLARE
	@Cmd NVARCHAR(256),
	@CurrDataSize INT,
	@CurrLogSize INT
/********************************************************************************************
	Configure Master Database
********************************************************************************************/
PRINT '	Configuring [master] database...'
	
SELECT @CurrDataSize = ((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = 'master' AND type_desc = 'ROWS'
SELECT @CurrLogSize = ((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = 'master' AND type_desc = 'LOG'
	
IF (@CurrDataSize) < 64
BEGIN
	PRINT '		Setting default size of [master] data file to 64MB...'
	ALTER DATABASE [master] MODIFY FILE ( NAME = N'master',SIZE = 64 MB ,FILEGROWTH = 16 MB );
END
ELSE
BEGIN
	PRINT '		Setting default growth of [master] data file to  ' + CAST((@CurrDataSize + 2) AS VARCHAR(10)) + 'MB...'
	SET @Cmd = 'ALTER DATABASE [master] MODIFY FILE ( NAME = N''master'',SIZE = ' + CAST((@CurrDataSize + 2) AS VARCHAR(10)) + ' MB ,FILEGROWTH = ' + CAST((@CurrDataSize*0.1) AS VARCHAR(10)) + ' MB );'
	EXEC sp_executesql @Cmd
END
	
IF (@CurrLogSize) < 16
BEGIN
	PRINT '		Setting default size of [master] log file to 16MB...'
	ALTER DATABASE [master] MODIFY FILE ( NAME = N'mastlog',SIZE = 16 MB ,FILEGROWTH = 8 MB );
END
ELSE
BEGIN
	PRINT '		Setting default growth of [master] log file to  ' + CAST((@CurrLogSize + 2) AS VARCHAR(10)) + 'MB...'
	SET @Cmd = 'ALTER DATABASE [master] MODIFY FILE ( NAME = N''mastlog'',SIZE = ' + CAST((@CurrLogSize + 2) AS VARCHAR(10)) + ' MB ,FILEGROWTH = ' + CAST((@CurrLogSize*0.1) AS VARCHAR(10)) + ' MB );'
	EXEC sp_executesql @Cmd
END
	
PRINT '	[master] database configured.'

/********************************************************************************************
	07
	Configure Model Database
********************************************************************************************/

--Configure the model database, ensures that 'Full' recovery model is used for newly created databases
PRINT '	Configuring [Model] database...'
USE [model];

DBCC SHRINKFILE (N'modellog', 0, TRUNCATEONLY);

USE [master];
PRINT '		Setting RECOVERY to FULL...'
ALTER DATABASE [model] SET RECOVERY FULL WITH NO_WAIT;
	
SELECT @CurrDataSize = ((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = 'model' AND type_desc = 'ROWS'
SELECT @CurrLogSize = ((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = 'model' AND type_desc = 'LOG'
	
IF (@CurrDataSize) < 128
BEGIN
	PRINT '		Setting default size of [model] data file to 128MB...'
	SET @Cmd = 'ALTER DATABASE [model] MODIFY FILE ( NAME = N''modeldev'',SIZE = 128 MB ,FILEGROWTH = 64 MB );'
	EXEC sp_executesql @Cmd
END
ELSE
BEGIN
	PRINT '		Setting default size of [model] data file to ' + CAST((@CurrDataSize + 2) AS VARCHAR(10)) + 'MB...'
	SET @Cmd = 'ALTER DATABASE [model] MODIFY FILE ( NAME = N''modeldev'',SIZE = ' + CAST((@CurrDataSize + 2) AS VARCHAR(10)) + ' MB ,FILEGROWTH = ' + CAST((@CurrDataSize*0.1) AS VARCHAR(10)) + ' MB );'
	EXEC sp_executesql @Cmd
END
	
IF (@CurrLogSize) < 32
BEGIN
	PRINT '		Setting default size of [model] log file to 32MB...'
	ALTER DATABASE [model] MODIFY FILE ( NAME = N'modellog',SIZE = 32 MB ,FILEGROWTH = 16 MB );
END
ELSE
BEGIN
	PRINT '		Setting default size of [model] log file to ' + CAST((@CurrLogSize + 2) AS VARCHAR(10)) + 'MB...'
	SET @Cmd = 'ALTER DATABASE [model] MODIFY FILE ( NAME = N''modeldev'',SIZE = ' + CAST((@CurrLogSize + 2) AS VARCHAR(10)) + ' MB ,FILEGROWTH = ' + CAST((@CurrLogSize*0.1) AS VARCHAR(10)) + ' MB );'
	EXEC sp_executesql @Cmd
END

USE [master]
PRINT '		Setting default options for AUTO_CLOSE, AUTO_CREATE_STATISTICS, AUTO_SHRINK and AUTO_UPDATE_STATISTICS...'
ALTER DATABASE [model] SET AUTO_CLOSE OFF WITH NO_WAIT
ALTER DATABASE [model] SET AUTO_CREATE_STATISTICS ON WITH NO_WAIT
ALTER DATABASE [model] SET AUTO_SHRINK OFF WITH NO_WAIT
ALTER DATABASE [model] SET AUTO_UPDATE_STATISTICS ON WITH NO_WAIT
	
PRINT '	[Model] configuration complete.'

/********************************************************************************************
	08
	Configure MSDB Database
********************************************************************************************/
--Configure the msdb database
PRINT '	Configuring [msdb] database...'
	
SELECT @CurrDataSize = ((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = 'msdb' AND type_desc = 'ROWS'
SELECT @CurrLogSize = ((size*8)/1024) FROM sys.master_files WHERE DB_NAME(database_id) = 'msdb' AND type_desc = 'LOG'
	
IF (@CurrDataSize) < 256
BEGIN
	PRINT '		Setting default size of [msdb] data file to 256MB...'
	ALTER DATABASE [msdb] MODIFY FILE ( NAME = N'MSDBData',SIZE = 256 MB ,FILEGROWTH = 64 MB );
END
ELSE
BEGIN
	PRINT '		Setting default growth of [msdb] data file to  ' + CAST((@CurrDataSize + 2) AS VARCHAR(10)) + 'MB...'
	SET @Cmd = 'ALTER DATABASE [msdb] MODIFY FILE ( NAME = N''MSDBData'',SIZE = ' + CAST((@CurrDataSize + 2) AS VARCHAR(10)) + ' MB ,FILEGROWTH = ' + CAST((@CurrDataSize*0.1) AS VARCHAR(10)) + ' MB );'
	EXEC sp_executesql @Cmd
END
	
IF (@CurrLogSize) < 64
BEGIN
	PRINT '		Setting default size of [msdb] log file to 64MB...'
	ALTER DATABASE [msdb] MODIFY FILE ( NAME = N'MSDBLog',SIZE = 64 MB ,FILEGROWTH = 32 MB );
END
ELSE
BEGIN
	PRINT '		Setting default growth of [msdb] log file to  ' + CAST((@CurrLogSize + 2) AS VARCHAR(10)) + 'MB...'
	SET @Cmd = 'ALTER DATABASE [msdb] MODIFY FILE ( NAME = N''MSDBLog'',SIZE = ' + CAST((@CurrLogSize + 2) AS VARCHAR(10)) + ' MB ,FILEGROWTH = ' + CAST((@CurrLogSize*0.1) AS VARCHAR(10)) + ' MB );'
	EXEC sp_executesql @Cmd
END
PRINT '	[msdb] database configured.'

/********************************************************************************************
	Configure TempDB Database
********************************************************************************************/
USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 1048576KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', SIZE = 1048576KB, MAXSIZE = UNLIMITED, FILEGROWTH = 1048576KB )
GO
USE [master]
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev2', FILENAME = N'H:\MSSQL\TempDB\tempdev2.ndf' , MAXSIZE = UNLIMITED, SIZE = 1048576KB , FILEGROWTH = 1048576KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev3', FILENAME = N'H:\MSSQL\TempDB\tempdev3.ndf' , MAXSIZE = UNLIMITED, SIZE = 1048576KB , FILEGROWTH = 1048576KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev4', FILENAME = N'H:\MSSQL\TempDB\tempdev4.ndf' , MAXSIZE = UNLIMITED, SIZE = 1048576KB , FILEGROWTH = 1048576KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev5', FILENAME = N'H:\MSSQL\TempDB\tempdev5.ndf' , MAXSIZE = UNLIMITED, SIZE = 1048576KB , FILEGROWTH = 1048576KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev6', FILENAME = N'H:\MSSQL\TempDB\tempdev6.ndf' , MAXSIZE = UNLIMITED, SIZE = 1048576KB , FILEGROWTH = 1048576KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev7', FILENAME = N'H:\MSSQL\TempDB\tempdev7.ndf' , MAXSIZE = UNLIMITED, SIZE = 1048576KB , FILEGROWTH = 1048576KB )
GO
ALTER DATABASE [tempdb] ADD FILE ( NAME = N'tempdev8', FILENAME = N'H:\MSSQL\TempDB\tempdev8.ndf' , MAXSIZE = UNLIMITED, SIZE = 1048576KB , FILEGROWTH = 1048576KB )
GO

--DBCC TraceOn(1117, 1118, -1)
GO



/********************************************************************************************
	Configure Error log retention
********************************************************************************************/
USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'NumErrorLogs', REG_DWORD, 99
GO

USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @jobhistory_max_rows=100000, 
		@jobhistory_max_rows_per_job=1000
GO
