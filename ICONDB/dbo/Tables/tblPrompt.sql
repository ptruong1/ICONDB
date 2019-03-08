CREATE TABLE [dbo].[tblPrompt] (
    [PromptFileID]   SMALLINT     NOT NULL,
    [PromptFileName] VARCHAR (25) NULL,
    [Descipt]        VARCHAR (50) NULL,
    CONSTRAINT [PK_tblPrompt] PRIMARY KEY CLUSTERED ([PromptFileID] ASC)
);

