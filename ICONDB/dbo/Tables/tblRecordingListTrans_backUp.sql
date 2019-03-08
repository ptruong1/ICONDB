CREATE TABLE [dbo].[tblRecordingListTrans_backUp] (
    [RecordID]         BIGINT   NOT NULL,
    [TranscriptListID] INT      NOT NULL,
    [status]           TINYINT  NULL,
    [processTime]      DATETIME NULL,
    [InputDate]        DATETIME NULL
);

