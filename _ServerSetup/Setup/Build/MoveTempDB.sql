USE [master]
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', FILENAME = 'H:\MSSQL\TempDB\tempdb.mdf' )
GO
ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'templog', FILENAME = 'H:\MSSQL\TempDB\templog.ldf' )
GO


