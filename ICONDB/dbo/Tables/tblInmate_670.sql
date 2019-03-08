﻿CREATE TABLE [dbo].[tblInmate_670] (
    [InmateID]          VARCHAR (12)  NOT NULL,
    [CaseID]            INT           NULL,
    [LastName]          VARCHAR (25)  NULL,
    [FirstName]         VARCHAR (25)  NULL,
    [MidName]           VARCHAR (25)  NULL,
    [Status]            TINYINT       NULL,
    [DNIRestrict]       BIT           NULL,
    [DateTimeRestrict]  BIT           NULL,
    [AccessType]        TINYINT       NULL,
    [AlertEmail]        VARCHAR (100) NULL,
    [AlertPage]         CHAR (10)     NULL,
    [AlertPhone]        CHAR (10)     NULL,
    [AlertCellPhones]   VARCHAR (100) NULL,
    [DNILimit]          TINYINT       NULL,
    [FacilityId]        INT           NOT NULL,
    [inputdate]         SMALLDATETIME NULL,
    [UserName]          VARCHAR (20)  NULL,
    [ModifyDate]        SMALLDATETIME NULL,
    [PIN]               VARCHAR (12)  NOT NULL,
    [MaxCallTime]       SMALLINT      NULL,
    [HourlyFreq]        TINYINT       NULL,
    [DailyFreq]         TINYINT       NULL,
    [WeeklyFreq]        TINYINT       NULL,
    [MonthlyFreq]       TINYINT       NULL,
    [MaxCallPerHour]    SMALLINT      NULL,
    [MaxCallPerDay]     SMALLINT      NULL,
    [MaxCallPerWeek]    SMALLINT      NULL,
    [MaxCallPerMonth]   SMALLINT      NULL,
    [DOB]               VARCHAR (12)  NULL,
    [SEX]               CHAR (1)      NULL,
    [TTY]               BIT           NULL,
    [StartDate]         DATETIME      NULL,
    [EndDate]           DATETIME      NULL,
    [DebitCardOpt]      BIT           NULL,
    [NameRecorded]      BIT           NULL,
    [AssignToDivision]  INT           NULL,
    [AssignToLocation]  INT           NULL,
    [AssignToStation]   INT           NULL,
    [BlockPeriodOfTime] BIT           NULL,
    [PANNotAllow]       BIT           NULL,
    [NotAllowLimit]     TINYINT       NULL,
    [BioRegister]       BIT           NULL,
    [ReBook]            TINYINT       NULL,
    [RebookDate]        DATETIME      NULL,
    [CustodialOpt]      BIT           NULL,
    [VisitSusStartDate] DATE          NULL,
    [VisitSusEndDate]   DATE          NULL,
    [VisitApprovedReq]  BIT           NULL,
    [AdminNote]         VARCHAR (150) NULL,
    [RaceID]            TINYINT       NULL,
    [InmateNote]        VARCHAR (200) NULL,
    [ActiveDate]        DATETIME      NULL,
    [FreeCallRemain]    TINYINT       NULL
);
