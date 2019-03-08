﻿CREATE TABLE [dbo].[tblAuthUsers_backUp1] (
    [AuthID]          INT          NOT NULL,
    [FacilityConfig]  BIT          NULL,
    [UserControl]     BIT          NULL,
    [PhoneConfig]     BIT          NULL,
    [CallControl]     BIT          NULL,
    [DebitCard]       BIT          NULL,
    [InmateProfile]   BIT          NULL,
    [Report]          BIT          NULL,
    [CallMonitor]     BIT          NULL,
    [Messaging]       BIT          NULL,
    [VideoVisit]      BIT          NULL,
    [ServiceRequest]  BIT          NULL,
    [Admin]           BIT          NULL,
    [PowerUser]       BIT          NULL,
    [Finance-Auditor] BIT          NULL,
    [Investigator]    BIT          NULL,
    [DataEntry]       BIT          NULL,
    [UserDefine]      BIT          NULL,
    [InputDate]       DATETIME     NULL,
    [ModifyDate]      DATETIME     NULL,
    [MyReport]        BIT          NULL,
    [ModifyBy]        VARCHAR (25) NULL,
    [Kites]           BIT          NULL
);

