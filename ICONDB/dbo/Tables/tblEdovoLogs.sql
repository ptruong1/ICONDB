CREATE TABLE [dbo].[tblEdovoLogs] (
    [TabletID]    VARCHAR (15) NOT NULL,
    [RecordDate]  DATETIME     CONSTRAINT [DF_tblEdovoLogs_RecordDate] DEFAULT (getdate()) NOT NULL,
    [EdovoFacID]  INT          NULL,
    [LegacyFacID] INT          NULL
);

