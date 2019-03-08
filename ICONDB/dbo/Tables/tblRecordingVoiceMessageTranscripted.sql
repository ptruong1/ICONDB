CREATE TABLE [dbo].[tblRecordingVoiceMessageTranscripted] (
    [MailBoxId]     INT           NOT NULL,
    [MessageId]     INT           NOT NULL,
    [TrascriptDate] SMALLDATETIME CONSTRAINT [DF_tblRecordingVoiceMessageTranscripted_TrascriptDate] DEFAULT (getdate()) NULL,
    [WordsMatch]    VARCHAR (500) NULL,
    [CallerText]    VARCHAR (MAX) NULL,
    [CalleeText]    VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblRecordingVoiceMessageTranscripted] PRIMARY KEY CLUSTERED ([MailBoxId] ASC, [MessageId] ASC)
);

