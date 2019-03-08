CREATE TABLE [dbo].[tblTempTranscript] (
    [RecordID]      BIGINT        NOT NULL,
    [TrascriptTime] SMALLDATETIME CONSTRAINT [DF_tblTempTranscript_TrascriptTime] DEFAULT (getdate()) NULL,
    [RecordPath]    VARCHAR (100) NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_RecordID]
    ON [dbo].[tblTempTranscript]([RecordID] ASC);

