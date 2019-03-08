CREATE TABLE [dbo].[tblLawOfficeType] (
    [LawyerTypeID] TINYINT      NOT NULL,
    [OfficeName]   VARCHAR (50) NULL,
    CONSTRAINT [PK_tblLawOfficeType] PRIMARY KEY CLUSTERED ([LawyerTypeID] ASC)
);

