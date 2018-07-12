USE [master]
GO

-- check if databaseMail is enabled
IF NOT EXISTS(
		SELECT 1
		FROM [master].[sys].[configurations]
		WHERE [name] = 'Database Mail XPs'
			AND [value_in_use] = 1
	)
BEGIN -- enable database mail
	RAISERROR('INFO: Enabling Database Mail XPs', 10, 1) WITH NOWAIT;
	EXEC sp_configure 'show advanced options', 1;
	RECONFIGURE;
	EXEC sp_configure 'Database Mail XPs', 1;
	RECONFIGURE;
END -- enable database mail
ELSE
BEGIN 
	RAISERROR('INFO: Database Mail is already enabled', 10, 1) WITH NOWAIT;
END -- database mail already enabled
GO
SET NOCOUNT ON;

DECLARE @sendTestEmail INT = 1;
DECLARE @testEmailRecipient varchar(50) = 'Phil.Carter@au.knightfrank.com';
DECLARE @testEmailSubject varchar(100) = '';
DECLARE @testEmailBody varchar(500) = '';
DECLARE @rv INT = 0;
DECLARE @msgText NVARCHAR(500) = N'';
DECLARE @CurrID INT = 0;
DECLARE @MaxID INT = 0;
DECLARE @systemName SYSNAME = '';
DECLARE @smtpServer SYSNAME = '';
DECLARE @profileName SYSNAME = '';
DECLARE @profileDesc NVARCHAR(256) = '';
DECLARE @accountName SYSNAME = '';
DECLARE @fromAddress NVARCHAR(128) = '';
DECLARE @displayName NVARCHAR(128) = '';
DECLARE @serverName NVARCHAR(128) = CAST(SERVERPROPERTY('ServerName') as varchar(50));
-- create temp table for mail profiles/accounts to create
IF OBJECT_ID('TempDB..#MailSetup') IS NOT NULL DROP TABLE #MailSetup;
CREATE TABLE #MailSetup (
	[ID] int NOT NULL IDENTITY(1,1) PRIMARY KEY
	, [systemName] SYSNAME NOT NULL
	, [smtpServer] SYSNAME NOT NULL
	, [profileName] SYSNAME NOT NULL
	, [profileDesc] NVARCHAR(256) NOT NULL
	, [accountName] SYSNAME NOT NULL
	, [fromAddress] NVARCHAR(128) NOT NULL
	, [displayName] NVARCHAR(128) NOT NULL
);
-- populate temp table
INSERT INTO #MailSetup ([systemName], [smtpServer], [profileName], [profileDesc], [accountName], [fromAddress], [displayName])
VALUES ('ALL','au-sdcmbx-01','default','Default system mail profile','default','do-not-reply@au.knightfrank.com',REPLACE(CAST(SERVERPROPERTY('ServerName') AS NVARCHAR(128)), '\', '$'))
, ('ALL','au-sdcmbx-01','ServiceDesk','profile for Service Desk emails','ServiceDesk','service_desk@au.knightfrank.com','Service Desk')
, ('MRI','au-sdcmbx-01','Support','profile for MRI emails to users','MRISupport','do-not-reply@au.knightfrank.com','MRI Support')
, ('VISION','au-sdcmbx-01','Vision','profile for VISION System messages to users','Vision','do-not-reply@au.knightfrank.com','Vision System Message')
, ('MRI','au-sdcmbx-01','SPSBanking','profile for SPS Banking group to email users','SPSBanking','SPS.Banking@au.knightfrank.com','SPS Banking')
, ('VISION','au-sdcmbx-01','HRPortal','profile for HRPortal System messages to users','HRPortal','do-not-reply@au.knightfrank.com','HR Portal')

-- initialise ID variable
SET @CurrID = ISNULL((SELECT MIN([ID]) FROM #MailSetup),0);
SET @msgText = 'INFO: Checking/Creating ' + CAST(ISNULL((SELECT COUNT([ID]) FROM #MailSetup),0) AS VARCHAR(10)) + ' DatabaseMail profiles on ' + @serverName;
RAISERROR(@msgText, 10, 1) WITH NOWAIT;
WHILE (@CurrID <= ISNULL((SELECT MAX([ID]) FROM #MailSetup),-1))
BEGIN -- loop through setup table
	-- get variable values from table
	SET @systemName = ISNULL((SELECT [systemName] FROM #MailSetup WHERE [ID] = @CurrID),NULL);
	SET @smtpServer = ISNULL((SELECT [smtpServer] FROM #MailSetup WHERE [ID] = @CurrID),NULL);
	SET @profileName = ISNULL((SELECT [profileName] FROM #MailSetup WHERE [ID] = @CurrID),NULL);
	SET @profileDesc = ISNULL((SELECT [profileDesc] FROM #MailSetup WHERE [ID] = @CurrID),NULL);
	SET @accountName = ISNULL((SELECT [accountName] FROM #MailSetup WHERE [ID] = @CurrID),NULL);
	SET @fromAddress = ISNULL((SELECT [fromAddress] FROM #MailSetup WHERE [ID] = @CurrID),NULL);
	SET @displayName = ISNULL((SELECT [displayName] FROM #MailSetup WHERE [ID] = @CurrID),NULL);
	-- check that all values where retrieved
	IF (ISNULL(@systemName + @smtpServer + @profileName + @profileDesc + @accountName + @fromAddress + @displayName, 'BLANK') <> 'BLANK')
	BEGIN -- all values where retrieved
		-- check if profile/account valid for this server
		IF ((@serverName LIKE '%' + @systemName + '%') OR (@systemName = 'ALL'))
		BEGIN -- create profile/account on server
			-- check if profile exists
			IF NOT EXISTS (SELECT * FROM msdb.dbo.sysmail_profile WHERE name = @profileName)
			BEGIN -- create the profile
				BEGIN TRAN;

				EXEC @rv = msdb.dbo.sysmail_add_profile_sp
					@profile_name = @profileName
					, @description = @profileDesc;

				IF @rv = 0
				BEGIN -- profile created
					COMMIT;
					SET @msgText = 'INFO: DatabaseMail profile (' + @profileName + ') was created.'
					RAISERROR(@msgText, 10, 1) WITH NOWAIT;
				END -- profile created
				ELSE
				BEGIN -- error creating profile
					ROLLBACK TRAN;
					SET @msgText = 'ERROR: Return value ' + cast(@rv as varchar(10)) + ' received creating DatabaseMail profile (' + @profileName + ').'
					RAISERROR(@msgText, 10, 1) WITH NOWAIT;
				END; -- error creating profile
			END -- create the profile
			ELSE
			BEGIN -- error profile exists
				SET @msgText = 'INFO: DatabaseMail profile (' + @profileName + ') already exists.'
				RAISERROR(@msgText, 10, 1) WITH NOWAIT;
			END; -- error profile exists

			-- check if account exists
			IF NOT EXISTS (SELECT * FROM msdb.dbo.sysmail_account WHERE name = @accountName )
			BEGIN -- create the account
				BEGIN TRAN;

				EXEC @rv =msdb.dbo.sysmail_add_account_sp
					@account_name = @accountName
					, @email_address = @fromAddress
					, @replyto_address = @fromAddress
					, @display_name = @displayName
					, @mailserver_name = @smtpServer;

				IF @rv = 0
				BEGIN -- account created
					COMMIT;
					SET @msgText = 'INFO: DatabaseMail account (' + @accountName + ') was created.'
					RAISERROR(@msgText, 10, 1) WITH NOWAIT;
				END -- account created
				ELSE
				BEGIN -- error creating account
					ROLLBACK TRAN;
					SET @msgText = 'ERROR: Return value ' + cast(@rv as varchar(10)) + ' received creating DatabaseMail account (' + @accountName + ').'
					RAISERROR(@msgText, 10, 1) WITH NOWAIT;
				END -- error creating account
			END -- create the account
			ELSE
			BEGIN -- acccount exists
				SET @msgText = 'INFO: DatabaseMail account (' + @accountName + ') already exists.'
				RAISERROR(@msgText, 10, 1) WITH NOWAIT;
			END; -- acccount exists

			-- check is account <-> profile association exists
			IF NOT EXISTS (
					SELECT 1
					FROM [msdb].[dbo].[sysmail_profileaccount] pa
						INNER JOIN [msdb].[dbo].[sysmail_profile] p ON pa.[profile_id] = p.[profile_id]
						INNER JOIN [msdb].[dbo].[sysmail_account] a ON pa.[account_id] = a.[account_id]
					WHERE p.[name] = @profileName
						AND a.[name] = @accountName
				)
			BEGIN -- Associate the account with the profile.
				BEGIN TRAN;

				EXEC @rv = msdb.dbo.sysmail_add_profileaccount_sp
					@profile_name = @profileName
					, @account_name = @accountName
					, @sequence_number = 1 ;
 
				IF @rv = 0
				BEGIN -- account/profile association created
					COMMIT;
					SET @msgText = 'INFO: DatabaseMail profile (' + @profileName + ') was associated with account (' + @accountName + ').'
					RAISERROR(@msgText, 10, 1) WITH NOWAIT;
				END -- account/profile association created
				ELSE
				BEGIN -- error associating account/profile
					ROLLBACK TRANSACTION;
					SET @msgText = 'ERROR: Return value ' + cast(@rv as varchar(10)) + ' received associating the profile (' + @profileName + ') with the account (' + @accountName + ').'
					RAISERROR(@msgText, 10, 1) WITH NOWAIT;
				END; -- error associating account/profile
			END -- Associate the account with the profile.
			ELSE
			BEGIN -- acccount already associated
				SET @msgText = 'INFO: Account (' + @accountName + ') already associated with profile (' + @profileName + ').'
				RAISERROR(@msgText, 10, 1) WITH NOWAIT;
			END; -- acccount already associated

			-- grant public access to profiles
			IF NOT EXISTS (
					SELECT 1
					FROM [msdb].[dbo].[sysmail_principalprofile] pp
						INNER JOIN [msdb].[dbo].[sysmail_profile] p on pp.[profile_id] = p.[profile_id]
						INNER JOIN [msdb].[sys].[database_principals] dp on pp.[principal_sid] = dp.[sid]
					WHERE p.[name] = @profileName
						AND dp.[name] = 'Guest'
				)
			BEGIN -- grant guest access to profile
				BEGIN TRAN;

				EXEC @rv = msdb.dbo.sysmail_add_principalprofile_sp 
					@principal_name=N'guest'
					, @profile_name=@profileName
					, @is_default=0;

				IF @rv = 0
				BEGIN -- guest access granted
					COMMIT;
					SET @msgText = 'INFO: Guest Access was granted to profile (' + @profileName + ') with the account (' + @accountName + ').'
					RAISERROR(@msgText, 10, 1) WITH NOWAIT;
				END -- guest access granted
				ELSE
				BEGIN -- error granting guest access
					ROLLBACK TRANSACTION;
					SET @msgText = 'ERROR: Return value ' + cast(@rv as varchar(10)) + ' received granting guest access to profile (' + @profileName + ') with the account (' + @accountName + ').'
					RAISERROR(@msgText, 10, 1) WITH NOWAIT;
				END -- error granting guest access
			END; -- grant guest access to profile
			ELSE
			BEGIN -- guest access already Granted
				SET @msgText = 'INFO: Guest access already granted to profile (' + @profileName + ').'
				RAISERROR(@msgText, 10, 1) WITH NOWAIT;
			END; -- guest access already Granted

			IF @sendTestEmail = 1
			BEGIN
				SET @testEmailSubject = '[TEST] Email sent at ' + CONVERT(varchar(30), CURRENT_TIMESTAMP, 120);
				SET @testEmailBody = 'Test only, please ignore.' + CHAR(13)+CHAR(10) + 'Email sent at ' + CONVERT(varchar(30), CURRENT_TIMESTAMP, 120);
				SET @testEmailBody = @testEmailBody + CHAR(13)+CHAR(10) + '@systemName = ' + ISNULL(@systemName,'< no system name>');
				SET @testEmailBody = @testEmailBody + CHAR(13)+CHAR(10) + '@serverName = ' + ISNULL(@serverName,'< no server name>');
				SET @testEmailBody = @testEmailBody + CHAR(13)+CHAR(10) + '@smtpServer = ' + ISNULL(@smtpServer,'< no SMTP server name>');
				SET @testEmailBody = @testEmailBody + CHAR(13)+CHAR(10) + '@profileName = ' + ISNULL(@profileName,'< no profile name>');
				SET @testEmailBody = @testEmailBody + CHAR(13)+CHAR(10) + '@profileDesc = ' + ISNULL(@profileDesc,'< no profile description>');
				SET @testEmailBody = @testEmailBody + CHAR(13)+CHAR(10) + '@accountName = ' + ISNULL(@accountName,'< no account name>');
				SET @testEmailBody = @testEmailBody + CHAR(13)+CHAR(10) + '@fromAddress = ' + ISNULL(@fromAddress,'< no from email address>');
				SET @testEmailBody = @testEmailBody + CHAR(13)+CHAR(10) + '@displayName = ' + ISNULL(@displayName,'< no display name>');

				EXEC msdb.dbo.sp_send_dbmail 
					@profile_name = @profileName
					, @recipients = @testEmailRecipient
					, @subject = @testEmailSubject
					, @body = @testEmailBody

			END
		END -- create profile/account on server
		ELSE
		BEGIN -- profile/account not for this server
			SET @msgText = 'INFO: Server (' + @serverName + ') is not a ' + @systemName + ' server, profile (' + @profileName + ') not created.';
			RAISERROR(@msgText, 10, 1) WITH NOWAIT;
		END -- profile/account not for this server
	END -- all values where retrieved
	ELSE
	BEGIN -- missing profile/account values
		SET @msgText = 'ERROR: Missing setup values,';
		RAISERROR(@msgText, 10, 1) WITH NOWAIT;
		SET @msgText = '@systemName = ' + ISNULL(@systemName,'< no system name>');
		RAISERROR(@msgText, 10, 1) WITH NOWAIT;
		SET @msgText = '@smtpServer = ' + ISNULL(@smtpServer,'< no SMTP server name>');
		RAISERROR(@msgText, 10, 1) WITH NOWAIT;
		SET @msgText = '@profileName = ' + ISNULL(@profileName,'< no profile name>');
		RAISERROR(@msgText, 10, 1) WITH NOWAIT;
		SET @msgText = '@profileDesc = ' + ISNULL(@profileDesc,'< no profile description>');
		RAISERROR(@msgText, 10, 1) WITH NOWAIT;
		SET @msgText = '@accountName = ' + ISNULL(@accountName,'< no account name>');
		RAISERROR(@msgText, 10, 1) WITH NOWAIT;
		SET @msgText = '@fromAddress = ' + ISNULL(@fromAddress,'< no from email address>');
		RAISERROR(@msgText, 10, 1) WITH NOWAIT;
		SET @msgText = '@displayName = ' + ISNULL(@displayName,'< no display name>');
		RAISERROR(@msgText, 10, 1) WITH NOWAIT;

	END -- missing profile/account values

	-- increment ID number
	SET @CurrID += 1;

END -- loop through setup table

SET @msgText = 'INFO: Open transactions ' + CAST(@@TRANCOUNT AS VARCHAR (30))
RAISERROR(@msgText, 10, 1) WITH NOWAIT;
GO
