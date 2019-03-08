CREATE TABLE [dbo].[tblFacilityKiosk] (
    [FacilityID] INT          NOT NULL,
    [KioskName]  VARCHAR (15) NOT NULL,
    [KioskAlias] VARCHAR (25) NULL,
    CONSTRAINT [PK_tblFacilityKisosk] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [KioskName] ASC)
);

