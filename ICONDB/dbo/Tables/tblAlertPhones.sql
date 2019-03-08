CREATE TABLE [dbo].[tblAlertPhones] (
    [PhoneNo]           VARCHAR (16)  NOT NULL,
    [FacilityID]        INT           NOT NULL,
    [LastName]          VARCHAR (25)  NULL,
    [FirstName]         VARCHAR (25)  NULL,
    [UserName]          VARCHAR (25)  NOT NULL,
    [AlertEmails]       VARCHAR (200) NULL,
    [AlertCellPhones]   VARCHAR (200) NULL,
    [AlertRegPhone]     CHAR (10)     NULL,
    [HourlyFreq]        TINYINT       CONSTRAINT [DF_tblAlertPhones_HourlyFreq] DEFAULT ((0)) NULL,
    [DailyFreq]         TINYINT       CONSTRAINT [DF_tblAlertPhones_DailyFreq] DEFAULT ((0)) NULL,
    [WeeklyFreq]        TINYINT       CONSTRAINT [DF_tblAlertPhones_WeeklyFreq] DEFAULT ((0)) NULL,
    [MonthlyFreq]       TINYINT       CONSTRAINT [DF_tblAlertPhones_MonthlyFreq] DEFAULT ((0)) NULL,
    [InputDate]         SMALLDATETIME CONSTRAINT [DF_tblAlertPhones_InputDate] DEFAULT (getdate()) NULL,
    [ModifyDate]        SMALLDATETIME NULL,
    [WatchListID]       INT           NULL,
    [WatchListDetailID] INT           NULL,
    [AlertMessage]      VARCHAR (200) NULL,
    CONSTRAINT [PK_tblAlertPhones] PRIMARY KEY CLUSTERED ([PhoneNo] ASC, [FacilityID] ASC, [UserName] ASC),
    CONSTRAINT [FK_tblAlertPhones_tblWatchList] FOREIGN KEY ([WatchListDetailID]) REFERENCES [dbo].[tblWatchList] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [ind_watchList]
    ON [dbo].[tblAlertPhones]([WatchListID] ASC, [WatchListDetailID] ASC);

