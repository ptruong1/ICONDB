CREATE TABLE [dbo].[tblCaseType] (
    [CaseTypeID] TINYINT      NOT NULL,
    [CaseName]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tblCaseType] PRIMARY KEY CLUSTERED ([CaseTypeID] ASC)
);

