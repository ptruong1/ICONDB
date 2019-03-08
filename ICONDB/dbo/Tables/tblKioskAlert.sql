CREATE TABLE [dbo].[tblKioskAlert] (
    [FacilityID]   INT          NOT NULL,
    [ComputerName] VARCHAR (20) NOT NULL,
    [AlertDate]    DATETIME     NOT NULL,
    [UserPic]      VARCHAR (20) NULL,
    [PublicIP]     VARCHAR (16) NULL,
    [LocalIP]      VARCHAR (16) NULL
);

