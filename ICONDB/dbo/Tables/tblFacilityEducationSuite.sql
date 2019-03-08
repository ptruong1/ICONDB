CREATE TABLE [dbo].[tblFacilityEducationSuite] (
    [FacilityID]   INT           NOT NULL,
    [Provider]     VARCHAR (50)  NULL,
    [ContactPhone] VARCHAR (10)  NULL,
    [Site]         VARCHAR (300) NULL,
    CONSTRAINT [PK_tblFacilityEducationSuite] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

