CREATE TABLE [dbo].[tblAuthServiceRequestTab] (
    [AuthID]               BIGINT NOT NULL,
    [CreateServiceRequest] BIT    CONSTRAINT [DF_tblAuthServiceRequestTab_CreateServiceRequest] DEFAULT ((1)) NULL,
    [SearchServiceRequest] BIT    NULL,
    [InmateIncidentReport] BIT    CONSTRAINT [DF_tblAuthServiceRequestTab_InmateIncidentReport] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblAuthServiceRequestTab] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

