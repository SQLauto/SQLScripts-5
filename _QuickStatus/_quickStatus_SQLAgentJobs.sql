
if object_id('tempdb..#jobs') is not null drop table #jobs
create table #jobs (
  job_id uniqueidentifier not null
  , last_run_date int not null
  , last_run_time int not null
  , next_run_date int not null
  , next_run_time int not null
  , next_run_schedule_id int not null
  , requested_to_run int not null
  , request_source int not null
  , request_source_id sysname collate database_default null
  , running int not null
  , current_step int not null
  , current_retry_attempt int not null
  , job_state int not null
)

if object_id('tempdb..#outcome') is not null drop table #outcome
create table #outcome (
  job_id uniqueidentifier not null
  , last_run_date int not null
  , last_run_time int not null
  , last_run_outcome int not null
)

insert into #jobs
execute master.dbo.xp_sqlagent_enum_jobs 1, 'sa'

insert into #outcome
select sjs.job_id
  , sjs.last_run_date
  , sjs.last_run_time
  , sjs.last_run_outcome
from msdb.dbo.sysjobservers sjs
where (convert(float, sjs.last_run_date) * 1000000) + sjs.last_run_time =
  (
    select max((convert(float, last_run_date) * 1000000) + last_run_time)
    from msdb.dbo.sysjobservers
    where job_id = sjs.job_id
  )


select
	sJb.name as [Job Name]
	, case 
	      when sJb.enabled = 1 then 'Yes'
	      else 'No'
	    end as [Job Enabled]
	, case
	      when #outcome.last_run_date > 0 then
	        CONVERT(datetime, 
			      LEFT(CAST(#outcome.last_run_date as varchar(10)), 4) + '-'
				       + SUBSTRING(CAST(#outcome.last_run_date as varchar(10)), 5, 2) + '-'
				       + RIGHT(CAST(#outcome.last_run_date as varchar(10)), 2) + ' '
				       + LEFT(RIGHT('000000' + CAST(#outcome.last_run_time as varchar(10)), 6), 2) + ':'
				       + SUBSTRING(RIGHT('000000' + CAST(#outcome.last_run_time as varchar(10)), 6), 3, 2) + ':'
				       + RIGHT(RIGHT('000000' + CAST(#outcome.last_run_time as varchar(10)), 6), 2), 120) 
        else NULL
      end as [Last Run]
	, case
	      when #jobs.next_run_date > 0 then
	        CONVERT(datetime, 
			      LEFT(CAST(#jobs.next_run_date as varchar(10)), 4) + '-'
				       + SUBSTRING(CAST(#jobs.next_run_date as varchar(10)), 5, 2) + '-'
				       + RIGHT(CAST(#jobs.next_run_date as varchar(10)), 2) + ' '
				       + LEFT(RIGHT('000000' + CAST(#jobs.next_run_time as varchar(10)), 6), 2) + ':'
				       + SUBSTRING(RIGHT('000000' + CAST(#jobs.next_run_time as varchar(10)), 6), 3, 2) + ':'
				       + RIGHT(RIGHT('000000' + CAST(#jobs.next_run_time as varchar(10)), 6), 2), 120) 
        else NULL
      end as [Next Run]
	, case
	      when #outcome.last_run_outcome = 0 then 'Failed'
	      when #outcome.last_run_outcome = 1 then 'Succeeded'
	      when #outcome.last_run_outcome = 2 then 'Retry'
	      when #outcome.last_run_outcome = 3 then 'Canceled'
	      else 'Unknown'
	    end as [Last Run Outcome]
	, case 
	      when #jobs.running = 1 then 'Yes'
	      else 'No'
	    end as [Is Running]
	, #jobs.current_step as [Current Step]
	, #jobs.current_retry_attempt as [Retry Attempt]
	, case 
	      when #jobs.job_state = 0 then 'Not idle or suspended'
	      when #jobs.job_state = 1 then 'Executing'
	      when #jobs.job_state = 2 then 'Waiting For Thread'
	      when #jobs.job_state = 3 then 'Between Retries'
	      when #jobs.job_state = 4 then 'Idle'
	      when #jobs.job_state = 5 then 'Suspended'
	      when #jobs.job_state = 6 then 'Waiting For Step To Finish'
	      when #jobs.job_state = 7 then 'Performing Completion Actions'
	      else 'Unknown'
	    end as [Job State]
  , sJbStp.step_name
  , sJbStp.subsystem
  , sJbStp.command
from #jobs
	inner join msdb.dbo.sysjobs sJb
	on #jobs.job_id = sJb.job_id
    left join msdb.dbo.sysjobsteps sJbStp
    on sJb.job_id = sJbStp.job_id
    and #jobs.current_step = sJbStp.step_id
	inner join #outcome 
	on #jobs.job_id = #outcome.job_id
where #jobs.running = 1
  or #outcome.last_run_outcome <> 1
order by
  [Last Run] desc

