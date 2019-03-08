CREATE TABLE [dbo].[tblBioMetricProfileVoiceITVerification] (
    [UserEmail]         VARCHAR (50) NOT NULL,
    [password]          VARCHAR (50) NOT NULL,
    [UserID]            VARCHAR (16) NOT NULL,
    [FirstName]         VARCHAR (16) NULL,
    [LastName]          VARCHAR (16) NULL,
    [Phone1]            VARCHAR (10) NULL,
    [Phone2]            VARCHAR (10) NULL,
    [Phone3]            VARCHAR (16) NULL,
    [InputDate]         DATETIME     NULL,
    [ModifyDate]        DATETIME     NULL,
    [RemainEnrollments] INT          NULL,
    [ContentLanguage]   VARCHAR (12) NOT NULL,
    [LanguageSelected]  VARCHAR (6)  NULL
);

