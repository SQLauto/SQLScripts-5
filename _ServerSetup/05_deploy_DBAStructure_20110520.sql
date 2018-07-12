/*
Deployment script for DBA
*/
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;
GO

USE [DBA]
GO

PRINT N'Creating [dbo].[alert_destinations]...';
GO
CREATE TABLE [dbo].[alert_destinations] (
    [error_num]            INT NOT NULL,
    [primary_profile_id]   INT NOT NULL,
    [secondary_profile_id] INT NULL
);
GO

PRINT N'Creating PK_alert_destinations...';
GO
ALTER TABLE [dbo].[alert_destinations]
    ADD CONSTRAINT [PK_alert_destinations] PRIMARY KEY CLUSTERED ([error_num] ASC);


GO

PRINT N'Creating [dbo].[backup_list]...';
GO
CREATE TABLE [dbo].[backup_list] (
    [backup_group]        INT            NOT NULL,
    [database_name]       VARCHAR (50)   NOT NULL,
    [backup_order]        TINYINT        NOT NULL,
    [full_backup]         BIT            NOT NULL,
    [full_backup_24h]     TINYINT        NOT NULL,
    [last_full_backup]    DATETIME       NULL,
    [last_full_restore]   DATETIME       NULL,
    [tlog_backup]         BIT            NOT NULL,
    [tlog_backup_24h]     TINYINT        NOT NULL,
    [last_tlog_backup]    DATETIME       NULL,
    [last_tlog_restore]   DATETIME       NULL,
    [is_log_shipped]      BIT            NOT NULL,
    [log_ship_restore_as] NVARCHAR (128) NULL
);


GO

PRINT N'Creating PK_backup_list...';
GO
ALTER TABLE [dbo].[backup_list]
    ADD CONSTRAINT [PK_backup_list] PRIMARY KEY CLUSTERED ([backup_group] ASC, [database_name] ASC);


GO

PRINT N'Creating [dbo].[blocking_session_info]...';
GO
CREATE TABLE [dbo].[blocking_session_info] (
    [batch]                   INT            NULL,
    [batchDate]               DATETIME       NOT NULL,
    [session_id]              SMALLINT       NOT NULL,
    [blocking]                SMALLINT       NULL,
    [blocked_by]              SMALLINT       NULL,
    [wait_duration_ms]        BIGINT         NULL,
    [db_name]                 NVARCHAR (128) NULL,
    [user_name]               NVARCHAR (128) NULL,
    [host_name]               NVARCHAR (128) NULL,
    [host_process_id]         INT            NULL,
    [login_time]              DATETIME       NOT NULL,
    [last_request_start_time] DATETIME       NOT NULL,
    [last_request_end_time]   DATETIME       NULL,
    [status]                  NVARCHAR (30)  NULL,
    [command]                 NVARCHAR (16)  NULL,
    [cpu_time]                INT            NULL,
    [total_elapsed_time]      INT            NULL,
    [reads]                   BIGINT         NULL,
    [writes]                  BIGINT         NULL,
    [logical_reads]           BIGINT         NULL,
    [proc_name]               NVARCHAR (128) NULL,
    [sql_statement]           NVARCHAR (MAX) NULL,
    [blocking_line]           NVARCHAR (MAX) NULL,
    [query_plan]              XML            NULL
);
GO

PRINT N'Creating [dbo].[CounterData]...';
GO
CREATE TABLE [dbo].[CounterData] (
    [GUID]            UNIQUEIDENTIFIER NOT NULL,
    [CounterID]       INT              NOT NULL,
    [RecordIndex]     INT              NOT NULL,
    [CounterDateTime] CHAR (24)        NOT NULL,
    [CounterValue]    FLOAT            NOT NULL,
    [FirstValueA]     INT              NULL,
    [FirstValueB]     INT              NULL,
    [SecondValueA]    INT              NULL,
    [SecondValueB]    INT              NULL,
    [MultiCount]      INT              NULL,
    PRIMARY KEY CLUSTERED ([GUID] ASC, [CounterID] ASC, [RecordIndex] ASC)
);
GO

PRINT N'Creating [dbo].[CounterData2]...';
GO
CREATE TABLE [dbo].[CounterData2] (
    [GUID]            UNIQUEIDENTIFIER NOT NULL,
    [CounterID]       INT              NOT NULL,
    [CounterDateTime] BIGINT           NOT NULL,
    [CounterValue]    FLOAT            NULL
);
GO

PRINT N'Creating PK_CounterData2...';


GO
ALTER TABLE [dbo].[CounterData2]
    ADD CONSTRAINT [PK_CounterData2] PRIMARY KEY CLUSTERED ([GUID] ASC, [CounterID] ASC, [CounterDateTime] ASC);


GO
PRINT N'Creating [dbo].[CounterDetails]...';


GO
CREATE TABLE [dbo].[CounterDetails] (
    [CounterID]      INT            IDENTITY (1, 1) NOT NULL,
    [MachineName]    VARCHAR (1024) NOT NULL,
    [ObjectName]     VARCHAR (1024) NOT NULL,
    [CounterName]    VARCHAR (1024) NOT NULL,
    [CounterType]    INT            NOT NULL,
    [DefaultScale]   INT            NOT NULL,
    [InstanceName]   VARCHAR (1024) NULL,
    [InstanceIndex]  INT            NULL,
    [ParentName]     VARCHAR (1024) NULL,
    [ParentObjectID] INT            NULL,
    [TimeBaseA]      INT            NULL,
    [TimeBaseB]      INT            NULL,
    PRIMARY KEY CLUSTERED ([CounterID] ASC)
);


GO
PRINT N'Creating [dbo].[CounterDetails2]...';


GO
CREATE TABLE [dbo].[CounterDetails2] (
    [CounterID]    INT              NOT NULL,
    [GUID]         UNIQUEIDENTIFIER NOT NULL,
    [MachineName]  VARCHAR (1024)   NOT NULL,
    [ObjectName]   VARCHAR (1024)   NOT NULL,
    [CounterName]  VARCHAR (1024)   NOT NULL,
    [InstanceName] VARCHAR (1024)   NULL
);


GO
PRINT N'Creating PK_CounterDetails2...';


GO
ALTER TABLE [dbo].[CounterDetails2]
    ADD CONSTRAINT [PK_CounterDetails2] PRIMARY KEY CLUSTERED ([CounterID] ASC, [GUID] ASC);


GO
PRINT N'Creating [dbo].[CTApplication]...';


GO
CREATE TABLE [dbo].[CTApplication] (
    [ApplicationID]   INT            NOT NULL,
    [ApplicationName] NVARCHAR (128) NOT NULL
);


GO
PRINT N'Creating PK_CTApplication...';


GO
ALTER TABLE [dbo].[CTApplication]
    ADD CONSTRAINT [PK_CTApplication] PRIMARY KEY CLUSTERED ([ApplicationID] ASC);


GO
PRINT N'Creating [dbo].[CTConfig]...';


GO
CREATE TABLE [dbo].[CTConfig] (
    [OptionCode]  NVARCHAR (20) NOT NULL,
    [OptionValue] SQL_VARIANT   NOT NULL
);


GO
PRINT N'Creating PK_CTConfig...';


GO
ALTER TABLE [dbo].[CTConfig]
    ADD CONSTRAINT [PK_CTConfig] PRIMARY KEY CLUSTERED ([OptionCode] ASC);


GO
PRINT N'Creating [dbo].[CTDateDimension]...';


GO
CREATE TABLE [dbo].[CTDateDimension] (
    [DateID]         INT          IDENTITY (1, 1) NOT NULL,
    [CalendarDate]   DATETIME     NOT NULL,
    [DayOfWeekNum]   TINYINT      NOT NULL,
    [DayOfWeekName]  VARCHAR (20) NOT NULL,
    [DayOfMonthNum]  TINYINT      NOT NULL,
    [DayOfYearNum]   SMALLINT     NOT NULL,
    [WeekInYearNum]  TINYINT      NOT NULL,
    [MonthInYearNum] TINYINT      NOT NULL,
    [MonthName]      VARCHAR (20) NOT NULL
);


GO
PRINT N'Creating PK_CTDateDimension...';


GO
ALTER TABLE [dbo].[CTDateDimension]
    ADD CONSTRAINT [PK_CTDateDimension] PRIMARY KEY CLUSTERED ([DateID] ASC);


GO
PRINT N'Creating [dbo].[CTHost]...';


GO
CREATE TABLE [dbo].[CTHost] (
    [HostID]   INT            NOT NULL,
    [HostName] NVARCHAR (128) NOT NULL
);


GO
PRINT N'Creating PK_CTHost...';


GO
ALTER TABLE [dbo].[CTHost]
    ADD CONSTRAINT [PK_CTHost] PRIMARY KEY CLUSTERED ([HostID] ASC);


GO
PRINT N'Creating [dbo].[CTLogin]...';


GO
CREATE TABLE [dbo].[CTLogin] (
    [LoginID]   INT            NOT NULL,
    [LoginName] NVARCHAR (256) NOT NULL
);


GO
PRINT N'Creating PK_CTLogin...';


GO
ALTER TABLE [dbo].[CTLogin]
    ADD CONSTRAINT [PK_CTLogin] PRIMARY KEY CLUSTERED ([LoginID] ASC);


GO
PRINT N'Creating [dbo].[CTServer]...';


GO
CREATE TABLE [dbo].[CTServer] (
    [ServerID]   INT            NOT NULL,
    [ServerName] NVARCHAR (256) NOT NULL
);


GO
PRINT N'Creating PK_CTServer...';


GO
ALTER TABLE [dbo].[CTServer]
    ADD CONSTRAINT [PK_CTServer] PRIMARY KEY CLUSTERED ([ServerID] ASC);


GO
PRINT N'Creating [dbo].[CTTextData]...';


GO
CREATE TABLE [dbo].[CTTextData] (
    [TextDataHashCode]   BIGINT          NOT NULL,
    [NormalizedTextData] NVARCHAR (4000) NOT NULL,
    [SampleTextData]     NTEXT           NOT NULL
);


GO
PRINT N'Creating PK_CTTextData...';


GO
ALTER TABLE [dbo].[CTTextData]
    ADD CONSTRAINT [PK_CTTextData] PRIMARY KEY CLUSTERED ([TextDataHashCode] ASC);


GO
PRINT N'Creating [dbo].[CTTrace]...';


GO
CREATE TABLE [dbo].[CTTrace] (
    [TraceID]   INT            NOT NULL,
    [TraceName] NVARCHAR (128) NOT NULL
);


GO
PRINT N'Creating PK_CTTrace...';


GO
ALTER TABLE [dbo].[CTTrace]
    ADD CONSTRAINT [PK_CTTrace] PRIMARY KEY CLUSTERED ([TraceID] ASC);


GO
PRINT N'Creating IX_CTTrace_Unique...';


GO
ALTER TABLE [dbo].[CTTrace]
    ADD CONSTRAINT [IX_CTTrace_Unique] UNIQUE NONCLUSTERED ([TraceName] ASC) ON [PRIMARY];


GO
PRINT N'Creating [dbo].[CTTraceDetail]...';


GO
CREATE TABLE [dbo].[CTTraceDetail] (
    [RowNumber]        INT      IDENTITY (1, 1) NOT NULL,
    [TraceID]          INT      NOT NULL,
    [EventClass]       SMALLINT NOT NULL,
    [TextDataHashCode] BIGINT   NULL,
    [CPU]              INT      NULL,
    [Reads]            BIGINT   NULL,
    [Writes]           BIGINT   NULL,
    [Duration]         BIGINT   NULL,
    [ApplicationID]    INT      NOT NULL,
    [LoginID]          INT      NOT NULL,
    [HostID]           INT      NOT NULL,
    [EndTime]          DATETIME NOT NULL,
    [TraceFileID]      INT      NOT NULL,
    [ServerID]         INT      NOT NULL
);


GO
PRINT N'Creating PK_CTTraceDetail...';


GO
ALTER TABLE [dbo].[CTTraceDetail]
    ADD CONSTRAINT [PK_CTTraceDetail] PRIMARY KEY CLUSTERED ([RowNumber] ASC);


GO
PRINT N'Creating [dbo].[CTTraceFile]...';


GO
CREATE TABLE [dbo].[CTTraceFile] (
    [TraceFileID]   INT            NOT NULL,
    [TraceFileName] NVARCHAR (512) NOT NULL,
    PRIMARY KEY CLUSTERED ([TraceFileID] ASC)
);


GO
PRINT N'Creating [dbo].[CTTraceSummary]...';


GO
CREATE TABLE [dbo].[CTTraceSummary] (
    [RowID]            INT      IDENTITY (1, 1) NOT NULL,
    [TraceID]          INT      NOT NULL,
    [TraceFileID]      INT      NOT NULL,
    [DateID]           INT      NOT NULL,
    [TimeID]           INT      NOT NULL,
    [ServerID]         INT      NULL,
    [EventClass]       SMALLINT NOT NULL,
    [ApplicationID]    INT      NOT NULL,
    [LoginID]          INT      NOT NULL,
    [HostID]           INT      NOT NULL,
    [TextDataHashCode] BIGINT   NULL,
    [CPU]              INT      NULL,
    [Reads]            BIGINT   NULL,
    [Writes]           BIGINT   NULL,
    [Duration]         BIGINT   NULL,
    [ExecutionCount]   INT      NULL,
    PRIMARY KEY CLUSTERED ([RowID] ASC)
);


GO
PRINT N'Creating [dbo].[CTTraceSummary].[IX_CTTraceSummary_Application]...';


GO
CREATE NONCLUSTERED INDEX [IX_CTTraceSummary_Application]
    ON [dbo].[CTTraceSummary]([TraceID] ASC, [ApplicationID] ASC)
    ON [PRIMARY];


GO
PRINT N'Creating [dbo].[CTTraceSummary].[IX_CTTraceSummary_Date]...';


GO
CREATE NONCLUSTERED INDEX [IX_CTTraceSummary_Date]
    ON [dbo].[CTTraceSummary]([TraceID] ASC, [DateID] ASC)
    ON [PRIMARY];


GO
PRINT N'Creating [dbo].[CTTraceSummary].[IX_CTTraceSummary_Host]...';


GO
CREATE NONCLUSTERED INDEX [IX_CTTraceSummary_Host]
    ON [dbo].[CTTraceSummary]([TraceID] ASC, [HostID] ASC)
    ON [PRIMARY];


GO
PRINT N'Creating [dbo].[CTTraceSummary].[IX_CTTraceSummary_Login]...';


GO
CREATE NONCLUSTERED INDEX [IX_CTTraceSummary_Login]
    ON [dbo].[CTTraceSummary]([TraceID] ASC, [LoginID] ASC)
    ON [PRIMARY];


GO
PRINT N'Creating [dbo].[CTTraceSummary].[IX_CTTraceSummary_TraceFile]...';


GO
CREATE NONCLUSTERED INDEX [IX_CTTraceSummary_TraceFile]
    ON [dbo].[CTTraceSummary]([TraceID] ASC, [TraceFileID] ASC)
    ON [PRIMARY];


GO
PRINT N'Creating [dbo].[database_backupmediafamily]...';


GO
CREATE TABLE [dbo].[database_backupmediafamily] (
    [media_set_id]           INT              NOT NULL,
    [sample_date]            DATETIME         NOT NULL,
    [family_sequence_number] TINYINT          NOT NULL,
    [media_family_id]        UNIQUEIDENTIFIER NULL,
    [media_count]            INT              NULL,
    [logical_device_name]    NVARCHAR (128)   NULL,
    [physical_device_name]   NVARCHAR (260)   NULL,
    [device_type]            TINYINT          NULL,
    [physical_block_size]    INT              NULL,
    [mirror]                 TINYINT          NOT NULL,
    [loaded_into_repository] BIT              NOT NULL,
    PRIMARY KEY CLUSTERED ([media_set_id] ASC, [family_sequence_number] ASC, [mirror] ASC)
);


GO
PRINT N'Creating [dbo].[database_backupset]...';


GO
CREATE TABLE [dbo].[database_backupset] (
    [backup_set_id]            INT              NOT NULL,
    [sample_date]              DATETIME         NOT NULL,
    [backup_set_uuid]          UNIQUEIDENTIFIER NOT NULL,
    [media_set_id]             INT              NOT NULL,
    [first_family_number]      TINYINT          NULL,
    [first_media_number]       SMALLINT         NULL,
    [last_family_number]       TINYINT          NULL,
    [last_media_number]        SMALLINT         NULL,
    [catalog_family_number]    TINYINT          NULL,
    [catalog_media_number]     SMALLINT         NULL,
    [position]                 INT              NULL,
    [expiration_date]          DATETIME         NULL,
    [software_vendor_id]       INT              NULL,
    [name]                     NVARCHAR (128)   NULL,
    [description]              NVARCHAR (255)   NULL,
    [user_name]                NVARCHAR (128)   NULL,
    [software_major_version]   TINYINT          NULL,
    [software_minor_version]   TINYINT          NULL,
    [software_build_version]   SMALLINT         NULL,
    [time_zone]                SMALLINT         NULL,
    [mtf_minor_version]        TINYINT          NULL,
    [first_lsn]                NUMERIC (25)     NULL,
    [last_lsn]                 NUMERIC (25)     NULL,
    [checkpoint_lsn]           NUMERIC (25)     NULL,
    [database_backup_lsn]      NUMERIC (25)     NULL,
    [database_creation_date]   DATETIME         NULL,
    [backup_start_date]        DATETIME         NULL,
    [backup_finish_date]       DATETIME         NULL,
    [type]                     CHAR (1)         NULL,
    [sort_order]               SMALLINT         NULL,
    [code_page]                SMALLINT         NULL,
    [compatibility_level]      TINYINT          NULL,
    [database_version]         INT              NULL,
    [backup_size]              NUMERIC (20)     NULL,
    [database_name]            NVARCHAR (128)   NULL,
    [server_name]              NVARCHAR (128)   NULL,
    [machine_name]             NVARCHAR (128)   NULL,
    [flags]                    INT              NULL,
    [unicode_locale]           INT              NULL,
    [unicode_compare_style]    INT              NULL,
    [collation_name]           NVARCHAR (128)   NULL,
    [is_password_protected]    BIT              NULL,
    [recovery_model]           NVARCHAR (60)    NULL,
    [has_bulk_logged_data]     BIT              NULL,
    [is_snapshot]              BIT              NULL,
    [is_readonly]              BIT              NULL,
    [is_single_user]           BIT              NULL,
    [has_backup_checksums]     BIT              NULL,
    [is_damaged]               BIT              NULL,
    [begins_log_chain]         BIT              NULL,
    [has_incomplete_metadata]  BIT              NULL,
    [is_force_offline]         BIT              NULL,
    [is_copy_only]             BIT              NULL,
    [first_recovery_fork_guid] UNIQUEIDENTIFIER NULL,
    [last_recovery_fork_guid]  UNIQUEIDENTIFIER NULL,
    [fork_point_lsn]           NUMERIC (25)     NULL,
    [database_guid]            UNIQUEIDENTIFIER NULL,
    [family_guid]              UNIQUEIDENTIFIER NULL,
    [differential_base_lsn]    NUMERIC (25)     NULL,
    [differential_base_guid]   UNIQUEIDENTIFIER NULL,
    [compressed_backup_size]   NUMERIC (20)     NULL,
    [loaded_into_repository]   BIT              NOT NULL,
    PRIMARY KEY CLUSTERED ([backup_set_id] ASC)
);


GO
PRINT N'Creating [dbo].[database_details]...';


GO
CREATE TABLE [dbo].[database_details] (
    [Sample_Date]            DATETIME       NOT NULL,
    [Database_ID]            TINYINT        NOT NULL,
    [Database_name]          NVARCHAR (128) NULL,
    [Recovery_Model]         VARCHAR (50)   NULL,
    [Status]                 VARCHAR (50)   NULL,
    [Collation]              VARCHAR (50)   NULL,
    [IsBulkCopy]             VARCHAR (1)    NOT NULL,
    [IsAutoClose]            VARCHAR (1)    NOT NULL,
    [IsAutoShrink]           VARCHAR (1)    NOT NULL,
    [IsAutoCreateStatistics] VARCHAR (1)    NOT NULL,
    [IsAutoUpdateStatistics] VARCHAR (1)    NOT NULL,
    [IsFulltextEnabled]      VARCHAR (1)    NOT NULL,
    [IsPublished]            VARCHAR (1)    NOT NULL,
    [IsSubscribed]           VARCHAR (1)    NOT NULL,
    [loaded_into_repository] BIT            NOT NULL
);


GO
PRINT N'Creating PK_database_details...';


GO
ALTER TABLE [dbo].[database_details]
    ADD CONSTRAINT [PK_database_details] PRIMARY KEY CLUSTERED ([Sample_Date] ASC, [Database_ID] ASC);


GO
PRINT N'Creating [dbo].[database_restorehistory]...';


GO
CREATE TABLE [dbo].[database_restorehistory] (
    [restore_history_id]        INT            NOT NULL,
    [sample_date]               DATETIME       NOT NULL,
    [restore_date]              DATETIME       NULL,
    [destination_database_name] NVARCHAR (128) NULL,
    [user_name]                 NVARCHAR (128) NULL,
    [backup_set_id]             INT            NOT NULL,
    [restore_type]              CHAR (1)       NULL,
    [replace]                   BIT            NULL,
    [recovery]                  BIT            NULL,
    [restart]                   BIT            NULL,
    [stop_at]                   DATETIME       NULL,
    [device_count]              TINYINT        NULL,
    [stop_at_mark_name]         NVARCHAR (128) NULL,
    [stop_before]               BIT            NULL,
    [loaded_into_repository]    BIT            NOT NULL,
    PRIMARY KEY CLUSTERED ([restore_history_id] ASC)
);


GO
PRINT N'Creating [dbo].[database_size]...';


GO
CREATE TABLE [dbo].[database_size] (
    [Sample_Date]            DATETIME        NOT NULL,
    [Database_ID]            INT             NOT NULL,
    [database_name]          NVARCHAR (128)  NULL,
    [file_group]             NCHAR (10)      NULL,
    [file_id]                NCHAR (10)      NULL,
    [Logical_Filename]       NVARCHAR (128)  NOT NULL,
    [Physical_Filename]      NVARCHAR (1024) NULL,
    [Data_Allocated_MB]      DECIMAL (19, 4) NULL,
    [Data_Used_MB]           DECIMAL (19, 4) NULL,
    [Data_Free_MB]           DECIMAL (19, 4) NULL,
    [Data_Free_Pcnt]         DECIMAL (19, 4) NULL,
    [Log_Allocated_MB]       DECIMAL (19, 4) NULL,
    [Log_Used_MB]            DECIMAL (19, 4) NULL,
    [Log_Free_MB]            DECIMAL (19, 4) NULL,
    [Log_Free_Pcnt]          DECIMAL (19, 4) NULL,
    [loaded_into_repository] BIT             NOT NULL
);


GO
PRINT N'Creating PK_database_size...';


GO
ALTER TABLE [dbo].[database_size]
    ADD CONSTRAINT [PK_database_size] PRIMARY KEY CLUSTERED ([Sample_Date] ASC, [Database_ID] ASC, [Logical_Filename] ASC);


GO
PRINT N'Creating [dbo].[DisplayToID]...';


GO
CREATE TABLE [dbo].[DisplayToID] (
    [GUID]            UNIQUEIDENTIFIER NOT NULL,
    [RunID]           INT              NULL,
    [DisplayString]   VARCHAR (1024)   NOT NULL,
    [LogStartTime]    CHAR (24)        NULL,
    [LogStopTime]     CHAR (24)        NULL,
    [NumberOfRecords] INT              NULL,
    [MinutesToUTC]    INT              NULL,
    [TimeZoneName]    CHAR (32)        NULL,
    PRIMARY KEY CLUSTERED ([GUID] ASC),
    UNIQUE NONCLUSTERED ([DisplayString] ASC) ON [PRIMARY]
);


GO
PRINT N'Creating [dbo].[EMailProfiles]...';


GO
CREATE TABLE [dbo].[EMailProfiles] (
    [ProfileID]      INT             IDENTITY (1, 1) NOT NULL,
    [ProfileName]    VARCHAR (20)    COLLATE Latin1_General_CI_AS NULL,
    [DBMailProfile]  VARCHAR (50)    NULL,
    [FromName]       NVARCHAR (128)  COLLATE Latin1_General_CI_AS NULL,
    [FromAddress]    NVARCHAR (255)  COLLATE Latin1_General_CI_AS NULL,
    [ReplyToAddress] NVARCHAR (255)  COLLATE Latin1_General_CI_AS NULL,
    [ToAddress]      NVARCHAR (255)  COLLATE Latin1_General_CI_AS NULL,
    [SMTPServer]     NVARCHAR (500)  COLLATE Latin1_General_CI_AS NULL,
    [SMTPPort]       INT             NULL,
    [TimeoutMS]      INT             NULL,
    [Priority]       NVARCHAR (10)   COLLATE Latin1_General_CI_AS NULL,
    [ContentType]    NVARCHAR (15)   COLLATE Latin1_General_CI_AS NULL,
    [HTMLStyleCSS]   NVARCHAR (1000) COLLATE Latin1_General_CI_AS NULL,
    [ForSMS]         BIT             NOT NULL
);


GO
PRINT N'Creating pk_EMailProfiles...';


GO
ALTER TABLE [dbo].[EMailProfiles]
    ADD CONSTRAINT [pk_EMailProfiles] PRIMARY KEY CLUSTERED ([ProfileID] ASC);


GO
PRINT N'Creating [dbo].[error_log]...';


GO
CREATE TABLE [dbo].[error_log] (
    [log_id]                 INT             IDENTITY (1, 1) NOT NULL,
    [log_date]               DATETIME        NULL,
    [process_info]           NVARCHAR (100)  NULL,
    [log_text]               NVARCHAR (2000) NULL,
    [continuation_row]       INT             NULL,
    [flagged]                BIT             NULL,
    [loaded_into_repository] BIT             NULL
);


GO
PRINT N'Creating PK_error_log_09540424...';


GO
ALTER TABLE [dbo].[error_log]
    ADD CONSTRAINT [PK_error_log_09540424] PRIMARY KEY CLUSTERED ([log_id] ASC);


GO
PRINT N'Creating [dbo].[error_log_latestDate]...';


GO
CREATE TABLE [dbo].[error_log_latestDate] (
    [latest_date] DATETIME NOT NULL,
    [id]          INT      IDENTITY (1, 1) NOT NULL
);


GO
PRINT N'Creating [dbo].[killed_processes]...';


GO
CREATE TABLE [dbo].[killed_processes] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [kill_date]     DATETIME       NOT NULL,
    [spid]          SMALLINT       NOT NULL,
    [hostname]      VARCHAR (128)  NOT NULL,
    [program_name]  VARCHAR (128)  NOT NULL,
    [loginame]      VARCHAR (128)  NOT NULL,
    [database_name] NVARCHAR (128) NULL,
    [login_time]    DATETIME       NOT NULL,
    [last_batch]    DATETIME       NOT NULL,
    [status]        VARCHAR (50)   NOT NULL,
    [cmd]           VARCHAR (50)   NOT NULL,
    [cpu]           INT            NOT NULL,
    [physical_io]   BIGINT         NOT NULL,
    [memusage]      INT            NOT NULL,
    [waittime]      INT            NOT NULL,
    [lastwaittype]  VARCHAR (50)   NULL,
    [waitresource]  VARCHAR (50)   NULL,
    [blocked]       SMALLINT       NOT NULL
);


GO
PRINT N'Creating PK_killed_processes...';


GO
ALTER TABLE [dbo].[killed_processes]
    ADD CONSTRAINT [PK_killed_processes] PRIMARY KEY CLUSTERED ([id] ASC);


GO
PRINT N'Creating [dbo].[logshipping_files]...';


GO
CREATE TABLE [dbo].[logshipping_files] (
    [file_id]             INT            IDENTITY (1, 1) NOT NULL,
    [database_name]       NVARCHAR (50)  NOT NULL,
    [backup_startdate]    DATETIME       NOT NULL,
    [backup_finishdate]   DATETIME       NULL,
    [backup_filename]     NVARCHAR (500) NOT NULL,
    [compress_date]       DATETIME       NULL,
    [compress_filename]   NVARCHAR (500) NULL,
    [archive_date]        DATETIME       NULL,
    [archive_filename]    NVARCHAR (500) NULL,
    [archive_removed]     BIT            NOT NULL,
    [xfer_readydate]      DATETIME       NULL,
    [xfer_filename]       NVARCHAR (500) NULL,
    [xfer_startdate]      DATETIME       NULL,
    [xfer_enddate]        DATETIME       NULL,
    [sec_archive_date]    DATETIME       NULL,
    [sec_archive_name]    NVARCHAR (500) NULL,
    [sec_archive_removed] BIT            NOT NULL,
    [decompress_date]     DATETIME       NULL,
    [decompress_filename] NVARCHAR (500) NULL,
    [restore_date]        DATETIME       NULL,
    [restore_filename]    NVARCHAR (500) NULL
);


GO
PRINT N'Creating PK_logshipping_files...';


GO
ALTER TABLE [dbo].[logshipping_files]
    ADD CONSTRAINT [PK_logshipping_files] PRIMARY KEY CLUSTERED ([file_id] ASC);


GO
PRINT N'Creating [dbo].[nums]...';


GO
CREATE TABLE [dbo].[nums] (
    [n] INT NOT NULL
);


GO
PRINT N'Creating PK_nums...';


GO
ALTER TABLE [dbo].[nums]
    ADD CONSTRAINT [PK_nums] PRIMARY KEY CLUSTERED ([n] ASC);


GO
PRINT N'Creating [dbo].[server_details]...';


GO
CREATE TABLE [dbo].[server_details] (
    [Sample_Date]              DATETIME     NOT NULL,
    [Start_Time]               DATETIME     NULL,
    [Server_Name]              VARCHAR (50) NULL,
    [Instance_Name]            VARCHAR (50) NULL,
    [MachineName]              VARCHAR (50) NULL,
    [ProductVersion]           VARCHAR (50) NULL,
    [ProductLevel]             VARCHAR (50) NULL,
    [Edition]                  VARCHAR (50) NULL,
    [Collation]                VARCHAR (50) NULL,
    [SqlCharSetName]           VARCHAR (50) NULL,
    [SqlSortOrderName]         VARCHAR (50) NULL,
    [IsClustered]              CHAR (1)     NOT NULL,
    [IsFullTextInstalled]      CHAR (1)     NULL,
    [IsIntegratedSecurityOnly] CHAR (1)     NULL,
    [LicenseType]              VARCHAR (50) NULL,
    [cpu_busy]                 BIGINT       NULL,
    [io_busy]                  BIGINT       NULL,
    [idle]                     BIGINT       NULL,
    [pack_received]            BIGINT       NULL,
    [pack_sent]                BIGINT       NULL,
    [connections]              BIGINT       NULL,
    [pack_errors]              BIGINT       NULL,
    [total_read]               BIGINT       NULL,
    [total_write]              BIGINT       NULL,
    [total_errors]             BIGINT       NULL,
    [loaded_into_repository]   BIT          NOT NULL
);


GO
PRINT N'Creating [dbo].[server_drivespace]...';


GO
CREATE TABLE [dbo].[server_drivespace] (
    [Sample_Date]            DATETIME NOT NULL,
    [drive_Letter]           CHAR (1) NULL,
    [mb_free]                INT      NULL,
    [loaded_into_repository] BIT      NOT NULL
);


GO
PRINT N'Creating [dbo].[server_logins]...';


GO
CREATE TABLE [dbo].[server_logins] (
    [Sample_Date]            DATETIME    NOT NULL,
    [loginname]              [sysname]   NOT NULL,
    [default_db]             [sysname]   NULL,
    [default_language]       [sysname]   NULL,
    [LoginDenied]            VARCHAR (1) NOT NULL,
    [HasServerAccess]        VARCHAR (1) NOT NULL,
    [IsWindowsName]          VARCHAR (1) NOT NULL,
    [IsWindowsGroup]         VARCHAR (1) NOT NULL,
    [IsWindowsUser]          VARCHAR (1) NOT NULL,
    [IsSysAdmin]             VARCHAR (1) NOT NULL,
    [IsSecurityAdmin]        VARCHAR (1) NOT NULL,
    [IsSetupAdmin]           VARCHAR (1) NOT NULL,
    [IsServerAdmin]          VARCHAR (1) NOT NULL,
    [IsProcessAdmin]         VARCHAR (1) NOT NULL,
    [IsDiskAdmin]            VARCHAR (1) NOT NULL,
    [IsBulkAdmin]            VARCHAR (1) NOT NULL,
    [IsDbCreator]            VARCHAR (1) NOT NULL,
    [loaded_into_repository] BIT         NOT NULL
);


GO
PRINT N'Creating [dbo].[server_monitor]...';


GO
CREATE TABLE [dbo].[server_monitor] (
    [hour_id]                BIGINT NOT NULL,
    [cpu_busy]               BIGINT NOT NULL,
    [io_busy]                BIGINT NOT NULL,
    [idle]                   BIGINT NOT NULL,
    [pack_received]          BIGINT NOT NULL,
    [pack_sent]              BIGINT NOT NULL,
    [connections]            BIGINT NOT NULL,
    [pack_errors]            BIGINT NOT NULL,
    [total_read]             BIGINT NOT NULL,
    [total_write]            BIGINT NOT NULL,
    [total_errors]           BIGINT NOT NULL,
    [loaded_into_repository] BIGINT NOT NULL
);


GO
PRINT N'Creating PK_server_monitor...';


GO
ALTER TABLE [dbo].[server_monitor]
    ADD CONSTRAINT [PK_server_monitor] PRIMARY KEY CLUSTERED ([hour_id] ASC);


GO
PRINT N'Creating [dbo].[server_sp_configure]...';


GO
CREATE TABLE [dbo].[server_sp_configure] (
    [Sample_Date]            DATETIME      NOT NULL,
    [name]                   NVARCHAR (35) NOT NULL,
    [minimum]                INT           NULL,
    [maximum]                INT           NULL,
    [config_value]           INT           NULL,
    [run_value]              INT           NULL,
    [loaded_into_repository] BIT           NOT NULL
);


GO
PRINT N'Creating [dbo].[sqlagent_job_info]...';


GO
CREATE TABLE [dbo].[sqlagent_job_info] (
    [Sample_Date]              DATETIME         NOT NULL,
    [job_id]                   UNIQUEIDENTIFIER NOT NULL,
    [originating_server]       NVARCHAR (30)    NULL,
    [name]                     NVARCHAR (128)   NULL,
    [enabled]                  TINYINT          NULL,
    [description]              NVARCHAR (512)   NULL,
    [start_step_id]            INT              NULL,
    [category]                 NVARCHAR (128)   NULL,
    [owner]                    NVARCHAR (128)   NULL,
    [notify_level_eventlog]    INT              NULL,
    [notify_level_email]       INT              NULL,
    [notify_level_netsend]     INT              NULL,
    [notify_level_page]        INT              NULL,
    [notify_email_operator]    NVARCHAR (128)   NULL,
    [notify_netsend_operator]  NVARCHAR (128)   NULL,
    [notify_page_operator]     NVARCHAR (128)   NULL,
    [delete_level]             INT              NULL,
    [date_created]             DATETIME         NULL,
    [date_modified]            DATETIME         NULL,
    [version_number]           INT              NULL,
    [last_run_date]            INT              NOT NULL,
    [last_run_time]            INT              NOT NULL,
    [last_run_outcome]         INT              NOT NULL,
    [next_run_date]            INT              NOT NULL,
    [next_run_time]            INT              NOT NULL,
    [next_run_schedule_id]     INT              NOT NULL,
    [current_execution_status] INT              NOT NULL,
    [current_execution_step]   NVARCHAR (128)   NULL,
    [current_retry_attempt]    INT              NOT NULL,
    [has_step]                 INT              NULL,
    [has_schedule]             INT              NULL,
    [has_target]               INT              NULL,
    [type]                     INT              NOT NULL,
    [loaded_into_repository]   BIT              NOT NULL
);


GO
PRINT N'Creating [dbo].[sqlagent_jobhistory]...';


GO
CREATE TABLE [dbo].[sqlagent_jobhistory] (
    [Sample_Date]            DATETIME         NOT NULL,
    [instance_id]            INT              NOT NULL,
    [job_id]                 UNIQUEIDENTIFIER NOT NULL,
    [step_id]                INT              NOT NULL,
    [step_name]              [sysname]        NOT NULL,
    [sql_message_id]         INT              NOT NULL,
    [sql_severity]           INT              NOT NULL,
    [message]                NVARCHAR (3000)  NULL,
    [run_status]             INT              NOT NULL,
    [run_date]               INT              NOT NULL,
    [run_time]               INT              NOT NULL,
    [run_duration]           INT              NOT NULL,
    [operator_id_emailed]    INT              NOT NULL,
    [operator_id_netsent]    INT              NOT NULL,
    [operator_id_paged]      INT              NOT NULL,
    [retries_attempted]      INT              NOT NULL,
    [server]                 [sysname]        NOT NULL,
    [loaded_into_repository] BIT              NOT NULL
);


GO
PRINT N'Creating [dbo].[sqlagent_jobschedule]...';


GO
CREATE TABLE [dbo].[sqlagent_jobschedule] (
    [Sample_Date]            DATETIME         NOT NULL,
    [schedule_id]            INT              NOT NULL,
    [job_id]                 UNIQUEIDENTIFIER NULL,
    [schedule_name]          NVARCHAR (128)   NULL,
    [enabled]                INT              NULL,
    [freq_type]              INT              NULL,
    [freq_interval]          INT              NULL,
    [freq_subday_type]       INT              NULL,
    [freq_subday_interval]   INT              NULL,
    [freq_relative_interval] INT              NULL,
    [freq_recurrence_factor] INT              NULL,
    [active_start_date]      INT              NULL,
    [active_end_date]        INT              NULL,
    [active_start_time]      INT              NULL,
    [active_end_time]        INT              NULL,
    [date_created]           DATETIME         NULL,
    [schedule_description]   NVARCHAR (2000)  NULL,
    [next_run_date]          INT              NULL,
    [next_run_time]          INT              NULL,
    [loaded_into_repository] BIT              NOT NULL
);


GO
PRINT N'Creating [dbo].[sqlagent_jobstep]...';


GO
CREATE TABLE [dbo].[sqlagent_jobstep] (
    [Sample_Date]            DATETIME         NOT NULL,
    [job_id]                 UNIQUEIDENTIFIER NULL,
    [step_id]                INT              NOT NULL,
    [step_name]              NVARCHAR (128)   NOT NULL,
    [subsystem]              NVARCHAR (40)    NOT NULL,
    [command]                NVARCHAR (MAX)   NULL,
    [flags]                  INT              NOT NULL,
    [cmdexec_success_code]   INT              NOT NULL,
    [on_success_action]      TINYINT          NOT NULL,
    [on_success_step_id]     INT              NOT NULL,
    [on_fail_action]         TINYINT          NOT NULL,
    [on_fail_step_id]        INT              NOT NULL,
    [server]                 NVARCHAR (128)   NULL,
    [database_name]          NVARCHAR (128)   NULL,
    [database_user_name]     NVARCHAR (128)   NULL,
    [retry_attempts]         INT              NOT NULL,
    [retry_interval]         INT              NOT NULL,
    [os_run_priority]        INT              NOT NULL,
    [output_file_name]       NVARCHAR (200)   NULL,
    [last_run_outcome]       INT              NOT NULL,
    [last_run_duration]      INT              NOT NULL,
    [last_run_retries]       INT              NOT NULL,
    [last_run_date]          INT              NOT NULL,
    [last_run_time]          INT              NOT NULL,
    [loaded_into_repository] BIT              NOT NULL
);


GO
PRINT N'Creating [dbo].[virtualFileStats]...';


GO
CREATE TABLE [dbo].[virtualFileStats] (
    [hour_id]                INT             NOT NULL,
    [db_id]                  SMALLINT        NOT NULL,
    [file_id]                SMALLINT        NOT NULL,
    [logical_name]           NVARCHAR (128)  NULL,
    [physical_name]          NVARCHAR (255)  NULL,
    [time_stamp]             BIGINT          NULL,
    [number_of_reads]        BIGINT          NULL,
    [number_of_writes]       BIGINT          NULL,
    [bytes_read]             DECIMAL (19, 2) NULL,
    [bytes_written]          DECIMAL (19, 2) NULL,
    [io_stall_ms]            BIGINT          NULL,
    [io_stall_read_ms]       BIGINT          NULL,
    [io_stall_write_ms]      BIGINT          NULL,
    [bytes_on_disk]          DECIMAL (19, 2) NULL,
    [loaded_into_repository] BIT             NOT NULL
);


GO
PRINT N'Creating pk_virtualfilestats...';


GO
ALTER TABLE [dbo].[virtualFileStats]
    ADD CONSTRAINT [pk_virtualfilestats] PRIMARY KEY CLUSTERED ([hour_id] ASC, [db_id] ASC, [file_id] ASC);


GO
PRINT N'Creating DF_backup_list_backup_order...';


GO
ALTER TABLE [dbo].[backup_list]
    ADD CONSTRAINT [DF_backup_list_backup_order] DEFAULT ((0)) FOR [backup_order];


GO
PRINT N'Creating DF_backup_list_full_backup_24h...';


GO
ALTER TABLE [dbo].[backup_list]
    ADD CONSTRAINT [DF_backup_list_full_backup_24h] DEFAULT ((0)) FOR [full_backup_24h];


GO
PRINT N'Creating DF_backup_list_isLogShipped...';


GO
ALTER TABLE [dbo].[backup_list]
    ADD CONSTRAINT [DF_backup_list_isLogShipped] DEFAULT ((0)) FOR [is_log_shipped];


GO
PRINT N'Creating DF_backup_list_tlog_backup_24h...';


GO
ALTER TABLE [dbo].[backup_list]
    ADD CONSTRAINT [DF_backup_list_tlog_backup_24h] DEFAULT ((0)) FOR [tlog_backup_24h];


GO
PRINT N'Creating On column: TimeID...';


GO
ALTER TABLE [dbo].[CTTraceSummary]
    ADD DEFAULT ((0)) FOR [TimeID];


GO
PRINT N'Creating On column: sample_date...';


GO
ALTER TABLE [dbo].[database_backupmediafamily]
    ADD DEFAULT (getdate()) FOR [sample_date];


GO
PRINT N'Creating On column: mirror...';


GO
ALTER TABLE [dbo].[database_backupmediafamily]
    ADD DEFAULT ((0)) FOR [mirror];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[database_backupmediafamily]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating On column: sample_date...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT (getdate()) FOR [sample_date];


GO
PRINT N'Creating On column: is_password_protected...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [is_password_protected];


GO
PRINT N'Creating On column: recovery_model...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [recovery_model];


GO
PRINT N'Creating On column: has_bulk_logged_data...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [has_bulk_logged_data];


GO
PRINT N'Creating On column: is_snapshot...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [is_snapshot];


GO
PRINT N'Creating On column: is_readonly...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [is_readonly];


GO
PRINT N'Creating On column: is_single_user...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [is_single_user];


GO
PRINT N'Creating On column: has_backup_checksums...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [has_backup_checksums];


GO
PRINT N'Creating On column: is_damaged...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [is_damaged];


GO
PRINT N'Creating On column: begins_log_chain...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [begins_log_chain];


GO
PRINT N'Creating On column: has_incomplete_metadata...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [has_incomplete_metadata];


GO
PRINT N'Creating On column: is_force_offline...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [is_force_offline];


GO
PRINT N'Creating On column: is_copy_only...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [is_copy_only];


GO
PRINT N'Creating On column: first_recovery_fork_guid...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [first_recovery_fork_guid];


GO
PRINT N'Creating On column: last_recovery_fork_guid...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [last_recovery_fork_guid];


GO
PRINT N'Creating On column: fork_point_lsn...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [fork_point_lsn];


GO
PRINT N'Creating On column: database_guid...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [database_guid];


GO
PRINT N'Creating On column: family_guid...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [family_guid];


GO
PRINT N'Creating On column: differential_base_lsn...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [differential_base_lsn];


GO
PRINT N'Creating On column: differential_base_guid...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [differential_base_guid];


GO
PRINT N'Creating On column: compressed_backup_size...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [compressed_backup_size];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[database_backupset]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating On column: Sample_Date...';


GO
ALTER TABLE [dbo].[database_details]
    ADD DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[database_details]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating On column: sample_date...';


GO
ALTER TABLE [dbo].[database_restorehistory]
    ADD DEFAULT (getdate()) FOR [sample_date];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[database_restorehistory]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating DF_database_size_loaded_into_repository...';


GO
ALTER TABLE [dbo].[database_size]
    ADD CONSTRAINT [DF_database_size_loaded_into_repository] DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating DF_database_size_Sample_Date...';


GO
ALTER TABLE [dbo].[database_size]
    ADD CONSTRAINT [DF_database_size_Sample_Date] DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: ForSMS...';


GO
ALTER TABLE [dbo].[EMailProfiles]
    ADD DEFAULT ((0)) FOR [ForSMS];


GO
PRINT N'Creating On column: continuation_row...';


GO
ALTER TABLE [dbo].[error_log]
    ADD DEFAULT ((0)) FOR [continuation_row];


GO
PRINT N'Creating On column: flagged...';


GO
ALTER TABLE [dbo].[error_log]
    ADD DEFAULT ((0)) FOR [flagged];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[error_log]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating DF_error_log_latestDate_latest_date...';


GO
ALTER TABLE [dbo].[error_log_latestDate]
    ADD CONSTRAINT [DF_error_log_latestDate_latest_date] DEFAULT (getdate()) FOR [latest_date];


GO
PRINT N'Creating DF_logshipping_files_archive_removed...';


GO
ALTER TABLE [dbo].[logshipping_files]
    ADD CONSTRAINT [DF_logshipping_files_archive_removed] DEFAULT ((0)) FOR [archive_removed];


GO
PRINT N'Creating DF_logshipping_files_sec_archive_removed...';


GO
ALTER TABLE [dbo].[logshipping_files]
    ADD CONSTRAINT [DF_logshipping_files_sec_archive_removed] DEFAULT ((0)) FOR [sec_archive_removed];


GO
PRINT N'Creating DF_server_details_loaded_into_repository...';


GO
ALTER TABLE [dbo].[server_details]
    ADD CONSTRAINT [DF_server_details_loaded_into_repository] DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating DF_server_details_Sample_Date...';


GO
ALTER TABLE [dbo].[server_details]
    ADD CONSTRAINT [DF_server_details_Sample_Date] DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: Sample_Date...';


GO
ALTER TABLE [dbo].[server_drivespace]
    ADD DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[server_drivespace]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating On column: Sample_Date...';


GO
ALTER TABLE [dbo].[server_logins]
    ADD DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[server_logins]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating DF_server_monitor_loaded_into_repository...';


GO
ALTER TABLE [dbo].[server_monitor]
    ADD CONSTRAINT [DF_server_monitor_loaded_into_repository] DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating On column: Sample_Date...';


GO
ALTER TABLE [dbo].[server_sp_configure]
    ADD DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[server_sp_configure]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating On column: Sample_Date...';


GO
ALTER TABLE [dbo].[sqlagent_job_info]
    ADD DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[sqlagent_job_info]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating On column: Sample_Date...';


GO
ALTER TABLE [dbo].[sqlagent_jobhistory]
    ADD DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[sqlagent_jobhistory]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating DF_sqlagent_jobschedule_loaded_into_repository...';


GO
ALTER TABLE [dbo].[sqlagent_jobschedule]
    ADD CONSTRAINT [DF_sqlagent_jobschedule_loaded_into_repository] DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating DF_sqlagent_jobschedule_Sample_Date...';


GO
ALTER TABLE [dbo].[sqlagent_jobschedule]
    ADD CONSTRAINT [DF_sqlagent_jobschedule_Sample_Date] DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: Sample_Date...';


GO
ALTER TABLE [dbo].[sqlagent_jobstep]
    ADD DEFAULT (getdate()) FOR [Sample_Date];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[sqlagent_jobstep]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating On column: loaded_into_repository...';


GO
ALTER TABLE [dbo].[virtualFileStats]
    ADD DEFAULT ((0)) FOR [loaded_into_repository];


GO
PRINT N'Creating CK_error_log_latestDate...';


GO
ALTER TABLE [dbo].[error_log_latestDate] WITH CHECK
    ADD CONSTRAINT [CK_error_log_latestDate] CHECK ([id]=(1));

GO

PRINT N'Creating [dbo].[usp_DBA_BlockingTracker]...';
GO
CREATE procedure [dbo].[usp_DBA_BlockingTracker] 
  @dur_secs int -- number of seconds to wait in loop
AS
BEGIN -- procedure
	set nocount on
	set dateformat dmy

  declare @waitText varchar(10);
  -- build WAITFOR DELAY period in format HH:MM:SS
  set @waitText = CASE WHEN @dur_secs/3600 < 10 THEN '0' ELSE '' END   
        + RTRIM(@dur_secs/3600) + ':' + RIGHT('0' + RTRIM((@dur_secs % 3600) / 60),2)  
        + ':' + RIGHT('0' + RTRIM((@dur_secs % 3600) % 60),2);

  while 1=1
  begin -- infinite loop
    if exists (
        select 1 from sys.dm_os_waiting_tasks 
        where blocking_session_id <> 0 
          and blocking_session_id <> @@spid
          and wait_duration_ms > 2000
      )
    begin -- blocking exists
      insert into [dbo].[blocking_session_info](
        [batch],[batchDate],[session_id],[blocking],[blocked_by],[wait_duration_ms]
        ,[db_name],[user_name],[host_name],[host_process_id],[login_time]
        ,[last_request_start_time],[last_request_end_time],[status],[command]
        ,[cpu_time],[total_elapsed_time],[reads],[writes],[logical_reads]
        ,[proc_name],[sql_statement],[blocking_line],[query_plan]
      )
      select 
        ISNULL((
            select MAX([batch]) 
            from dbo.blocking_session_info with (nolock)
          ),0) + 1 as [batch]
        , getdate() as [batchDate]
        , sess.[session_id]
        , blkr.[session_id] as blocking
        , wt.[blocking_session_id] as blocked_by
        , wt.[wait_duration_ms]  
        , db_name(er.[database_id]) as [db_name]
        , user_name(er.[user_id]) as [user_name]
        , sess.[host_name]
        , sess.[host_process_id]
        , sess.[login_time]
        , sess.[last_request_start_time]
        , sess.[last_request_end_time]
        , er.[status]
        , er.[command]
        , er.[cpu_time]
        , er.[total_elapsed_time]
        , er.[reads]
        , er.[writes]
        , er.[logical_reads]
        , OBJECT_NAME(hnd.[objectid]) as proc_name
        , hnd.[text] as [sql_statement]
        , SUBSTRING(hnd.[text],er.[statement_start_offset] / 2+1, ( (
            CASE 
              WHEN er.[statement_end_offset] = -1 THEN (LEN(CONVERT(nvarchar(max),hnd.text)) * 2) 
              ELSE er.[statement_end_offset]
            END
          ) - er.[statement_start_offset]) / 2 + 1 ) AS [blocking_line]
        , pln.[query_plan] as [query_plan]
      from sys.dm_exec_sessions sess
        left join sys.dm_exec_requests er
        on sess.session_id = er.session_id
          outer apply sys.dm_exec_sql_text(er.sql_handle) hnd
          outer apply sys.dm_exec_query_plan (er.plan_handle) AS pln
        left join sys.dm_os_waiting_tasks wt
        on sess.session_id = wt.session_id
        left join sys.dm_os_waiting_tasks blkr
        on sess.session_id = blkr.blocking_session_id
      where sess.session_id <> @@spid 
        and sess.session_id <> blkr.session_id
      order by sess.session_id 

    end -- blocking exists

    waitfor delay @waitText

  end -- infinite loop

END -- procedure
GO
PRINT N'Creating [dbo].[usp_DBA_spwho]...';


GO
CREATE procedure [dbo].[usp_DBA_spwho] 
	@include_sys_processes char(1) = 'N'
	, @active_only char(1) = 'Y'
	, @blocking_only char(1) = 'N'
as
begin -- procedure
	set nocount on
	set dateformat dmy

	select
		sess.[session_id]
		, blkr.[session_id] as [blocking]
		, wt.[blocking_session_id] as [blocked_by]
		, db_name(er.[database_id]) as [db_name]
		, sess.[login_name]
		, sess.[host_name]
		, sess.[host_process_id]
		, sess.[last_request_start_time]
		, sess.[last_request_end_time]
		, sess.[status]
		, sess.[program_name]
		, sess.[cpu_time]
		, sess.[memory_usage]
		, sess.[total_elapsed_time]
		, sess.[reads]
		, sess.[writes]
		, sess.[logical_reads]
		, OBJECT_NAME(txt.[objectid]) as proc_name
		, txt.[text] as sql_statement
		, case 
				  when blkr.[session_id] is null then null
				  else 
				    SUBSTRING(txt.[text],er.[statement_start_offset] / 2+1, ( (
						    CASE 
							    WHEN er.[statement_end_offset] = -1 THEN (LEN(CONVERT(nvarchar(max),txt.[text])) * 2) 
							    ELSE er.[statement_end_offset] 
						    END
					    ) - er.statement_start_offset) / 2 + 1 ) 
			  end AS [blocking_line]
    , pln.[query_plan]
	from sys.dm_exec_sessions sess
		left join sys.dm_exec_requests er
		on sess.session_id = er.session_id
		outer apply sys.dm_exec_sql_text(er.sql_handle) txt
    outer apply sys.dm_exec_query_plan (er.plan_handle) pln
		left join sys.dm_os_waiting_tasks wt
		on sess.session_id = wt.session_id
		left join sys.dm_os_waiting_tasks blkr
		on sess.session_id = blkr.blocking_session_id
	where (1 = case when @include_sys_processes = 'N' then sess.is_user_process else 1 end)
		and (@active_only = 'N' or (@active_only = 'Y' and er.session_id is not null))
		and (@blocking_only = 'N' or (@blocking_only = 'Y' and blkr.session_id is not null))
	order by
		sess.session_id 
		
end -- procedure
GO
PRINT N'Creating [dbo].[usp_ArchiveOldBackups]...';


GO


CREATE  procedure [dbo].[usp_ArchiveOldBackups]
  @dbName varchar(200) -- database to delete files for
	, @backupDir varchar(500) -- full drive and path to backup files
	, @debug char(1) -- 0 minimal informational messages, 1 extra messages
as
begin -- procedure
  set nocount on
  set dateformat dmy

 	declare @cnt int
  declare @cmdText varchar(500)
  declare @errorDesc varchar(1000)
  declare @errCode int
  declare @rtnCode int
 	declare @bkpName varchar(500)
 	declare @bkpFile varchar(200)
  declare @arcName varchar(500)


	if @debug = 'Y'
	begin
		print replicate('-', 40)
		print convert(varchar(30), getdate(), 120) + ' - Debug messages are on'
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @dbName = ' + @dbName
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @backupDir = ' + @backupDir
		print replicate('-', 40)
	end
	
  -- table for directory tree
  if object_id('tempdb..#f') is not null drop table #f;
  create table #f(
    fileDetail varchar(500)
    , fName varchar(255)
    , fdate datetime
    , fBytes bigint
    , id int not null identity (1, 1)
  )

  if right(@backupDir, 1) <> '\'
    set @backupDir = @backupDir + '\'

  -- DIR command
  set @cmdText = 'DIR /A-D "' + @backupDir + @dbName + '\*' + @dbName + '*.*"'
  if @debug = 'Y' 
  begin
  	print convert(varchar(30), getdate(), 120) + ' Directory listing command.'
  	print convert(varchar(30), getdate(), 120) + ' ' + isnull(@cmdText, 'No Command built')
  end

  -- execute command
  insert #f (fileDetail)
  exec @rtnCode = master.dbo.xp_cmdshell @cmdText
  set @errCode = @@error

  -- check for errors
  If (@errCode = 0) and (@rtnCode = 0)
  begin
  	if @debug = 'Y'
  	begin
  		print convert(varchar(30), getdate(), 120) + ' Before temp table cleanup.'
  		select * from #f
		  print replicate('-', 40)
  	end

    delete from #f
    where fileDetail like ' Volume%'
      or fileDetail like ' Directory%'
      or fileDetail like '%File(s)%'
      or fileDetail like '%Dir(s)%'
      or fileDetail like '%<DIR>%'
      or fileDetail like '%Total Files%'
      or fileDetail is null
  
  	if @debug = 'Y'
  	begin
  		print convert(varchar(30), getdate(), 120) + ' After temp table cleanup.'
  		select * from #f
		  print replicate('-', 40)
  	end

    -- table contents
    update #f
    set 
      #f.fName = ltrim(rtrim(right(trimmedName, charindex(' ', reverse(trimmedName)))))
      , #f.fBytes = cast(cast(left(trimmedName, charindex(' ', trimmedName)) as money) as bigint)
      , #f.fDate = cast(left(dtl, 20) as datetime)
    from #f 
      inner join (
          select
            id
            , fileDetail as dtl
            , ltrim(right(fileDetail, len(fileDetail)-21)) as trimmedName
          from #f
        ) as q
      on #f.id = q.id

  	if @debug = 'Y'
  	begin
  		print convert(varchar(30), getdate(), 120) + ' After temp table update.'
  		select * from #f
		  print replicate('-', 40)
  	end
  
  	-- print message showing total files
  	set @cnt = ISNULL((SELECT COUNT(id) from #f), 0)
  	print convert(varchar(30), getdate(), 120) + ' ' + cast(@cnt as varchar(10)) + ' file(s) in folder for database ' + @dbName

    if @cnt > 1
    begin
    	DECLARE cFiles CURSOR FOR
    		SELECT fName 
        from #f
        where not fDate in (
            select max(fDate)
            from #f
          )
  
    	OPEN cFiles
    	FETCH NEXT FROM cFiles into @bkpFile
  
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
        set @bkpName = @backupDir + @dbName + '\' + @bkpFile
        set @arcName = @backupDir + @dbName + '\Versions\'
      	if @debug = 'Y'
      	begin
      		-- print status message
      		print convert(varchar(30), getdate(), 120) + ' Processing file - "' + @bkpName + '"'
      		print convert(varchar(30), getdate(), 120) + ' Moving file to - "' + @arcName + '"'
    		  print replicate('-', 40)
      	end
        set @errCode = 0
        set @rtnCode = 0
  
        set @cmdText = 'MOVE /Y "' + @bkpName + '" "' + @arcName + '"'
        if @debug = 'Y'
        begin
          print convert(varchar(30), getdate(), 120) + ' - Move command "' + @cmdText + '"'
  	      exec @rtnCode = master..xp_cmdshell @cmdText
        end
        else
          exec @rtnCode = master..xp_cmdshell @cmdText, no_output
  
        -- check for errors
        If (@errCode <> 0) or (@rtnCode <> 0)
        begin
        	set @errorDesc = 'WARNING: Received Error Code ' + cast(@errCode as varchar(10))
            + ', and Return Code ' + cast(@rtnCode as varchar(10))
            + ', when executing command "' + @cmdText + '" to delete backup file.'
          if @debug = 'Y'
          begin
            select * from #f
            print @errorDesc
          end
          else
          	raiserror(@errorDesc, 10, 1) WITH LOG, NOWAIT
  
        end
  
    	  FETCH NEXT FROM cFiles into @bkpFile
    
    	END
    	
    	-- cleanup
    	CLOSE cFiles
    	DEALLOCATE cFiles

    end  	

  end
  else
  begin
  	set @errorDesc = 'WARNING: Message "' 
      + isnull((select top 1 filedetail from #f where filedetail is not null order by id desc), 'No Message')
      + '" received when executing command "' + @cmdText 
      + '" to list files in directory "' + @backupDir + '".'
    if @debug = 'Y'
    begin
      select * from #f
      print @errorDesc
    end
    else
    	raiserror(@errorDesc, 10, 1) WITH LOG, NOWAIT
  end

	print convert(varchar(30), getdate(), 120) + ' File processing complete for database ' + @dbName
	print replicate('=', 40)

end -- procedure
GO
PRINT N'Creating [dbo].[usp_Cycle_SQLAgentLog]...';


GO

CREATE PROCEDURE [dbo].[usp_Cycle_SQLAgentLog]
AS
begin -- procedure
  set nocount on;
  set dateformat ymd;
  
  declare @prodVer varchar(20);
  declare @ver int;

  set @prodVer = cast(serverproperty('ProductVersion') as varchar(20));
  set @ver = cast(left(@prodVer, charindex('.',@prodVer)-1) as int);
 
  if @ver >= 10
  begin -- SQL 2008+
    exec msdb.dbo.sp_cycle_agent_errorlog;

	end -- SQL 2008+
	else
	begin -- version < SQL 2008
	  raiserror('SQL Agent Log cycling not support in this version of SQL Server.', 10, 1) WITH LOG, NOWAIT;
	  
	end -- version < SQL 2008

END -- procedure
GO
PRINT N'Creating [dbo].[usp_DeleteOldBackups]...';


GO


CREATE  procedure [dbo].[usp_DeleteOldBackups]
  @dbName varchar(200) -- database to delete files for
	, @archiveDir varchar(500) -- full drive and path to backup files
	, @hoursOld int -- maximum age in hours of files to keep
	, @debug char(1) -- 0 minimal informational messages, 1 extra messages

as
begin -- procedure
  set nocount on
  set dateformat dmy

 	declare @cnt int
  declare @cmdText varchar(500)
	declare @maxDate datetime
  declare @errorDesc varchar(1000)
  declare @errCode int
  declare @rtnCode int
 	declare @bkpName varchar(500)
 	declare @bkpFile varchar(200)

	set @maxDate = dateadd(hh, -(@hoursold), getdate())	

	if @debug = 'Y'
	begin
		print replicate('-', 40)
		print convert(varchar(30), getdate(), 120) + ' - Debug messages are on'
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @dbName = ' + @dbName
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @archiveDir = ' + @archiveDir
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @hoursOld = ' + cast(@hoursOld as varchar(10))
		print convert(varchar(30), getdate(), 120) + ' - maximum backup age calculated @maxDate = ' + convert(varchar(30), @maxDate, 120)
		print replicate('-', 40)
	end
	
  -- table for directory tree
  if object_id('tempdb..#f') is not null drop table #f;
  create table #f(
    fileDetail varchar(500)
    , fName varchar(255)
    , fdate datetime
    , fBytes bigint
    , id int not null identity (1, 1)
  )

  if right(@archiveDir, 1) <> '\'
    set @archiveDir = @archiveDir + '\'

  -- DIR command
  set @cmdText = 'DIR /A-D "' + @archiveDir + @dbName + '\Versions\*' + @dbName + '*.*"'
  if @debug = 'Y' 
  begin
  	print convert(varchar(30), getdate(), 120) + ' Directory listing command.'
  	print convert(varchar(30), getdate(), 120) + ' ' + isnull(@cmdText, 'No Command built')
  end

  -- execute command
  insert #f (fileDetail)
  exec @rtnCode = master.dbo.xp_cmdshell @cmdText
  set @errCode = @@error

  -- check for errors
  If (@errCode = 0) and (@rtnCode = 0)
  begin
  	if @debug = 'Y'
  	begin
  		print convert(varchar(30), getdate(), 120) + ' Before temp table cleanup.'
  		select * from #f
		  print replicate('-', 40)
  	end

    delete from #f
    where fileDetail like ' Volume%'
      or fileDetail like ' Directory%'
      or fileDetail like '%File(s)%'
      or fileDetail like '%Dir(s)%'
      or fileDetail like '%<DIR>%'
      or fileDetail like '%Total Files%'
      or fileDetail is null
  
  	if @debug = 'Y'
  	begin
  		print convert(varchar(30), getdate(), 120) + ' After temp table cleanup.'
  		select * from #f
		  print replicate('-', 40)
  	end

    -- table contents
    update #f
    set 
      #f.fName = ltrim(rtrim(right(trimmedName, charindex(' ', reverse(trimmedName)))))
      , #f.fBytes = cast(cast(left(trimmedName, charindex(' ', trimmedName)) as money) as bigint)
      , #f.fDate = cast(left(dtl, 20) as datetime)
    from #f 
      inner join (
          select
            id
            , fileDetail as dtl
            , ltrim(right(fileDetail, len(fileDetail)-21)) as trimmedName
          from #f
        ) as q
      on #f.id = q.id

  	if @debug = 'Y'
  	begin
  		print convert(varchar(30), getdate(), 120) + ' After temp table update.'
  		select * from #f
		  print replicate('-', 40)
  	end
  
  	-- print message showing total files
  	set @cnt = ISNULL((SELECT COUNT(id) from #f), 0)
  	print convert(varchar(30), getdate(), 120) + ' ' + cast(@cnt as varchar(10)) + ' file(s) in archive for database ' + @dbName
  	set @cnt = ISNULL((SELECT COUNT(id) from #f where fDate < @maxDate), 0)
  	print convert(varchar(30), getdate(), 120) + ' ' + cast(@cnt as varchar(10)) + ' file(s) older than ' + convert(varchar(30), @maxDate, 120)

  	DECLARE cFiles CURSOR FOR
  		SELECT fName 
      from #f
      where fDate < @maxDate

  	OPEN cFiles
  	FETCH NEXT FROM cFiles into @bkpFile

  	WHILE @@FETCH_STATUS = 0
  	BEGIN
      set @bkpName = @archiveDir + @dbName + '\Versions\' + @bkpFile
    	if @debug = 'Y'
    	begin
    		-- print status message
    		print convert(varchar(30), getdate(), 120) + ' Processing file - "' + @bkpName + '"'
  		  print replicate('-', 40)
    	end
      set @errCode = 0
      set @rtnCode = 0

      set @cmdText = 'DEL "' + @bkpName + '"'
      if @debug = 'Y'
      begin
        print convert(varchar(30), getdate(), 120) + ' - Delete command "' + @cmdText + '"'
	      exec @rtnCode = master..xp_cmdshell @cmdText
      end
      else
        exec @rtnCode = master..xp_cmdshell @cmdText, no_output

      -- check for errors
      If (@errCode <> 0) or (@rtnCode <> 0)
      begin
      	set @errorDesc = 'WARNING: Received Error Code ' + cast(@errCode as varchar(10))
          + ', and Return Code ' + cast(@rtnCode as varchar(10))
          + ', when executing command "' + @cmdText + '" to delete backup file.'
        if @debug = 'Y'
        begin
          select * from #f
          print @errorDesc
        end
        else
        	raiserror(@errorDesc, 10, 1) WITH LOG, NOWAIT

      end

  	  FETCH NEXT FROM cFiles into @bkpFile
  
  	END
  	
  	-- cleanup
  	CLOSE cFiles
  	DEALLOCATE cFiles
  	
  end
  else
  begin
  	set @errorDesc = 'WARNING: Message "' 
      + isnull((select top 1 filedetail from #f where filedetail is not null order by id desc), 'No Message')
      + '" received when executing command "' + @cmdText 
      + '" to list files in directory "' + @archiveDir + '".'
    if @debug = 'Y'
    begin
      select * from #f
      print @errorDesc
    end
    else
    	raiserror(@errorDesc, 10, 1) WITH LOG, NOWAIT
  end

	print convert(varchar(30), getdate(), 120) + ' File processing complete for database ' + @dbName
	print replicate('=', 40)

end -- procedure
GO
PRINT N'Creating [dbo].[usp_LogShipping_ArchiveFiles]...';


GO


CREATE procedure [dbo].[usp_LogShipping_ArchiveFiles]
	@databaseName varchar(200) -- name of database to process
	, @archiveFolder VARCHAR(500) -- full drive and path to archive folder
	, @transferFolder VARCHAR(500) -- full drive and path to transfer folder
	, @fldrForDb char(1) = 'Y' -- Y or N to put files into seperate folders for each database
	, @onPrimary char(1) = 'N' -- Y running on primary server, N running on secondary server
	, @isCompressed CHAR(1) = 'Y' -- Y check for compressed file, N only check backup finish
	, @debug char(1) = 'Y' -- N minimal informational messages, Y extra messages
as

begin
	set nocount on
	set dateformat dmy

	-- table for xp_cmdshell output
	if object_id('tempdb..#h') is not null drop table #h;
	create table #h(output varchar(255), id int not null identity (1, 1))

	declare @fullPath varchar(500)
	DECLARE @backupDate DATETIME
	declare @backupName varchar(500)
	declare @destFolder varchar(500)
	declare @cmdText varchar(500)
	declare @cnt int
	declare @arcYear varchar(8)
	declare @arcMonth varchar(8)
	declare @arcDay varchar(8)
	declare @statusMsg varchar(500)

	declare @errText varchar(255)

	set @arcYear = ''
	set @arcMonth = ''
	set @arcDay = ''
	set @cmdText = ''
	if right(@archiveFolder, 1) <> '\'
		set @archiveFolder = @archiveFolder + '\'
	if right(@transferFolder, 1) <> '\'
		set @transferFolder = @transferFolder + '\'

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Start processing for database [%s].'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait

  -- on primary files need to be from finished backup, or compressed
  -- on secondary files need to have finished transfer
  SET @cnt = ISNULL((
      SELECT COUNT([FILE_ID]) 
      from [dbo].[logshipping_files]
      where [database_name] = @databaseName
        and 1 = 
          case 
            when (@onPrimary = 'Y') then -- on primary, is finsished backup, or compressed file
              case 
                when (@isCompressed = 'Y') and ([compress_date] is not null) and ([archive_date] is null) then 1
                when (@isCompressed = 'N') and ([backup_finishdate] is not null) and ([archive_date] is null) then 1
                else 0
              end
            else -- on secondary, file finished xfer, not archived
              case 
                when ([xfer_enddate] is not null) and ([sec_archive_date] is null) then 1
                else 0
              end
          end
    ),0)        
	set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + cast(@cnt as varchar(10)) + ' file(s) to be processed'
	raiserror(@statusMsg, 10, 1) with nowait

  if @cnt > 0 
  begin -- files to process
	  -- get list of files to process
	  DECLARE csrFiles CURSOR FOR
      SELECT case when (@onPrimary = 'Y') then [compress_filename] else [xfer_filename] end as [full_path]
        , [backup_finishdate]
      FROM [dbo].[logshipping_files]
      WHERE [database_name] = @databaseName
        and 1 = 
          case 
            when (@onPrimary = 'Y') then -- on primary, is finsished backup, or compressed file
              case 
                when (@isCompressed = 'Y') and ([compress_date] is not null) and ([archive_date] is null) then 1
                when (@isCompressed = 'N') and ([backup_finishdate] is not null) and ([archive_date] is null) then 1
                else 0
              end
            else -- on secondary, file finished xfer, not archived
              case 
                when ([xfer_enddate] is not null) and ([sec_archive_date] is null) then 1
                else 0
              end
          end

	  OPEN csrFiles
	  FETCH NEXT FROM csrFiles into @fullPath, @backupDate

	  WHILE @@FETCH_STATUS = 0
	  BEGIN
		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing file "%s".'
	    raiserror(@statusMsg, 10, 1, @fullPath) with nowait
	    -- move file from backups to archive
	    -- get day, month and year for archive directory
	    set @arcYear = CAST(DATEPART(yy,@backupDate) AS varchar(10))
	    set @arcMonth = RIGHT('00' + CAST(DATEPART(mm,@backupDate) AS varchar(10)), 2)
	    set @arcDay = RIGHT('00' + CAST(DATEPART(dd,@backupDate) AS varchar(10)), 2)
	    SET @backupName = RIGHT(@fullPath, CHARINDEX('\', REVERSE(@fullPath))-1)

	    -- make sure archive directory structure exists
	    set @destFolder = @archiveFolder + @arcYear + '\' + @arcMonth + '\' + @arcDay + '\'
	        + case when @fldrForDb = 'Y' then @databaseName + '\' else '' end 
  	    
	    set @cmdText = 'if not exist "' + @destFolder + '" md "' + @destFolder + '"'
	    if @debug = 'Y' 
	    begin
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Directory checking command is'
        raiserror(@statusMsg, 10, 1) with nowait
		    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
        raiserror(@statusMsg, 10, 1) with nowait
		    exec master..xp_cmdshell @cmdText
	    end
	    else
		    exec master..xp_cmdshell @cmdText, no_output

      -- copy file to archive
	    set @cmdText = 'copy "' + @fullPath + '" "' + @destFolder + '" /Y'
	    if @debug = 'Y' 
	    begin
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Copy command built is'
        raiserror(@statusMsg, 10, 1) with nowait
	      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
        raiserror(@statusMsg, 10, 1) with nowait
      end
      
      delete from #h 
      -- execute command     
	    insert into #h exec master..xp_cmdshell @cmdText

      -- check if command was successful
		  if exists (select top 1 output from #h where output like '%1 file%')
		  begin -- file copied
	      if @debug = 'Y'
	      begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + N' - File "%s" successfully copied to "%s".'
          raiserror(@statusMsg, 10, 1, @backupName, @destFolder) with nowait
        end
        IF @onPrimary = 'Y'
        BEGIN
          -- update archived file details
          UPDATE [dbo].[logshipping_files]
          SET [archive_filename] = @destFolder + @backupName
            , [archive_date] = GETDATE()
          WHERE [compress_filename] = @fullPath
        END
        ELSE
        BEGIN
          -- update archived file details
          UPDATE [dbo].[logshipping_files]
          SET [sec_archive_name] = @destFolder + @backupName
            , [sec_archive_date] = GETDATE()
          WHERE [xfer_filename] = @fullPath
        END
        --
        -- MOVE to transfer folder to make ready for move to secondary
        --
	      -- make sure transfer directory structure exists
        SET @destFolder = @transferFolder + case when @fldrForDb = 'Y' then @databaseName + '\' else '' end
	      set @cmdText = 'if not exist "' + @destFolder + '" md "' + @destFolder + '"'
  	    
	      if @debug = 'Y' 
	      begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Directory checking command is'
          raiserror(@statusMsg, 10, 1) with nowait
		      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
          raiserror(@statusMsg, 10, 1) with nowait
		      exec master..xp_cmdshell @cmdText
	      end
	      else
		      exec master..xp_cmdshell @cmdText, no_output

		    -- move file to transfer folder
	      set @cmdText = 'move /Y "' + @fullPath + '" "' + @destFolder + '"'
		    if @debug = 'Y'
		    begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Move command built is'
          raiserror(@statusMsg, 10, 1) with nowait
		      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
	        raiserror(@statusMsg, 10, 1) with nowait
	      end

        delete from #h 
        -- execute command     
		    insert into #h exec master..xp_cmdshell @cmdText

        -- check if command was successful
		    if exists (select top 1 output from #h where output like '%1 file%')
		    begin -- file moved to transfer
		      if @debug = 'Y'
		      begin
            set @statusMsg = convert(varchar(30), getdate(), 120) + N' - File "%s" successfully moved to "%s".'
            raiserror(@statusMsg, 10, 1, @backupName, @destFolder) with nowait
          END
          IF @onPrimary = 'Y'
          BEGIN
            -- update transfer file details
            UPDATE [dbo].[logshipping_files]
            SET [xfer_filename] = @destFolder + @backupName
              , [xfer_readydate] = GETDATE()
            WHERE [compress_filename] = @fullPath
          end

		    end -- file moved to transfer
		    else
		    begin -- error moving file to transfer
	        select * from #h
	        set @statusMsg = convert(varchar(30), getdate(), 120) + N' - ERROR moving file "%s" to transfer folder "%s".'
          raiserror(@statusMsg, 10, 1, @backupName, @destFolder) with nowait
			    if @debug = 'N'
			    begin
            set @statusMsg = convert(varchar(30), getdate(), 120) + ' - move command executed was'
            raiserror(@statusMsg, 10, 1) with nowait
			      set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + isnull(@cmdText, 'No Command built')
            raiserror(@statusMsg, 10, 1) with nowait
			    end
			    set @errText = 'ERROR: ' + isnull((select top 1 output from #h where output is not null), 'An unknown error occurred moving file.')
			    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + @errText
          raiserror(@statusMsg, 10, 1) with nowait
		    end -- error moving file to transfer
		  end -- file moved
		  else
	    begin -- error copying file to archive
	      select * from #h
        set @statusMsg = convert(varchar(30), getdate(), 120) + N' - ERROR copying file "%s" to archive folder "%s".'
        raiserror(@statusMsg, 10, 1, @backupName, @destFolder) with nowait
		    if @debug = 'N'
		    begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - copy command executed was'
          raiserror(@statusMsg, 10, 1) with nowait
		      set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + isnull(@cmdText, 'No Command built')
          raiserror(@statusMsg, 10, 1) with nowait
  	    end
		    set @errText = 'ERROR: ' + isnull((select top 1 output from #h where output is not null), 'An unknown error occurred copying file.')
		    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + @errText
        raiserror(@statusMsg, 10, 1) with nowait

	    end -- error copying file to archive

	    FETCH NEXT FROM csrFiles into @fullPath, @backupDate

	  END

	  CLOSE csrFiles
	  DEALLOCATE csrFiles

  end -- files to process

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing complete for database [%s].'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait
  set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + replicate('=', 40)
  raiserror(@statusMsg, 10, 1) with nowait

end
GO
PRINT N'Creating [dbo].[usp_LogShipping_BackupLogs]...';


GO


CREATE procedure [dbo].[usp_LogShipping_BackupLogs]
	@databaseName varchar(200) -- comma seperated list of databases
	, @backupFolder varchar(500) -- full drive and path to backup to
	, @backupExt varchar(10) = 'bak' -- file extension to use for backup file
	, @fldrForDb char(1) = 'Y' -- Y or N to put backups into seperate folders for each database
	, @debug char(1) = 'N' -- N minimal informational messages, Y extra messages
as

begin
	set nocount on
	set dateformat dmy

	declare @cmdText nvarchar(500)
	declare @backupFile varchar(100)
	declare @fullPath varchar(500)
	declare @serverName varchar(50)
	declare @statusMsg varchar(500)
	declare @ts varchar(15)
	declare @err int
	declare @rtn int
	declare @er int
	declare @rt int

	set @err = 0
	set @rtn = 0
	set @er = ''
	set @rt = ''
	set @cmdText = ''
	set @backupFile = ''
	set @fullPath = ''
	-- save timestamp and servername for backup filename
	set @ts = convert(varchar(10), getdate(), 112) + replace(convert(varchar(10), getdate(), 108), ':', '')
	set @serverName = replace(cast(serverproperty('serverName') as varchar(50)), '\', '$')

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Start processing for database [%s].'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait

	if right(@backupFolder, 1) <> '\'
		set @backupFolder = @backupFolder + '\'

  if exists(select [name] from [master].[dbo].[sysdatabases] where [name] = @databaseName)
  begin -- database exists on server
    -- check if database is in state for log backup
    --  > database should be ONLINE
    --  > recovery mode should be FULL
    --  > a full backup should have been taken
    if exists(
        select bkp.database_name
        from DBA.dbo.backup_list bkp
          inner join master..sysdatabases db 
          on bkp.database_name = db.name collate database_default
        where bkp.database_name = @databaseName
          and databasepropertyex(db.name, 'Status') = 'ONLINE'
          and databasepropertyex(db.name, 'Recovery') = 'FULL'
          and 1 = CASE WHEN bkp.tlog_backup = 1 THEN 
                      CASE WHEN bkp.last_full_backup IS NULL THEN 0 
                        ELSE 1 END ELSE 0 END
      )
    begin -- database ready for log backup
	    -- build dynamic filename for backup
	    set @backupFile = @serverName + '_'  + @databaseName + '_tlog_' + @ts + '.' + @backupExt

	    if @debug = 'Y'
	    begin
	      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - backup file name is : "%s"'
	      raiserror(@statusMsg, 10, 1, @backupFile) with nowait
	    end

			-- check and create folder for database if necessary
    	if @fldrForDb = 'Y'
			begin
				set @fullPath = @backupFolder + @databaseName + '\'

				if @debug = 'Y'
				begin
					set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Checking/Creating backup folder "%s"'
	        raiserror(@statusMsg, 10, 1, @fullPath) with nowait
	      end

		    set @cmdText = 'MD ' + quotename(@fullPath, '"')
		    exec master..xp_cmdshell @cmdText, no_output
				set @fullPath = @fullPath + @backupFile

			end
			else
				set @fullPath = @backupFolder + @backupFile

      insert into [dbo].[logshipping_files] (
        [database_name]
        ,[backup_filename]
        ,[backup_startdate]
      ) VALUES (
        @databaseName
        , @fullPath
        , getdate()
      )

	    if @debug = 'Y'
	    begin
	      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - full patch and filename for backup is : "%s"'
	      raiserror(@statusMsg, 10, 1, @fullPath) with nowait
	    end

	    set @cmdText = 'backup log ' + @databaseName + ' to disk = ''' + @fullPath + ''''
	    if @debug = 'Y'
	    begin
	      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - backup command built is'
	      raiserror(@statusMsg, 10, 1) with nowait
	      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
	      raiserror(@statusMsg, 10, 1) with nowait
	    end
	    set @statusMsg = convert(varchar(30), getdate(), 120) + N' - Performing Log backup for database [%s].'
      raiserror(@statusMsg, 10, 1, @databaseName) with nowait
	    exec @rtn = sp_executesql @cmdText
	    set @err = @@ERROR

	    If (@err = 0) and (@rtn = 0)
	    begin -- completed ok
        update [dbo].[logshipping_files] 
        set [backup_finishdate] = getdate()
        where [backup_filename] = @fullPath;

	      set @statusMsg = convert(varchar(30), getdate(), 120) + N' - Log backup for database [%s] completed.'
        raiserror(@statusMsg, 10, 1, @databaseName) with nowait
	    end -- completed ok
	    else
	    begin -- backup error
	      set @er = cast(@err as varchar(10))
	      set @rt = cast(@rtn as varchar(10))
		    set @statusMsg = convert(varchar(30), getdate(), 120) + N' - ERROR in backup for database [%s].'
	      raiserror(@statusMsg, 10, 1, @databaseName) with nowait
		    if @debug = 'N'
		    begin
	        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - backup command executed was'
	        raiserror(@statusMsg, 10, 1) with nowait
	        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
	        raiserror(@statusMsg, 10, 1) with nowait
		    end
		    set @statusMsg = convert(varchar(30), getdate(), 120) + N' - Return value: %s, Error code: %s '
	      raiserror(@statusMsg, 10, 1, @rt, @er) with nowait
	    end -- backup error
    end -- database ready for log backup
    else
    begin -- database state not valid
	    set @statusMsg = convert(varchar(30), getdate(), 120) + N' - Database [%s] is not in a state to allow log backups.'
      raiserror(@statusMsg, 10, 1, @databaseName) with nowait
	    set @statusMsg = convert(varchar(30), getdate(), 120) + N' - Check database status, recovery model, and last full backup.'
      raiserror(@statusMsg, 10, 1) with nowait
    
    end -- database state not valid
  end -- database exists
  else
  begin -- database not on server
    set @statusMsg = convert(varchar(30), getdate(), 120) + N' - Database [%s] does not exist on server [%s].'
    raiserror(@statusMsg, 10, 1, @databaseName, @serverName) with nowait
  
  end -- database not on server
  
  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing complete for database [%s].'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait
  set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + replicate('=', 40)
  raiserror(@statusMsg, 10, 1) with nowait

end
GO
PRINT N'Creating [dbo].[usp_LogShipping_CleanupFolders]...';


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER OFF;


GO
CREATE PROCEDURE [dbo].[usp_LogShipping_CleanupFolders]
  @archiveDir varchar(1000) -- full drive and path to archive compressed files
	, @debug char(1) = 'N' -- N minimal informational messages, Y extra messages
AS
BEGIN -- procedure

  SET NOCOUNT ON;
  SET DATEFORMAT dmy;

	-- table for directory tree
	if exists(select * from tempdb..sysobjects where id = object_id('tempdb..#f')) drop table #f;
	create table #f(fullpath varchar(500), filedate datetime, id int not null identity (1, 1))

	declare @cmdText varchar(500)
	declare @cnt int
	declare @folderName varchar(200)
	declare @statusMsg varchar(500)

	set @statusMsg = convert(varchar(30), getdate(), 120) + ' Removing empty directories in "' + @archiveDir + '"'
	raiserror(@statusMsg, 10, 1) with nowait

	-- DIR /B=bare format, /S=recurse subdirs, /AD=directories only
	set @cmdText = 'DIR /B /S /AD "' + @archiveDir + '"'
	if @debug = 'Y' 
	begin
		set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + @cmdText
	  raiserror(@statusMsg, 10, 1) with nowait
	end
	delete from #f 

	insert #f (fullpath)
	execute master.dbo.xp_cmdshell @cmdText

	if @debug = 'Y'
	begin
		set @statusMsg = convert(varchar(30), getdate(), 120) + ' before deleting unwanted records from temp table.'
		raiserror(@statusMsg, 10, 1) with nowait
		select * from #f
	end

	delete from #f 
	where #f.fullpath is null
		or #f.fullpath = 'File Not Found' 
		or #f.fullpath like 'The system cannot find%'

	-- print message showing total files
	set @cnt = ISNULL((SELECT COUNT([id]) from #f), 0)
	set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + cast(@cnt as varchar(10)) 
    + ' folder(s) in archive.'
	raiserror(@statusMsg, 10, 1) with nowait

	DECLARE csrFiles CURSOR FOR
		SELECT fullpath 
		from #f
		order by id desc

	OPEN csrFiles

	FETCH NEXT FROM csrFiles into @folderName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- print status message
		set @statusMsg = convert(varchar(30), getdate(), 120) + ' Processing folder - "' + @folderName + '"'
	  raiserror(@statusMsg, 10, 1) with nowait

		-- remove the directory
		set @cmdText = 'rd "' + @folderName + '"'
		if @debug = 'Y' 
		begin
			set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + isnull(@cmdText, 'No Command built')
	    raiserror(@statusMsg, 10, 1) with nowait
			exec master..xp_cmdshell @cmdText
		end
		else
			exec master..xp_cmdshell @cmdText, no_output

		FETCH NEXT FROM csrFiles into @folderName
	END

	-- cleanup
	CLOSE csrFiles
	DEALLOCATE csrFiles

	set @statusMsg = convert(varchar(30), getdate(), 120) + ' Folder processing complete.'
	raiserror(@statusMsg, 10, 1) with nowait

END -- procedure
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[usp_LogShipping_CompressFiles]...';


GO

CREATE procedure dbo.usp_LogShipping_CompressFiles
  @databaseName sysname -- database to process
	, @zipCmdLine varchar(500) -- full zip command line including path and executable filename
	, @zipCmdToken VARCHAR(10) -- token in command line to replace with filename
	, @zipExt varchar(10) -- file extension usually appended to filename
	, @debug CHAR(1) = 'N' -- N minimal informational messages, Y extra messages
as

begin -- procedure
	set nocount on
	set dateformat dmy

	declare @backupName varchar(500)
	declare @zippedName varchar(500)
	declare @cmdText varchar(1000)
	DECLARE @err int
	declare @cnt int
	declare @statusMsg varchar(500)

  -- get count of files to process
  SET @cnt = ISNULL((
      SELECT COUNT([file_id])
      FROM [dbo].[logshipping_files] 
      WHERE [database_name] = @databaseName
        AND (NOT([backup_finishdate] IS NULL))
        AND [compress_date] IS NULL
    ), 0)

	set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + cast(@cnt as varchar(10)) + ' file(s) to be processed'
	raiserror(@statusMsg, 10, 1) with nowait

  IF @cnt > 0
  BEGIN -- files to process

	  DECLARE curFiles CURSOR FAST_FORWARD FOR
      SELECT [backup_filename]
      FROM [dbo].[logshipping_files] 
      WHERE [database_name] = @databaseName
        AND (NOT([backup_finishdate] IS NULL))
        AND [compress_date] IS NULL
	  OPEN curFiles
	  FETCH NEXT FROM curFiles into @backupName

	  WHILE @@FETCH_STATUS = 0
	  BEGIN -- cursor loop
		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing file "%s".'
	    raiserror(@statusMsg, 10, 1, @backupName) with nowait

		  -- compress file
		  set @cmdText = REPLACE(@zipCmdLine, @zipCmdToken, @backupName)
		  if @debug = 'Y' 
		  BEGIN
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Zip command built is'
        raiserror(@statusMsg, 10, 1) with nowait
  		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
  	    raiserror(@statusMsg, 10, 1, @cmdText) with nowait
		    exec @err = master..xp_cmdshell @cmdText
  	  END
  	  ELSE
		    exec @err = master..xp_cmdshell @cmdText, no_output

      IF @err = 0
      BEGIN -- file zipped
        SET @zippedName = @backupName + @zipExt
        -- update compressed file details
        UPDATE [dbo].[logshipping_files]
        SET [compress_filename] = @zippedName
          , [compress_date] = GETDATE()
        WHERE [backup_filename] = @backupName
        
      END -- file zipped
      ELSE
      BEGIN -- zipping error
	      set @statusMsg = convert(varchar(30), getdate(), 120) + N' - ERROR compressing file "%s".'
        raiserror(@statusMsg, 10, 1, @backupName) with nowait
			  if @debug = 'N'
			  begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Zip command built was'
          raiserror(@statusMsg, 10, 1) with nowait
  		    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
  	      raiserror(@statusMsg, 10, 1, @cmdText) with nowait
			  end
      
      END -- zipping error
      
  		FETCH NEXT FROM curFiles into @backupName
	  END -- cursor loop

	  CLOSE curFiles
	  DEALLOCATE curFiles

  END -- files to process

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing complete for database [%s].'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait
  set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + replicate('=', 40)
  raiserror(@statusMsg, 10, 1) with nowait
  
END -- procedure  
GO
PRINT N'Creating [dbo].[usp_LogShipping_DecompressFiles]...';


GO

CREATE procedure [dbo].[usp_LogShipping_DecompressFiles]
  @databaseName sysname -- database to process
  , @backupFolder VARCHAR(500) -- full drive and path to transfer folder on standby server
	, @fldrForDb char(1) = 'Y' -- Y or N to put files into seperate folders for each database
	, @zipCmdLine varchar(500) -- full zip command line including path and executable filename
	, @zipCmdToken VARCHAR(10) -- token in command line to replace with filename
	, @zipExt varchar(10) -- file extension usually appended to filename
	, @debug CHAR(1) = 'N' -- N minimal informational messages, Y extra messages
as

begin -- procedure
	set nocount on
	set dateformat dmy

	declare @fullPath varchar(500)
	declare @backupName varchar(500)
	declare @zippedName varchar(500)
	declare @unzipName varchar(500)
	declare @cmdText varchar(1000)
	declare @err int
	declare @cnt int
	declare @statusMsg varchar(500)

	if right(@backupFolder, 1) <> '\'
		set @backupFolder = @backupFolder + '\'

  -- get count of files to process
  SET @cnt = ISNULL((
      SELECT COUNT([file_id])
      FROM [dbo].[logshipping_files] 
      WHERE [database_name] = @databaseName
        AND (NOT([sec_archive_date] IS NULL))
        AND [decompress_date] IS NULL
    ), 0)

	set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + cast(@cnt as varchar(10)) + ' file(s) to be processed'
	raiserror(@statusMsg, 10, 1) with nowait

  IF @cnt > 0
  BEGIN -- files to process

	  DECLARE curFiles CURSOR FAST_FORWARD FOR
      SELECT [xfer_filename]
      FROM [dbo].[logshipping_files] 
      WHERE [database_name] = @databaseName
        AND (NOT([sec_archive_date] IS NULL))
        AND [decompress_date] IS NULL
	  OPEN curFiles
	  FETCH NEXT FROM curFiles into @fullPath

	  WHILE @@FETCH_STATUS = 0
	  BEGIN -- cursor loop
	    SET @backupName = RIGHT(@fullPath, CHARINDEX('\', REVERSE(@fullPath))-1)
	    SET @zippedName = @backupFolder + case when @fldrForDb = 'Y' then @databaseName + '\' else '' end + @backupName
		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing file "%s".'
	    raiserror(@statusMsg, 10, 1, @backupName) with nowait

		  -- compress file
		  set @cmdText = REPLACE(@zipCmdLine, @zipCmdToken, @zippedName)
		  if @debug = 'Y' 
		  BEGIN
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Zip command built is'
        raiserror(@statusMsg, 10, 1) with nowait
  		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
  	    raiserror(@statusMsg, 10, 1, @cmdText) with nowait
		    exec @err = master..xp_cmdshell @cmdText
  	  END
  	  ELSE
		    exec @err = master..xp_cmdshell @cmdText, no_output

      IF @err = 0
      BEGIN -- file unzipped
        SET @unzipName = REPLACE(@zippedName, @zipExt, '')
        -- update compressed file details
        UPDATE [dbo].[logshipping_files]
        SET [decompress_filename] = @unzipName
          , [decompress_date] = GETDATE()
        WHERE [xfer_filename] = @fullPath
        
      END -- file zipped
      ELSE
      BEGIN -- zipping error
	      set @statusMsg = convert(varchar(30), getdate(), 120) + N' - ERROR decompressing file "%s".'
        raiserror(@statusMsg, 10, 1, @zippedName) with nowait
			  if @debug = 'N'
			  begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Zip command built was'
          raiserror(@statusMsg, 10, 1) with nowait
  		    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
  	      raiserror(@statusMsg, 10, 1, @cmdText) with nowait
			  end
      
      END -- zipping error
      
  		FETCH NEXT FROM curFiles into @fullPath
	  END -- cursor loop

	  CLOSE curFiles
	  DEALLOCATE curFiles

  END -- files to process

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing complete for database [%s].'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait
  set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + replicate('=', 40)
  raiserror(@statusMsg, 10, 1) with nowait
  
END -- procedure  
GO
PRINT N'Creating [dbo].[usp_LogShipping_RestoreLogs]...';


GO


CREATE procedure [dbo].[usp_LogShipping_RestoreLogs]
	@databaseName varchar(200) -- database name
	, @databaseNameAs varchar(200) = NULL -- restore database to different name
	, @fldrForDb char(1) = 'Y' -- Y or N backup files are in seperate folders for each database
	, @debug char(1) = 'N' -- 0 minimal informational messages, 1 extra messages
as

begin
	set nocount on
	set dateformat dmy

	declare @db varchar(150)
	declare @cmdText nvarchar(4000)
	declare @cmdText2 nvarchar(4000)
	declare @restoreFile varchar(500)
	declare @statusMsg varchar(1000)
	declare @fileType char(1)
	declare @csrOuter int
	declare @csrInner int
	declare @cnt int
	declare @err int
	declare @rtn int
	declare @er varchar(10)
	declare @rt varchar(10)

	SET @db = ''
	SET @cnt = 0
	SET @err = 0
	SET @rtn = 0

  SET @cnt = ISNULL((
      SELECT COUNT([FILE_ID])
      FROM [dbo].[logshipping_files]
      WHERE [database_name] = @databaseName
        AND [restore_date] IS NULL
        AND (NOT ([decompress_date] IS NULL))
    ), 0)
	set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + cast(@cnt as varchar(10)) + ' file(s) to be processed'
	raiserror(@statusMsg, 10, 1) with nowait

	DECLARE csrFiles CURSOR FOR
      SELECT [decompress_filename]
      FROM [dbo].[logshipping_files]
      WHERE [database_name] = @databaseName
        AND [restore_date] IS NULL
        AND (NOT ([decompress_date] IS NULL))
	OPEN csrFiles

	FETCH NEXT FROM csrFiles into @restoreFile
	set @csrOuter = @@FETCH_STATUS

	while (@csrOuter = 0 and @err = 0)
	begin -- file processing cursor
	  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing file - "' + @restoreFile + '"'
	  raiserror(@statusMsg, 10, 1) with nowait

	  -- build sql command to restore file
	  set @cmdText = 'RESTORE LOG ' + QUOTENAME(ISNULL(@databaseNameAs, @databaseName)) 
	    + ' FROM DISK = ' + QUOTENAME(@restoreFile, '''') + ' WITH NORECOVERY'
	  if @debug = 'Y'
	  begin
		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - FULL RESTORE COMMAND'
		  raiserror(@statusMsg, 10, 1) with nowait
		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
	    raiserror(@statusMsg, 10, 1) with nowait
	  end

	  set @rtn = 0;
	  SET @err = 0;
	  EXEC @rtn = sp_executesql @cmdText
	  set @err = @@ERROR
  	If @err = 0 and @rtn = 0
	  begin -- restore ok
      UPDATE [dbo].[logshipping_files]
      SET [Restore_date] = GETDATE()
        , [restore_filename] = @restoreFile
      WHERE [decompress_filename] = @restoreFile

		  -- delete restored file
		  set @cmdText = 'del "' + @restoreFile + '"'
		  if @debug = 'Y'
	    begin
		    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - File delete command'
		    raiserror(@statusMsg, 10, 1) with nowait
		    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
		    raiserror(@statusMsg, 10, 1) with nowait
		    exec master..xp_cmdshell @cmdText
	    end
	    else
	    begin
			  exec master..xp_cmdshell @cmdText, no_output
		  end
	  end -- restore ok
	  else
	  begin -- restore error
	    set @er = cast(@err as varchar(10))
	    set @rt = cast(@rtn as varchar(10))
	    if @debug = 'N'
	    begin
		    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - FULL RESTORE COMMAND'
		    raiserror(@statusMsg, 10, 1) with nowait
		    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
  		  raiserror(@statusMsg, 10, 1) with nowait
	    end
		  set @statusMsg = convert(varchar(30), getdate(), 120) + N' - Restore failed. Error: [%s], Return: [%s].'
	    raiserror(@statusMsg, 10, 1, @er, @rt) with nowait
	  end -- restore error

		FETCH NEXT FROM csrFiles into @restoreFile
	  set @csrOuter = @@FETCH_STATUS
		
	END -- file processing cursor

	CLOSE csrFiles
	DEALLOCATE csrFiles

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing complete for database [%s].'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait
  set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + replicate('=', 40)
  raiserror(@statusMsg, 10, 1) with nowait

end
GO
PRINT N'Creating [dbo].[usp_LogShipping_SyncFileTable]...';


GO

CREATE procedure [dbo].[usp_LogShipping_SyncFileTable] 
	@debug CHAR(1) = 'N' -- N minimal informational messages, Y extra messages
AS

BEGIN -- PROCEDURE
	SET NOCOUNT ON
	SET DATEFORMAT dmy

  DECLARE @cnt INT;
	DECLARE @statusMsg varchar(1000);

  -- insert newly created records
  SET IDENTITY_INSERT [dbo].[logshipping_files] ON;

  INSERT INTO [dbo].[logshipping_files] (
    [file_id],[database_name],[backup_startdate],[backup_finishdate]
    ,[backup_filename],[compress_date],[compress_filename],[archive_date]
    ,[archive_filename],[archive_removed],[xfer_readydate],[xfer_filename]
  )
  SELECT 
    pri.[file_id],pri.[database_name],pri.[backup_startdate],pri.[backup_finishdate]
    ,pri.[backup_filename],pri.[compress_date],pri.[compress_filename],pri.[archive_date]
    ,pri.[archive_filename],pri.[archive_removed],pri.[xfer_readydate],pri.[xfer_filename]
  FROM [dbo].[logshipping_files] pri WITH (nolock)
    LEFT JOIN [dbo].[logshipping_files] sec
    ON pri.[file_id] = sec.[file_id]
  WHERE sec.[file_id] IS NULL;

  SET IDENTITY_INSERT [dbo].[logshipping_files] OFF;

  SET @cnt = @@ROWCOUNT;
  SET @statusMsg = convert(varchar(30), getdate(), 120) + ' - Copied ' 
    + CAST(@cnt AS VARCHAR(10)) + ' new record(s) to secondary server.'
  RAISERROR(@statusMsg, 10, 1) WITH NOWAIT

  -- update SECONDARY server with backup/compress/archive details
  UPDATE sec
  SET 
    sec.[backup_startdate] = pri.[backup_startdate]
    ,sec.[backup_finishdate] = pri.[backup_finishdate]
    ,sec.[backup_filename] = pri.[backup_filename]
    ,sec.[compress_date] = pri.[compress_date]
    ,sec.[compress_filename] = pri.[compress_filename]
    ,sec.[archive_date] = pri.[archive_date]
    ,sec.[archive_filename] = pri.[archive_filename]
    ,sec.[archive_removed] = pri.[archive_removed]
    ,sec.[xfer_readydate] = pri.[xfer_readydate]
    ,sec.[xfer_filename] = pri.[xfer_filename]
  FROM [dbo].[logshipping_files] pri WITH (updlock)
    INNER JOIN [dbo].[logshipping_files] sec WITH (nolock)
    ON pri.[file_id] = sec.[file_id]
  WHERE (
      sec.[backup_startdate] IS NULL
      AND (NOT (pri.[backup_startdate] IS NULL))
    )
    OR (
      sec.[backup_finishdate] IS NULL
      AND (NOT (pri.[backup_finishdate] IS NULL))
    )
    OR (
      sec.[backup_filename] IS NULL
      AND (NOT (pri.[backup_filename] IS NULL))
    )
    OR (
      sec.[compress_date] IS NULL
      AND (NOT (pri.[compress_date] IS NULL))
    )
    OR (
      sec.[compress_filename] IS NULL
      AND (NOT (pri.[compress_filename] IS NULL))
    )
    OR (
      sec.[archive_date] IS NULL
      AND (NOT (pri.[archive_date] IS NULL))
    )
    OR (
      sec.[archive_filename] IS NULL
      AND (NOT (pri.[archive_filename] IS NULL))
    )
    OR (
      sec.[archive_removed] = 0
      AND (NOT (pri.[archive_removed] = 0))
    )
    OR (
      sec.[xfer_readydate] IS NULL
      AND (NOT (pri.[xfer_readydate] IS NULL))
    )
    OR (
      sec.[xfer_filename] IS NULL
      AND (NOT (pri.[xfer_filename] IS NULL))
    )

  SET @cnt = @@ROWCOUNT;
  SET @statusMsg = convert(varchar(30), getdate(), 120) + ' - Updated ' 
    + CAST(@cnt AS VARCHAR(10)) + ' record(s) on secondary server.'
  RAISERROR(@statusMsg, 10, 1) WITH NOWAIT

  -- update PRIMARY server with transfer/decompress/restore details
  UPDATE pri
  SET 
    pri.[xfer_startdate] = sec.[xfer_startdate]
    ,pri.[xfer_enddate] = sec.[xfer_enddate]
    ,pri.[sec_archive_date] = sec.[sec_archive_date]
    ,pri.[sec_archive_name] = sec.[sec_archive_name]
    ,pri.[sec_archive_removed] = sec.[sec_archive_removed]
    ,pri.[decompress_date] = sec.[decompress_date]
    ,pri.[decompress_filename] = sec.[decompress_filename]
    ,pri.[restore_date] = sec.[restore_date]
    ,pri.[restore_filename] = sec.[restore_filename]
  FROM [dbo].[logshipping_files] pri WITH (updlock)
    INNER JOIN [dbo].[logshipping_files] sec WITH (nolock)
    ON pri.[file_id] = sec.[file_id]
  WHERE (
        pri.[xfer_startdate] IS NULL
        AND (NOT (sec.[xfer_startdate] IS NULL))
      )
      OR (
        pri.[xfer_enddate] IS NULL
        AND (NOT (sec.[xfer_enddate] IS NULL))
      )
      OR (
        pri.[sec_archive_date] IS NULL
        AND (NOT (sec.[sec_archive_date] IS NULL))
      )
      OR (
        pri.[decompress_date] IS NULL
        AND (NOT (sec.[decompress_date] IS NULL))
      )
      OR (
        pri.[restore_date] IS NULL
        AND (NOT (sec.[restore_date] IS NULL))
      )
      OR (
        pri.[sec_archive_removed] = 0
        AND (NOT (sec.[sec_archive_removed] = 0))
      )

  SET @cnt = @@ROWCOUNT;
  SET @statusMsg = convert(varchar(30), getdate(), 120) + ' - Updated ' 
    + CAST(@cnt AS VARCHAR(10)) + ' record(s) on primary server.'
  RAISERROR(@statusMsg, 10, 1) WITH NOWAIT

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + replicate('=', 40)
  raiserror(@statusMsg, 10, 1) with nowait
  
END -- procedure  
GO
PRINT N'Creating [dbo].[usp_LogShipping_TransferFiles]...';


GO
SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER OFF;


GO


CREATE procedure [dbo].[usp_LogShipping_TransferFiles]
	@databaseName varchar(200) -- comma seperated list of databases
	, @targetFolder varchar(500) -- full drive and path to transfer folder on standby server
	, @fldrForDb char(1) = 'Y' -- Y or N to put files into seperate folders for each database
	, @debug char(1) = 'N' -- N minimal informational messages, Y extra messages
as

begin
	set nocount on
	set dateformat dmy

	-- table for directory tree
	if object_id('tempdb..#f') is not null drop table #f;
	create table #f(fullpath varchar(500), id int not null identity (1, 1))

	-- table for xp_cmdshell output
	if object_id('tempdb..#h') is not null drop table #h;
	create table #h(output varchar(255), id int not null identity (1, 1))

	declare @backupName varchar(500)
	declare @destFolder varchar(500)
	declare @errText varchar(255)
	declare @cmdText varchar(500)
	declare @cnt int
	declare @statusMsg varchar(500)

	set @cmdText = ''
	if right(@targetFolder, 1) <> '\'
		set @targetFolder = @targetFolder + '\'

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Start processing for database "%s".'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait
  
  SET @cnt = ISNULL((
      SELECT COUNT([FILE_ID])
      FROM [dbo].[logshipping_files]
      WHERE (NOT ([xfer_readydate] IS NULL))
        AND [xfer_enddate] IS NULL
    ),0)
      
	set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + cast(@cnt as varchar(10)) + ' file(s) to be processed'
	raiserror(@statusMsg, 10, 1) with nowait

  IF @cnt > 0
  BEGIN -- files to process
    
	  -- get list of file to process
	  DECLARE csrFiles CURSOR FOR
      SELECT [xfer_filename]
      FROM [dbo].[logshipping_files]
      WHERE (NOT ([xfer_readydate] IS NULL))
        AND [xfer_enddate] IS NULL
	  OPEN csrFiles
	  FETCH NEXT FROM csrFiles into @backupName

	  WHILE @@FETCH_STATUS = 0
	  BEGIN
		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing file "%s".'
	    raiserror(@statusMsg, 10, 1, @backupName) with nowait
	    SET @destFolder = @targetFolder + case when @fldrForDb = 'Y' then @databaseName + '\' else '' end
  	  set @cmdText = 'if not exist "' +  @destFolder + '" md "' + @destFolder + '"'
      
      if @debug = 'Y' 
      begin
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Directory checking command is'
        raiserror(@statusMsg, 10, 1) with nowait
	      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
        raiserror(@statusMsg, 10, 1) with nowait
	      exec master..xp_cmdshell @cmdText
      end
      else
	      exec master..xp_cmdshell @cmdText, no_output

	    -- move file from primary transfer to secondary transfer
      set @cmdText = 'move /Y "' + @backupName + '" "' + @destFolder + '"'  
      if @debug = 'Y'
      begin
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Move command built is'
        raiserror(@statusMsg, 10, 1) with nowait
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + isnull(@cmdText, 'No Command built')
        raiserror(@statusMsg, 10, 1) with nowait
      end

      -- update transfer start date
      UPDATE [dbo].[logshipping_files]
      SET [xfer_startdate] = GETDATE()
      WHERE [xfer_filename] = @backupName

      delete from #h 
      -- execute command     
      insert into #h exec master..xp_cmdshell @cmdText

      -- check if command was successful
		  if exists (select top 1 output from #h where output like '%1 file%')
      begin -- file moved to secondary transfer

        -- update transfer start date
        UPDATE [dbo].[logshipping_files]
        SET [xfer_enddate] = GETDATE()
          , [xfer_filename] = @destFolder + RIGHT(@backupName, CHARINDEX('\', REVERSE(@backupName))-1)
        WHERE [xfer_filename] = @backupName
        
	      if @debug = 'Y'
	      begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + N' - File "%s" successfully moved to "%s".'
          raiserror(@statusMsg, 10, 1, @backupName, @destFolder) with nowait
        end
        
      end -- file moved to secondary transfer
      else
	    begin -- error moving file to secondary transfer
        set @statusMsg = convert(varchar(30), getdate(), 120) + N' - ERROR moving file "%s".'
        raiserror(@statusMsg, 10, 1, @backupName, @databaseName) with nowait
	      if @debug = 'N'
	      begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - move command executed was'
          raiserror(@statusMsg, 10, 1) with nowait
	        set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + isnull(@cmdText, 'No Command built')
          raiserror(@statusMsg, 10, 1) with nowait
	      end
        select output from #h
	      set @errText = 'ERROR: ' + isnull((select top 1 output from #h where output is not null), 'An unknown error occurred moving file.')
	      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' + @errText
        raiserror(@statusMsg, 10, 1) with nowait
      end -- error moving file to secondary transfer

		  FETCH NEXT FROM csrFiles into @backupName

	  END

	  CLOSE csrFiles
	  DEALLOCATE csrFiles

  END -- file to process
  
  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Processing complete.'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait
  set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + replicate('=', 40)
  raiserror(@statusMsg, 10, 1) with nowait

end
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[usp_Perfmon_AggregateData]...';


GO

CREATE procedure [dbo].[usp_Perfmon_AggregateData]

as
begin
  set nocount on
  set dateformat ymd;

  declare @minDatetime datetime
  declare @maxDatetime datetime
  declare @fromDate datetime
  declare @toDate datetime
  declare @recCount varchar(10)
	declare @statusMsg varchar(500)
	declare @err int

  ---- update changed counters
  UPDATE dtl2
  SET dtl2.[MachineName] = dtl1.[MachineName]
    , dtl2.[ObjectName] = dtl1.[ObjectName]
    , dtl2.[CounterName] = dtl1.[CounterName]
    , dtl2.[InstanceName] = dtl1.[InstanceName]
  FROM [DBA].[dbo].[CounterDetails2] dtl2
    INNER JOIN (
        SELECT DISTINCT
          dtl.[CounterID], dat.[GUID], dtl.[MachineName]
          , dtl.[ObjectName], dtl.[CounterName]
          , dtl.[InstanceName]
        FROM [DBA].[dbo].[CounterDetails] dtl 
          inner join [DBA].[dbo].[CounterData] dat
          on dtl.[CounterID] = dat.CounterID
      ) as dtl1
     ON dtl2.[counterID] = dtl1.[CounterID]
     and dtl2.[GUID] = dtl1.[GUID]
  WHERE dtl2.[MachineName] <> dtl1.[MachineName] COLLATE database_default
    or dtl2.[ObjectName] <> dtl1.[ObjectName] COLLATE database_default
    or dtl2.[CounterName] <> dtl1.[CounterName] COLLATE database_default
    or dtl2.[InstanceName] <> dtl1.[InstanceName] COLLATE database_default

  set @recCount = cast(@@ROWCOUNT as varchar(10))
  set @statusMsg = convert(varchar(30), getdate(), 121) + N' - %s counter detail records updated.'
  raiserror(@statusMsg, 10, 1, @recCount) with nowait

  -- insert any new counters
  INSERT INTO [DBA].[dbo].[CounterDetails2] (
    [CounterID], [GUID], [MachineName], [ObjectName]
    , [CounterName], [InstanceName]
  )
  SELECT
    dtl1.[CounterID], dtl1.[GUID], dtl1.[MachineName]
    , dtl1.[ObjectName], dtl1.[CounterName]
    , dtl1.[InstanceName]
  FROM (
        SELECT DISTINCT
          dtl.[CounterID], dat.[GUID], dtl.[MachineName]
          , dtl.[ObjectName], dtl.[CounterName]
          , dtl.[InstanceName]
        FROM [DBA].[dbo].[CounterDetails] dtl 
          inner join [DBA].[dbo].[CounterData] dat
          on dtl.[CounterID] = dat.CounterID
      ) as dtl1
    LEFT JOIN [DBA].[dbo].[CounterDetails2] dtl2
    ON dtl2.[counterID] = dtl1.[CounterID]
    and dtl2.[GUID] = dtl1.[GUID]
  WHERE dtl2.[CounterID] is null

  set @recCount = cast(@@ROWCOUNT as varchar(10))
  set @statusMsg = convert(varchar(30), getdate(), 121) + N' - %s new counter detail records inserted.'
  raiserror(@statusMsg, 10, 1, @recCount) with nowait

  --
  -- get the maximum date that is more than 1 hour ago 
  -- to ensure we don't pick up part of a 15 min aggregation
  select @minDatetime = '2010-01-01 00:00'
  select @maxDatetime = CAST((CONVERT(varchar(8), GETDATE(), 112) + ' ' + DATENAME(hh, GETDATE()) + ':00') as datetime)
  select @maxDatetime = DATEADD(hh, -1, @maxDatetime)
  set @statusMsg = convert(varchar(30), getdate(), 121) + N' - Min/Max date range between ' 
    + CONVERT(varchar(30), @minDatetime, 121) + ' and ' + CONVERT(varchar(30), @maxDatetime, 121)
  raiserror(@statusMsg, 10, 1) with nowait
  
  declare cDates cursor fast_forward for
    SELECT 
      MIN([CounterDateTime]) as [fromDate]
      , MAX([CounterDateTime]) as [toDate]
    FROM (  
      --
      -- NOTE: schema enforced by relog utility 
      -- has [CounterDateTime] defined as char(24)
      SELECT CONVERT(datetime, CAST([CounterDateTime] as varchar(23)), 121) as [CounterDateTime]
      FROM [DBA].[dbo].[CounterData]
    ) as q
    WHERE [CounterDateTime] between @minDatetime and @maxDatetime
    GROUP BY CAST(CONVERT(varchar(8), [CounterDateTime], 112) as datetime)
    ORDER BY CAST(CONVERT(varchar(8), [CounterDateTime], 112) as datetime)
  
  open cDates
  fetch next from cDates into @fromDate, @toDate
  
  if @@fetch_status = 0
  begin
    while @@fetch_status = 0
    begin
      set @statusMsg = convert(varchar(30), getdate(), 121) + N' - Aggregating all records between ' 
        + CONVERT(varchar(30), @fromDate, 121) + ' and ' + CONVERT(varchar(30), @toDate, 121)
      raiserror(@statusMsg, 10, 1) with nowait

      set @err = 0

      begin tran

      insert into [DBA].[dbo].[CounterData2] (
        [GUID], [CounterID], [CounterDateTime], [CounterValue]
      )
      SELECT 
        [GUID]
        , [CounterID]
        , CAST(CAST(DATEPART(yy, [CounterDateTime]) as varchar(5)) 
            + RIGHT('00' + CAST(DATEPART(MM, [CounterDateTime]) as varchar(5)),2)
            + RIGHT('00' + CAST(DATEPART(DD, [CounterDateTime]) as varchar(5)),2)
            + RIGHT('00' + CAST(DATEPART(HH, [CounterDateTime]) as varchar(5)),2)
            + CASE
                  WHEN DATEPART(MI, [CounterDateTime]) < 15 THEN '00'
                  WHEN DATEPART(MI, [CounterDateTime]) < 30 THEN '15'
                  WHEN DATEPART(MI, [CounterDateTime]) < 45 THEN '30'
                  WHEN DATEPART(MI, [CounterDateTime]) >= 45 THEN '45'
                  ELSE '00'
                END as bigint) as [CounterDateTime]
        , avg([CounterValue]) as [CounterValue]
      FROM (
          select [GuID], [CounterID]
            , CONVERT(datetime, CAST([CounterDateTime] as varchar(23)), 121) as [CounterDateTime]
            , [CounterValue]
          FROM [DBA].[dbo].[CounterData]
        ) as cDta
      where [CounterDateTime] between @fromDate and @toDate
      group by
        [GUID]
        , [CounterID]
        , CAST(CAST(DATEPART(yy, [CounterDateTime]) as varchar(5)) 
            + RIGHT('00' + CAST(DATEPART(MM, [CounterDateTime]) as varchar(5)),2)
            + RIGHT('00' + CAST(DATEPART(DD, [CounterDateTime]) as varchar(5)),2)
            + RIGHT('00' + CAST(DATEPART(HH, [CounterDateTime]) as varchar(5)),2)
            + CASE
                  WHEN DATEPART(MI, [CounterDateTime]) < 15 THEN '00'
                  WHEN DATEPART(MI, [CounterDateTime]) < 30 THEN '15'
                  WHEN DATEPART(MI, [CounterDateTime]) < 45 THEN '30'
                  WHEN DATEPART(MI, [CounterDateTime]) >= 45 THEN '45'
                  ELSE '00'
                END as bigint)

      select @err = @@ERROR, @recCount = cast(@@ROWCOUNT as varchar(10))
      if @err = 0
        set @statusMsg = convert(varchar(30), getdate(), 121) + N' - %s aggregated records inserted.'
      else
        set @statusMsg = convert(varchar(30), getdate(), 121) 
          + N' - Error ' + cast(@err as varchar(10)) + ' occurred. %s aggregated records inserted.'

      raiserror(@statusMsg, 10, 1, @recCount) with nowait

      if @err = 0
      begin -- delete aggregated records
        delete from [DBA].[dbo].[CounterData]
        where CONVERT(datetime, CAST([CounterDateTime] as varchar(23)), 121) between @fromDate and @toDate

        select @err = @@ERROR, @recCount = cast(@@ROWCOUNT as varchar(10))
        if @err = 0
          set @statusMsg = convert(varchar(30), getdate(), 121) + N' - %s detail records deleted.'
        else
        set @statusMsg = convert(varchar(30), getdate(), 121) 
          + N' - Error ' + cast(@err as varchar(10)) + ' occurred. %s detail records deleted.'
        
        raiserror(@statusMsg, 10, 1, @recCount) with nowait

      end -- delete aggregated records

      if @err = 0
        commit
      else
        rollback

      fetch next from cDates into @fromDate, @toDate
    
    end
  end
  else
  begin
    set @statusMsg = convert(varchar(30), getdate(), 121) + N' - No records to aggregate between Min/Max date range.' 
    raiserror(@statusMsg, 10, 1) with nowait

  end
    
  close cDates
  deallocate cDates

end
GO
PRINT N'Creating [dbo].[usp_PerformBackup]...';


GO
CREATE procedure [dbo].[usp_PerformBackup]
  @backupGroup int = 1 -- backup group from dbo.backup_list
	, @backupType char(1) = 'F' -- (F)ull, (D)ifferential or (T)ransaction Log
	, @backupFolder varchar(500) -- full drive and path to backup to
	, @backupExt varchar(10) = 'bak' -- file extension to use for backup file
	, @fldrForDb char(1) = 'Y' -- Y or N to put backups into seperate folders for each database
	, @excludeSysDb char(1) = 'Y' -- Y or N, to exclude all system databases from backup
	, @debug char(1) = 'N' -- Y or N, Y provides additional feedback via print statements
as

begin
	set nocount on
	set dateformat dmy

	declare @srvrName varchar(50)
	declare @dbName varchar(50)
	declare @fullPath varchar(1000)
	declare @backupFile varchar(100)
	declare @ts varchar(20)
	declare @sql nvarchar(1000)
	declare @cmd nvarchar(1000)
	declare @err int
	declare @rtn int

	if @debug = 'Y'
	begin
		print replicate('-', 40)
		print convert(varchar(30), getdate(), 120) + ' - Debug messages are on'
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @backupGroup = ' + cast(@backupGroup as varchar(10))
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @backupType = ' + @backupType
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @backupFolder = ' + @backupFolder
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @fldrForDb = ' + @fldrForDb
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @excludeSysDb = ' + @excludeSysDb
		print replicate('-', 40)
	end

	-- save timestamp and servername for backup filename
	set @ts = convert(varchar(10), getdate(), 112) + replace(convert(varchar(10), getdate(), 108), ':', '')
	set @srvrName = replace(cast(serverproperty('serverName') as varchar(50)), '\', '$')

	if right(@backupFolder, 1) <> '\'
		set @backupFolder = @backupFolder + '\'

	if @backupType in ('L', 'D', 'F')
	begin
		if @debug = 'Y'
			print convert(varchar(30), getdate(), 120) + ' - Checking/Creating backup folder ' + @backupFolder

		-- check and create backup folder if necessary
		set @cmd = 'MD ' + quotename(@backupFolder, '"')
		exec master..xp_cmdshell @cmd, no_output

		if @debug = 'Y'
		begin
			print convert(varchar(30), getdate(), 120) + ' - list of databases to backup'
			select database_name
			from dbo.backup_list bkp
				inner join master..sysdatabases db 
				on bkp.database_name = db.name collate database_default
			where bkp.backup_group = @backupGroup
			  and db.name <> 'tempdb'
				and databasepropertyex(db.name, 'Status') = 'ONLINE'
				and 1 = CASE WHEN @backupType = 'L' THEN 
							CASE WHEN databasepropertyex(db.name, 'Recovery') = 'SIMPLE' THEN 0 ELSE 1 END
							ELSE 1
						END
				and 1 = CASE WHEN @excludeSysDb = 'Y' THEN 
							CASE WHEN db.name = 'master' THEN 0 
								WHEN db.name = 'model' THEN 0 
								WHEN db.name = 'msdb' THEN 0 
								WHEN db.name = 'distrubution' THEN 0 
								ELSE 1 END
							ELSE 1 END
				and 1 = CASE WHEN @backupType = 'L' THEN 
							CASE WHEN bkp.tlog_backup = 1 THEN 
								CASE WHEN bkp.last_full_backup IS NULL THEN 0 ELSE 1 END ELSE 0 END
							ELSE CASE WHEN bkp.full_backup = 1 THEN 1 ELSE 0 END
						END
		end

		declare cDb cursor fast_forward for
			-- get list of databases to backup
			select database_name
			from dbo.backup_list bkp
				inner join master..sysdatabases db 
				on bkp.database_name = db.name collate database_default
			where bkp.backup_group = @backupGroup
			  and db.name <> 'tempdb'
				and databasepropertyex(db.name, 'Status') = 'ONLINE'
				-- if backup type is 'L' only perform a log backup for databases in full/bulk logged recovery model
				and 1 = CASE WHEN @backupType = 'L' 
								THEN CASE WHEN databasepropertyex(db.name, 'Recovery') = 'SIMPLE' THEN 0 ELSE 1 END
							ELSE 1
						END
				-- only backup databases that have the appropriate flag set in the table
				and 1 = CASE WHEN @backupType = 'L' THEN 
				-- only do transaction log backup when appropriate flag is set and full backup has been completed
							CASE WHEN bkp.tlog_backup = 1 THEN 
								CASE WHEN bkp.last_full_backup IS NULL THEN 0 ELSE 1 END ELSE 0 END
							ELSE CASE WHEN bkp.full_backup = 1 THEN 1 ELSE 0 END
						END
				-- exclude system databases if required
				and 1 = CASE WHEN @excludeSysDb = 'Y' 
								THEN CASE 
										WHEN db.name = 'master' THEN 0 
										WHEN db.name = 'model' THEN 0 
										WHEN db.name = 'msdb' THEN 0 
										WHEN db.name = 'distrubution' THEN 0 
										ELSE 1 
									END
							ELSE 1
						END
				

		open cDb
		fetch next from cDb into @dbName

		while @@fetch_status = 0
		begin
			print convert(varchar(30), getdate(), 120) + ' - Processing database ' + @dbName

			-- build dynamic filename for backup
			set @backupFile = @srvrName + '_'  + @dbName + '_' 
			set @backupFile = @backupFile + case @backupType 
													when 'L' then 'tlog'
													when 'D' then 'diff'
													when 'F' then 'full'
												end

			set @backupFile = @backupFile + '_' + @ts + '.' + @backupExt

			if @debug = 'Y'
				print convert(varchar(30), getdate(), 120) + ' - backup file name is : ' + @backupFile

			-- check and create folder for database if necessary
			if @fldrForDb = 'Y'
			begin
				set @fullPath = @backupFolder + @dbName + '\'

				if @debug = 'Y'
					print convert(varchar(30), getdate(), 120) + ' - Checking/Creating backup folder ' + @fullPath

        
		    set @cmd = 'MD ' + quotename(@fullPath, '"')
		    exec master..xp_cmdshell @cmd, no_output
				set @fullPath = @fullPath + @backupFile

			end
			else
				set @fullPath = @backupFolder + @backupFile

			if @debug = 'Y'
				print convert(varchar(30), getdate(), 120) + ' - full backup path and filename is : ' + @fullPath

			-- build dynamic T-SQL backup command
			if @backupType = 'L'
				set @sql = 'backup log ' + quotename(@dbname)
			else
				set @sql = 'backup database ' + quotename(@dbname)

			set @sql = @sql + ' to disk = ''' + @fullpath + ''''

			if @backupType = 'D'
				set @sql = @sql + ' with differential'

			if @debug = 'Y'
				print convert(varchar(30), getdate(), 120) + ' - SQL backup command is ' + @sql

			-- execute backup command
			exec @rtn = master..sp_executesql @sql
			set @err = @@ERROR

			-- trap any failure that occurs
			if (@err <> 0) or (@rtn <> 0)
			begin
				if @debug = 'Y'
					print convert(varchar(30), getdate(), 120) + ' - SQL backup command is ' + @sql

				print convert(varchar(30), getdate(), 120) + ' - Error ' + cast(@err as varchar(10)) + ' occurred when performing backup'
				print convert(varchar(30), getdate(), 120) + ' - Check SQL error log for further details.'

			end

			print convert(varchar(30), getdate(), 120) + ' - Backup for database ' + @dbName + ' complete'

			fetch next from cDb into @dbName

		end
		close cDb
		deallocate cDb

	end
	else
	begin
		raiserror('Backup type ''%s'' is invalid. Type needs to be one of (F)ull, (D)ifferential or (T)ransaction Log.', 16, 1, @backupType)
	end

	print convert(varchar(30), getdate(), 120) + ' - Processing complete'
	print replicate('=', 40)

end
GO
PRINT N'Creating [dbo].[usp_PerformBackup_Individual]...';


GO

CREATE procedure [dbo].[usp_PerformBackup_Individual]
  @databaseName varchar(50) -- name of database to backup
	, @backupType char(1) = 'F' -- (F)ull, (D)ifferential or (T)ransaction Log
	, @backupFolder varchar(500) -- full drive and path to backup to
	, @backupExt varchar(10) = 'bak' -- file extension to use for backup file
	, @fldrForDb char(1) = 'Y' -- Y or N to put backups into seperate folders for each database
	, @excludeSysDb char(1) = 'Y' -- Y or N, to exclude all system databases from backup
	, @debug char(1) = 'N' -- Y or N, Y provides additional feedback via print statements
as
begin
	set nocount on
	set dateformat dmy

	declare @srvrName varchar(50)
	declare @fullPath varchar(1000)
	declare @backupFile varchar(100)
  declare @bkpType varchar(15)
	declare @ts varchar(20)
	declare @sql nvarchar(1000)
	declare @cmd nvarchar(1000)
	declare @err int
	declare @rtn int

	if @debug = 'Y'
	begin
		print replicate('-', 40)
		print convert(varchar(30), getdate(), 120) + ' - Debug messages are on'
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @databaseName = ' + @databaseName
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @backupType = ' + @backupType
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @backupFolder = ' + @backupFolder
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @fldrForDb = ' + @fldrForDb
		print convert(varchar(30), getdate(), 120) + ' - value passed for parameter @excludeSysDb = ' + @excludeSysDb
		print replicate('-', 40)
	end

	-- save timestamp and servername for backup filename
	set @ts = convert(varchar(10), getdate(), 112) + replace(convert(varchar(10), getdate(), 108), ':', '')
	set @srvrName = replace(cast(serverproperty('serverName') as varchar(50)), '\', '$')
	if right(@backupFolder, 1) <> '\'
		set @backupFolder = @backupFolder + '\'

	if @backupType in ('L', 'D', 'F')
	begin
		if @debug = 'Y'
			print convert(varchar(30), getdate(), 120) + ' - Checking/Creating backup folder ' + @backupFolder
		-- check and create backup folder if necessary
		set @cmd = 'MD ' + quotename(@backupFolder, '"')
		exec master..xp_cmdshell @cmd, no_output

		if @debug = 'Y'
		begin
			print convert(varchar(30), getdate(), 120) + ' - list of databases to backup'
			select database_name
			from dbo.backup_list bkp
				inner join master.sys.databases db 
				on bkp.database_name = db.name collate database_default
			where bkp.database_name = @databaseName
			  and db.name <> 'tempdb'
				and databasepropertyex(db.name, 'Status') = 'ONLINE'
				and 1 = CASE WHEN @backupType = 'L' THEN 
							CASE WHEN databasepropertyex(db.name, 'Recovery') = 'SIMPLE' THEN 0 ELSE 1 END
							ELSE 1
						END
				and 1 = CASE WHEN @excludeSysDb = 'Y' THEN 
							CASE WHEN db.name = 'master' THEN 0 
								WHEN db.name = 'model' THEN 0 
								WHEN db.name = 'msdb' THEN 0 
								WHEN db.name = 'distrubution' THEN 0 
								ELSE 1 END
							ELSE 1 END
				and 1 = CASE WHEN @backupType = 'L' THEN 
							CASE WHEN bkp.tlog_backup = 1 THEN 
								CASE WHEN bkp.last_full_backup IS NULL THEN 0 ELSE 1 END ELSE 0 END
							ELSE CASE WHEN bkp.full_backup = 1 THEN 1 ELSE 0 END
						END
		end

		-- check that database exists and can be backed up
    if exists (
			select 1
			from dbo.backup_list bkp
				inner join master..sysdatabases db 
				on bkp.database_name = db.name collate database_default
			where bkp.database_name = @databaseName
			  and db.name <> 'tempdb'
				and databasepropertyex(db.name, 'Status') = 'ONLINE'
				-- if backup type is 'L' only perform a log backup for databases in full/bulk logged recovery model
				and 1 = CASE WHEN @backupType = 'L' 
								THEN CASE WHEN databasepropertyex(db.name, 'Recovery') = 'SIMPLE' THEN 0 ELSE 1 END
							ELSE 1
						END
				-- only backup databases that have the appropriate flag set in the table
				and 1 = CASE WHEN @backupType = 'L' THEN 
				-- only do transaction log backup when appropriate flag is set and full backup has been completed
							CASE WHEN bkp.tlog_backup = 1 THEN 
								CASE WHEN bkp.last_full_backup IS NULL THEN 0 ELSE 1 END ELSE 0 END
							ELSE CASE WHEN bkp.full_backup = 1 THEN 1 ELSE 0 END
						END
				-- exclude system databases if required
				and 1 = CASE WHEN @excludeSysDb = 'Y' 
								THEN CASE 
										WHEN db.name = 'master' THEN 0 
										WHEN db.name = 'model' THEN 0 
										WHEN db.name = 'msdb' THEN 0 
										WHEN db.name = 'distrubution' THEN 0 
										ELSE 1 
									END
							ELSE 1
						END
      )
		begin
			print convert(varchar(30), getdate(), 120) + ' - Processing database ' + @databaseName
			-- build dynamic filename for backup
			set @backupFile = @srvrName + '_'  + @databaseName + '_' 
			set @backupFile = @backupFile + case @backupType 
													when 'L' then 'tlog'
													when 'D' then 'diff'
													when 'F' then 'full'
												end
			set @backupFile = @backupFile + '_' + @ts + '.' + @backupExt
      set @bkpType = case @backupType 
													when 'L' then 'Log'
													when 'D' then 'Differential'
													when 'F' then 'Full'
												end
			if @debug = 'Y'
				print convert(varchar(30), getdate(), 120) + ' - backup file name is : ' + @backupFile
			-- check and create folder for database if necessary
			if @fldrForDb = 'Y'
			begin
				set @fullPath = @backupFolder + @databaseName + '\'
				if @debug = 'Y'
					print convert(varchar(30), getdate(), 120) + ' - Checking/Creating backup folder ' + @fullPath
        
		    set @cmd = 'MD ' + quotename(@fullPath, '"')
		    exec master..xp_cmdshell @cmd, no_output
				set @fullPath = @fullPath + @backupFile
			end
			else
				set @fullPath = @backupFolder + @backupFile
			if @debug = 'Y'
				print convert(varchar(30), getdate(), 120) + ' - full backup path and filename is : ' + @fullPath

      if @bkpType = 'F'
      BEGIN
        set @sql = 'BACKUP DATABASE ' + QUOTENAME(@databaseName)
        set @sql = @sql + ' TO DISK = ''' + @fullpath + ''''
      
      END
      ELSE
      if @bkpType = 'L'
      BEGIN
        set @sql = 'BACKUP LOG ' + QUOTENAME(@databaseName)
        set @sql = @sql + ' TO DISK = ''' + @fullpath + ''''
      
      END
      ELSE
      if @bkpType = 'D'
      BEGIN
        set @sql = 'BACKUP DATABASE ' + QUOTENAME(@databaseName)
        set @sql = @sql + ' TO DISK = ''' + @fullpath + ''''
        set @sql = @sql + ' WITH DIFFERENTIAL'
      
      END

      exec @rtn = sys.sp_executeSQL @sql
 			set @err = @@ERROR
			-- trap any failure that occurs
			if (@err <> 0) or (@rtn <> 0)
			begin
				if @debug = 'Y'
					print convert(varchar(30), getdate(), 120) + ' - SQL backup command is ' + @sql
				print convert(varchar(30), getdate(), 120) + ' - Error ' + cast(@err as varchar(10)) + ' occurred when performing backup'
				print convert(varchar(30), getdate(), 120) + ' - Check SQL error log for further details.'
			end
			print convert(varchar(30), getdate(), 120) + ' - Backup for database ' + @databaseName + ' complete'

		end
  	else
  	begin
  		raiserror('A backup of type ''%s'' cannot be performed on the [%s] database at this time. Check if database is online and has correct recovery model.', 10, 1, @backupType, @databaseName)
  	end

	end
	else
	begin
		raiserror('Backup type ''%s'' is invalid. Type needs to be one of (F)ull, (D)ifferential or (T)ransaction Log.', 10, 1, @backupType)
	end

	print convert(varchar(30), getdate(), 120) + ' - Processing complete'
	print replicate('=', 40)

end
GO
PRINT N'Creating [dbo].[usp_Sample_BackupDetails]...';


GO

CREATE PROCEDURE [dbo].[usp_Sample_BackupDetails]
AS
BEGIN -- procedure
  set nocount on;
  
  -- capture media family details
  INSERT INTO [dbo].[database_backupmediafamily](
    [media_set_id],[family_sequence_number],[media_family_id]
    ,[media_count],[logical_device_name],[physical_device_name]
    ,[device_type],[physical_block_size]
  )
  SELECT [media_set_id],[family_sequence_number],[media_family_id]
    ,[media_count],[logical_device_name],[physical_device_name]
    ,[device_type],[physical_block_size]
  FROM [msdb].[dbo].[backupmediafamily]
  WHERE [media_set_id] > (
      SELECT ISNULL(MAX([media_set_id]), 0) as MaxId
      FROM [dbo].[database_backupmediafamily]
    )

  -- capture backup set details
  INSERT INTO [dbo].[database_backupset] (
    [backup_set_id],[backup_set_uuid],[media_set_id],[first_family_number]
    ,[first_media_number],[last_family_number],[last_media_number]
    ,[catalog_family_number],[catalog_media_number],[position]
    ,[expiration_date],[software_vendor_id],[name],[description]
    ,[user_name],[software_major_version],[software_minor_version]
    ,[software_build_version],[time_zone],[mtf_minor_version]
    ,[first_lsn],[last_lsn],[checkpoint_lsn],[database_backup_lsn]
    ,[database_creation_date],[backup_start_date],[backup_finish_date]
    ,[type],[sort_order],[code_page],[compatibility_level]
    ,[database_version],[backup_size],[database_name],[server_name]
    ,[machine_name],[flags],[unicode_locale],[unicode_compare_style]
    ,[collation_name]
  )
  SELECT [backup_set_id],[backup_set_uuid],[media_set_id],[first_family_number]
    ,[first_media_number],[last_family_number],[last_media_number]
    ,[catalog_family_number],[catalog_media_number],[position]
    ,[expiration_date],[software_vendor_id],[name],[description]
    ,[user_name],[software_major_version],[software_minor_version]
    ,[software_build_version],[time_zone],[mtf_minor_version],[first_lsn]
    ,[last_lsn],[checkpoint_lsn],[database_backup_lsn],[database_creation_date]
    ,[backup_start_date],[backup_finish_date],[type],[sort_order],[code_page]
    ,[compatibility_level],[database_version],[backup_size],[database_name]
    ,[server_name],[machine_name],[flags],[unicode_locale],[unicode_compare_style]
    ,[collation_name]
  FROM [msdb].[dbo].[backupset]
  WHERE [backup_set_id] > (
      SELECT ISNULL(MAX([backup_set_id]), 0) as MaxId
      FROM [dbo].[database_backupset]
    )

  -- capture restore history
  INSERT INTO [dbo].[database_restorehistory] (
    [restore_history_id],[restore_date],[destination_database_name]
    ,[user_name],[backup_set_id],[restore_type],[replace],[recovery]
    ,[restart],[stop_at],[device_count],[stop_at_mark_name],[stop_before]
  )
  SELECT [restore_history_id],[restore_date],[destination_database_name]
    ,[user_name],[backup_set_id],[restore_type],[replace],[recovery],[restart]
    ,[stop_at],[device_count],[stop_at_mark_name],[stop_before]
  FROM [msdb].[dbo].[restorehistory]
  WHERE [restore_history_id] > (
      SELECT ISNULL(MAX(restore_history_id), 0) as MaxId
      FROM [dbo].[database_restorehistory]
    )

  -- clear out loaded data
  delete from dbo.[database_backupmediafamily]
  where [loaded_into_repository] = 1
  delete from dbo.[database_backupset]
  where [loaded_into_repository] = 1
  delete from dbo.[database_restorehistory]
  where [loaded_into_repository] = 1
  
END -- procedure
GO
PRINT N'Creating [dbo].[usp_Sample_DatabaseStats]...';


GO

CREATE procedure [dbo].[usp_Sample_DatabaseStats]

as
begin -- procedure
  set nocount on
  
  declare @sqlCmd nvarchar(1024) 
  declare @db nvarchar(128)
  declare @logsize real
  declare @logspaceused real

  -- clear out loaded data
  delete from dbo.database_details
  where [loaded_into_repository] = 1
  delete from dbo.database_size
  where [loaded_into_repository] = 1

  -- create temporary table that will store log space data
  if object_id('tempdb..tmpLogSpace') is not null drop table tempdb..tmpLogSpace
  CREATE TABLE tempdb..tmpLogSpace (
    DBName varchar(50), LogSize real, LogSpaceUsed real, Status int)
  
  -- create temporary table that will store output from DBCC SHOWFILESTATS
  if object_id('tempdb..tmpShowFileStats') is not null drop table tempdb..tmpShowFileStats
  create table tempdb..tmpShowFileStats (
    fileid int, filegroup int, totalextents int, usedextents int
    , name varchar(1024), filename varchar(1024))
  
  -- Create temporary table for holding data file size information
  if object_id('tempdb..tmpDBFilestats') is not null drop table tempdb..tmpDBFilestats
  create table tempdb..tmpDBFilestats (
    DBName varchar(50), fileid int, filegroup int, totalextents int
    , usedextents int, name varchar(1024), filename varchar(1024))
  
  -- capture transaction log size
  insert into tempdb..tmplogspace 
  execute ('DBCC SQLPERF(logspace) WITH NO_INFOMSGS')

  -- capture data file size information
  DECLARE allDBs CURSOR FOR
    SELECT name FROM master..sysdatabases
    WHERE databasepropertyex(name, 'Status') = 'ONLINE'
  OPEN allDBs
  FETCH NEXT FROM allDBs INTO @DB

  WHILE (@@FETCH_STATUS = 0)
  BEGIN
    set @sqlCmd = 'use ' + quotename(@DB) + '; truncate table tempdb..tmpShowFileStats; '
      + 'insert into tempdb..tmpShowFileStats exec(''DBCC SHOWFILESTATS WITH NO_INFOMSGS'')'
    exec sp_executeSql @sqlCmd
    insert into tempdb..tmpDBFilestats
    select @db, fileid, filegroup, totalextents, usedextents, name, filename
    from tempdb..tmpShowFileStats

    FETCH NEXT FROM allDBs INTO @DB
  END
  CLOSE allDBs
  DEALLOCATE allDBs

  -- database details
  insert into dbo.database_details (
    [Sample_Date], [Database_ID], [database_name], [Recovery_Model]
    , [Status], [Collation], [IsBulkCopy], [IsAutoClose], [IsAutoShrink]
    , [IsAutoCreateStatistics], [IsAutoUpdateStatistics]
    , [IsFulltextEnabled], [IsPublished], [IsSubscribed]
  )	
  select
	  getdate() as [Sample_Date]
    , db.[database_id] as [Database_ID]
    , db.[name] as [database_name]
    , cast(databasepropertyex(db.[name], 'Recovery') as varchar(50)) as [Recovery_Model] 
    , cast(databasepropertyex(db.[name], 'Status') as varchar(50)) as [Status]
    , cast(databasepropertyex(db.[name], 'Collation') as varchar(50)) as [Collation]
    , case when databaseproperty(db.[name], 'IsBulkCopy') = 1 then 'Y' else 'N' end as [IsBulkCopy]
    , case when databasepropertyex(db.[name], 'IsAutoClose') = 1 then 'Y' else 'N' end as [IsAutoClose]
    , case when databasepropertyex(db.[name], 'IsAutoShrink') = 1 then 'Y' else 'N' end as [IsAutoShrink]
    , case when databasepropertyex(db.[name], 'IsAutoCreateStatistics') = 1 then 'Y' else 'N' end as [IsAutoCreateStatistics]
    , case when databasepropertyex(db.[name], 'IsAutoUpdateStatistics') = 1 then 'Y' else 'N' end as [IsAutoUpdateStatistics]
    , case when databasepropertyex(db.[name], 'IsFulltextEnabled') = 1 then 'Y' else 'N' end as [IsFulltextEnabled]
    , case when databasepropertyex(db.[name], 'IsPublished') = 1 then 'Y' else 'N' end as [IsPublished]
    , case when databasepropertyex(db.[name], 'IsSubscribed') = 1 then 'Y' else 'N' end as [IsSubscribed] 
  from [master].[sys].[databases] db

  -- database sizing
  insert into dbo.database_size (
	  Sample_Date, [Database_ID], [database_name], [File_ID], [File_Group]
	  , [Logical_Filename], [Physical_Filename]
	  , [Data_Allocated_MB], [Data_Used_MB], [Data_Free_MB], [Data_Free_Pcnt]
	  , [Log_Allocated_MB], [Log_Used_MB], [Log_Free_MB], [Log_Free_Pcnt]
  )
  select
	  getdate() as [Sample_Date]
    , DB_ID(ls.DBName) as [Database_ID]
    , ls.DBName as [database_name]
    , fs.[fileid]
    , fs.[filegroup]
    , fs.[name] as [Logical_Filename]
    , fs.[filename]
    , cast((fs.totalextents * 64)/1024.0 as decimal(19,4)) as [Data_Allocated_MB]
    , cast((fs.usedextents * 64)/1024.0 as decimal(19,4)) as [Data_Used_MB]
    , cast((((fs.totalextents-fs.usedextents)*64)/1024.0) as decimal(19,4)) as [Data_Free_MB]
    , cast(((fs.totalextents-fs.usedextents)/(fs.totalextents * 1.0)) as decimal(19,4)) as [Data_Free_Pcnt]
    , cast(ls.logsize as decimal(19,4)) as [Log_Allocated_MB]
    , cast(ls.logsize * (ls.logspaceused/100.0) as decimal(19,4)) as [Log_Used_MB]
    , cast((ls.logsize - (ls.logsize * (ls.logspaceused/100.0))) as decimal(19,4)) as [Log_Free_MB]
    , cast((ls.logsize - (ls.logsize * (ls.logspaceused/100.0)))/ls.logsize as decimal(19,4)) as [Log_Free_Pcnt]
  from tempdb..tmpLogSpace ls
    inner join tempdb..tmpDBFilestats fs
    on ls.DBName = fs.DBName


end -- procedure
GO
PRINT N'Creating [dbo].[usp_sample_drivespace]...';


GO


CREATE  PROCEDURE [dbo].[usp_sample_drivespace]

as
begin -- procedure
  set nocount on

  -- clear out loaded data
  delete from dbo.[server_drivespace]
  where [loaded_into_repository] = 1

  insert into [dbo].[server_drivespace] ([drive_Letter], [mb_free])
  EXEC master..xp_fixeddrives

end -- procedure
GO
PRINT N'Creating [dbo].[usp_sample_ErrorLogEvents]...';


GO

CREATE  PROCEDURE [dbo].[usp_sample_ErrorLogEvents]
AS
begin -- procedure
  set nocount on
  set dateformat ymd
  
  declare @latestDate datetime;
  declare @prodVer varchar(20);
  declare @ver int;
  declare @cnt int;

  set @cnt = 0;
  set @prodVer = cast(serverproperty('ProductVersion') as varchar(20));
  set @ver = cast(left(@prodVer, charindex('.',@prodVer)-1) as int);
 
  -- delete loaded log data
  delete from [dbo].[error_log]
  where [loaded_into_repository] = 1;

  if object_id('tempdb..#errorlog') is not null drop table #errorlog;
  create table #errorlog (
     [log_id] int identity primary key
     , [log_date] datetime
     , [process_info] nvarchar(100)
     , [log_text] nvarchar(2000)
     , [continuation_row] int default(0)
     , [flagged] bit default(0)
  );
 
  SET @latestDate = ISNULL((
      SELECT [latest_date] FROM [dbo].[error_log_latestDate]
    ),'1 Jan 1900')

  if @ver = 8
  begin -- SQL 2000
	  insert into #errorlog ([log_text], [continuation_row])
	  execute ('exec master..sp_readerrorlog')
    -- fill in any blank rows
    update #errorlog
    set [log_text] = [log_text] + replicate('-', 20)
    where isdate(left([log_text], 23)) = 1
      and len([log_text]) < 35
    -- pull date and process details out of message text
    update #errorlog
    set [log_date] = cast(left([log_text], 23) as datetime)
      , [process_info] = rtrim(substring([log_text], 24, charindex(' ', [log_text], 24)-24))
      , [log_text] = ltrim(rtrim(right([log_text], len([log_text])-charindex(' ', [log_text], 24))))
    from #errorlog
    where isdate(left([log_text], 23)) = 1

	end -- SQL 2000
	else
	begin -- SQL 2005, 2008
	  insert into #errorlog ([log_date], [process_info], [log_text])
	  execute ('exec master..sp_readerrorlog')
	  
	end -- SQL 2005, 2008

  -- back-fill any blank dates with the date of the previous entry
  select @cnt = isnull(count(s.log_id), 0)
  from #errorlog p
    inner join #errorlog s
    on p.log_id = s.log_id-1
    and s.log_date is null
  where not (p.log_date is null)
  
  While @cnt > 0
  begin
  
    update s
    set s.log_date = p.log_date
    from #errorlog p
      inner join #errorlog s
      on p.log_id = s.log_id-1
      and s.log_date is null
    where not (p.log_date is null)

    select @cnt = isnull(count(s.log_id), 0)
    from #errorlog p
      inner join #errorlog s
      on p.log_id = s.log_id-1
      and s.log_date is null
    where not (p.log_date is null)

  end

  -- remove previously captured entries
  DELETE FROM #errorLog
  WHERE [log_date] <= @latestDate;

  -- Mark interesting entries
  update #errorlog
  set [flagged] = 1
  where (
      [log_text] like '%err%'
      or [log_text] like '%warn%'
      or [log_text] like '%kill%'
      or [log_text] like '%dead%'
      or [log_text] like '%cannot%'
      or [log_text] like '%could%'
      or [log_text] like '%fail%'
      or [log_text] like '%not%'
      or [log_text] like '%stop%'
      or [log_text] like '%terminate%'
      or [log_text] like '%bypass%'
      or [log_text] like '%roll%'
      or [log_text] like '%truncate%'
      or [log_text] like '%upgrade%'
      or [log_text] like '%victim%'
      or [log_text] like '%recover%'
      or [log_text] like '%IO requests taking longer than%'
    )
    AND [log_text] not like '%errorlog%'
    AND [log_text] not like '%dbcc%'
    AND [log_text] not like '%bypass%'

  -- store entries in table for repository pickup
	INSERT INTO [dbo].[error_log] (
	  [log_date], [process_info], [log_text]
	  , [continuation_row], [flagged]
	)
	SELECT
	  [log_date], [process_info], [log_text]
	  , [continuation_row], [flagged]
	FROM #errorlog lg
	ORDER BY [log_id]

  -- store new latest date
  IF EXISTS (SELECT 1 FROM #errorlog where [log_date] > @latestDate)
  BEGIN
    UPDATE [dbo].[error_log_latestDate]
    SET [latest_Date] = (SELECT max([log_date]) as [max_date] FROM #errorlog)
  END
 
END -- procedure
GO
PRINT N'Creating [dbo].[usp_sample_monitor]...';


GO

CREATE  PROCEDURE [dbo].[usp_sample_monitor]

as
begin -- procedure
  SET NOCOUNT ON

  declare @hour_id int
  -- set hour_id for sample
  set @hour_id = convert(varchar(10), GetDate(), 112) + convert(varchar(2), GetDate(), 108)

  -- clear out loaded data
  delete from dbo.[server_monitor]
  where [loaded_into_repository] = 1

  -- Get current values and store in table
  -- CAST(@@TIMETICKS AS FLOAT) required to avoid integer 
  -- overflow when server has been up for long time
  INSERT INTO [dbo].[server_monitor] (
    [hour_id], [cpu_busy],[io_busy], [idle], [pack_received]
    , [pack_sent], [connections], [pack_errors], [total_read]
    , [total_write], [total_errors]
  )
  SELECT @hour_id, @@CPU_BUSY * CAST(@@TIMETICKS AS FLOAT)
    , @@IO_BUSY * CAST(@@TIMETICKS AS FLOAT)
    , @@IDLE * CAST(@@TIMETICKS AS FLOAT)
    , @@PACK_RECEIVED, @@PACK_SENT, @@CONNECTIONS
    , @@PACKET_ERRORS, @@TOTAL_READ
    , @@TOTAL_WRITE, @@TOTAL_ERRORS

end -- procedure
GO
PRINT N'Creating [dbo].[usp_Sample_ServerStats]...';


GO


CREATE  procedure [dbo].[usp_Sample_ServerStats]

as
begin -- procedure
  set nocount on
  
  declare @sqlCmd nvarchar(1024) 
  declare @srvr varchar(50)

  -- clear out loaded data
  delete from dbo.server_details
  where [loaded_into_repository] = 1
  delete from dbo.server_sp_configure
  where [loaded_into_repository] = 1
  delete from dbo.[server_logins]
  where [loaded_into_repository] = 1

  -- save in DBA database
  --
  -- server details
  insert into dbo.server_details (
    [Sample_Date], [Start_Time], [Server_Name], [Instance_Name]
    , [MachineName], [ProductVersion], [ProductLevel], [Edition]
    , [Collation], [IsClustered], [IsIntegratedSecurityOnly]
    , [IsFullTextInstalled], [SqlCharSetName], [SqlSortOrderName]
    , [LicenseType]
  )
  select
    getdate() as [Sample_Date]
    , (select login_time from master..sysprocesses where spid = 1) as [Start_Time]
    , cast(serverproperty('Servername') as varchar(50)) as [Server_Name]
    , isnull(cast(serverproperty('InstanceName') as varchar(50)), 'default') as [Instance_Name]
    , cast(serverproperty('MachineName') as varchar(50)) as [MachineName] 
    , cast(serverproperty('ProductVersion') as varchar(50)) as [ProductVersion]
    , cast(serverproperty('ProductLevel') as varchar(50)) as [ProductLevel]
    , cast(serverproperty('Edition') as varchar(50)) as [Edition]
    , cast(serverproperty('Collation') as varchar(50)) as [Collation]
    , case when serverproperty('IsClustered') = 1 then 'Y' else 'N' end as [IsClustered]
    , CASE WHEN SERVERPROPERTY('IsIntegratedSecurityOnly') = 1 THEN 'Y' ELSE 'N' END AS [IsIntegratedSecurityOnly]
    , CASE WHEN SERVERPROPERTY('IsFullTextInstalled') = 1 THEN 'Y' ELSE 'N' END AS [IsFullTextInstalled]
    , CAST(SERVERPROPERTY('SqlCharSetName') as varchar(50)) AS [SqlCharSetName]
    , CAST(SERVERPROPERTY('SqlSortOrderName') as varchar(50)) AS [SqlSortOrderName]
    , cast(serverproperty('LicenseType') as varchar(50)) as [LicenseType]
	from [master].[dbo].[spt_monitor]
	
  -- server configuration parameters
	insert into [dbo].[server_sp_configure] ([name], [minimum], [maximum], [config_value], [run_value])
	exec sp_configure
	
  -- server logins
  INSERT INTO [dbo].[server_logins](
    [Sample_Date],[loginname],[default_db],[default_language],[LoginDenied]
    ,[HasServerAccess],[IsWindowsName],[IsWindowsGroup],[IsWindowsUser]
    ,[IsSysAdmin],[IsSecurityAdmin],[IsSetupAdmin],[IsServerAdmin]
    ,[IsProcessAdmin],[IsDiskAdmin],[IsBulkAdmin],[IsDbCreator]
  )
  SELECT
    getdate() as [Sample_Date]
    , lgn.[loginname]
    , lgn.[dbname] as [default_db]
    , lgn.[language] as [default_language]
    , CASE WHEN lgn.[denylogin] = 1 THEN 'Y' ELSE 'N' END as [LoginDenied]
    , CASE WHEN lgn.[hasaccess] = 1 THEN 'Y' ELSE 'N' END as [HasServerAccess]
    , CASE WHEN lgn.[isntname] = 1 THEN 'Y' ELSE 'N' END as [IsWindowsName]
    , CASE WHEN lgn.[isntgroup] = 1 THEN 'Y' ELSE 'N' END as [IsWindowsGroup]
    , CASE WHEN lgn.[isntuser] = 1 THEN 'Y' ELSE 'N' END as [IsWindowsUser]
    , CASE WHEN IS_SRVROLEMEMBER('sysadmin', lgn.[loginname]) = 1 THEN 'Y' ELSE 'N' END as [IsSysAdmin]
    , CASE WHEN IS_SRVROLEMEMBER('securityadmin', lgn.[loginname]) = 1 THEN 'Y' ELSE 'N' END as [IsSecurityAdmin]
    , CASE WHEN IS_SRVROLEMEMBER('setupadmin', lgn.[loginname]) = 1 THEN 'Y' ELSE 'N' END as [IsSetupAdmin]
    , CASE WHEN IS_SRVROLEMEMBER('serveradmin', lgn.[loginname]) = 1 THEN 'Y' ELSE 'N' END as [IsServerAdmin]
    , CASE WHEN IS_SRVROLEMEMBER('processadmin', lgn.[loginname]) = 1 THEN 'Y' ELSE 'N' END as [IsProcessAdmin]
    , CASE WHEN IS_SRVROLEMEMBER('diskadmin', lgn.[loginname]) = 1 THEN 'Y' ELSE 'N' END as [IsDiskAdmin]
    , CASE WHEN IS_SRVROLEMEMBER('bulkadmin', lgn.[loginname]) = 1 THEN 'Y' ELSE 'N' END as [IsBulkAdmin]
    , CASE WHEN IS_SRVROLEMEMBER('dbcreator', lgn.[loginname]) = 1 THEN 'Y' ELSE 'N' END as [IsDbCreator]
  FROM master..syslogins lgn


end -- procedure
GO
PRINT N'Creating [dbo].[usp_sample_virtualfilestats]...';


GO

CREATE procedure [dbo].[usp_sample_virtualfilestats]

as
begin -- procedure
  set nocount on

  declare @hour_id int
  declare @prodVer varchar(20)
  declare @ver int
  declare @srvr varchar(50)
  -- set hour_id for sample
  set @hour_id = convert(varchar(10), GetDate(), 112) + convert(varchar(2), GetDate(), 108)
  -- get product version and convert major version to int
  set @prodVer = cast(serverproperty('ProductVersion') as varchar(20))
  set @ver = cast(left(@prodVer, charindex('.',@prodVer)-1) as int)

  -- clear out loaded data
  delete from dbo.[virtualFileStats]
  where [loaded_into_repository] = 1

  -- check if running on SQL 2000
  if @ver = 8
  begin
    -- run command using SQL 2000 format
    insert into .[dbo].[virtualFileStats] (
      [hour_id], [db_id], [file_id], [logical_name]
      , [physical_name], [time_stamp], [number_of_reads], [number_of_writes]
      , [bytes_read], [bytes_written], [io_stall_ms]
    )
    select 
      @hour_id, vfs.[DbID], vfs.[FileId],  rtrim(alt.[name]),  rtrim(alt.[filename])
      , vfs.[TimeStamp], vfs.[NumberReads], vfs.[NumberWrites]
      , vfs.[BytesRead], vfs.[BytesWritten], vfs.[IoStallMS]
    from ::fn_virtualfilestats(-1,-1) as vfs  
      inner join master..sysaltfiles alt
	    on vfs.dbid = alt.dbid
	    and vfs.fileid = alt.fileid
  end	
  else if (@ver = 9) or (@ver = 10)
  begin
    -- run command using SQL 2005 & 2008 format
    insert into .[dbo].[virtualFileStats] (
      [hour_id], [db_id], [file_id], [logical_name]
      , [physical_name], [time_stamp], [number_of_reads], [number_of_writes]
      , [bytes_read], [bytes_written], [io_stall_ms]
      , [io_stall_read_ms], [io_stall_write_ms], [bytes_on_disk]
    )
    select
      @hour_id, vfs.[database_id], vfs.[file_id], rtrim(mf.[name]), rtrim(mf.[physical_name])
      , vfs.[sample_ms], vfs.[num_of_reads], vfs.[num_of_writes]
      , vfs.[num_of_bytes_read], vfs.[num_of_bytes_written]
	    , vfs.[io_stall], vfs.[io_stall_read_ms], vfs.[io_stall_write_ms]
	    , vfs.[size_on_disk_bytes]
    from sys.dm_io_virtual_file_stats(null, null) as vfs
	    inner join sys.master_files mf
	    on vfs.database_id = mf.database_id
	    and vfs.file_id = mf.file_id

  end
  
end -- procedure
GO
PRINT N'Creating [dbo].[usp_Script_Logins]...';


GO


CREATE  procedure [dbo].[usp_Script_Logins]
  @outputDir varchar(500)
as
begin -- procedure
  set nocount on
  
  declare @server varchar(30)
  declare @instance varchar(30)
  declare @cmdText varchar(2000)
  declare @sqlText varchar(2000)
  declare @outputFile varchar(2000)
  declare @login_name sysname

  set @server = cast(serverproperty('ServerName') as varchar(30))
  set @instance = cast(serverproperty('InstanceName') as varchar(30))

	if right(@outputDir, 1) <> '\'
	set @outputDir = @outputDir + '\'
	
	-- exec MD command to ensure directory exists
	set @cmdText = 'MD "' + @outputDir + '"'
  exec master..xp_cmdshell @cmdText, no_output
  
  declare curLgns cursor fast_forward for
    SELECT l.name
    FROM master.dbo.syslogins l
    WHERE l.name <> 'sa'
      AND not (l.name like '%##%')
      AND not (l.name like '%BUILTIN%')
    ORDER BY l.name

  open curLgns
  fetch next from curLgns into @login_name

  while @@FETCH_STATUS = 0
  begin
    set @sqlText = 'exec master..sp_help_revlogin @login_name = ''' + @login_name + ''''
    set @outputFile = @outputDir + @server + isnull('_' + @instance, '') + '_login_' + replace(@login_name, '\', '~') + '.sql'
    set @cmdText = 'osql -S. -E -Q"' + @sqlText + '" -o "' + @outputFile + '" -w255'
    
    exec master..xp_cmdshell @cmdText, no_output
    
    fetch next from curLgns into @login_name 
    
  end

  close curLgns
  deallocate curLgns

end -- procedure
GO
PRINT N'Creating [dbo].[usp_SendEmail]...';


GO
CREATE procedure [dbo].[usp_SendEmail]
  @EmailProfile varchar(20)
  , @Subject nvarchar(200)
  , @msgBody nvarchar(4000)
as

begin --#region procedure
  set nocount on
  
  declare @DBMailProfile varchar(50)
  declare @ToAddress nvarchar(255)
  declare @Priority nvarchar(10)
  declare @ContentType nvarchar(15)
  declare @HTMLStyleCSS nvarchar(1000)
  declare @rtn int
  declare @err int
  declare @er varchar(20)
  declare @rt varchar(20)

  if exists (select 1 from dbo.EmailProfiles where [ProfileName] = @EmailProfile)
  begin --#region valid email profile
    -- get the profile details
    select 
      @DBMailProfile = [DBMailProfile]
      , @ToAddress = [ToAddress]
      , @Priority = [Priority]
      , @ContentType = [ContentType]
      , @HTMLStyleCSS = [HTMLStyleCSS]
    from [dbo].[EMailProfiles]
    where [ProfileName] = @EmailProfile
    
    -- if the profile is HTML add heading tag and CSS
    if @ContentType = 'HTML'
    begin 
      set @msgBody = '<HTML><HEAD>' + @HTMLStyleCSS + '</HEAD>' 
        + @msgBody + '</HTML>'
    end
    -- send the email
    exec [msdb].[dbo].[sp_send_dbmail]
      @profile_name = @DBMailProfile
      , @recipients = @toAddress
      , @subject = @Subject
      , @importance = @Priority
      , @body_format = @ContentType
      , @body = @msgBody
    set @err = @@ERROR
    if @rtn <> 0 or @err <> 0
    begin --#region Error sending email
      set @er = cast(@err as varchar(20))
      set @rt = cast(@rtn as varchar(20))
      raiserror('Problem sending email via profile [%s], Return Value: %s, SQL Error: %s', 16, 1, @EmailProfile, @er, @rt)
      
    end --#endregion
    
  end --#endregion
  else
  begin --#region Unknown email profile
    raiserror('Email profile "%s" is not known.', 16, 1, @EmailProfile)
    
  end --#endregion 

end --#endregion
GO
PRINT N'Creating [dbo].[usp_SendJobFailureMessage]...';


GO

CREATE  PROCEDURE [dbo].[usp_SendJobFailureMessage]
   @job_id uniqueidentifier
  , @emailProfile varchar(20) = 'DBA'
AS
BEGIN -- procedure
  SET NOCOUNT ON  

  declare @emailSubject nvarchar(100);
  declare @emailMessage nvarchar(4000);
  declare @serverName varchar(50);
  declare @jobName varchar(50);

  set @serverName = cast(serverproperty('ServerName') as varchar(50))
  set @emailMessage = ''

  set @jobName = isnull((select name from msdb..sysjobs where job_id = @job_id), 'unkown')
  set @emailSubject = @serverName + ': SQL Agent Job Failure - ''' + @jobName + ''''

  select @emailMessage = @emailMessage + q.[detail]
  from (
    select '<BODY><DIV align="centre">'
      + '<P></P>'
      + '<TABLE border= "1"><TR><TH>Step Name</TH><TH>Error #</TH><TH>Error Message</TH></TR>' as [detail]
      , 1 as [sort_order]
    UNION ALL
    SELECT
      '<TR><TD>' + jHst.[step_name] + '</TD>'
      + '<TD>' + isnull(cast(jHst.[sql_message_id] as varchar(20)), '') + '</TD>'
      + '<TD>' + jHst.[message] + '</TD></TR>' as [detail]
      , 2 as [sort_order]
    from msdb..sysjobhistory jHst
      inner join (
          select hst.[job_id], hst.[run_date]
            , max(hst.[run_time]) as [run_time] 
          from msdb..sysjobhistory hst
            inner join (
                select [job_id] as [job_id]
                  , max([run_date]) as [run_date]
                from msdb..sysjobhistory
                where job_id = @job_id
                  and message like '%failed%'
                group by [job_id]  
              ) as mx
            on hst.[job_id] = mx.[job_id]
            and hst.[run_date] = mx.[run_date]
          group by hst.[job_id], hst.[run_date]
        ) as err
      on jHst.[job_id] = err.[job_id]
      and jHst.[run_date] = err.[run_date]
      and jHst.[run_time] = err.[run_time]
    UNION ALL
    select '</TABLE></DIV></BODY>', 99 as [sort_order]
  ) as q  
  order by [sort_order];

  exec [DBA].[dbo].[usp_SendEmail]
    @EmailProfile = @emailProfile
    , @Subject = @emailSubject
    , @MsgBody = @emailMessage
    
END -- procedure
GO
PRINT N'Creating [dbo].[usp_SqlAgent_JobHistory]...';


GO

CREATE procedure [dbo].[usp_SqlAgent_JobHistory]

as
begin
  set nocount on
  
  if object_id('tempdb..tmpJobHistory') is not null drop table tempdb..tmpJobHistory
  CREATE TABLE tempdb..[tmpJobHistory] (
	  [Sample_Date] [datetime] NOT NULL DEFAULT (getdate()),
	  [instance_id] [int] NOT NULL,
	  [job_id] [uniqueidentifier] NOT NULL,
	  [step_id] [int] NOT NULL,
	  [step_name] [sysname] NOT NULL,
	  [sql_message_id] [int] NOT NULL,
	  [sql_severity] [int] NOT NULL,
	  [message] [nvarchar](3000) NULL,
	  [run_status] [int] NOT NULL,
	  [run_date] [int] NOT NULL,
	  [run_time] [int] NOT NULL,
	  [run_duration] [int] NOT NULL,
	  [operator_id_emailed] [int] NOT NULL,
	  [operator_id_netsent] [int] NOT NULL,
	  [operator_id_paged] [int] NOT NULL,
	  [retries_attempted] [int] NOT NULL,
	  [server] [sysname] NOT NULL
  )

  -- clear out loaded data
  delete from dbo.[sqlagent_jobhistory]
  where [loaded_into_repository] = 1

  -- capture job history to temp table
  insert into tempdb..tmpJobHistory (
    [Sample_Date], [instance_id],[job_id],[step_id]
    ,[step_name],[sql_message_id],[sql_severity],[message]
    ,[run_status],[run_date],[run_time],[run_duration]
    ,[operator_id_emailed],[operator_id_netsent]
    ,[operator_id_paged],[retries_attempted],[server]
  )
  SELECT Getdate(), [instance_id],[job_id],[step_id]
    ,[step_name],[sql_message_id],[sql_severity]
    ,cast([message] as nvarchar(3000)) as [message]
    ,[run_status],[run_date],[run_time],[run_duration]
    ,[operator_id_emailed],[operator_id_netsent]
    ,[operator_id_paged],[retries_attempted],[server]
  FROM [msdb].[dbo].[sysjobhistory]

  -- insert history just for previous day
  INSERT INTO [DBA].[dbo].[sqlagent_jobhistory] (
    [Sample_Date],[instance_id],[job_id],[step_id]
    ,[step_name],[sql_message_id],[sql_severity],[message]
    ,[run_status],[run_date],[run_time],[run_duration]
    ,[operator_id_emailed],[operator_id_netsent]
    ,[operator_id_paged],[retries_attempted],[server]
  )    
  SELECT
    [Sample_Date],[instance_id],[job_id],[step_id]
    ,[step_name],[sql_message_id],[sql_severity],[message]
    ,[run_status],[run_date],[run_time],[run_duration]
    ,[operator_id_emailed],[operator_id_netsent]
    ,[operator_id_paged],[retries_attempted],[server]
  FROM tempdb..tmpJobHistory
  WHERE [run_date] = CONVERT(varchar(10), getdate()-1, 112)
  
end
GO
PRINT N'Creating [dbo].[usp_SqlAgent_JobInfo]...';


GO


CREATE  procedure [dbo].[usp_SqlAgent_JobInfo]

as
begin
  set nocount on

  -- clear out loaded data
  delete from dbo.sqlagent_job_info
  where [loaded_into_repository] = 1

  declare @xp_results table (
    job_id uniqueidentifier not null
    ,last_run_date int not null
    ,last_run_time int not null
    ,next_run_date int not null
    ,next_run_time int not null
    ,next_run_schedule_id  int not null
    ,requested_to_run int not null -- bool
    ,request_source int not null
    ,request_source_id sysname collate database_default null
    ,running int not null -- bool
    ,current_step  int not null
    ,current_retry_attempt int not null
    ,job_state int not null
  )
  insert into @xp_results
  execute master.dbo.xp_sqlagent_enum_jobs 1, 'sa'

  insert into [dbo].[sqlagent_job_info] (
    [Sample_Date], q.[job_id],[originating_server],[name],[enabled]
    ,[description],[start_step_id],[category],[owner],[notify_level_eventlog]
    ,[notify_level_email],[notify_level_netsend],[notify_level_page]
    ,[notify_email_operator],[notify_netsend_operator],[notify_page_operator]
    ,[delete_level],[date_created],[date_modified],[version_number]
    ,[last_run_date],[last_run_time],[last_run_outcome],[next_run_date]
    ,[next_run_time],[next_run_schedule_id],[current_execution_status]
    ,[current_execution_step],[current_retry_attempt],[has_step]
    ,[has_schedule],[has_target],[type]) 
  select 
    GETDATE() as [sample_date]
    ,xp.[job_id],sjv.[originating_server],sjv.[name],sjv.[enabled],sjv.[description]
    ,sjv.[start_step_id],category = ISNULL(cat.name, FORMATMESSAGE(14205))
    ,SUSER_SNAME(sjv.[owner_sid]),sjv.[notify_level_eventlog]
    ,sjv.[notify_level_email],sjv.[notify_level_netsend],sjv.[notify_level_page]
    ,notify_email_operator = ISNULL(so1.name, FORMATMESSAGE(14205))
    ,notify_netsend_operator = ISNULL(so2.name, FORMATMESSAGE(14205))
    ,notify_page_operator = ISNULL(so3.name, FORMATMESSAGE(14205))
    ,sjv.[delete_level],sjv.[date_created]
    ,sjv.[date_modified],sjv.[version_number]
    ,xp.[last_run_date],xp.[last_run_time],jSrv.[last_run_outcome]
    ,xp.[next_run_date],xp.[next_run_time],xp.[next_run_schedule_id]
    ,xp.[running],xp.[current_step],xp.[current_retry_attempt]
    ,has_step = (select count(step_id)
               from msdb.dbo.sysjobsteps sjst
               where (sjst.job_id = sjv.job_id))
    ,has_schedule = (select count(schedule_id)
                   from msdb.dbo.sysjobschedules sjsch
                   where (sjsch.job_id = sjv.job_id))
    ,has_target = (select count(job_id)
                 from msdb.dbo.sysjobservers sjs
                 where (sjs.job_id = sjv.job_id))
    ,Case when jSrv.[server_id] = 0 THEN 1 ELSE 2 END as [type]
  from @xp_results xp
    left join msdb.dbo.[sysjobs_view] sjv  
    on xp.[job_id] = sjv.[job_id]
      left join msdb.dbo.syscategories cat
      on sjv.[category_id] = cat.[category_id]
      left join msdb.dbo.sysoperators  so1 
      on sjv.notify_email_operator_id = so1.id
      left join msdb.dbo.sysoperators  so2 
      on sjv.notify_netsend_operator_id = so2.id
      left join msdb.dbo.sysoperators  so3 
      on sjv.notify_page_operator_id = so3.id
    left join [msdb].[dbo].[sysjobschedules] jSch
    on xp.[job_id] = jSch.[job_id]
    left join [msdb].[dbo].[sysjobservers] jSrv
    on xp.[job_id] = jSrv.[job_id]

end
GO
PRINT N'Creating [dbo].[usp_SqlAgent_JobSchedule]...';


GO

CREATE  procedure [dbo].[usp_SqlAgent_JobSchedule]

as
begin -- procedure
  set nocount on
  
  declare @schedule_description NVARCHAR(255)
  declare @name sysname
  declare @freq_type INT
  declare @freq_interval INT
  declare @freq_subday_type INT
  declare @freq_subday_interval INT
  declare @freq_relative_interval INT
  declare @freq_recurrence_factor INT
  declare @active_start_date INT
  declare @active_end_date INT
  declare @active_start_time INT
  declare @active_end_time INT
  declare @schedule_id_as_char VARCHAR(10)
  declare @schedule_id INT
  declare @job_id uniqueidentifier
  declare @enabled int
  declare @next_run_date int
  declare @next_run_time int
  declare @date_created datetime
  declare @sample_date datetime
  SET @sample_date = getdate()

  -- clear out loaded data
  delete from [dbo].[sqlagent_jobschedule]
  where [loaded_into_repository] = 1

  declare cSch cursor fast_forward for
    SELECT 
      sch.[schedule_id],jSch.[job_id],sch.[name],sch.[enabled],sch.[freq_type]
      ,sch.[freq_interval],sch.[freq_subday_type],sch.[freq_subday_interval]
      ,sch.[freq_relative_interval],sch.[freq_recurrence_factor]
      ,sch.[active_start_date],sch.[active_end_date],sch.[active_start_time]
      ,sch.[active_end_time],jSch.[next_run_date]
      ,jSch.[next_run_time],sch.[date_created]
    FROM [msdb].[dbo].[sysschedules] sch
      INNER JOIN [msdb].[dbo].[sysjobschedules] jSch
      ON sch.[schedule_id] = jSch.[schedule_id]
      
  open cSch
  fetch next from cSch into 
    @schedule_id, @job_id, @name, @enabled, @freq_type
    , @freq_interval, @freq_subday_type, @freq_subday_interval
    , @freq_relative_interval, @freq_recurrence_factor, @active_start_date
    , @active_end_date, @active_start_time, @active_end_time
    , @next_run_date, @next_run_time, @date_created
 
  while @@fetch_status = 0
  begin -- schedule cursor
    -- retrieve schedule description
    EXECUTE msdb..sp_get_schedule_description
      @freq_type
      , @freq_interval
      , @freq_subday_type
      , @freq_subday_interval
      , @freq_relative_interval
      , @freq_recurrence_factor
      , @active_start_date
      , @active_end_date
      , @active_start_time
      , @active_end_time
      , @schedule_description OUTPUT

    insert into [dbo].[sqlagent_jobschedule] (
      [sample_date], [schedule_id], [job_id], [schedule_name], [enabled], [freq_type]
      , [freq_interval], [freq_subday_type], [freq_subday_interval], [freq_relative_interval]
      , [freq_recurrence_factor], [active_start_date], [active_end_date], [active_start_time]
      , [active_end_time], [next_run_date], [next_run_time], [date_created]
      , [schedule_description], [loaded_into_repository]
    )
    select
      @sample_date, @schedule_id, @job_id, @name, @enabled, @freq_type
      , @freq_interval, @freq_subday_type, @freq_subday_interval
      , @freq_relative_interval, @freq_recurrence_factor, @active_start_date
      , @active_end_date, @active_start_time, @active_end_time
      , @next_run_date, @next_run_time, @date_created, @schedule_description
      , cast(0 as bit) as [loaded_into_repository]
 
    fetch next from cSch into 
      @schedule_id, @job_id, @name, @enabled, @freq_type
      , @freq_interval, @freq_subday_type, @freq_subday_interval
      , @freq_relative_interval, @freq_recurrence_factor, @active_start_date
      , @active_end_date, @active_start_time, @active_end_time
      , @next_run_date, @next_run_time, @date_created

  end -- schedule cursor

  close cSch
  deallocate cSch

end -- procedure
GO
PRINT N'Creating [dbo].[usp_SqlAgent_JobSteps]...';


GO



CREATE   procedure [dbo].[usp_SqlAgent_JobSteps]

as
begin
  set nocount on

  declare @sample_date datetime
  set @sample_date = getdate()

  -- clear out loaded data
  delete from dbo.sqlagent_jobstep
  where [loaded_into_repository] = 1

  -- grab new set of data
  INSERT INTO dbo.sqlagent_jobstep ( 
      [Sample_Date],[job_id],[step_id],[step_name],[subsystem]
      ,[command],[flags],[cmdexec_success_code],[on_success_action]
      ,[on_success_step_id],[on_fail_action],[on_fail_step_id]
      ,[server],[database_name],[database_user_name],[retry_attempts]
      ,[retry_interval],[os_run_priority],[output_file_name]
      ,[last_run_outcome],[last_run_duration],[last_run_retries]
      ,[last_run_date],[last_run_time])   
  SELECT 
    @sample_date, [job_id], [step_id], [step_name], [subsystem]
    , [command], [flags], [cmdexec_success_code], [on_success_action]
    , [on_success_step_id], [on_fail_action], [on_fail_step_id]
    , [server], [database_name], [database_user_name], [retry_attempts]
    , [retry_interval], [os_run_priority], [output_file_name]
    , [last_run_outcome], [last_run_duration], [last_run_retries]
    , [last_run_date], [last_run_time] 
  FROM [msdb].[dbo].[sysjobsteps]

end
GO
PRINT N'Creating [dbo].[usp_UpdateBackupList]...';


GO


CREATE   PROCEDURE [dbo].[usp_UpdateBackupList]
  @sendEmail CHAR(1) = 'Y' -- send update email
  , @emailProfile VARCHAR(20) = 'DBA' -- mail profile to use
  , @tlog24hDefault int = 24 -- default number of tlog backups for 24hr period
as
BEGIN -- procedure
  
  set nocount on;
  declare @updCnt int;
  declare @insCnt int;
  declare @bkpCnt int;
  declare @rstCnt int;
  declare @msgSubject varchar(500);
  declare @msgBody varchar(8000);
  declare @serverName varchar(50);

  set @updCnt = 0;
  set @insCnt = 0;
  set @bkpCnt = 0;
  set @rstCnt = 0;
  set @msgBody = N'';
  set @serverName = cast(serverproperty('ServerName') as varchar(50))
  set @msgSubject = N'Database backup_list updated on ' + @serverName;

  -- update where stored requirements do not match
  update bkp
  set bkp.full_backup = case when db.name is null then 0 else 1 end
    , bkp.tlog_backup = case when db.name is not null and databasepropertyex(db.name, 'Recovery') = 'FULL' then 1 else 0 end
  from  dbo.backup_list bkp
	  left join master.dbo.sysdatabases db 
	  on bkp.database_name = db.name collate database_default
  where
    NOT (db.[name] in ('tempdb', 'ReportServerTempDB'))
    and (
      bkp.full_backup <> case when db.name is null then 0 else 1 end
      or bkp.tlog_backup <> case when db.name is not null and databasepropertyex(db.name, 'Recovery') = 'FULL' then 1 else 0 end
    )
  select @updCnt = @@ROWCOUNT
  print cast(@updCnt as varchar(10)) + ' old database(s) updated.';

  -- insert newly created databases
  insert into  dbo.backup_list (backup_group, database_name
    , full_backup, full_backup_24h, last_full_backup, tlog_backup
    , tlog_backup_24h, last_tlog_backup)  
  select distinct 0 as backup_group, db.name as database_name
    , 1 as full_backup, 1 as full_backup_24h, null as last_full_backup
    , case when databasepropertyex(db.name, 'Recovery') = 'FULL' then 1 else 0 end as tlog_backup
    , @tlog24hDefault as tlog_backup_24h, null as last_tlog_backup
  from master.dbo.sysdatabases db 
    left join  dbo.backup_list bkp 
    on db.name = bkp.database_name collate database_default
  where bkp.database_name is null
  select @insCnt = @@ROWCOUNT
  print cast(@insCnt as varchar(10)) + ' new database(s) inserted.'

  -- update last backup details
  update bkp
  set bkp.last_full_backup = lastBkp.last_full_backup
    , bkp.last_tlog_backup = lastBkp.last_tlog_backup
  from  dbo.backup_list bkp
    left join (
        select
          bkp.database_name
          , max(case when type = 'D' then bkp.backup_finish_date else '1 Jan 1900' end) as last_full_backup
          , max(case when type = 'L' then bkp.backup_finish_date else '1 Jan 1900' end) as last_tlog_backup
        from msdb.dbo.backupset bkp
        group by 
          bkp.database_name
      ) as lastBkp
      on bkp.database_name = lastBkp.database_name collate database_default
  select @bkpCnt = @@ROWCOUNT
  print cast(@bkpCnt as varchar(10)) + ' database(s) had backup dates updated.'

  -- update last restore details
  update bkp
  set bkp.[last_full_restore] = lstRst.[last_full_restore]
    , bkp.[last_tlog_restore] = lstRst.[last_tlog_restore]
  from  dbo.backup_list bkp
    inner join (
	      select rst.[destination_database_name] as [database_name]
          , max(case when rst.[restore_type] = 'D' then rst.[restore_date] else '1 Jan 1900' end) as [last_full_restore]
          , max(case when rst.[restore_type] = 'L' then rst.[restore_date] else '1 Jan 1900' end) as [last_tlog_restore]
	      from msdb.dbo.restorehistory rst
	      group by rst.[destination_database_name]
      ) as lstRst
    on bkp.[database_name] = lstRst.[database_name] collate database_default
  -- update last restore details for log shipped restore as databases
  update bkp
  set bkp.[last_full_restore] = lstRst.[last_full_restore]
    , bkp.[last_tlog_restore] = lstRst.[last_tlog_restore]
  from  dbo.backup_list bkp
    inner join (
	      select rst.[destination_database_name] as [database_name]
          , max(case when rst.[restore_type] = 'D' then rst.[restore_date] else '1 Jan 1900' end) as [last_full_restore]
          , max(case when rst.[restore_type] = 'L' then rst.[restore_date] else '1 Jan 1900' end) as [last_tlog_restore]
	      from msdb.dbo.restorehistory rst
	      group by rst.[destination_database_name]
      ) as lstRst
    on bkp.[log_ship_restore_as] = lstRst.[database_name] collate database_default

  select @rstCnt = @@ROWCOUNT
  print cast(@rstCnt as varchar(10)) + ' database(s) had restore dates updated.'

  if (@insCnt > 0) AND (@sendEmail = 'Y')
  begin
    select @msgBody = @msgBody + q.[detail]
    from (
      select '<BODY><DIV align="centre">'
        + '<P>Following list of databases are not in any group for backups. Please check and confirm.</P>'
        + '<TABLE border= "1"><TR><TH>Database Name</TH><TH>Last Full Backup</TH><TH>Last Log Backup</TH></TR>' as [detail]
        , 1 as [sort_order]
      UNION ALL
      SELECT
        '<TR><TD>' + cast([database_name] as varchar(50)) + '</TD>' 
        + '<TD>' + isnull(convert(varchar(30), [last_full_backup], 120), '') + '</TD>'
        + '<TD>' + isnull(convert(varchar(30), [last_tlog_backup], 120), '') + '</TD></TR>' as [detail]
        , 2 as [sort_order]
      FROM  [dbo].[backup_list]
      WHERE [backup_group] = 0
      UNION ALL
      select '</TABLE></DIV></BODY>', 99
    ) as q  
    order by [sort_order]

    exec  dbo.usp_SendEmail
      @EmailProfile = @emailProfile
      , @Subject = @msgSubject
      , @MsgBody = @msgBody

  end

end -- procedure
GO
PRINT N'Creating [dbo].[usp_UpdateLogins]...';


GO




CREATE  Procedure [dbo].[usp_UpdateLogins]
	@scriptDir varchar(500) -- full drive and path where script files are located
  , @filePrefix varchar(50) = NULL -- file prefix that is stripped off to get login name
	, @reportOnly char(1) = 'Y' -- [Y]es, report diferences only don't create logins
	, @debug bit = 1 -- 0 minimal informational messages, 1 extra messages
as
begin
	set nocount on
              
	declare @cmd nvarchar(1000)
	declare @Msg varchar(1000)
	declare @scriptFileName varchar(100)
	declare @loginName varchar(100)
	declare @server varchar(30)
	declare @title varchar(80)
	declare @fileID int
	declare @cnt int
	declare @err int
	declare @smtp_server varchar(50)
	declare @from_address varchar(100)
	declare @from_name varchar(50)
	declare @to_address varchar(100)
	declare @reply_to varchar(100)
	declare @msg_priority varchar(10)
	declare @msg_type varchar(10)
	declare @msg_subject varchar(100)
	declare @msg_file varchar(100)
	declare @rc int
	declare @crlf char(2)

	set @cmd = ''
	set @Msg = ''
	set @scriptFileName = ''
	set @server = cast(serverproperty('ServerName') as varchar(30))
	set @loginName = ''
	set @fileID = 0
	set @cnt = 0
	set @err = 0
	set @crlf = char(13) + char(10)
	set @msg_subject = 'Logins that do not exist on ' + @server
	set @msg_file = 'c:\temp\login_differences.htm'
	
	-- retrieve default settings from table
	select @smtp_server = IsNull(SmtpServer, '')
		, @from_address = IsNull(FromAddress, '')
		, @from_name = IsNull(FromName, '')
		, @to_address = IsNull(ToAddress, '')
		, @reply_to = IsNull(ReplyToAddress, '')
		, @msg_priority = IsNull(Priority, '')
		, @msg_type = IsNull(ContentType, '')
	from DBA.dbo.EMailProfiles
	where [ProfileName] = 'DBA'

	if right(@scriptDir, 1) <> '\'
		set @scriptDir = @scriptDir + '\'

	if object_id('tempdb..loginDiff') is not null drop table tempdb..loginDiff
	create table tempdb..loginDiff (id int identity(1,1), fn varchar(500), d int, f int, diff char(1))
 
	insert into tempdb..loginDiff (fn, d, f)
	exec master..xp_dirtree @scriptDir, 1, 1

	if @debug = 1 select * from tempdb..loginDiff

	delete from tempdb..loginDiff where patindex('%AllLogins%', fn) > 1 or f = 0

	if @debug = 1 select * from tempdb..loginDiff
 
	set @cnt = ISNULL((select count(id) from tempdb..loginDiff), 0)
	print convert(varchar(30), getdate(), 120) + ' ' + cast(@cnt as varchar(10)) + ' file(s) in folder'

	if @cnt > 0
	begin
 		declare cFn cursor fast_forward for
			select id, fn from tempdb..loginDiff order by id
		
 		open cFn
 		fetch next from cFn into @fileID, @scriptFileName
  
 		while @@Fetch_status =0
 		begin
			print convert(varchar(30), getdate(), 120) + N' processing file ' + @scriptFileName

			select @loginName = replace(left(@scriptFileName, len(@scriptFileName)-4), @filePrefix, '')
			select @loginName = replace(@loginName, '~', '\')

			print convert(varchar(30), getdate(), 120) + N' processing login ' + @loginName

			if not exists(select sid from master..syslogins where name like @loginName)
			begin
				print convert(varchar(30), getdate(), 120) + N' login ' + @loginName + N' does not exist'
				update tempdb..loginDiff set diff = 'Y' where id = @fileID
				
				if @reportOnly = 'N'
				begin
					set @cmd = 'osql -S ' + @server + ' -E -i"' + @scriptDir + @scriptFileName + '"'
					print convert(varchar(30), getdate(), 120) + N' Creating login ' + @loginName + N' with command "' + @cmd + '"'
					exec @rc = master..xp_cmdshell @cmd
					if @rc <> 0
					begin
						print convert(varchar(30), getdate(), 120) + N' Error executing command "' + @cmd + '"'
						raiserror('Login creation failed', 16, 1)
					end
				end

			end
			else
			begin
				print convert(varchar(30), getdate(), 120) + N' login ' + @loginName + N' already exists'

			end
	 
	 		fetch next from cFn into @fileID, @scriptFileName
	    
		end

		close cFn
		deallocate cFn

		if (select max(id) from tempdb..loginDiff where diff = 'Y') > 0
		begin
	
			insert into tempdb..loginDiff (fn, d, f, diff)
			values (@scriptDir, 0, 0, 'H')
	
			if @reportOnly = 'Y'
				insert into tempdb..loginDiff (fn, d, f, diff)
				values ('** NOTE: Job run as report only. No changes made.', 0, 0, 'H')
			else
				insert into tempdb..loginDiff (fn, d, f, diff)
				values ('Appropriate scripts were run to create logins.', 0, 0, 'H')
	
			exec sp_makewebtask 
				@outputfile = @msg_file
				, @resultstitle = '<br/> '
				, @query = 'select fn as [Script Directory] FROM tempdb..loginDiff where diff = ''H'' order by id
						select count(id) as [Total Missing Logins] FROM tempdb..loginDiff where diff = ''Y''
						select fn as [Script Filename] FROM tempdb..loginDiff where diff = ''Y'' order by id'
				, @whentype = 1 -- run and delete
				, @HTMLheader = 3 -- H3
				, @lastupdated = 1 -- don't include
	
			-- send email message
			exec @rc = master.dbo.xp_smtp_sendmail
				@server = @smtp_server
				, @from = @from_address
				, @from_name = @from_name
				, @to = @to_address
				, @replyto = @reply_to
				, @priority = @msg_priority
				, @type = @msg_type
				, @subject = @msg_subject
				, @messagefile = @msg_file
		
			if @rc <> 0
			begin
				raiserror('EMail send failed', 16, 1)
			end
		end
		else
		begin
			set @Msg = 'All scripts found in directory "' + @scriptDir + '"'
			set @Msg = @Msg + ' were successfully matched against existing '
			set @Msg = @Msg + ' logins. No further action necessary.'
			-- send email message
			exec @rc = master.dbo.xp_smtp_sendmail
				@server = @smtp_server
				, @from = @from_address
				, @from_name = @from_name
				, @to = @to_address
				, @replyto = @reply_to
				, @priority = @msg_priority
				, @type = @msg_type
				, @subject = @msg_subject
				, @message = @Msg
		
			if @rc <> 0
			begin
				raiserror('EMail send failed', 16, 1)
			end

		end
	
	
		if object_id('tempdb..loginDiff') is not null drop table tempdb..loginDiff

	end

	print convert(varchar(30), getdate(), 120) + ' Processing complete.'
	print ''
	print replicate('=', 40)

end
GO
PRINT N'Creating [dbo].[usp_UpdateSQLAgentJobs]...';


GO
SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER OFF;


GO

CREATE Procedure [dbo].[usp_UpdateSQLAgentJobs]
	@scriptDir varchar(500) -- full drive and path where script files are located
	, @reportOnly char(1) = 'Y' -- [Y]es, report diferences only don't create logins
	, @debug bit = 1 -- 0 minimal informational messages, 1 extra messages
as
begin
	set nocount on
              
	declare @cmd nvarchar(1000)
	declare @Msg varchar(1000)
	declare @scriptFileName varchar(100)
	declare @jobName varchar(100)
	declare @server varchar(30)
	declare @title varchar(80)
	declare @fileID int
	declare @cnt int
	declare @err int
	declare @smtp_server varchar(50)
	declare @from_address varchar(100)
	declare @from_name varchar(50)
	declare @to_address varchar(100)
	declare @reply_to varchar(100)
	declare @msg_priority varchar(10)
	declare @msg_type varchar(10)
	declare @msg_subject varchar(100)
	declare @msg_file varchar(100)
	declare @rc int
	declare @crlf char(2)

	set @cmd = ''
	set @Msg = ''
	set @scriptFileName = ''
	set @server = cast(serverproperty('ServerName') as varchar(30))
	set @jobName = ''
	set @fileID = 0
	set @cnt = 0
	set @err = 0
	set @crlf = char(13) + char(10)
	set @msg_subject = 'SQL Agent jobs that do not exist on ' + @server
	set @msg_file = 'c:\temp\SQLAgent_differences.htm'
	
	-- retrieve default settings from table
	select @smtp_server = IsNull(SmtpServer, '')
		, @from_address = IsNull(FromAddress, '')
		, @from_name = IsNull(FromName, '')
		, @to_address = IsNull(ToAddress, '')
		, @reply_to = IsNull(ReplyToAddress, '')
		, @msg_priority = IsNull(Priority, '')
		, @msg_type = IsNull(ContentType, '')
	from DBA.dbo.EMailProfiles
	where [ProfileName] = 'DBA'

	if right(@scriptDir, 1) <> '\'
		set @scriptDir = @scriptDir + '\'

	if object_id('tempdb..SQLAgentDiff') is not null drop table tempdb..SQLAgentDiff
	create table tempdb..SQLAgentDiff (id int identity(1,1), fn varchar(500), d int, f int, diff char(1))
 
	insert into tempdb..SQLAgentDiff (fn, d, f)
	exec master..xp_dirtree @scriptDir, 1, 1

	if @debug = 1 select * from tempdb..SQLAgentDiff

	delete from tempdb..SQLAgentDiff where patindex('%Alljobs%', fn) > 1 or f = 0

	if @debug = 1 select * from tempdb..SQLAgentDiff
 
	set @cnt = ISNULL((select count(id) from tempdb..SQLAgentDiff), 0)
	print convert(varchar(30), getdate(), 120) + ' ' + cast(@cnt as varchar(10)) + ' file(s) in folder'

	if @cnt > 0
	begin
 		declare cFn cursor fast_forward for
			select id, fn from tempdb..SQLAgentDiff order by id
		
 		open cFn
 		fetch next from cFn into @fileID, @scriptFileName
  
 		while @@Fetch_status =0
 		begin
			print convert(varchar(30), getdate(), 120) + N' processing file ' + @scriptFileName

      select @jobName = right(@scriptFileName, len(@scriptFileName) - patindex('%[_]sqlagent[_]%', @scriptFileName)-9)
      select @jobName = left(@jobName, len(@jobName)-4)
      
			print convert(varchar(30), getdate(), 120) + N' processing job ' + @jobName

			if not exists(select job_id from msdb..sysjobs where name like @jobName)
			begin
				print convert(varchar(30), getdate(), 120) + N' SQL Agent Job ' + @jobName + N' does not exist'
				update tempdb..SQLAgentDiff set diff = 'Y' where id = @fileID
				
				if @reportOnly = 'N'
				begin
					set @cmd = 'osql -S ' + @server + ' -E -i"' + @scriptDir + @scriptFileName + '"'
					print convert(varchar(30), getdate(), 120) + N' Creating Job ' + @jobName + N' with command "' + @cmd + '"'
					exec @rc = master..xp_cmdshell @cmd
					if @rc <> 0
					begin
						print convert(varchar(30), getdate(), 120) + N' Error executing command "' + @cmd + '"'
						raiserror('SQL Agent Job creation failed', 16, 1)
					end
				end

			end
			else
			begin
				print convert(varchar(30), getdate(), 120) + N' SQL Agent Job ' + @jobName + N' already exists'

			end
	 
	 		fetch next from cFn into @fileID, @scriptFileName
	    
		end

		close cFn
		deallocate cFn

		if (select max(id) from tempdb..SQLAgentDiff where diff = 'Y') > 0
		begin
	
			insert into tempdb..SQLAgentDiff (fn, d, f, diff)
			values (@scriptDir, 0, 0, 'H')
	
			if @reportOnly = 'Y'
				insert into tempdb..SQLAgentDiff (fn, d, f, diff)
				values ('** NOTE: Job run as report only. No changes made.', 0, 0, 'H')
			else
				insert into tempdb..SQLAgentDiff (fn, d, f, diff)
				values ('Appropriate scripts were run to create SQL Agent Jobs.', 0, 0, 'H')
	
			exec sp_makewebtask 
				@outputfile = @msg_file
				, @resultstitle = '<br/> '
				, @query = 'select fn as [Script Directory] FROM tempdb..SQLAgentDiff where diff = ''H'' order by id
						select count(id) as [Total Missing Jobs] FROM tempdb..SQLAgentDiff where diff = ''Y''
						select fn as [Script Filename] FROM tempdb..SQLAgentDiff where diff = ''Y'' order by id'
				, @whentype = 1 -- run and delete
				, @HTMLheader = 3 -- H3
				, @lastupdated = 1 -- don't include
	
			-- send email message
			exec @rc = master.dbo.xp_smtp_sendmail
				@server = @smtp_server
				, @from = @from_address
				, @from_name = @from_name
				, @to = @to_address
				, @replyto = @reply_to
				, @priority = @msg_priority
				, @type = @msg_type
				, @subject = @msg_subject
				, @messagefile = @msg_file
		
			if @rc <> 0
			begin
				raiserror('EMail send failed', 16, 1)
			end
		end
		else
		begin
			set @Msg = 'All scripts found in directory "' + @scriptDir + '"'
			set @Msg = @Msg + ' were successfully matched against existing '
			set @Msg = @Msg + ' logins. No further action necessary.'
			-- send email message
			exec @rc = master.dbo.xp_smtp_sendmail
				@server = @smtp_server
				, @from = @from_address
				, @from_name = @from_name
				, @to = @to_address
				, @replyto = @reply_to
				, @priority = @msg_priority
				, @type = @msg_type
				, @subject = @msg_subject
				, @message = @Msg
		
			if @rc <> 0
			begin
				raiserror('EMail send failed', 16, 1)
			end

		end
	
	
		if object_id('tempdb..SQLAgentDiff') is not null drop table tempdb..SQLAgentDiff

	end

	print convert(varchar(30), getdate(), 120) + ' Processing complete.'
	print ''
	print replicate('=', 40)

end
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating [dbo].[usp_KillOldConnections]...';


GO

CREATE procedure [dbo].[usp_KillOldConnections]
  @idleHours int

as
begin -- procedure
  set nocount on

  declare @spid int
  declare @sqlCmd nvarchar(100)
  declare @killDate datetime
  declare @msgSubject varchar(500);
  declare @msgBody varchar(8000);
  declare @serverName varchar(50);

  set @msgBody = N'';
  set @serverName = cast(serverproperty('ServerName') as varchar(50))
  set @msgSubject = N'Old connections terminated on ' + @serverName;
  set @killDate = current_timestamp

  insert INTO [dbo].[killed_processes]  (
    [kill_date], [spid], [hostname], [program_name], [loginame]
    , [database_name], [login_time], [last_batch], [status], [cmd]
    , [cpu], [physical_io], [memusage], [waittime], [lastwaittype]
    , [waitresource], [blocked]
  )
  select 
    @killDate as kill_date
    , [spid]
    , ltrim(rtrim([hostname]))
    , ltrim(rtrim([program_name]))
    , ltrim(rtrim([loginame]))
    , db_name([dbid]) as [database_name]
    , [login_time]
    , [last_batch]
    , ltrim(rtrim([status]))
    , ltrim(rtrim([cmd]))
    , [cpu]
    , [physical_io]
    , [memusage]
    , [waittime]
    , replace([lastwaittype], char(0), '') as [lastwaittype]
    , replace([waitresource], char(0), '') as [waitresource]
    , [blocked] as [blocked]
  from master..sysprocesses
  where spid > 50
    and not ([program_name] like '%SQLAgent%')
    and [last_batch] < dateadd(hh, -(@idleHours), @killDate)
    or ([login_time] < dateadd(hh, -(@idleHours), @killDate) 
          and [last_batch] is null)

  -- build and execute dynamic SQL command to kill all old spids
  select @sqlCmd = @sqlCmd + q.[spids]
  from (
      select 'KILL ' + cast([spid] as varchar(10)) + ';'
        + CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10) as [spids]
      from [dbo].[killed_processes]
      where [kill_date] = @killDate
    ) as q
  exec sp_ExecuteSQL @sqlCmd

  -- build email message text to list killed spids
  select @msgBody = @msgBody + q.[detail]
  from (
    select '<BODY><DIV align="centre">'
      + '<P>Following list of connections have been inactive for over '
      + 'two days and have been terminated.</P><TABLE border= "1"><TR>'
      + '<TH>SPID</TH><TH>Host</TH><TH>Program</TH><TH>Login</TH>'
      + '<TH>Database</TH><TH>Login Time</TH><TH>Last Batch</TH>'
      + '<TH>Status</TH><TH>Command</TH><TH>CPU</TH><TH>Physical I/O</TH>'
      + '<TH>Memory</TH><TH>Wait Time</TH><TH>Last Wait</TH>'
      + '<TH>Wait Resource</TH><TH>Blocked</TH></TR>' as [detail]
      , cast('1 Jan 1900' as datetime) as [last_batch]
      , 1 as [sort_order]
    UNION ALL
    SELECT
      '<TR><TD>' + cast([spid] as varchar(10)) + '</TD>' 
        + '<TD>' + isnull([hostname], '') + '</TD>'
        + '<TD>' + isnull([program_name], '') + '</TD>'
        + '<TD>' + isnull([loginame], '') + '</TD>'
        + '<TD>' + isnull([database_name], '') + '</TD>'
        + '<TD>' + convert(varchar(30), [login_time], 120) + '</TD>'
        + '<TD>' + convert(varchar(30), [last_batch], 120) + '</TD>'
        + '<TD>' + isnull([status], '') + '</TD>'
        + '<TD>' + isnull([cmd], '') + '</TD>'
        + '<TD>' + isnull(cast([cpu] as varchar(20)), '') + '</TD>'
        + '<TD>' + isnull(cast([physical_io] as varchar(20)), '') + '</TD>'
        + '<TD>' + isnull(cast([memusage] as varchar(20)), '') + '</TD>'
        + '<TD>' + isnull(cast([waittime] as varchar(20)), '') + '</TD>'
        + '<TD>' + isnull([lastwaittype], '') + '</TD>'
        + '<TD>' + isnull([waitresource], '') + '</TD>'
        + '<TD>' + isnull(cast([blocked] as varchar(20)), '') 
        + '</TD></TR>' as [detail]
      , [last_batch]
      , 2 as [sort_order]
    from [dbo].[killed_processes]
    where [kill_date] = @killDate
    UNION ALL
    select 
      '</TABLE></DIV></BODY>'
      , '31 Dec 9999' as [last_batch]
      , 99 as [sort_order]
  ) as q  
  order by [sort_order], [last_batch];

  exec [dbo].[usp_SendEmail]
    @EmailProfile = 'DBA'
    , @Subject = @msgSubject
    , @MsgBody = @msgBody

end -- procedure
GO
PRINT N'Creating [dbo].[usp_LogShipping_CheckStatus]...';


GO
CREATE  PROCEDURE [dbo].[usp_LogShipping_CheckStatus]
  @onPrimary char(1) = 'Y' -- running check on primary server?
  , @PushOrPull char(1) = 'L' -- pu(S)hing files to secondary, or pu(L)ling files from primary
  , @allowedLag int = 15 -- minutes to allow between backups
  , @useCompress CHAR(1) = 'Y' -- check for files being compressed/decompressed
  , @sendMail char(1) = 'Y' -- send email notifcation?
  , @mailProfile varchar(20) = 'DBA_HTML' -- profile to use for email
  , @debug CHAR(1) = 'N' -- Y extra informational messages
as
begin -- procedure

  set nocount on
  -- error lists
  if exists(select * from tempdb..sysobjects where id = object_id('tempdb..#checks')) drop table #checks;
  create table #checks(database_name varchar(50), last_date datetime, id int not null identity (1, 1))

  if exists(select * from tempdb..sysobjects where id = object_id('tempdb..#errors')) drop table #errors;
  create table #errors(errMsg varchar(500), errType char(1), id int not null identity (1, 1))

  declare @dbCount int
  declare @fileCount INT
  declare @lagDate datetime
  declare @cmdText varchar(500)
  declare @errMsg varchar(500)
  declare @serverName varchar(30)
  declare @msgSubject nvarchar(500);
  declare @msgBody varchar(max);
  DECLARE @statusMsg VARCHAR(MAX);

  SET @lagDate = dateadd(mi, -@allowedLag, getdate())
  set @msgSubject = N'';
  set @msgBody = N'';
  set @serverName = cast(serverproperty('ServerName') as varchar(50))

  set @errMsg = '<TR><TD colspan="2"><strong>Server designated as ' 
    + case when @onPrimary = 'Y' then 'PRIMARY' else 'SECONDARY' end 
    + ' with allowed latency of ' + CAST(@allowedLag AS VARCHAR(10)) + ' minute(s).</strong></TD></TR>'
  insert into #errors([errMsg], [errType]) values (@errMsg, 'H')
          
  IF @debug = 'Y'
  BEGIN
    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Checking count of database with "is_log_shipped" flag set.'
    raiserror(@statusMsg, 10, 1) with nowait
  END

  set @dbCount = isnull((
      select count([backup_group]) 
      from [dbo].[backup_list]
      where [is_log_shipped] = 1
      ), 0)

  IF @debug = 'Y'
  BEGIN
    set @statusMsg = convert(varchar(30), getdate(), 120) + ' - ' 
      + CAST(@dbCount AS VARCHAR(10)) + ' database(s) with "is_log_shipped" flag set.'
    raiserror(@statusMsg, 10, 1) with nowait
  END
      
  if @dbCount > 0
  begin -- databases being log shipped

    IF @debug = 'Y'
    BEGIN
      set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Checking latest database backup/restore times.'
      raiserror(@statusMsg, 10, 1) with nowait
    END
    -- check when last transaction log backup was performed
    TRUNCATE TABLE #checks
    INSERT INTO #checks ( database_name, last_date)
    SELECT fl.[database_name]
      , MAX(ISNULL(
            case when @onPrimary = 'Y' 
              then fl.[backup_finishdate] 
              else fl.[restore_date]
            end,'1900-01-01')
          ) AS [BakRst_date]
    FROM [dbo].[logshipping_files] fl
      INNER JOIN [dbo].[backup_list] lst
      on fl.[database_name] = lst.[database_name]
    WHERE lst.[is_log_shipped] = 1
    GROUP BY fl.[database_name]
    HAVING MAX(ISNULL(
        CASE WHEN @onPrimary = 'Y' THEN fl.[backup_finishdate] 
          ELSE fl.[restore_date] END,'1900-01-01'
      )) < @lagDate

    IF @debug = 'Y'
    BEGIN
      SELECT * FROM #checks
    END
    
    if exists (SELECT 1 FROM #checks)
    begin -- slow backup/restore
      IF @debug = 'Y'
      BEGIN
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Found slow backup/restore times.'
        raiserror(@statusMsg, 10, 1) with nowait
        select [database_name], [last_date] as [max_backup/restore], @lagDate AS [lagDate], GETDATE() AS [NOW]
        FROM #checks
      END

      set @errMsg = '<TR><TD colspan="2"><strong>The following databases have not had a transaction log '
        + case when @onPrimary = 'Y' then 'backup' else 'restore' end
        + ' within the allowed latency time of ' + cast(@allowedLag as varchar(10)) + ' minute(s).</strong></TD></TR>'
      insert into #errors([errMsg], [errType]) values (@errMsg, 'H')
      set @errMsg = '<TR><TD><strong>Database Name</strong></TD><TD><strong>Last ' 
        + case when @onPrimary = 'Y' then 'Backup' else 'Restore' end + ' Date</strong></TD></TR>'
      insert into #errors([errMsg], [errType]) values (@errMsg, 'H')
      insert into #errors([errMsg], [errType]) 
      select '<TR><TD>' + quotename([database_name]) + '</TD><TD>' 
        + convert(varchar(30), [last_date], 120) + '</TD></TR>', 'D'
      FROM #checks

      IF @debug = 'Y'
      BEGIN
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Current issues logged to #errors table.'
        raiserror(@statusMsg, 10, 1) with nowait
        SELECT [errMsg], [errType] FROM #errors
      END

    end -- slow backup/restore
    ELSE
    BEGIN -- no slow backup/restore
      if @debug = 'Y'
      begin
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - there is no slow backup/restore times.'
        raiserror(@statusMsg, 10, 1) with nowait
      end
    END -- no slow backup/restore

    IF @useCompress = 'Y'
    BEGIN -- check compress/decompress
      IF @debug = 'Y'
      BEGIN
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Checking for compress/decompress lag.'
        raiserror(@statusMsg, 10, 1) with nowait
      END
      -- check for file compress/decompress lag
      TRUNCATE TABLE #checks
      INSERT INTO #checks ( database_name, last_date)
      SELECT fl.[database_name]
        , MAX(ISNULL(
              case when @onPrimary = 'Y' 
                then fl.[compress_date] 
                else fl.[decompress_date]
              end,'1900-01-01')
            ) AS [compr_date]
      FROM [dbo].[logshipping_files] fl
        INNER JOIN [dbo].[backup_list] lst
        on fl.[database_name] = lst.[database_name]
      WHERE lst.[is_log_shipped] = 1
      GROUP BY fl.[database_name]
      HAVING MAX(ISNULL(
          CASE WHEN @onPrimary = 'Y' THEN fl.[compress_date] 
            ELSE fl.[decompress_date] END,'1900-01-01'
        )) < @lagDate

      IF @debug = 'Y'
      BEGIN
        SELECT * FROM #checks
      END

      if exists (SELECT 1 FROM #checks)
      BEGIN -- compress/decompress latency exists        
        IF @debug = 'Y'
        BEGIN
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - compress/decompress latency exists.'
          raiserror(@statusMsg, 10, 1) with nowait

          SELECT [database_name], [last_date] as [max_compress/decompress], @lagDate AS [lagDate], GETDATE() AS [NOW]
          FROM #checks
          
        END

        set @errMsg = '<TR><TD colspan="2"><strong>The following databases may have files with slow '
          + case when @onPrimary = 'Y' then 'compress' else 'decompress' end
          + ' times, or the files have not been ' 
          + case when @onPrimary = 'Y' then 'compressed' else 'decompressed' end
          + ' within the allowed latency time of ' 
          + cast(@allowedLag as varchar(10)) + ' minute(s).</strong></TD></TR>'
        insert into #errors([errMsg], [errType]) values (@errMsg, 'H')
        set @errMsg = '<TR><TD><strong>Database Name</strong></TD><TD><strong>Last ' 
          + case when @onPrimary = 'Y' then 'Compress' else 'Decompress' END + ' Date</strong></TD></TR>'
        insert into #errors([errMsg], [errType]) values (@errMsg, 'H')
        insert into #errors([errMsg], [errType])
        select '<TR><TD>' + quotename([database_name]) + '</TD><TD>' 
          + convert(varchar(30), [last_date], 120) + '</TD></TR>', 'D'
        FROM #checks
          
        IF @debug = 'Y'
        BEGIN
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Current issues logged to #errors table.'
          raiserror(@statusMsg, 10, 1) with nowait
          SELECT [errMsg], [errType] FROM #errors
        END
          
      END -- compress/decompress latency exists
      ELSE
      BEGIN -- no compress/decompress lag
        if @debug = 'Y'
        begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - there is no compress/decompress lag.'
          raiserror(@statusMsg, 10, 1) with nowait
        end
      END -- no compress/decompress lag
      
    END -- check compress/decompress

    IF (@onPrimary = 'Y' AND @PushOrPull = 'S')
      OR (@onPrimary = 'N' AND @PushOrPull = 'L')
    BEGIN -- run on secondary server for pull, primary server for push
      IF @debug = 'Y'
      BEGIN
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Checking for transfer lag.'
        raiserror(@statusMsg, 10, 1) with nowait
      END

      -- check for transfer lag
      TRUNCATE TABLE #checks
      INSERT INTO #checks ( database_name, last_date)
      SELECT fl.[database_name]
        , MAX(ISNULL(
              case when @onPrimary = 'Y' 
                then fl.[xfer_readydate] 
                else fl.[xfer_enddate]
              end,'1900-01-01')
            ) AS [xfer_date]
      FROM [dbo].[logshipping_files] fl
        INNER JOIN [dbo].[backup_list] lst
        on fl.[database_name] = lst.[database_name]
      WHERE lst.[is_log_shipped] = 1
      GROUP BY fl.[database_name]
      HAVING MAX(ISNULL(
          CASE WHEN @onPrimary = 'Y' THEN fl.[xfer_readydate] 
            ELSE fl.[xfer_enddate] END,'1900-01-01'
        )) < @lagDate

      IF @debug = 'Y'
      BEGIN
        SELECT * FROM #checks
      END

      if exists (SELECT 1 FROM #checks)
      BEGIN -- transfer latency exists        
        IF @debug = 'Y'
        BEGIN
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - transfer latency exists.'
          raiserror(@statusMsg, 10, 1) with nowait

          SELECT [database_name], [last_date] as [Archive Date/Xfer End], @lagDate AS [lagDate], GETDATE() AS [NOW]
          FROM #checks

        END

        set @errMsg = '<TR><TD colspan="2"><strong>The following databases may '
          + 'have file tranfers that have not started or are running slow.</strong></TD></TR>'
        insert into #errors([errMsg], [errType]) values (@errMsg, 'H')
        set @errMsg = '<TR><TD><strong>Database Name</strong></TD><TD><strong>Last '
          + case when @onPrimary = 'Y' then 'Transfer Ready' else 'Transfer End' END + ' Date</strong></TD></TR>'
        insert into #errors([errMsg], [errType]) values (@errMsg, 'H')
        insert into #errors([errMsg], [errType])
        select '<TR><TD>' + quotename([database_name]) + '</TD><TD>' 
          + convert(varchar(30), [last_date], 120) + '</TD></TR>', 'D'
        FROM #checks

        IF @debug = 'Y'
        BEGIN
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Current issues logged to #errors table.'
          raiserror(@statusMsg, 10, 1) with nowait
          SELECT [errMsg], [errType] FROM #errors
        END

      END -- transfer latency exists
      ELSE
      BEGIN -- no transfer lag
        if @debug = 'Y'
        begin
          set @statusMsg = convert(varchar(30), getdate(), 120) + ' - there is no transfer lag.'
          raiserror(@statusMsg, 10, 1) with nowait
        end
      END -- no transfer lag

    END -- run on secondary server for pull, primary server for push
    ELSE
    BEGIN -- secondary server for push, primary server for pull
      set @errMsg = '<TR><TD colspan="2"><strong>No transfer checking performed.</strong></TD></TR>'
      insert into #errors([errMsg], [errType]) values (@errMsg, 'H')
      set @errMsg = '<TR><TD colspan="2">Running on ' 
        + case when @onPrimary = 'Y' then 'PRIMARY' else 'SECONDARY' end 
        + ' with ' + case when @PushOrPull = 'S' then 'PUSH' else 'PULL' end 
        + ' file transfer.</TD></TR>'
      insert into #errors([errMsg], [errType]) values (@errMsg, 'H')

      if @debug = 'Y'
      begin
        set @statusMsg = convert(varchar(30), getdate(), 120) + ' - No transfer checking performed. '
          + 'Running on ' + case when @onPrimary = 'Y' then 'PRIMARY' else 'SECONDARY' end 
          + ' and with ' + case when @PushOrPull = 'S' then 'PUSH' else 'PULL' end + ' file transfer.'
        raiserror(@statusMsg, 10, 1) with nowait
      end
    END -- secondary server for push, primary server for pull

    -- check for errors logged and issue message    
    if (select count(id) from #errors where errType = 'D') > 0
    begin -- errors detected
      If @sendMail = 'Y'
      begin -- email error list
        select @msgSubject = @serverName + ': Log Shipping Issues detected';
        select @msgBody = @msgBody + q.[detail]
        from (
          select '<BODY><DIV align="centre"><P>List of Log Shipping problems on ' + @serverName + ' as at ' 
            + CONVERT(varchar(30), getdate(), 120) + '</P><TABLE border= "1">' as [detail]
            , 0 as [order]
          UNION ALL
          SELECT
            errMsg as [detail]
            , [id] AS [order]
          FROM #errors
          UNION ALL
          SELECT '</DIV></BODY>', 9999
        ) as q  
        order by [order];

        exec dbo.usp_SendEmail
          @EmailProfile = @mailProfile
          , @subject = @msgSubject
          , @msgBody = @msgBody;
        
      end -- email errors list
      else
      begin -- list out errors
        print 'Errors detected'
        select [errMsg], [errType] from #errors
      
      end -- list out errors
      
    end -- errors detected
    else
    begin -- no errors
      If @sendMail = 'N'
        print 'No errors in log shipping process detected'
    
    end -- no errors
    
  end -- databases being log shipped
  
end -- procedure
GO
PRINT N'Creating [dbo].[usp_LogShipping_CleanupArchive]...';


GO



CREATE   procedure [dbo].[usp_LogShipping_CleanupArchive]
	@databaseName varchar(200) -- comma seperated list of databases
	, @hoursOld int -- maximum age of files to keep
	, @onPrimary char(1) = 'N' -- Y running on primary server, 'N' running on secondary server
	, @debug char(1) = 'N' -- N minimal informational messages, Y extra messages

as
begin
	set nocount on
	set dateformat ymd
	
	-- table for directory tree
	if exists(select * from tempdb..sysobjects where id = object_id('tempdb..#f')) drop table #f;
	create table #f(fullpath varchar(500), filedate datetime, id int not null identity (1, 1))
	
	declare @cmdText varchar(500)
	declare @archiveDir varchar(500)
	declare @cnt int
	declare @maxDate datetime
	declare @fileDate datetime
	declare @archiveName varchar(500)
	declare @statusMsg varchar(500)

  set @statusMsg = convert(varchar(30), getdate(), 120) + ' - Start processing for database [%s].'
  raiserror(@statusMsg, 10, 1, @databaseName) with nowait
	
	-- calculate the maximum file age
	set @maxDate = dateadd(hh, -(@hoursold), getdate())	
	
	-- print message showing count of files to delete
  set @cnt = ISNULL((
      select count([file_id])
      from dbo.[logshipping_files]
      where [database_name] = @databaseName
        and case -- file hasn't been removed
              when @onPrimary = 'Y' then [archive_removed] 
              else [sec_archive_removed] 
            end = 0
        and case -- file is older than max calc'd date
              when @onPrimary = 'Y' then [archive_date] 
              else [sec_archive_date] 
            end < @maxDate
    ), 0)
	set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + cast(@cnt as varchar(10)) 
    + ' file(s) older than ' + convert(varchar(30), @maxDate, 113) + ' to be removed.'
	raiserror(@statusMsg, 10, 1) with nowait

  if @cnt > 0
  begin -- files to process
    	
	  -- get list of file to process
	  DECLARE csrFiles CURSOR FOR
      select 
        case 
          when @onPrimary = 'Y' then [archive_filename] 
          else [sec_archive_name] 
        end
      from dbo.[logshipping_files]
      where [database_name] = @databaseName
        and case -- file hasn't been removed
              when @onPrimary = 'Y' then [archive_removed] 
              else [sec_archive_removed] 
            end = 0
        and case -- file is older than max calc'd date
              when @onPrimary = 'Y' then [archive_date] 
              else [sec_archive_date] 
            end < @maxDate
	  OPEN csrFiles
	  FETCH NEXT FROM csrFiles into @archiveName
  	
	  WHILE @@FETCH_STATUS = 0
	  BEGIN -- file processing cursor
		  -- print status message
		  set @statusMsg = convert(varchar(30), getdate(), 120) + ' Processing file - "' + @archiveName + '"'
	    raiserror(@statusMsg, 10, 1) with nowait

		  -- delete the file
		  set @cmdText = 'del "' + @archiveName + '"'
		  if @debug = 'Y' 
		  begin
			  set @statusMsg = convert(varchar(30), getdate(), 120) + ' ' + isnull(@cmdText, 'No Command built')
	      raiserror(@statusMsg, 10, 1) with nowait
			  exec master..xp_cmdshell @cmdText
		  end
		  else
			  exec master..xp_cmdshell @cmdText, no_output
			  
      IF @onPrimary = 'Y'
        update [dbo].[logshipping_files]
        set [archive_removed] = 1
        where [archive_filename] = @archiveName
      else        
        update [dbo].[logshipping_files]
        set [sec_archive_removed] = 1
        where [sec_archive_name] = @archiveName
  	
		  FETCH NEXT FROM csrFiles into @archiveName
	  END -- file processing cursor
  	
	  -- cleanup
	  CLOSE csrFiles
	  DEALLOCATE csrFiles
  	
	  set @statusMsg = convert(varchar(30), getdate(), 120) + ' File processing complete.'
	  raiserror(@statusMsg, 10, 1) with nowait

    set @archiveDir = LEFT(@archiveName, LEN(@archiveName) - PATINDEX('%\[0-9][0-9][0-9][0-9]\%', REVERSE(@archiveName))-4)
    -- delete empty folders in archive
    exec dbo.usp_LogShipping_CleanupFolders 
      @archiveDir = @archiveDir
      , @debug = @debug

  end -- files to process

	set @statusMsg = replicate('=', 40)
	raiserror(@statusMsg, 10, 1) with nowait
	
end
GO
PRINT N'Creating [dbo].[usp_Sample_SQLAgentStats]...';


GO

create procedure [dbo].[usp_Sample_SQLAgentStats]

as
begin
  set nocount on
  
  exec dbo.usp_SqlAgent_JobInfo
  exec dbo.usp_SQLAgent_JobSchedule
  exec dbo.usp_SQLAgent_JobHistory
  exec dbo.usp_SqlAgent_JobSteps

end
GO
PRINT N'Creating [dbo].[usp_SendAlert]...';


GO

CREATE procedure [dbo].[usp_SendAlert]
  @Server nvarchar(128)
  , @AlertDate varchar(10)
  , @AlertTime varchar(10)
  , @DBName nvarchar(128)
  , @ErrNum varchar(10)
  , @Severity varchar(10)
  , @MsgText nvarchar(4000)
as

begin -- procedure
  set nocount on
  
  declare @ProfileName varchar(20);
  declare @ForSMS bit;
  declare @MsgSubject varchar(150);
  declare @MsgBody varchar(4000);
  declare @rtn int;
  declare @err int;
  declare @er varchar(20);
  declare @rt varchar(20);
  
  if exists(select 1 from dba.dbo.alert_destinations where error_num = @ErrNum)
  begin -- specific profile
    select
      @ProfileName = [ProfileName], @ForSMS = [ForSMS]
    from DBA.dbo.EmailProfiles prf
      inner join DBA.dbo.alert_destinations dst
      on prf.ProfileID = dst.primary_profile_id
    where dst.[error_num] = @ErrNum

  end -- specific profile
  else
  begin -- default profile
    select 
      @ProfileName = [ProfileName], @ForSMS = [ForSMS]
    from DBA.dbo.EmailProfiles prf
      inner join DBA.dbo.alert_destinations dst
      on prf.ProfileID = dst.primary_profile_id
    where dst.[error_num] = 0

  end -- default profile

  IF @ForSMS = 1
  BEGIN -- build SMS message
    SET @MsgSubject = @Server + ': Severity ' + @Severity + ': '
    SET @MsgSubject = @MsgSubject + LEFT(@MsgText, 160 - LEN(@MsgSubject))
    SET @MsgBody = ''

    -- send the SMS
    exec @rtn = [dbo].[usp_SendEmail]
      @EmailProfile = @ProfileName
      , @Subject = @msgSubject
      , @MsgBody = @msgBody

    set @err = @@ERROR
    if @rtn <> 0 or @err <> 0
    begin -- Error sending SMS
      set @er = cast(@err as varchar(20))
      set @rt = cast(@rtn as varchar(20))
      raiserror('Problem sending SMS for error number [%s], Return Value: %s, SQL Error: %s', 16, 1, @ErrNum, @er, @rt)
      
    end -- Error sending SMS

    -- get secondary profile details
    select
      @ProfileName = [ProfileName], @ForSMS = [ForSMS]
    from DBA.dbo.EmailProfiles prf
      inner join DBA.dbo.alert_destinations dst
      on prf.ProfileID = dst.secondary_profile_id
    where dst.[error_num] = @ErrNum

  END -- build SMS message

  -- check if we send EMail message
  IF NOT (@ProfileName IS NULL)
  begin -- send the email
    -- build Subject and MsgBody for EMail
    SET @MsgSubject = @Server + ': Severity ' + @Severity + ' Error Occurred'
    SET @MsgBody = '<BODY>Date: ' + @AlertDate + '<BR />'
      + 'Time: ' + @AlertTime + '<BR />'
      + 'Database: ' + @DBName + '<BR />'
      + 'Error: ' + @ErrNum + '<BR />'
      + 'Severity: ' + @Severity + '<BR />'
      + 'Message: ' + @MsgText + '<BR /></BODY>'

    -- send the email
    exec @rtn = [dbo].[usp_SendEmail]
      @EmailProfile = @ProfileName
      , @Subject = @msgSubject
      , @MsgBody = @msgBody
    set @err = @@ERROR
    if @rtn <> 0 or @err <> 0
    begin -- Error sending email
      set @er = cast(@err as varchar(20))
      set @rt = cast(@rtn as varchar(20))
      raiserror('Problem sending email for error number [%s], Return Value: %s, SQL Error: %s', 16, 1, @ErrNum, @er, @rt)
      
    end -- Error sending email

  end -- send the email
  
end -- procedure
GO
PRINT N'Creating [dbo].[usp_UpdateSQLAgentJobLogFile]...';


GO

CREATE procedure [dbo].[usp_UpdateSQLAgentJobLogFile]
	@jobid uniqueidentifier
	, @logDir nvarchar(100) = 'G:\Backups\Reports\'
as
begin
  set nocount on
  
	declare @stpID int
	declare @jobNm nvarchar(128)
	declare @oldFile nvarchar(255)
	declare @newFile nvarchar(255)
	declare @oldDte nvarchar(6)
	declare @newDte nvarchar(6)

  set @stpID = 0
  set @jobNm = ''
	set @oldFile = ''
	set @newFile = ''
	set @oldDte = convert(nvarchar(6), dateadd(mm, -1, getdate()), 112)
	set @newDte = convert(nvarchar(6), getdate(), 112)
	
	if right(@logDir, 1) <> '\'
	  set @logDir = @logDir + '\'

  declare stps cursor fast_forward for
    select jStp.[step_id], sJb.[name], jStp.[output_file_name]
    from [msdb].[dbo].[sysjobsteps] jStp
      inner join [msdb].[dbo].[sysjobs] sJb
      on jStp.[job_id] = sJb.[job_id]
	  where sJb.[job_id] = @jobid

  open stps
  fetch next from stps into @stpID, @jobNm, @oldFile				

  while @@fetch_status = 0
  begin
  
    set @newFile = replace(@oldFile, @oldDte, @newDte)
    if (charindex(@newDte, @newFile) = 0) or (@oldFile is null)
    begin
      select @jobNm = dbo.fn_StripCharacters(@jobNm, '^a-z')
      select @newFile = @logDir + replace(@jobNm, ' ', '') + '_' + @newDte + '.log'
      
    end
    
    exec msdb..sp_update_jobstep 
      @job_id = @jobid
      , @step_id = @stpID
      , @output_file_name = @newFile
      , @flags = 2

    fetch next from stps into @stpID, @jobNm, @oldFile				
  
  end
  
  close stps
  deallocate stps
  
end
GO
PRINT N'Creating [dbo].[fn_StripCharacters]...';


GO

CREATE  FUNCTION [dbo].[fn_StripCharacters]
(
    @String NVARCHAR(4000), 
    @MatchExpression VARCHAR(255)
)
RETURNS NVARCHAR(4000)
AS
BEGIN
    SET @MatchExpression =  '%['+@MatchExpression+']%'
    WHILE PatIndex(@MatchExpression, @String) > 0
        SET @String = Stuff(@String, PatIndex(@MatchExpression, @String), 1, '')
    RETURN @String
END
GO
PRINT N'Creating [dbo].[CTTraceDetailView]...';


GO

CREATE VIEW [dbo].[CTTraceDetailView]
AS
SELECT 
    TD.[RowNumber],
    TD.[EventClass],
    TD.[TextDataHashCode],
    T.[NormalizedTextData],
    T.[SampleTextData],
    TD.[CPU],
    TD.[Reads],
    TD.[Writes],
    TD.[Duration],
    TD.[ApplicationID],
    A.[ApplicationName],
    TD.[LoginID],
    L.[LoginName],
    TD.[HostID],
    H.[HostName],
    TD.[EndTime],
    TD.[ServerID],
    S.[ServerName],
    TD.[TraceFileID],
    TD.TraceID,
    Tr.TraceName
FROM 
    [dbo].[CTTraceDetail] TD
LEFT JOIN
    [dbo].[CTApplication] A ON A.ApplicationID = TD.ApplicationID
LEFT JOIN
    [dbo].[CTLogin] L ON L.LoginID = TD.LoginID
LEFT JOIN
    [dbo].[CTHost] H ON H.HostID = TD.[HostID]
LEFT JOIN
    [dbo].[CTTextData] T ON T.[TextDataHashCode] = TD.[TextDataHashCode]
LEFT JOIN
    [dbo].[CTServer] S ON S.[ServerID] = TD.[ServerID]
LEFT JOIN
    dbo.CTTrace Tr ON Tr.TraceID = TD.TraceID
GO
PRINT N'Creating [dbo].[CTTraceSummaryView]...';


GO

CREATE VIEW [dbo].[CTTraceSummaryView]
AS
SELECT 
    TD.[EventClass],
    TD.[TextDataHashCode],
    T.[NormalizedTextData],
    T.[SampleTextData],
    TD.[CPU],
    TD.[Reads],
    TD.[Writes],
    TD.[Duration],
	TD.[ExecutionCount],
    TD.[ApplicationID],
    A.[ApplicationName],
    TD.[LoginID],
    L.[LoginName],
    TD.[HostID],
    H.[HostName],   
    TD.[ServerID],
    S.[ServerName],
    TD.[TraceFileID],
    TD.TraceID,
    Tr.TraceName,
    TD.DateID,
    DD.CalendarDate,
    TD.TimeID
FROM 
    [dbo].[CTTraceSummary] TD
LEFT JOIN
    [dbo].[CTApplication] A ON A.ApplicationID = TD.ApplicationID
LEFT JOIN
    [dbo].[CTLogin] L ON L.LoginID = TD.LoginID
LEFT JOIN
    [dbo].[CTHost] H ON H.HostID = TD.[HostID]
LEFT JOIN
    [dbo].[CTTextData] T ON T.[TextDataHashCode] = TD.[TextDataHashCode]
LEFT JOIN
    [dbo].[CTServer] S ON S.[ServerID] = TD.[ServerID]
LEFT JOIN
    dbo.CTTrace Tr ON Tr.TraceID = TD.TraceID
LEFT JOIN
    dbo.CTDateDimension DD ON DD.DateID = TD.DateID
GO
