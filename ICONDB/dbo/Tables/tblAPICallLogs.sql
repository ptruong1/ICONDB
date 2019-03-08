CREATE TABLE [dbo].[tblAPICallLogs] (
    [RequestID]   VARCHAR (22) NOT NULL,
    [ClientType]  VARCHAR (16) NULL,
    [SystemID]    VARCHAR (12) NULL,
    [SystemTag]   VARCHAR (12) NULL,
    [Vendor]      VARCHAR (12) NULL,
    [InmateID]    VARCHAR (12) NULL,
    [PIN]         VARCHAR (12) NULL,
    [RecordDate]  DATETIME     NULL,
    [IPaddress]   VARCHAR (16) NULL,
    [APICalltype] TINYINT      NULL,
    [Amount]      VARCHAR (10) NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_systemTag_RecordDate]
    ON [dbo].[tblAPICallLogs]([SystemTag] ASC, [RecordDate] ASC);

