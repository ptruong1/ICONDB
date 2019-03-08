CREATE TABLE [dbo].[tblFacilityLawLib] (
    [FacilityID]    INT           NOT NULL,
    [Provider]      VARCHAR (50)  NULL,
    [ProviderPhone] VARCHAR (10)  NULL,
    [ProviderSite]  VARCHAR (120) NULL,
    [Inputdate]     DATETIME      NULL,
    [ModifyDate]    DATETIME      NULL,
    CONSTRAINT [PK_tblFacilityLawLib] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

