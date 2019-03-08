CREATE TABLE [dbo].[tblAlertANIs] (
    [ANINo]             CHAR (10)     NOT NULL,
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
    [UserName]          VARCHAR (25)  NULL,
    [WatchListID]       INT           NULL,
    [WatchListDetailID] INT           NULL,
    [AlertMessage]      VARCHAR (200) NULL,
    [StationID]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblAlertANIs] PRIMARY KEY CLUSTERED ([ANINo] ASC),
    CONSTRAINT [FK_tblAlertANIs_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);

