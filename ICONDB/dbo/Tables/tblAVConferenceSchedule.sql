CREATE TABLE [dbo].[tblAVConferenceSchedule] (
    [FacilityID]    INT           NOT NULL,
    [InmateID]      INT           NOT NULL,
    [PIN]           VARCHAR (12)  NOT NULL,
    [FirstName]     VARCHAR (20)  NULL,
    [LastName]      VARCHAR (50)  NULL,
    [VisitorFName]  VARCHAR (20)  NOT NULL,
    [VisitorLName]  VARCHAR (50)  NOT NULL,
    [ScheduledDate] SMALLDATETIME NOT NULL,
    [VisitDuration] TINYINT       NOT NULL,
    [FromTime]      VARCHAR (5)   NOT NULL,
    [ToTime]        VARCHAR (5)   NOT NULL,
    [BoothAssigned] VARCHAR (20)  NULL,
    [inputdate]     SMALLDATETIME NULL,
    [modifydate]    SMALLDATETIME NULL,
    [userName]      VARCHAR (20)  NULL,
    [Status]        BIT           NULL,
    [Relationship]  VARCHAR (50)  NULL,
    [VisitType]     TINYINT       NULL,
    [VisitBillType] TINYINT       NULL,
    [ID]            INT           NOT NULL
);

