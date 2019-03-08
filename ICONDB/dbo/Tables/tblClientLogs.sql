CREATE TABLE [dbo].[tblClientLogs] (
    [ClientID]   CHAR (10)    NULL,
    [UserName]   VARCHAR (20) NULL,
    [Password]   VARCHAR (20) NULL,
    [SiteID]     INT          NULL,
    [SiteIPadd]  VARCHAR (16) NULL,
    [AcessTime]  DATETIME     NULL,
    [AccessCode] CHAR (3)     NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_client]
    ON [dbo].[tblClientLogs]([ClientID] ASC, [SiteIPadd] ASC);

