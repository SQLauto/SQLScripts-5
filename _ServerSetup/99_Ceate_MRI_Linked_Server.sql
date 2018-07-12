

DECLARE @RealName sysname
DECLARE @SrvrName sysname
DECLARE @RemoteUser sysname
DECLARE @RemotePwd sysname

--SET @RealName = ISNULL((SELECT REPLACE(CAST(ServerProperty('MachineName') as nvarchar(128)), 'VS', 'MRI')), N'DEVMRISQL01')

SET @RealName = N'DRPSQLCLU01\MRI'
SET @SrvrName = N'MRI'
SET @RemoteUser = N'SQLLink'
SET @RemotePwd = N'WLZPZ7vU7Jxnu2IoVM3c'

-- remove existing linked server
IF EXISTS (
      SELECT 1
      FROM sys.servers srv 
      WHERE srv.server_id != 0 
        AND srv.name = @SrvrName
    )
  EXEC master.dbo.sp_dropserver @server=@SrvrName, @droplogins='droplogins'

-- create linked server
EXEC master.dbo.sp_addlinkedserver @server = @SrvrName
  , @srvproduct = N' ', @provider = N'SQLOLEDB'
  , @datasrc = @RealName, @catalog = N'KFProd'

-- drop linked server login
IF EXISTS (
      SELECT 1
      FROM sys.linked_logins lgn
        inner join sys.servers svr
        on lgn.[server_id] = svr.[server_id]
      WHERE svr.[name] = @SrvrName
        AND lgn.[remote_name] = @RemoteUser
    )  
  EXEC master.dbo.sp_droplinkedsrvlogin @rmtsrvname = @SrvrName, @locallogin = @RemoteUser

-- create linked server login
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = @SrvrName, @locallogin = NULL , @useself = N'False', @rmtuser = @RemoteUser, @rmtpassword = @RemotePwd

-- set linked server options
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'collation compatible', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'data access', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'dist', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'pub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'rpc', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'rpc out', @optvalue=N'true'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'sub', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'connect timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'collation name', @optvalue=null
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'lazy schema validation', @optvalue=N'false'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'query timeout', @optvalue=N'0'
EXEC master.dbo.sp_serveroption @server=@SrvrName, @optname=N'use remote collation', @optvalue=N'false'



