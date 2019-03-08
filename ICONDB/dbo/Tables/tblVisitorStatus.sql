CREATE TABLE [dbo].[tblVisitorStatus] (
    [Status]   CHAR (1)     NOT NULL,
    [Descript] VARCHAR (10) NOT NULL,
    CONSTRAINT [PK_tblVisitorStatus] PRIMARY KEY CLUSTERED ([Status] ASC)
);

