CREATE TABLE [dbo].[tblAlertLogs] (
    [AlertID]     BIGINT        NOT NULL,
    [ANIno]       CHAR (10)     NULL,
    [DNI]         VARCHAR (16)  NULL,
    [LocationID]  INT           NULL,
    [ALertType]   TINYINT       NULL,
    [AlertTime]   DATETIME      NULL,
    [AlertEmails] VARCHAR (200) NULL,
    [AlertCells]  VARCHAR (200) NULL,
    [AlertPhone]  CHAR (10)     NULL
);

