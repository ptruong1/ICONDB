CREATE TABLE [dbo].[tblLiveMonitor] (
    [WatchListID]       INT          NULL,
    [RecordID]          BIGINT       NULL,
    [ProjectCode]       CHAR (6)     NULL,
    [CallDate]          CHAR (6)     NULL,
    [CallTime]          CHAR (6)     NULL,
    [CallingNo]         VARCHAR (10) NULL,
    [LocationID]        INT          NULL,
    [CalledNo]          VARCHAR (10) NULL,
    [InmateID]          VARCHAR (12) NULL,
    [PIN]               VARCHAR (12) NULL,
    [Billtype]          CHAR (2)     NULL,
    [HostName]          VARCHAR (20) NULL,
    [Channel]           TINYINT      NULL,
    [FolderDate]        VARCHAR (8)  NULL,
    [RecordFileName]    VARCHAR (15) NULL,
    [Status]            CHAR (1)     CONSTRAINT [DF_tblLiveMonitor_Status] DEFAULT ('U') NULL,
    [duration]          VARCHAR (7)  NULL,
    [LastUpdate]        DATETIME     CONSTRAINT [DF_tblLiveMonitor_LastUpdate] DEFAULT (getdate()) NULL,
    [Watchby]           TINYINT      NULL,
    [WatchListDetailID] INT          NULL,
    CONSTRAINT [FK_tblLiveMonitor_tblWatchList] FOREIGN KEY ([WatchListDetailID]) REFERENCES [dbo].[tblWatchList] ([ID]) ON DELETE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [ind_call]
    ON [dbo].[tblLiveMonitor]([CallingNo] ASC, [Watchby] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_projectcode]
    ON [dbo].[tblLiveMonitor]([ProjectCode] ASC, [CallDate] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_des]
    ON [dbo].[tblLiveMonitor]([CalledNo] ASC, [Watchby] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_pin]
    ON [dbo].[tblLiveMonitor]([PIN] ASC, [Watchby] ASC);

