CREATE TABLE [dbo].[tblAuthInmateTab] (
    [AuthID]           BIGINT NOT NULL,
    [RegisterInmate]   BIT    CONSTRAINT [DF_tblAuthInmateTab_RegisterInmate] DEFAULT ((1)) NULL,
    [ListInmate]       BIT    CONSTRAINT [DF_tblAuthInmateTab_ListInmate] DEFAULT ((1)) NULL,
    [SearchInmate]     BIT    CONSTRAINT [DF_tblAuthInmateTab_SearchInmate] DEFAULT ((1)) NULL,
    [InmateSuspended]  BIT    NULL,
    [InmateActivity]   BIT    NULL,
    [InmateSuspicious] BIT    NULL,
    CONSTRAINT [PK_tblAuthInmateTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

