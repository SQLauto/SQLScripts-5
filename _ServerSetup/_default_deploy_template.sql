USE [<database_Name, sysname, db_Name>]
GO

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET NOCOUNT ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO

PRINT CONVERT(varchar(30), GETDATE(), 120) + N'- << object1 change description >>';
GO
BEGIN TRY

  -- object1 change script

END TRY
BEGIN CATCH
  IF XACT_STATE() = -1
    ROLLBACK TRAN;

  DECLARE @sev int;
  DECLARE @msg nvarchar(1000);
  SET @msg = ISNULL(ERROR_MESSAGE(),'< no message text>');
  SET @sev = ERROR_SEVERITY();
    
  RAISERROR(@msg, @sev, 1) WITH NOWAIT;
  SET NOEXEC ON;

END CATCH
GO

PRINT CONVERT(varchar(30), GETDATE(), 120) + N'- << object2 change description >>';
GO
BEGIN TRY

  -- object2 change script

END TRY
BEGIN CATCH
  IF XACT_STATE() = -1
    ROLLBACK TRAN;

  DECLARE @sev int;
  DECLARE @msg nvarchar(1000);
  SET @msg = ISNULL(ERROR_MESSAGE(),'< no message text>');
  SET @sev = ERROR_SEVERITY();
    
  RAISERROR(@msg, @sev, 1) WITH NOWAIT;
  SET NOEXEC ON;

END CATCH
GO

IF @@TRANCOUNT > 0 
BEGIN
  PRINT CONVERT(varchar(30), GETDATE(), 120) + N'- Database updates successfully processed';
  COMMIT TRANSACTION;
END
ELSE 
  PRINT CONVERT(varchar(30), GETDATE(), 120) + N'- Database update failed due to previous errors';
GO


