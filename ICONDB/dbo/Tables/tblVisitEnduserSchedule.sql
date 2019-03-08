CREATE TABLE [dbo].[tblVisitEnduserSchedule] (
    [ApmNo]            VARCHAR (15)   NOT NULL,
    [FacilityID]       INT            NOT NULL,
    [InmateID]         VARCHAR (12)   NULL,
    [InmateName]       VARCHAR (50)   NULL,
    [EndUserID]        VARCHAR (12)   NULL,
    [RequestedTime]    DATETIME       NULL,
    [RequestBy]        TINYINT        NULL,
    [ApprovedTime]     DATETIME       NULL,
    [ApprovedBy]       VARCHAR (25)   NULL,
    [ApmDate]          SMALLDATETIME  NOT NULL,
    [ApmTime]          TIME (0)       NOT NULL,
    [status]           TINYINT        NOT NULL,
    [CreatedBy]        VARCHAR (25)   NULL,
    [visitType]        TINYINT        NULL,
    [LimitTime]        INT            NULL,
    [VisitorID]        INT            NOT NULL,
    [StationID]        VARCHAR (25)   NULL,
    [InmateLogInID]    VARCHAR (25)   NULL,
    [VisitorLogInID]   VARCHAR (25)   NULL,
    [Note]             VARCHAR (100)  NULL,
    [AlertCellPhone]   VARCHAR (10)   NULL,
    [AlertCellCarrier] VARCHAR (25)   NULL,
    [VisitDuration]    SMALLINT       NULL,
    [locationID]       INT            NULL,
    [TotalCharge]      NUMERIC (5, 2) NULL,
    [RecordStatus]     TINYINT        NULL,
    [ChatServerIP]     VARCHAR (50)   NULL,
    [RecordOpt]        CHAR (1)       DEFAULT ('Y') NULL,
    [Relationship]     VARCHAR (30)   NULL,
    [RoomID]           INT            NOT NULL,
    [CancelBy]         VARCHAR (25)   NULL,
    [SendJMS]          TINYINT        DEFAULT ((0)) NULL,
    [CancelDate]       DATETIME       NULL,
    [AdjustedDate]     DATETIME       NULL,
    [VisitLocationID]  INT            NULL,
    CONSTRAINT [PK_tblVisitEnduserSchedule] PRIMARY KEY CLUSTERED ([RoomID] ASC),
    CONSTRAINT [FK_tblVisitEnduserSchedule_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID]),
    CONSTRAINT [FK_tblVisitEnduserSchedule_tblstatus] FOREIGN KEY ([status]) REFERENCES [dbo].[tblVisitStatus] ([StatusID]),
    CONSTRAINT [FK_tblVisitEnduserSchedule_tblVisitStatus] FOREIGN KEY ([status]) REFERENCES [dbo].[tblVisitStatus] ([StatusID])
);


GO
CREATE NONCLUSTERED INDEX [Ind_ApmNo]
    ON [dbo].[tblVisitEnduserSchedule]([ApmNo] ASC, [status] ASC);


GO
CREATE NONCLUSTERED INDEX [ind_datetime]
    ON [dbo].[tblVisitEnduserSchedule]([FacilityID] ASC, [ApmDate] ASC, [locationID] ASC, [ApmTime] ASC, [status] ASC);

