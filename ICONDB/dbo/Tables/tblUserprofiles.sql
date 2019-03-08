CREATE TABLE [dbo].[tblUserprofiles] (
    [UserID]            VARCHAR (20)    NOT NULL,
    [Password]          VARCHAR (20)    NOT NULL,
    [FacilityID]        INT             NULL,
    [AgentID]           INT             NULL,
    [LastName]          VARCHAR (25)    NULL,
    [FirstName]         VARCHAR (20)    NULL,
    [MidName]           VARCHAR (15)    NULL,
    [Department]        VARCHAR (25)    NULL,
    [authID]            INT             NOT NULL,
    [Phone]             NCHAR (10)      NULL,
    [Email]             VARCHAR (50)    NULL,
    [inputdate]         SMALLDATETIME   CONSTRAINT [DF_tblUserprofiles_inputdate] DEFAULT (getdate()) NULL,
    [CreatedBy]         VARCHAR (20)    NULL,
    [UserLevel]         TINYINT         NULL,
    [Status]            TINYINT         CONSTRAINT [DF_tblUserprofiles_Status] DEFAULT ((1)) NULL,
    [IPaddress]         VARCHAR (16)    NULL,
    [modifyDate]        DATETIME        NULL,
    [modifyBy]          VARCHAR (25)    NULL,
    [ExpiredDate]       SMALLDATETIME   NULL,
    [ID]                INT             NULL,
    [UserIDDEC]         VARBINARY (200) NULL,
    [PasswordDEC]       VARBINARY (200) NULL,
    [IPrequired]        BIT             NULL,
    [SecondFactor]      BIT             NULL,
    [UserGroupID]       INT             NULL,
    [MasterUserGroupID] INT             NULL,
    [RoleID]            TINYINT         NULL,
    CONSTRAINT [PK_tblUserprofiles] PRIMARY KEY CLUSTERED ([UserID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_user]
    ON [dbo].[tblUserprofiles]([UserIDDEC] ASC, [PasswordDEC] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_user_facility]
    ON [dbo].[tblUserprofiles]([UserID] ASC, [PasswordDEC] ASC);

