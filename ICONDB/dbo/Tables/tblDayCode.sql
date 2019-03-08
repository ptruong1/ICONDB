CREATE TABLE [dbo].[tblDayCode] (
    [DayCode]  TINYINT      NOT NULL,
    [Day]      TINYINT      NOT NULL,
    [Hour]     TINYINT      NOT NULL,
    [Descript] VARCHAR (50) NULL,
    CONSTRAINT [PK_tblDayCode] PRIMARY KEY CLUSTERED ([DayCode] ASC, [Day] ASC, [Hour] ASC)
);

