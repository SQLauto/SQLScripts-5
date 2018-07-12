-- STEP 1 : Create Your @destination_table
-- addl info http://www.brentozar.com/responder/log-sp_whoisactive-to-a-table/

DECLARE @destination_table VARCHAR(4000) ;
SET @destination_table = 'WhoIsActive_' + CONVERT(VARCHAR, GETDATE(), 112) ;
 
DECLARE @schema VARCHAR(4000) ;

EXEC [DBA].[dbo].[sp_WhoIsActive] 
@find_block_leaders = 1 
, @output_column_list = '[collection_time],[session_id][block%][login_name][database%][host%][host_process_id][program%][sql_text][wait_info][read%][write%][cpu%]' 
,@get_transaction_info = 1
,@get_plans = 1
,@RETURN_SCHEMA = 1
,@SCHEMA = @schema OUTPUT ;



 
SET @schema = REPLACE(@schema, '<table_name>', @destination_table) ;
 
PRINT @schema
EXEC(@schema) ;


-- step 2 : Create Your Loop to Periodically Log Data
DECLARE
    @destination_table VARCHAR(4000) ,
    @msg NVARCHAR(1000) ;
 
SET @destination_table = 'WhoIsActive_' + CONVERT(VARCHAR, GETDATE(), 112) ;
 
DECLARE @numberOfRuns INT ;
SET @numberOfRuns = 2 ;
 
WHILE @numberOfRuns > 0
    BEGIN;
        EXEC dbo.sp_WhoIsActive @find_block_leaders = 1 
			, @output_column_list = '[collection_time],[session_id][block%][login_name][database%][host%][host_process_id][program%][sql_text][wait_info][read%][write%][cpu%]' 
			,@get_transaction_info = 1
			,@get_plans = 1
            ,@DESTINATION_TABLE = @destination_table ;
 
        SET @numberOfRuns = @numberOfRuns - 1 ;
 
        IF @numberOfRuns > 0
            BEGIN
                SET @msg = CONVERT(CHAR(19), GETDATE(), 121) + ': ' +
                 'Logged info. Waiting...'
                RAISERROR(@msg,0,0) WITH nowait ;
 
                WAITFOR DELAY '00:00:05'
            END
        ELSE
            BEGIN
                SET @msg = CONVERT(CHAR(19), GETDATE(), 121) + ': ' + 'Done.'
                RAISERROR(@msg,0,0) WITH nowait ;
            END
 
    END ;
GO

-- Step 3: Set Up Your Query to Look at the Results
DECLARE @destination_table NVARCHAR(2000), @dSQL NVARCHAR(4000) ;
SET @destination_table = 'WhoIsActive_' + CONVERT(VARCHAR, GETDATE(), 112) ;
SET @dSQL = N'SELECT * FROM dbo.' +
 QUOTENAME(@destination_table) + N' order by 1 desc' ;
print @dSQL
EXEC sp_executesql @dSQL
