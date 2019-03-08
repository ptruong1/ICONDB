CREATE TABLE [dbo].[tblKioskActivity] (
    [ActID]      BIGINT       NOT NULL,
    [DeviceName] VARCHAR (20) NOT NULL,
    [ActType]    TINYINT      NULL,
    [ActTime]    DATETIME     NULL,
    [FacilityID] INT          NULL,
    [InmateID]   VARCHAR (12) NULL
);

