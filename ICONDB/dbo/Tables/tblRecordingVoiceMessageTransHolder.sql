CREATE TABLE [dbo].[tblRecordingVoiceMessageTransHolder] (
    [MailBoxId]         INT           NOT NULL,
    [MessageId]         INT           NOT NULL,
    [Inputwav]          VARCHAR (120) NULL,
    [words]             VARCHAR (500) NULL,
    [TranscriptionName] VARCHAR (50)  NULL,
    [CalleeText]        VARCHAR (1)   NOT NULL,
    [CallerText]        VARCHAR (1)   NOT NULL,
    [WordsMatch]        VARCHAR (1)   NOT NULL,
    [Extension]         VARCHAR (8)   NOT NULL,
    [MainStatus]        TINYINT       NULL,
    [InStatus]          TINYINT       NULL,
    [OutStatus]         TINYINT       NULL
);

