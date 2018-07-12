use MyDBA
go

create procedure dbo.usp_MyDBA_spwho 
	@include_sys_processes bit  = 0
	, @active_only bit = 0
	, @blocking_only bit = 0
as
begin -- procedure
	set nocount on
	set dateformat dmy

	select
		sess.session_id
		, blkr.session_id as blocking
		, wt.blocking_session_id as blocked_by
		, db_name(er.database_id) as db_name
		, sess.login_name
		, sess.host_name
		, sess.last_request_start_time	
		, sess.last_request_end_time
		, sess.status
		, sess.program_name
		, sess.cpu_time
		, sess.memory_usage
		, sess.total_elapsed_time
		, sess.reads
		, sess.writes
		, sess.logical_reads
		, OBJECT_NAME(txt.[objectid]) as proc_name
		, txt.text as sql_statement
		, case 
				when blkr.session_id is null then null
				else 
					SUBSTRING(txt.text,er.statement_start_offset / 2+1, ( (
							CASE 
								WHEN er.statement_end_offset = -1 THEN (LEN(CONVERT(nvarchar(max),txt.text)) * 2) 
								ELSE er.statement_end_offset 
							END
						) - er.statement_start_offset) / 2 + 1 ) 
			end AS blocking_line
	from sys.dm_exec_sessions sess
		left join sys.dm_exec_requests er
		on sess.session_id = er.session_id
		outer apply sys.dm_exec_sql_text(er.sql_handle) txt
		left join sys.dm_os_waiting_tasks wt
		on sess.session_id = wt.session_id
		left join sys.dm_os_waiting_tasks blkr
		on sess.session_id = blkr.blocking_session_id
	where (1 = case when @include_sys_processes = 0 then sess.is_user_process else 1 end)
		and (@active_only = 0 or (@active_only = 1 and er.session_id is not null))
		and (@blocking_only = 0 or (@blocking_only = 1 and blkr.session_id is not null))
	order by
		sess.session_id 
		
end -- procedure
go

-- include system sessions
exec dbo.usp_MyDBA_spwho 	
	@include_sys_processes = 1
	, @active_only = 0
	, @blocking_only = 0
go

-- sp_who2 active
exec dbo.usp_MyDBA_spwho 	
	@include_sys_processes = 0
	, @active_only = 1
	, @blocking_only = 0
go	
	
-- blocking only
exec dbo.usp_MyDBA_spwho 	
	@include_sys_processes = 0
	, @active_only = 0
	, @blocking_only = 1
go

-- active & blocking
exec dbo.usp_MyDBA_spwho 	
	@include_sys_processes = 0
	, @active_only = 1
	, @blocking_only = 1
go

-- system & active
exec dbo.usp_MyDBA_spwho 	
	@include_sys_processes = 1
	, @active_only = 1
	, @blocking_only = 0
go
