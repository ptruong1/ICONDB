CREATE TABLE [dbo].[tblRestrictedNPANXX] (
    [NPA]      CHAR (3)     NOT NULL,
    [NXX]      CHAR (3)     NOT NULL,
    [Descript] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblRestrictedNPANXX] PRIMARY KEY CLUSTERED ([NPA] ASC)
);

