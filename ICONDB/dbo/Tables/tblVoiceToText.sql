CREATE TABLE [dbo].[tblVoiceToText] (
    [RecordID]  INT            NOT NULL,
    [FileName]  VARCHAR (14)   NULL,
    [VoiceText] VARCHAR (4000) NULL,
    CONSTRAINT [PK_tblVoiceToText] PRIMARY KEY CLUSTERED ([RecordID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [Ind_RecordID]
    ON [dbo].[tblVoiceToText]([RecordID] ASC);

