CREATE TABLE [dbo].[tblRecordingNote] (
    [NoteID]              BIGINT        NOT NULL,
    [RecordID]            BIGINT        NOT NULL,
    [Note]                VARCHAR (200) NULL,
    [PlayMark]            INT           NULL,
    [UserName]            VARCHAR (25)  NULL,
    [inputDate]           SMALLDATETIME CONSTRAINT [DF_tblRecordNote_inputDate] DEFAULT (getdate()) NULL,
    [modifyDate]          SMALLDATETIME NULL,
    [RecordingMarkerName] VARCHAR (25)  NULL,
    CONSTRAINT [PK_tblRecordingNote] PRIMARY KEY CLUSTERED ([NoteID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_record]
    ON [dbo].[tblRecordingNote]([RecordID] ASC, [UserName] ASC);

