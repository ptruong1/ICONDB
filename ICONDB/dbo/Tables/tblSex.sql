CREATE TABLE [dbo].[tblSex] (
    [ID]       TINYINT      NOT NULL,
    [Sex]      CHAR (1)     NOT NULL,
    [Descript] VARCHAR (15) NULL,
    CONSTRAINT [PK_tblSex] PRIMARY KEY CLUSTERED ([ID] ASC, [Sex] ASC)
);

