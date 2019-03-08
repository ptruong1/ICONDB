CREATE TABLE [dbo].[tblLanguages] (
    [ACPSelectOpt]    SMALLINT      NULL,
    [LanguageContent] NVARCHAR (50) NULL,
    [ConfidentLevel]  INT           NULL,
    [Nation]          VARCHAR (50)  NULL,
    [VoiceITSupport]  BIT           NULL,
    [VoiceLanguages]  NCHAR (100)   NULL,
    [Abbrev]          VARCHAR (3)   NULL
);

