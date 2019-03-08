CREATE TABLE [dbo].[tblUserGroupFacility] (
    [ID]                INT IDENTITY (1, 1) NOT NULL,
    [AgentID]           INT NOT NULL,
    [UserGroupID]       INT NOT NULL,
    [FacilityID]        INT NOT NULL,
    [MasterUserGroupID] INT NULL,
    CONSTRAINT [PK_tblUserGroupFacility1] PRIMARY KEY CLUSTERED ([AgentID] ASC, [UserGroupID] ASC, [FacilityID] ASC)
);

