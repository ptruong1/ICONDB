CREATE TABLE [dbo].[tblRecordingVoiveMessages] (
    [MailBoxId]        INT      NOT NULL,
    [MessageId]        INT      NOT NULL,
    [TranscriptListID] INT      NOT NULL,
    [status]           TINYINT  CONSTRAINT [DF_tblRecordingVoiveMessages_status] DEFAULT ((0)) NULL,
    [processTime]      DATETIME NULL,
    [InputDate]        DATETIME CONSTRAINT [DF_tblRecordingVoiveMessages_InputDate] DEFAULT (getdate()) NULL,
    [OutStatus]        TINYINT  NULL,
    [InStatus]         TINYINT  NULL,
    CONSTRAINT [PK_tblRecordingVoiveMessages] PRIMARY KEY CLUSTERED ([TranscriptListID] ASC, [MailBoxId] ASC, [MessageId] ASC)
);

