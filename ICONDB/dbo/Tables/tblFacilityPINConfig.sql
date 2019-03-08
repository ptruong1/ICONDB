CREATE TABLE [dbo].[tblFacilityPINConfig] (
    [FacilityID]          INT     NOT NULL,
    [PINLen]              TINYINT NULL,
    [PINType]             TINYINT NULL,
    [IniFreeCall]         TINYINT NULL,
    [IniFreeCallDuration] TINYINT NULL,
    CONSTRAINT [PK_tblFacilityPINConfig] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

