if object_id('tempdb..tmpMsgSummary') is not null drop table tempdb..tmpMsgSummary
create table [tempdb].[dbo].[tmpMsgSummary](
	[DbName] [varchar] (30) NULL,
	[HourSent] [int] NULL,
	[MessageCount] [int] NULL
)
if object_id('tempdb..tmpHourID') is not null drop table tempdb..tmpHourID
create table [tempdb].[dbo].[tmpHourID](
	[HourID] [int] NULL
)

declare @sql nvarchar(500)
declare @dbName sysname
declare @datenow datetime
declare @datestart datetime

set @dateNow = getdate()
set @dateStart = dateadd(hh, -24, @dateNow)

while @dateNow > @dateStart
begin
  insert into tempdb..tmpHourID
  select cast(convert(varchar(10), @dateNow, 112) + convert(varchar(2), @dateNow, 108) as int)

  set @dateNow = dateadd(hh, -1, @dateNow)
  
end

declare cDB cursor fast_forward for
  select name
  from master..sysdatabases
  where name like '3G%'
    and databasepropertyex(name, 'Status') = 'ONLINE'
    and not (name in ('3GOptusShared', '3GOptusTest'))
  order by name
  
open cDB
fetch next from cDB into @dbName

while @@fetch_status = 0
begin
  set @sql = 'USE ' + quotename(@dbName) + '; ' +
'insert into tempdb..tmpMsgSummary ([DbName],	[MessageCount],	[HourSent])
SELECT ' + quotename(@dbName, '''') + ', COUNT([ID])
  , left(convert(varchar(10), [DateSent], 112) + replace(convert(varchar(10), [DateSent], 108), '':'', ''''), 10)
FROM [dbo].[Messages] WITH (NOLOCK)
WHERE [DateSent] > DATEADD(hh, -24, GetDate())
GROUP BY left(convert(varchar(10), [DateSent], 112) + replace(convert(varchar(10), [DateSent], 108), '':'', ''''), 10)
'
  exec sp_executesql @sql
  
  fetch next from cDB into @dbName

end

close cDB
deallocate cDB


select 
  hr.HourID
  , sum(case when [MessageCount] is null then 0 else [MessageCount] end) as [TotalMessages]
  , max(case when DbName = '3G2Tribe' then [MessageCount] else 0 end) as [3G2Tribe]
  , max(case when DbName = '3GACP' then [MessageCount] else 0 end) as [3GACP]
  , max(case when DbName = '3GArrow' then [MessageCount] else 0 end) as [3GArrow]
  , max(case when DbName = '3GAussie' then [MessageCount] else 0 end) as [3GAussie]
  , max(case when DbName = '3GAxis' then [MessageCount] else 0 end) as [3GAxis]
  , max(case when DbName = '3GBetter' then [MessageCount] else 0 end) as [3GBetter]
  , max(case when DbName = '3GBKB' then [MessageCount] else 0 end) as [3GBKB]
  , max(case when DbName = '3GBlitz' then [MessageCount] else 0 end) as [3GBlitz]
  , max(case when DbName = '3GBureau_Spin' then [MessageCount] else 0 end) as [3GBureau_Spin]
  , max(case when DbName = '3GBureau_Telarus' then [MessageCount] else 0 end) as [3GBureau_Telarus]
  , max(case when DbName = '3GBYON' then [MessageCount] else 0 end) as [3GBYON]
  , max(case when DbName = '3GCastle' then [MessageCount] else 0 end) as [3GCastle]
  , max(case when DbName = '3GCoast' then [MessageCount] else 0 end) as [3GCoast]
  , max(case when DbName = '3GCommander' then [MessageCount] else 0 end) as [3GCommander]
  , max(case when DbName = '3GCommunicomm' then [MessageCount] else 0 end) as [3GCommunicomm]
  , max(case when DbName = '3GConvoitec' then [MessageCount] else 0 end) as [3GConvoitec]
  , max(case when DbName = '3GCTA' then [MessageCount] else 0 end) as [3GCTA]
  , max(case when DbName = '3GEdirect' then [MessageCount] else 0 end) as [3GEdirect]
  , max(case when DbName = '3GeGeneration' then [MessageCount] else 0 end) as [3GeGeneration]
  , max(case when DbName = '3GEmerald' then [MessageCount] else 0 end) as [3GEmerald]
  , max(case when DbName = '3gEverythingTelco' then [MessageCount] else 0 end) as [3gEverythingTelco]
  , max(case when DbName = '3GFirstReach' then [MessageCount] else 0 end) as [3GFirstReach]
  , max(case when DbName = '3GFlexirent' then [MessageCount] else 0 end) as [3GFlexirent]
  , max(case when DbName = '3GFresh' then [MessageCount] else 0 end) as [3GFresh]
  , max(case when DbName = '3GHighlands' then [MessageCount] else 0 end) as [3GHighlands]
  , max(case when DbName = '3GHummertime' then [MessageCount] else 0 end) as [3GHummertime]
  , max(case when DbName = '3GJadiOne' then [MessageCount] else 0 end) as [3GJadiOne]
  , max(case when DbName = '3GLime' then [MessageCount] else 0 end) as [3GLime]
  , max(case when DbName = '3GM2' then [MessageCount] else 0 end) as [3GM2]
  , max(case when DbName = '3GMobOffice' then [MessageCount] else 0 end) as [3GMobOffice]
  , max(case when DbName = '3GMyPh' then [MessageCount] else 0 end) as [3GMyPh]
  , max(case when DbName = '3GNationtel' then [MessageCount] else 0 end) as [3GNationtel]
  , max(case when DbName = '3GNetCo' then [MessageCount] else 0 end) as [3GNetCo]
  , max(case when DbName = '3GNetspace' then [MessageCount] else 0 end) as [3GNetspace]
  , max(case when DbName = '3GNTG' then [MessageCount] else 0 end) as [3GNTG]
  , max(case when DbName = '3GOneCom' then [MessageCount] else 0 end) as [3GOneCom]
  , max(case when DbName = '3GPlanetPlan' then [MessageCount] else 0 end) as [3GPlanetPlan]
  , max(case when DbName = '3GProTalk' then [MessageCount] else 0 end) as [3GProTalk]
  , max(case when DbName = '3GRedMedia' then [MessageCount] else 0 end) as [3GRedMedia]
  , max(case when DbName = '3GSmartCharge' then [MessageCount] else 0 end) as [3GSmartCharge]
  , max(case when DbName = '3GSpirit' then [MessageCount] else 0 end) as [3GSpirit]
  , max(case when DbName = '3GSPSM' then [MessageCount] else 0 end) as [3GSPSM]
  , max(case when DbName = '3GSqueeze' then [MessageCount] else 0 end) as [3GSqueeze]
  , max(case when DbName = '3GT4' then [MessageCount] else 0 end) as [3GT4]
  , max(case when DbName = '3GTDU' then [MessageCount] else 0 end) as [3GTDU]
  , max(case when DbName = '3GTekworx' then [MessageCount] else 0 end) as [3GTekworx]
  , max(case when DbName = '3GTelcoBlue' then [MessageCount] else 0 end) as [3GTelcoBlue]
  , max(case when DbName = '3GTelConnect' then [MessageCount] else 0 end) as [3GTelConnect]
  , max(case when DbName = '3GTelkom' then [MessageCount] else 0 end) as [3GTelkom]
  , max(case when DbName = '3GTotalCom' then [MessageCount] else 0 end) as [3GTotalCom]
  , max(case when DbName = '3GTrinity' then [MessageCount] else 0 end) as [3GTrinity]
  , max(case when DbName = '3GVocal' then [MessageCount] else 0 end) as [3GVocal]
  , max(case when DbName = '3GVoip' then [MessageCount] else 0 end) as [3GVoip]
  , max(case when DbName = '3GWestnet' then [MessageCount] else 0 end) as [3GWestnet]
  , max(case when DbName = '3GWorldTel' then [MessageCount] else 0 end) as [3GWorldTel]
from tempdb..tmpHourID hr
  left join [tempdb].[dbo].[tmpMsgSummary] smry
  on hr.HourID = smry.HourSent
group by 
  hr.HourID


