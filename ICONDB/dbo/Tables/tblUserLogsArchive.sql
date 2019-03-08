CREATE TABLE [dbo].[tblUserLogsArchive] (
    [LoginID]    BIGINT       NOT NULL,
    [userName]   VARCHAR (20) NULL,
    [password]   VARCHAR (20) NULL,
    [IpAddess]   VARCHAR (16) NULL,
    [LoginTime]  DATETIME     NULL,
    [logoutTime] DATETIME     NULL,
    CONSTRAINT [PK_tblUserLogsArchive] PRIMARY KEY CLUSTERED ([LoginID] ASC)
);

