CREATE TABLE [dbo].[tblOfficer] (
    [OfficerID] TINYINT      NOT NULL,
    [LevelDesc] VARCHAR (30) NULL,
    CONSTRAINT [PK_tblOfficer] PRIMARY KEY CLUSTERED ([OfficerID] ASC)
);

