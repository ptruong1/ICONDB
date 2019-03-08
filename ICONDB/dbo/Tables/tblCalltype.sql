CREATE TABLE [dbo].[tblCalltype] (
    [CallType] CHAR (1)     NULL,
    [Abrev]    CHAR (2)     NOT NULL,
    [Descript] VARCHAR (20) NULL,
    CONSTRAINT [PK_tblCalltype] PRIMARY KEY CLUSTERED ([Abrev] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_av]
    ON [dbo].[tblCalltype]([Abrev] ASC);

