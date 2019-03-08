CREATE TABLE [dbo].[tblAccountRepresentative] (
    [AcctRepID]   TINYINT      NOT NULL,
    [AcctRepName] VARCHAR (25) NULL,
    [Email]       VARCHAR (30) NULL,
    [BusPhone]    VARCHAR (10) NULL,
    [CellPhone]   VARCHAR (10) NULL,
    CONSTRAINT [PK_tblAccountRepresentative] PRIMARY KEY CLUSTERED ([AcctRepID] ASC)
);

