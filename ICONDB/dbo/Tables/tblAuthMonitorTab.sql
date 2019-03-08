CREATE TABLE [dbo].[tblAuthMonitorTab] (
    [AuthID]          BIGINT   NULL,
    [LiveMonitor]     BIT      NULL,
    [WatchList]       BIT      NULL,
    [GPSMonitor]      BIT      NULL,
    [CallDetail]      BIT      CONSTRAINT [DF_tblAuthMonitorTab_CallDetail] DEFAULT ((1)) NULL,
    [VisitDetail]     BIT      CONSTRAINT [DF_tblAuthMonitorTab_VisitDetail] DEFAULT ((1)) NULL,
    [Archive]         BIT      CONSTRAINT [DF_tblAuthMonitorTab_Archive] DEFAULT ((1)) NULL,
    [SearchWordLists] BIT      NULL,
    [ModifyDate]      DATETIME NULL
);

