if OBJECT_ID('tempdb..#dbs') is not null drop table #dbs
create table #dbs (
  name sysname
  , size varchar(20)
  , owner sysname
  , dbid smallint
  , created date
  , status varchar(max)
  , compatibility_level int
)

insert into #dbs
select * from openquery([192.168.172.130,1234], 'SET FMTONLY OFF;exec master.dbo.sp_helpdb') as q


select
  *
from (
  select
    name
    , max(case when patindex('Status=%', Element) > 0 then RIGHT(Element, len(Element)-charindex('=', Element)) else null end) as [Status]
    , max(case when patindex('Updateability=%', Element) > 0 then RIGHT(Element, len(Element)-charindex('=', Element)) else null end) as [Updateability]
    , max(case when patindex('UserAccess=%', Element) > 0 then RIGHT(Element, len(Element)-charindex('=', Element)) else null end) as [UserAccess]
    , max(case when patindex('Recovery=%', Element) > 0 then RIGHT(Element, len(Element)-charindex('=', Element)) else null end) as [Recovery]
    , max(case when patindex('Version=%', Element) > 0 then RIGHT(Element, len(Element)-charindex('=', Element)) else null end) as [Version]
    , max(case when patindex('Collation=%', Element) > 0 then RIGHT(Element, len(Element)-charindex('=', Element)) else null end) as [Collation]
  from (
    select
      #dbs.name
      , st.Element
    from #dbs
    cross apply [DBA].dbo.[fn_CharSplit](status,',')  as st
  ) as q
  group by
    name
) as sts
where sts.Status <> 'ONLINE'
order by sts.name