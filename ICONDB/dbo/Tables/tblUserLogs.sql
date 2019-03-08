CREATE TABLE [dbo].[tblUserLogs] (
    [LoginID]    BIGINT       NOT NULL,
    [userName]   VARCHAR (20) NULL,
    [password]   VARCHAR (20) NULL,
    [IpAddess]   VARCHAR (16) NULL,
    [LoginTime]  DATETIME     NULL,
    [logoutTime] DATETIME     NULL,
    CONSTRAINT [PK_tblUserLogs] PRIMARY KEY CLUSTERED ([LoginID] ASC)
);

