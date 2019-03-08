CREATE TABLE [dbo].[tblAccountExecutive] (
    [AcctExeID]   TINYINT      NOT NULL,
    [AcctExeName] VARCHAR (25) NULL,
    [Email]       VARCHAR (50) NULL,
    [BusPhone]    VARCHAR (10) NULL,
    [CellPhone]   VARCHAR (10) NULL,
    CONSTRAINT [PK_tblAccountExecutive] PRIMARY KEY CLUSTERED ([AcctExeID] ASC)
);

