CREATE TABLE [dbo].[tblRecordingList] (
    [RecordID]   BIGINT        NOT NULL,
    [PlayListID] INT           NOT NULL,
    [UserName]   VARCHAR (25)  NULL,
    [inputDate]  SMALLDATETIME CONSTRAINT [DF_tblRecordingList_inputDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblRecordingList] PRIMARY KEY CLUSTERED ([RecordID] ASC, [PlayListID] ASC)
);

