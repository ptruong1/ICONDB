CREATE TABLE [dbo].[tblVisitOnline] (
    [RoomID]              BIGINT       NOT NULL,
    [FacilityID]          INT          NOT NULL,
    [InmateID]            VARCHAR (12) NULL,
    [InmateName]          VARCHAR (50) NULL,
    [StationID]           VARCHAR (25) NULL,
    [ApmDate]             DATETIME     NULL,
    [status]              TINYINT      NULL,
    [visitType]           TINYINT      NULL,
    [LimitTime]           INT          NULL,
    [VisitorName]         VARCHAR (50) NULL,
    [VisitorIP]           VARCHAR (25) NULL,
    [locationID]          INT          NULL,
    [RecordOpt]           CHAR (1)     NULL,
    [InmateLoginTime]     DATETIME     NULL,
    [VisitorLoginTime]    DATETIME     NULL,
    [ChatServerIP]        VARCHAR (50) NULL,
    [InmateVisitEndTime]  DATETIME     NULL,
    [VisitorVisitEndTime] DATETIME     NULL,
    CONSTRAINT [PK_tblVisitOnline] PRIMARY KEY CLUSTERED ([RoomID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [ind_ID]
    ON [dbo].[tblVisitOnline]([FacilityID] ASC, [RoomID] ASC, [ApmDate] ASC, [InmateLoginTime] ASC, [VisitorLoginTime] ASC);

