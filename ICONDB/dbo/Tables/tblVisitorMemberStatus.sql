CREATE TABLE [dbo].[tblVisitorMemberStatus] (
    [Status]   TINYINT      NOT NULL,
    [Descript] VARCHAR (15) NOT NULL,
    CONSTRAINT [PK_tblVisitorMemberStatus] PRIMARY KEY CLUSTERED ([Status] ASC)
);

