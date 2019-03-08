CREATE TABLE [dbo].[tblFacilityACP] (
    [FacilityID] INT          NOT NULL,
    [agentID]    INT          NULL,
    [UserName]   VARCHAR (23) NULL,
    [tableName]  VARCHAR (14) NOT NULL,
    CONSTRAINT [PK_tblFacilityACP] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

