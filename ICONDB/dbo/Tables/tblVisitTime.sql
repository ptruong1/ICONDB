CREATE TABLE [dbo].[tblVisitTime] (
    [hourID] TINYINT  NOT NULL,
    [hour]   TIME (0) NULL,
    CONSTRAINT [PK_tblVisitTime] PRIMARY KEY CLUSTERED ([hourID] ASC)
);

