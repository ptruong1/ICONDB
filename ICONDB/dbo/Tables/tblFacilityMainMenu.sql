CREATE TABLE [dbo].[tblFacilityMainMenu] (
    [FacilityID]     INT NOT NULL,
    [FacilityConfig] BIT NULL,
    [UserControl]    BIT NULL,
    [PhoneConfig]    BIT NULL,
    [CallControl]    BIT NULL,
    [Debit]          BIT NULL,
    [Inmate]         BIT NULL,
    [Report]         BIT NULL,
    [CallAnalysis]   BIT NULL,
    [Message]        BIT NULL,
    [Visitation]     BIT NULL,
    [Kite]           BIT NULL,
    [ServiceRequest] BIT NULL,
    CONSTRAINT [PK_tblFacilityMainMenu] PRIMARY KEY CLUSTERED ([FacilityID] ASC)
);

