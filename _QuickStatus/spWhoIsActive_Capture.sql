
DECLARE @schema VARCHAR(4000);
EXEC sp_WhoIsActive 
  @find_block_leaders = 1 
  , @output_column_list = '[collection_time][session_id][block%][login_name][database%][host%][host_process_id][program%][sql_text][wait_info]' 
  , @sort_order = '[blocked_session_count] DESC'
  , @RETURN_SCHEMA = 1
  , @SCHEMA = @schema OUTPUT ;
SET @schema = REPLACE(@schema, '<table_name>', 'WhoIsActive_blocking') ;
SET @schema = 'IF EXISTS(SELECT 1 FROM sys.tables WHERE [name] = ''WhoIsActive_blocking'') DROP TABLE [WhoIsActive_blocking]
' + @schema;
PRINT @schema;
EXEC(@schema);

set nocount on
set dateformat dmy

DECLARE @destination_table VARCHAR(4000)
declare @statusMsg varchar(500)
declare @waitText varchar(10);

set @waitText = '00:00:10'; -- 10 seconds
SET @destination_table = 'WhoIsActive_blocking';

while 1=1
begin -- infinite loop
  if exists (
      select 1 from sys.dm_os_waiting_tasks 
      where blocking_session_id <> 0 
        and blocking_session_id <> @@spid
        and wait_duration_ms > 2000
    )
  begin -- blocking exists
    EXEC sp_WhoIsActive 
      @find_block_leaders = 1 
      , @output_column_list = '[collection_time][session_id][block%][login_name][database%][host%][host_process_id][program%][sql_text][wait_info]' 
      , @sort_order = '[blocked_session_count] DESC'
      , @DESTINATION_TABLE = @destination_table;

    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - inserted ' + cast(@@ROWCOUNT as varchar(10)) 
      + ' blocking row(s) into ' + @destination_table;
    raiserror(@statusMsg,10,1) WITH NOWAIT;

  end -- blocking exists

  waitfor delay @waitText

end -- infinite loop
GO