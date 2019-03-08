CREATE TABLE [dbo].[tblBioMetricProfileOxfordVerification_backUp] (
    [UserID]            VARCHAR (16)   NOT NULL,
    [InputDate]         DATETIME       NULL,
    [ModifyDate]        DATETIME       NULL,
    [ProfileID]         NVARCHAR (100) NOT NULL,
    [RemainEnrollments] INT            NULL,
    [SharedPort]        INT            NULL,
    [LanguageSelected]  VARCHAR (6)    NULL,
    [BioInmateID]       VARCHAR (12)   NULL
);

