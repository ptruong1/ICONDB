CREATE TABLE [dbo].[tblInmateStatus] (
    [statusID] TINYINT      NOT NULL,
    [Descipt]  VARCHAR (50) NULL,
    CONSTRAINT [PK_tblInmateStatus] PRIMARY KEY CLUSTERED ([statusID] ASC)
);

