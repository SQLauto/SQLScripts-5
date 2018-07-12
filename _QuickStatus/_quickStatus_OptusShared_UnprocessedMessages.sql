
if OBJECT_ID('tempdb.dbo.OptusSharedMessages') is not null drop table tempdb.dbo.OptusSharedMessages
CREATE TABLE tempdb.[dbo].[OptusSharedMessages](
	[ID] [int] NOT NULL,
	[ContextID] [varchar](20) NULL,
	[DealerID] [varchar](50) NULL,
	[ForeignContextID] [varchar](20) NULL,
	[MSN] [varchar](20) NULL,
	[MessageName] [varchar](50) NULL,
	[Soap] [xml] NULL,
	[StatusID] [int] NULL,
	[DateCreated] [datetime] NULL,
	[DateSent] [datetime] NULL,
	[UserIDCreated] [int] NULL,
	[Action] [int] NULL
)

insert into tempdb..OptusSharedMessages (	
  [ID], [ContextID], [DealerID], [ForeignContextID], [MSN],
	[MessageName], [Soap], [StatusID], [DateCreated],
	[DateSent], [UserIDCreated], [Action]
)
SELECT [ID], [ContextID], [DealerID], [ForeignContextID], [MSN],
	[MessageName], [Soap], [StatusID], [DateCreated],
	[DateSent], [UserIDCreated], [Action] 
FROM [192.168.172.130,1234].[3GOptusShared].[dbo].[Messages]
where [DateCreated] >= dateadd(hh, -24, Getdate())

update tempdb..OptusSharedMessages
set [Soap] = REPLACE(REPLACE(REPLACE(cast([Soap] as varchar(max)), '<m:', '<'), '</m:', '</'), 'SOAP-ENV:', '')


select usr.Name, usr.Logon, usr.Password, lst.Val4, msg.ID, msg.[DateCreated], msg.[StatusID], msg.Soap
FROM [192.168.172.130,1234].[3GOptusShared].[dbo].[Users] usr
  inner join (
      select Val4, Val2, Val, ListID 
      FROM [192.168.172.130,1234].[3GOptusShared].[dbo].[Lists]
      where Type = 'SPIDDB'
    ) as lst
   on usr.spid = lst.ListID
      inner join (
          select
            [Soap].value('(//Envelope//Header//SoapHeaderMsg//DealerId)[1]', 'varchar(10)') as [DealerId]
            , [Soap]
            , [DateCreated]
            , [ID]
            , [StatusID]
          from tempdb..OptusSharedMessages     
        ) as msg
      on lst.Val2 = msg.DealerId
where UserType = 'Admin'

  
