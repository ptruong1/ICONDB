CREATE TABLE [dbo].[tblFacilityCommissary] (
    [FacilityID] INT           NOT NULL,
    [CommVendor] VARCHAR (25)  NULL,
    [CommPhone]  VARCHAR (10)  NULL,
    [CommSite]   VARCHAR (120) NULL,
    [Inputdate]  DATETIME      NULL,
    [ModifyDate] DATETIME      NULL,
    [KioskID]    VARCHAR (15)  NOT NULL,
    CONSTRAINT [PK_tblFacilityCommissary] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [KioskID] ASC)
);

