CREATE TABLE [dbo].[tblRecordingListTrans] (
    [RecordID]         BIGINT        NOT NULL,
    [TranscriptListID] INT           NOT NULL,
    [status]           TINYINT       CONSTRAINT [DF_tblRecordingListTrans_status] DEFAULT (0) NULL,
    [processTime]      DATETIME      NULL,
    [InputDate]        DATETIME      CONSTRAINT [DF_tblRecordingListTrans_InputDate] DEFAULT (getdate()) NULL,
    [OutStatus]        TINYINT       NULL,
    [InStatus]         TINYINT       NULL,
    [SearchWord]       VARCHAR (200) NULL,
    CONSTRAINT [PK_tblRecordingListTrans] PRIMARY KEY CLUSTERED ([RecordID] ASC, [TranscriptListID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_status]
    ON [dbo].[tblRecordingListTrans]([status] ASC);

