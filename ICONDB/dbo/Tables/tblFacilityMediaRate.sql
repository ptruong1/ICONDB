CREATE TABLE [dbo].[tblFacilityMediaRate] (
    [FacilityID]         INT            NOT NULL,
    [RentalRatePerDay]   NUMERIC (4, 2) NULL,
    [RentalRatePerWeek]  NUMERIC (4, 2) NULL,
    [RentalRatePerMonth] NUMERIC (4, 2) NULL,
    [OneTimeCharge]      NUMERIC (4, 2) NULL,
    [InputDate]          DATETIME       NULL,
    [ModifyDate]         DATETIME       NULL,
    [UserName]           VARCHAR (25)   NULL,
    CONSTRAINT [PK_tblFacilityMediaRate] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

