CREATE TABLE [dbo].[tblBioMetricVoiceIT_Trans] (
    [UserEmail]         VARCHAR (50)  NOT NULL,
    [UserID]            VARCHAR (16)  NOT NULL,
    [FirstName]         VARCHAR (16)  NULL,
    [LastName]          VARCHAR (16)  NULL,
    [TransType]         INT           NULL,
    [FilePath]          VARCHAR (100) NULL,
    [ReturnCode]        VARCHAR (3)   NULL,
    [Response]          VARCHAR (100) NULL,
    [InputDate]         DATETIME      NULL,
    [ModifyDate]        DATETIME      NULL,
    [RemainEnrollments] INT           NULL,
    [ContentLanguage]   VARCHAR (12)  NOT NULL
);

