
create event session session_waits 
  on server
    add event sqlos.wait_info (
      WHERE sqlserver.session_id=73 and duration>0
    )
    , add event sqlos.wait_info_external (
    WHERE sqlserver.session_id=73 and duration>0
    )
    add target package0.asynchronous_file_target (
      SET filename=N'F:\TraceData\EventData\wait_stats.xel'
        , metadatafile=N'F:\TraceData\EventData\wait_stats.xem'
    );
GO

create view dbo.read_xe_file 
as
  select 
    object_name as event
    , CONVERT(xml, event_data) as data
  from sys.fn_xe_file_target_read_file ('F:\TraceData\EventData\wait_stats*.xel', 'F:\TraceData\EventData\wait_stats*.xem', null, null)
go

create view dbo.xe_file_table 
as
  select
    event
    , data.value('(/event/data/text)[1]','nvarchar(50)') as 'wait_type'
    , data.value('(/event/data/value)[3]','int') as 'duration'
    , data.value('(/event/data/value)[6]','int') as 'signal_duration'
from dbo.read_xe_file
go

create procedure dbo.usp_DBA_SessionWaits 
  @spid int
  , @duration int
as
begin
  set nocount on;
  
  declare @sqlStmt nvarchar(500);
  declare @waitText varchar(10);
  
  -- delete any previous files
  exec xp_cmdshell 'del F:\TraceData\EventData\wait_stats*.xel', no_output;
  exec xp_cmdshell 'del F:\TraceData\EventData\wait_stats*.xem', no_output;
  
  -- build WAITFOR DELAY period in format HH:MM:SS
  set @waitText = CASE WHEN @duration/3600 < 10 THEN '0' ELSE '' END   
        + RTRIM(@duration/3600) + ':' + RIGHT('0' + RTRIM((@duration % 3600) / 60),2)  
        + ':' + RIGHT('0' + RTRIM((@duration % 3600) % 60),2);
  
  -- remove existing events
  alter event session session_waits 
    on server 
      drop event sqlos.wait_info
      , drop event sqlos.wait_info_external;

  -- build dynamic sql statement to track waits for specified SPID
  set @sqlStmt = N'alter event session session_waits '
    + N'on server add event sqlos.wait_info ( '
    + N'where sqlserver.session_id = ' + cast(@spid as nvarchar(10))
    + N' and duration > 0), add event sqlos.wait_info_external ( '
    + N'where sqlserver.session_id = ' + cast(@spid as nvarchar(10))
    + N' and duration > 0);'
  exec sp_executeSQL @sqlStmt
  
  -- start event session
  alter event session session_waits 
    on server state = start;

  -- wait for duration specified
  waitfor delay @waitText

  -- stop session
  alter event session session_waits 
    on server state = stop;

  -- show results
  select
    wait_type
    , sum(duration) as 'total_duration'
    , sum(signal_duration) as 'total_signal_duration'
  from dbo.xe_file_table
  group by wait_type
  order by sum(duration) desc;

end
go

