SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @oldFileServer sysname = 'SDCPFILE01';
DECLARE @newFileServer sysname = 'SDCDVLFILE01';
DECLARE @sqlServer sysname = 'SDCDVLSQL01';
DECLARE @sev INT;
DECLARE @msg NVARCHAR(1000);
DECLARE @capNew VARCHAR(50);
DECLARE @cntrlprop VARCHAR(8000);
DECLARE @capStart INT;
DECLARE @capEnd INT;
DECLARE @capText VARCHAR(50);
DECLARE @cntrlNew VARCHAR(8000);
DECLARE @t VARCHAR(100);
DECLARE @s VARCHAR(100);
DECLARE @SQLString NVARCHAR(1000);
DECLARE @user NVARCHAR(256);
DECLARE @sqlStmt NVARCHAR(max);

SET @user = 'Wi2UAT.BugReports@au.knightfrank.com';

IF CAST(SERVERPROPERTY('ServerName') AS VARCHAR(50)) = 'SDCDVLSQL01'
BEGIN -- correct server
	IF EXISTS (SELECT 1 FROM sys.sysprocesses WHERE DB_NAME(dbid) = 'KFProd')
	BEGIN
		RAISERROR ('Active sessions found in KFProd. They must be closed/terminated before continuing.',16,1) WITH NOWAIT;
		SELECT sp.spid,sp.login_time,sp.last_batch
			,cast(sp.loginame AS VARCHAR(20)) AS login_name
			,cast(sp.hostname AS VARCHAR(10)) AS host_name
			,cast(sp.program_name AS VARCHAR(50)) AS program_name
		FROM sys.sysprocesses sp WHERE DB_NAME(dbid) = 'KFProd';
	END
	ELSE
	BEGIN -- no active sessions
		BEGIN TRY
			-- drop service broker routes to avoid communicating outside the DB
			IF EXISTS (SELECT 1 FROM KFProd.sys.routes WHERE NAME = N'KnightVisionBackendDBInitiatorServiceRoute')
				EXEC ('USE KFProd;DROP ROUTE [KnightVisionBackendDBInitiatorServiceRoute];');
			IF EXISTS (SELECT 1 FROM KFProd.sys.routes WHERE NAME = N'KnightVisionBackendDBTargetServiceRoute')
				EXEC ('USE KFProd;DROP ROUTE [KnightVisionBackendDBTargetServiceRoute]');
			RAISERROR ('Service broker routes dropped',10,1)WITH NOWAIT;

			IF EXISTS (SELECT 1 FROM sys.databases WHERE owner_sid <> SUSER_SID('sa') AND NAME = 'KFProd')
				ALTER AUTHORIZATION ON DATABASE::KFProd TO sa;
			RAISERROR ('KFProd owner set to "sa"',10,1)WITH NOWAIT;

			IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE NAME = 'KFProd' AND is_broker_enabled = 1)
				ALTER DATABASE KFProd SET ENABLE_BROKER;
			RAISERROR ('Service broker enabled for KFProd',10,1) WITH NOWAIT;

			IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE NAME = 'KFProd' AND is_trustworthy_on = 1)
				ALTER DATABASE KFProd SET TRUSTWORTHY ON;
			RAISERROR ('Trustworthy set for KFProd',10,1) WITH NOWAIT;

			ALTER QUEUE [KFProd].[dbo].[KnightVision_SourceDB_InitiatorQueue]
				WITH STATUS = ON
					,RETENTION = OFF
					,ACTIVATION (
						STATUS = ON
						,PROCEDURE_NAME = [KFProd].[dbo].[KF_KnightVision_ServiceBroker_Process_InitiatorQueue]
						,MAX_QUEUE_READERS = 1
						,EXECUTE AS N'KF_ServiceBroker'
					);
			ALTER QUEUE [KFProd].[dbo].[KnightVision_SourceDB_TargetQueue]
				WITH STATUS = ON
					,RETENTION = OFF
					,ACTIVATION (
						STATUS = ON
						,PROCEDURE_NAME = [KFProd].[dbo].[KF_KnightVision_ServiceBroker_Process_TargetQueue]
						,MAX_QUEUE_READERS = 1
						,EXECUTE AS N'KF_ServiceBroker'
					);
			ALTER QUEUE [KFProd].[dbo].[OutboundQueue]
				WITH STATUS = ON
					,RETENTION = OFF
					,ACTIVATION (
						STATUS = ON
						,PROCEDURE_NAME = [KFProd].[dbo].[KF_KnightVision_ServiceBroker_Process_OutboundQueue]
						,MAX_QUEUE_READERS = 1
						,EXECUTE AS N'KF_ServiceBroker'
					);
			RAISERROR ('Service Broker queues re-activated',10,1) WITH NOWAIT;

			-- clean up report queue items 
			DELETE FROM kfprod.dbo.mrirptqueue;
			RAISERROR ('mrirptqueue cleared',10,1) WITH NOWAIT;

			EXECUTE AS LOGIN = 'KF_ServiceBroker';

			-- update object definitions with new server name
			EXEC [KFProd].[dbo].[SP_UPDATE_SERVER] 
				@OldServer = @oldFileServer
				, @NewServer = @newFileServer;
			RAISERROR ('SP_UPDATE_SERVER has completed',10,1)WITH NOWAIT;
      
			-- disable triggers used for the MRI-FRC Interface
			EXEC [KFProd].[dbo].[spMRIFRCInterfaceDisableTriggers];
			RAISERROR ('[spMRIFRCInterfaceDisableTriggers] has completed',10,1)WITH NOWAIT;

			-- disable any interaction with KFProdAudit 
			EXEC [KFProd].[dbo].[KFSupport_DisableKFProdAudit];
			RAISERROR ('[KFSupport_DisableKFProdAudit] has completed',10,1)WITH NOWAIT;

			-- update tables in MRIMDB to reference DRP server
			UPDATE [MRIMDB].[dbo].[tb_System_ApplicationDatabase]
			SET [ServerName] = @sqlServer
				, [Description] = CASE WHEN PATINDEX('MRIX%',[Description]) = 0 THEN 'MRIX ' + [Description] ELSE [Description] END;
			RAISERROR('MRIMDB tb_System_ApplicationDatabase after update', 10, 0) WITH NOWAIT;
			SELECT [ServerName], [Database_name], [Description]
			FROM [MRIMDB].[dbo].[tb_System_ApplicationDatabase];

			-- update DRP KFProd users to match Production
			UPDATE [MRIMDB].[dbo].[MRIInstalledVersions]
			SET [LOCATION] = REPLACE(CAST([LOCATION] as nvarchar(4000)), @oldFileServer, @newFileServer);
			RAISERROR('MRIMDB MRIInstalledVersions after update', 10, 0) WITH NOWAIT;
			SELECT [VERSION],[LOCATION] FROM [MRIMDB].[dbo].[MRIInstalledVersions];
      
			-- update DRP KFProd users to match Production
			IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'kfprod_user')
				ALTER USER [kfprod_user] WITH LOGIN = [kfprod_user]
			IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'adoaccess')
				ALTER USER [adoaccess] WITH LOGIN = [adoaccess]

			RAISERROR('KFProd users after update', 10, 0) WITH NOWAIT;
			SELECT dp.[name] as [db_user], dp.[modify_date], sp.[name] as [srvr_login]
			FROM [KFProd].sys.database_principals dp
				LEFT JOIN [KFProd].sys.server_principals sp ON dp.[sid] = sp.[sid]
			WHERE dp.[type_desc] = 'SQL_USER' AND dp.[name] IN ('kfprod_user','adoaccess');

			-- update background color
			UPDATE [KFProd].[dbo].[MRIMenuObjects]
			SET cntrlprop = replace(convert(VARCHAR(8000), cntrlprop), 'backcolor= 16777215', 'BACKCOLOR= 13434879')
			WHERE mnugrpid = 'kf3'
				AND controltype = '@form'
				AND cast(cntrlprop AS VARCHAR(8000)) LIKE '%backcolor= 16777215%';
			-- update "last updated" caption
			SELECT TOP 1 @capNew = '~CAPTION=Data as at ' + CONVERT(VARCHAR(30), [restore_date], 103)
			FROM [msdb].[dbo].[restorehistory]
			WHERE [restore_type] = 'D'
				AND [destination_database_name] = 'kfprod'
			ORDER BY restore_date DESC;
			SELECT @cntrlprop = cntrlprop
			FROM [KFProd].[dbo].[MRIMenuObjects]
			WHERE mnugrpid = 'kf3'
				AND mriprop LIKE '~REALCAPTION=Data as at%'

			SET @capStart = patindex('%~CAPTION%', @cntrlprop);
			SET @capEnd = charindex('~', @cntrlprop, @capStart + 1);
			SET @capText = substring(@cntrlprop, @capStart, @capEnd - @capStart);
			SET @cntrlNew = replace(@cntrlProp, @capText, @capNew);

			UPDATE [KFProd].[dbo].[MRIMenuObjects]
			SET mriprop = '~REALCAPTION=Data as at ' + convert(VARCHAR(30), getdate(), 103)
				,cntrlprop = @cntrlNew
			WHERE mnugrpid = 'kf3'
				AND mriprop LIKE '~REALCAPTION=Data as at%'
			RAISERROR ('UPDATED Screen properties',10,1)WITH NOWAIT;

			-- clean up emails to our test user
			UPDATE [KFProd].[dbo].[PAS_User_Data] SET Email_Address = @user WHERE Email_Address IS NOT NULL;
			UPDATE [KFProd].[dbo].[PAS_User] SET EmailAddress = @user WHERE EmailAddress IS NOT NULL;
			UPDATE [KFProd].[dbo].MngRptDistributionList SET email = @user WHERE email IS NOT NULL;
			UPDATE [KFProd].[dbo].[KF_EFTREMIT] SET DETAILS = @User WHERE DETAILS IS NOT NULL;
			UPDATE [KFProd].[dbo].[MNGR] SET EMAIL = @user WHERE EMAIL IS NOT NULL;
			UPDATE [KFProd].[dbo].[LEASCONT] SET EMAIL = @user WHERE EMAIL IS NOT NULL AND CONTACTTYPE = 'INVC';
			UPDATE [KFProd].[dbo].[LEASCONT] SET EMAIL = @user WHERE EMAIL IS NOT NULL AND CONTACTTYPE = 'INV2';
			SET @sqlStmt = 'USE [KFProd];
				OPEN SYMMETRIC KEY IRESKey DECRYPTION BY CERTIFICATE IRES_CERT;
				UPDATE [KFPROD].[dbo].[BANK] SET REM_EMAIL = ''' + @user + ''' WHERE REM_EMAIL IS NOT NULL;';
				--CLOSE SYMMETRIC KEY IRESKey;'; -- trigger on BANK closes key
			EXEC [KFProd]..sp_ExecuteSQL @sqlStmt;
			RAISERROR ('UPDATED email address data',10,1)WITH NOWAIT;
			REVERT;

			DECLARE stmtList CURSOR FAST_FORWARD FOR
				SELECT DISTINCT 'USE KFProd;END CONVERSATION ''' + CAST([conversation_handle] as varchar(50)) + ''' WITH CLEANUP;'
				FROM KFProd.sys.conversation_endpoints
      
			OPEN stmtList
			FETCH NEXT FROM stmtList INTO @sqlStmt

			WHILE @@FETCH_STATUS = 0
			BEGIN
				RAISERROR(@sqlStmt,10,1) WITH NOWAIT
				EXEC KFProd.dbo.sp_ExecuteSQL @sqlStmt
      
				FETCH NEXT FROM stmtList INTO @sqlStmt

			END
			CLOSE stmtList
			DEALLOCATE stmtList
			RAISERROR ('Old SSB conversations removed',10,1) WITH NOWAIT;
		END TRY
		BEGIN CATCH
			SET @sev = ERROR_SEVERITY();
			SET @msg = ERROR_MESSAGE();
			SET @msg = ISNULL(@msg, '<no error message>');
			IF XACT_STATE() = - 1
				ROLLBACK TRANSACTION;
			RAISERROR (@msg,@sev,1) WITH NOWAIT;
		END CATCH

	END -- no active sessions
END -- correct server
ELSE
BEGIN
	RAISERROR ('ERROR This procedure should only be run on the SDCDVLSQL01 server',16,0) WITH NOWAIT;
END
