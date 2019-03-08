CREATE TABLE [dbo].[tblInmate] (
    [InmateID]          VARCHAR (12)  NOT NULL,
    [CaseID]            INT           NULL,
    [LastName]          VARCHAR (25)  NULL,
    [FirstName]         VARCHAR (25)  NULL,
    [MidName]           VARCHAR (25)  NULL,
    [Status]            TINYINT       NULL,
    [DNIRestrict]       BIT           CONSTRAINT [DF_tblInmate_DNIRestrict] DEFAULT ((0)) NULL,
    [DateTimeRestrict]  BIT           CONSTRAINT [DF_tblInmate_DateTimeRestrict] DEFAULT ((0)) NULL,
    [AccessType]        TINYINT       NULL,
    [AlertEmail]        VARCHAR (100) NULL,
    [AlertPage]         CHAR (10)     NULL,
    [AlertPhone]        CHAR (10)     NULL,
    [AlertCellPhones]   VARCHAR (100) NULL,
    [DNILimit]          TINYINT       CONSTRAINT [DF_tblInmate_DNILimit] DEFAULT ((20)) NULL,
    [FacilityId]        INT           NOT NULL,
    [inputdate]         SMALLDATETIME CONSTRAINT [DF_tblInmate_inputdate] DEFAULT (getdate()) NULL,
    [UserName]          VARCHAR (20)  NULL,
    [ModifyDate]        SMALLDATETIME NULL,
    [PIN]               VARCHAR (12)  NOT NULL,
    [MaxCallTime]       SMALLINT      CONSTRAINT [DF_tblInmate_MaxCallTime] DEFAULT ((15)) NULL,
    [HourlyFreq]        TINYINT       CONSTRAINT [DF_tblInmate_HourlyFreq] DEFAULT ((1)) NULL,
    [DailyFreq]         TINYINT       CONSTRAINT [DF_tblInmate_DailyFreq] DEFAULT ((1)) NULL,
    [WeeklyFreq]        TINYINT       CONSTRAINT [DF_tblInmate_WeeklyFreq] DEFAULT ((1)) NULL,
    [MonthlyFreq]       TINYINT       CONSTRAINT [DF_tblInmate_MonthlyFreq] DEFAULT ((1)) NULL,
    [MaxCallPerHour]    SMALLINT      CONSTRAINT [DF__tblinmate__MaxCa__24F264BB] DEFAULT ((0)) NULL,
    [MaxCallPerDay]     SMALLINT      CONSTRAINT [DF__tblinmate__MaxCa__25E688F4] DEFAULT ((0)) NULL,
    [MaxCallPerWeek]    SMALLINT      CONSTRAINT [DF__tblinmate__MaxCa__26DAAD2D] DEFAULT ((0)) NULL,
    [MaxCallPerMonth]   SMALLINT      CONSTRAINT [DF__tblinmate__MaxCa__27CED166] DEFAULT ((0)) NULL,
    [DOB]               VARCHAR (12)  NULL,
    [SEX]               CHAR (1)      NULL,
    [TTY]               BIT           CONSTRAINT [DF__tblInmate__TTY__6B4FD30B] DEFAULT ((0)) NULL,
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
    [BioRegister]       BIT           DEFAULT ((0)) NULL,
    [ReBook]            TINYINT       DEFAULT ((0)) NULL,
    [RebookDate]        DATETIME      NULL,
    [CustodialOpt]      BIT           DEFAULT ((0)) NULL,
    [VisitSusStartDate] DATE          NULL,
    [VisitSusEndDate]   DATE          NULL,
    [VisitApprovedReq]  BIT           NULL,
    [AdminNote]         VARCHAR (150) NULL,
    [RaceID]            TINYINT       NULL,
    [InmateNote]        VARCHAR (200) NULL,
    [ActiveDate]        DATETIME      NULL,
    [FreeCallRemain]    TINYINT       DEFAULT ((0)) NULL,
    [PrimaryLanguage]   TINYINT       DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblInmate1] PRIMARY KEY CLUSTERED ([InmateID] ASC, [FacilityId] ASC, [PIN] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_PIN]
    ON [dbo].[tblInmate]([FacilityId] ASC, [PIN] ASC, [Status] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_name]
    ON [dbo].[tblInmate]([LastName] ASC, [FirstName] ASC, [Status] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_inmateID]
    ON [dbo].[tblInmate]([InmateID] ASC, [FacilityId] ASC);

