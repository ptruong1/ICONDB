CREATE TABLE [dbo].[tblAlertLocations] (
    [LocationID]        INT           NOT NULL,
    [AlertEmails]       VARCHAR (200) NULL,
    [AlertCellPhones]   VARCHAR (200) NULL,
    [AlertRegPhone]     CHAR (10)     NULL,
    [HourlyFreq]        TINYINT       NULL,
    [DailyFreq]         TINYINT       NULL,
    [WeeklyFreq]        TINYINT       NULL,
    [MonthlyFreq]       TINYINT       NULL,
    [InputDate]         SMALLDATETIME NULL,
    [ModifyDate]        SMALLDATETIME NULL,
    [userName]          VARCHAR (25)  NULL,
    [WatchListID]       INT           NULL,
    [WatchListDetailID] INT           NULL,
    CONSTRAINT [PK_tblAlertLocations] PRIMARY KEY CLUSTERED ([LocationID] ASC)
);

