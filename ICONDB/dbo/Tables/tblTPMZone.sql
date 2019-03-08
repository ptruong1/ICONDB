CREATE TABLE [dbo].[tblTPMZone] (
    [ZoneCode]    CHAR (1)     NOT NULL,
    [GMT]         SMALLINT     NULL,
    [AMT]         SMALLINT     NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblTPMZone] PRIMARY KEY CLUSTERED ([ZoneCode] ASC)
);

