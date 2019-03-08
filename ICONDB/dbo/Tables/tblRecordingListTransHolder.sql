CREATE TABLE [dbo].[tblRecordingListTransHolder] (
    [RecordID]          BIGINT        NOT NULL,
    [Inputwav]          VARCHAR (150) NULL,
    [words]             VARCHAR (500) NULL,
    [TranscriptionName] VARCHAR (50)  NULL,
    [CalleeText]        VARCHAR (1)   NOT NULL,
    [CallerText]        VARCHAR (1)   NOT NULL,
    [WordsMatch]        VARCHAR (1)   NOT NULL,
    [Extension]         VARCHAR (8)   NOT NULL,
    [MainStatus]        TINYINT       NULL,
    [InStatus]          TINYINT       NULL,
    [OutStatus]         TINYINT       NULL,
    [UserLanguage]      VARCHAR (10)  NULL
);

