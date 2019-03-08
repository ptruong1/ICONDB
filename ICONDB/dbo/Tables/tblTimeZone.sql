CREATE TABLE [dbo].[tblTimeZone] (
    [ZoneCode]    SMALLINT     NOT NULL,
    [GMT]         SMALLINT     NULL,
    [AMT]         SMALLINT     NULL,
    [Description] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblTimeZone] PRIMARY KEY CLUSTERED ([ZoneCode] ASC)
);

