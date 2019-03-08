CREATE TABLE [dbo].[tblUserGroup] (
    [UserGroupID]   INT          NOT NULL,
    [UserGroupName] VARCHAR (30) NULL,
    [Descript]      VARCHAR (50) NULL,
    CONSTRAINT [PK_tblUserGroup] PRIMARY KEY CLUSTERED ([UserGroupID] ASC)
);

