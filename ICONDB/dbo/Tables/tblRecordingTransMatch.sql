CREATE TABLE [dbo].[tblRecordingTransMatch] (
    [RecordID]      BIGINT        NOT NULL,
    [TrascriptDate] SMALLDATETIME CONSTRAINT [DF_tblRecordingTransMatch_TrascriptDate] DEFAULT (getdate()) NULL,
    [WordsMatch]    VARCHAR (500) NULL,
    [CallerText]    VARCHAR (MAX) NULL,
    [CalleeText]    VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblRecordingTransMatch] PRIMARY KEY CLUSTERED ([RecordID] ASC)
);

