CREATE TABLE [dbo].[tblServiceLevel] (
    [LevelID]       TINYINT      NOT NULL,
    [LevelDescript] VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_tblServiceLevel] PRIMARY KEY CLUSTERED ([LevelID] ASC)
);

