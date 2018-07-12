
-- create stub if procedure doesn't exist
IF NOT EXISTS (
  SELECT 1 FROM INFORMATION_SCHEMA.ROUTINES 
  WHERE SPECIFIC_SCHEMA = N'<Schema_Name, sysname, Schema_Name>'
    AND SPECIFIC_NAME = N'<Procedure_Name, sysname, Procedure_Name>' 
  )
  EXEC sp_ExecuteSQL @statement = N'CREATE PROCEDURE <Schema_Name, sysname, Schema_Name>.<Procedure_Name, sysname, Procedure_Name> 
  AS
  BEGIN 
    SELECT 1;
  END'
GO

ALTER PROCEDURE <Schema_Name, sysname, Schema_Name>.<Procedure_Name, sysname, ProcedureName>
	-- Add the parameters for the stored procedure here
	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>
	, <@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- start testing code
--
--
-- end testing code
BEGIN -- procedure
	SET NOCOUNT ON;
  SET XACT_ABORT ON;
  -- only if required
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

  -- declare local variables
	DECLARE @err int; -- error number
	DECLARE @sev int; -- error severity
	DECLARE @proc nvarchar(126); -- error procedure
	DECLARE @msg nvarchar(1000);  -- error message
  -- NOTE: Only use default for local variable for SQL 2008
  DECLARE <@localVar1, sysname, @v1> <Datatype_For_Var1, , int> = <Default_Value_For_Var1, , 0>;
  DECLARE <@localVar2, sysname, @v2> <Datatype_For_Var2, , int> = <Default_Value_For_Var2, , 0>;

  BEGIN TRY
    
    -- only if explicitly required
    BEGIN TRAN;

    -- procedure statements here
    SELECT <@Param1, sysname, @p1>
      , <@Param2, sysname, @p2>
      , <@localVar1, sysname, @v1>
      , <@localVar2, sysname, @v2>;

    COMMIT TRAN;
    
  END TRY
  BEGIN CATCH
    IF XACT_STATE() = -1
      ROLLBACK TRAN;

		SET @err = ERROR_NUMBER();
		SET @sev = ERROR_SEVERITY();
		SET @proc = ISNULL(ERROR_PROCEDURE(),'<no procedure>');
		SET @msg = ISNULL(ERROR_MESSAGE(),'<no message text>');
		SET @msg = 'ERROR: ' + CAST(ISNULL(@err,0) as varchar(10)) 
			+ ' - ' + @proc + ': ' + @msg
      
    RAISERROR(@msg, @sev, 1) WITH LOG, NOWAIT;
    SET NOEXEC ON;

  END CATCH;
  
END -- procedure
GO

