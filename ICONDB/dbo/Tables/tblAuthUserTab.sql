CREATE TABLE [dbo].[tblAuthUserTab] (
    [AuthID]          BIGINT NOT NULL,
    [CreateUser]      BIT    CONSTRAINT [DF_tblAuthUserTab_CreateUser] DEFAULT ((1)) NULL,
    [ListUser]        BIT    CONSTRAINT [DF_tblAuthUserTab_ListUser] DEFAULT ((1)) NULL,
    [SearchUser]      BIT    CONSTRAINT [DF_tblAuthUserTab_SearchUser] DEFAULT ((1)) NULL,
    [ActivityUser]    BIT    CONSTRAINT [DF_tblAuthUserTab_ActivityUser] DEFAULT ((1)) NULL,
    [OfficerActivity] BIT    CONSTRAINT [DF_tblAuthUserTab_OfficerActivity] DEFAULT ((1)) NULL,
    [OnlineUsers]     BIT    NULL,
    [UserGroups]      BIT    NULL,
    [UserRoles]       BIT    NULL,
    CONSTRAINT [PK_tblAuthUserTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

