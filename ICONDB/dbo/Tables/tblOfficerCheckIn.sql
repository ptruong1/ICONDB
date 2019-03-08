CREATE TABLE [dbo].[tblOfficerCheckIn] (
    [RecordID]      BIGINT       NOT NULL,
    [FacilityID]    INT          NOT NULL,
    [ANI]           CHAR (10)    NOT NULL,
    [BadgeID]       VARCHAR (12) NOT NULL,
    [RecordDate]    DATETIME     NOT NULL,
    [RecordName]    VARCHAR (20) NULL,
    [CheckInStatus] TINYINT      NULL,
    [ServerIP]      VARCHAR (17) NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_facility_badgeID]
    ON [dbo].[tblOfficerCheckIn]([FacilityID] ASC, [BadgeID] ASC, [RecordDate] ASC);

