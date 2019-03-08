CREATE TABLE [dbo].[tblVisitOnlineArchive] (
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
    [VisitorVisitEndTime] DATETIME     NULL
);

