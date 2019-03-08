CREATE TABLE [dbo].[tblVisitRequest] (
    [RequestID]     INT          NOT NULL,
    [FacilityID]    INT          NOT NULL,
    [InmateID]      VARCHAR (12) NOT NULL,
    [VisitorID]     INT          NOT NULL,
    [RequestDate]   DATETIME     NULL,
    [RequestStatus] TINYINT      NULL,
    [ReplyDate]     DATETIME     NULL,
    CONSTRAINT [PK_tblVisitRequest] PRIMARY KEY CLUSTERED ([RequestID] ASC)
);

