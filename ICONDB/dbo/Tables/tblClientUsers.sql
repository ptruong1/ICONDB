CREATE TABLE [dbo].[tblClientUsers] (
    [clientID]   VARCHAR (10) NOT NULL,
    [siteIP]     VARCHAR (15) NULL,
    [siteID]     INT          NOT NULL,
    [userName]   VARCHAR (25) NULL,
    [password]   VARCHAR (25) NULL,
    [userLevel]  TINYINT      NULL,
    [inputdate]  DATETIME     NULL,
    [modifydate] DATETIME     NULL,
    CONSTRAINT [PK_tblClientUsers] PRIMARY KEY CLUSTERED ([clientID] ASC, [siteID] ASC)
);

