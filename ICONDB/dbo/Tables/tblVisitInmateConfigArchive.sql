CREATE TABLE [dbo].[tblVisitInmateConfigArchive] (
    [InmateID]      VARCHAR (12)  NOT NULL,
    [FacilityID]    INT           NOT NULL,
    [ApprovedReq]   BIT           NOT NULL,
    [AtLocation]    VARCHAR (30)  NULL,
    [ExtID]         VARCHAR (12)  NULL,
    [SusStartDate]  DATE          NULL,
    [SusEndDate]    DATE          NULL,
    [PAV]           BIT           NULL,
    [MaxVisitor]    TINYINT       NULL,
    [VisitPerDay]   TINYINT       NULL,
    [VisitPerWeek]  TINYINT       NULL,
    [VisitPerMonth] TINYINT       NULL,
    [LocationID]    INT           NULL,
    [MaxVisitTime]  SMALLINT      NULL,
    [InputDate]     SMALLDATETIME NULL,
    [ModifyDate]    SMALLDATETIME NULL,
    [VNote]         VARCHAR (150) NULL,
    [VisitRemain]   SMALLINT      NULL
);

