CREATE TABLE [dbo].[tblAuthFacilityTab] (
    [AuthID]               BIGINT NOT NULL,
    [Config]               BIT    CONSTRAINT [DF_tblUserFacilityTabAuth_Config] DEFAULT ((1)) NULL,
    [Schedule]             BIT    CONSTRAINT [DF_tblUserFacilityTabAuth_Schedule] DEFAULT ((1)) NULL,
    [Layout]               BIT    NULL,
    [VideoVisitLayout]     BIT    NULL,
    [VideoVisitSchedule]   BIT    NULL,
    [PhoneVisitLayout]     BIT    NULL,
    [PhoneVisitSchedule]   BIT    NULL,
    [GeneralInfo]          BIT    NULL,
    [MobileDeviceLayout]   BIT    NULL,
    [MobileDeviceSchedule] BIT    NULL,
    [MultiFacility]        BIT    NULL,
    CONSTRAINT [PK_tblUserFacilityTabAuth] PRIMARY KEY CLUSTERED ([AuthID] ASC)
);

