﻿CREATE TABLE [dbo].[tblAlertPINs] (
    [PIN]               VARCHAR (12)  NOT NULL,
    [FacilityID]        INT           NOT NULL,
    [AlertEmails]       VARCHAR (200) NULL,
    [AlertCellPhones]   VARCHAR (200) NULL,
    [AlertRegPhone]     CHAR (10)     NULL,
    [HourlyFreq]        TINYINT       NULL,
    [DailyFreq]         TINYINT       NULL,
    [WeeklyFreq]        TINYINT       NULL,
    [MonthlyFreq]       TINYINT       NULL,
    [InputDate]         SMALLDATETIME NULL,
    [ModifyDate]        SMALLDATETIME NULL,
    [WatchListID]       INT           NULL,
    [WatchListDetailID] INT           NOT NULL,
    [AlertMessage]      VARCHAR (200) NULL,
    CONSTRAINT [PK_tblAlertPINs] PRIMARY KEY CLUSTERED ([PIN] ASC, [FacilityID] ASC, [WatchListDetailID] ASC)
);

