CREATE TABLE [dbo].[tblRecordingTranscript] (
    [TranscriptListID] INT           NOT NULL,
    [TranscriptName]   VARCHAR (50)  NULL,
    [UserName]         VARCHAR (25)  NULL,
    [InputDate]        SMALLDATETIME CONSTRAINT [DF_tblRecordingTranscript_InputDate] DEFAULT (getdate()) NULL,
    [Words]            VARCHAR (500) NULL,
    [status]           TINYINT       CONSTRAINT [DF_tblRecordingTranscript_status] DEFAULT ((3)) NULL,
    CONSTRAINT [PK_tblRecordingTranscript] PRIMARY KEY CLUSTERED ([TranscriptListID] ASC)
);

