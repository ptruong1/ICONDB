CREATE TABLE [dbo].[tblUserRole] (
    [FacilityID]     INT          NOT NULL,
    [RoleID]         TINYINT      NOT NULL,
    [RoleDescript]   VARCHAR (25) NOT NULL,
    [FacilityConfig] BIT          NULL,
    [UserControl]    BIT          NULL,
    [PhoneConfig]    BIT          NULL,
    [CallControl]    BIT          NULL,
    [DebitCard]      BIT          NULL,
    [InmateProfile]  BIT          NULL,
    [Report]         BIT          NULL,
    [CallMonitor]    BIT          NULL,
    [Messaging]      BIT          NULL,
    [VideoVisit]     BIT          NULL,
    [ServiceRequest] BIT          NULL,
    [MyReport]       BIT          NULL,
    [Form]           BIT          NULL,
    [RoleAuthID]     INT          NULL,
    CONSTRAINT [PK_tblUserRole] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [RoleID] ASC)
);

