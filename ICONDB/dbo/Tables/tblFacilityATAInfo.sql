CREATE TABLE [dbo].[tblFacilityATAInfo] (
    [FacilityID]    INT           NOT NULL,
    [AgentID]       INT           CONSTRAINT [DF_tblFacilityATAInfo_AgentID] DEFAULT (1) NOT NULL,
    [ATAIP]         VARCHAR (16)  NOT NULL,
    [ATAgateway]    VARCHAR (16)  NULL,
    [ATASubnet]     VARCHAR (16)  NULL,
    [PriDNS]        VARCHAR (16)  NULL,
    [SecDNS]        VARCHAR (16)  NULL,
    [ProviderName]  VARCHAR (150) NULL,
    [ProviderEmail] VARCHAR (40)  NULL,
    [ProviderPhone] VARCHAR (10)  NULL,
    [ATAModel]      VARCHAR (50)  NULL,
    [ATALocation]   VARCHAR (50)  NULL,
    [TechSupportID] INT           NULL,
    [status]        TINYINT       CONSTRAINT [DF_tblFacilityATAInfo_status] DEFAULT (1) NULL,
    [AlertID]       SMALLINT      CONSTRAINT [DF_tblFacilityATAInfo_AlertID] DEFAULT (1) NULL,
    [routeID]       SMALLINT      NULL,
    CONSTRAINT [PK_tblFacilityATAInfo] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [ATAIP] ASC),
    CONSTRAINT [FK_tblFacilityATAInfo_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

