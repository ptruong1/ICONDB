CREATE TABLE [dbo].[tblVisitEnduserScheduleTemp] (
    [RoomID]           INT           NOT NULL,
    [ApmNo]            VARCHAR (15)  NOT NULL,
    [FacilityID]       INT           NOT NULL,
    [InmateID]         VARCHAR (25)  NULL,
    [InmateName]       VARCHAR (50)  NULL,
    [EndUserID]        VARCHAR (12)  NULL,
    [RequestedTime]    DATETIME      NULL,
    [RequestBy]        TINYINT       NULL,
    [ApprovedTime]     DATETIME      NULL,
    [ApprovedBy]       VARCHAR (25)  NULL,
    [ApmDate]          SMALLDATETIME NOT NULL,
    [ApmTime]          TIME (0)      NOT NULL,
    [status]           TINYINT       NOT NULL,
    [CreatedBy]        VARCHAR (25)  NULL,
    [visitType]        TINYINT       NULL,
    [LimitTime]        INT           NULL,
    [VisitorID]        INT           DEFAULT ((0)) NOT NULL,
    [StationID]        VARCHAR (25)  NULL,
    [InmateLogInID]    VARCHAR (25)  NULL,
    [VisitorLogInID]   VARCHAR (25)  NULL,
    [Note]             VARCHAR (100) NULL,
    [AlertCellPhone]   VARCHAR (10)  NULL,
    [AlertCellCarrier] VARCHAR (25)  NULL,
    [VisitDuration]    SMALLINT      NULL,
    [locationID]       INT           NULL,
    [RecordOpt]        CHAR (1)      DEFAULT ('Y') NULL,
    [Relationship]     VARCHAR (30)  NULL,
    [VisitLocationID]  INT           NULL,
    CONSTRAINT [FK_tblVisitEnduserScheduleTemp_tblFacility] FOREIGN KEY ([FacilityID]) REFERENCES [dbo].[tblFacility] ([FacilityID])
);


GO
CREATE NONCLUSTERED INDEX [ind_apm]
    ON [dbo].[tblVisitEnduserScheduleTemp]([FacilityID] ASC, [ApmDate] ASC, [ApmTime] ASC, [locationID] ASC);

