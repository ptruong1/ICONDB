CREATE TABLE [dbo].[tblVisitLocationSchedule] (
    [FacilityID]    INT          NOT NULL,
    [LocationID]    INT          NOT NULL,
    [UserName]      VARCHAR (25) NULL,
    [InputDate]     DATETIME     NULL,
    [ModifyDate]    DATETIME     NULL,
    [FromTime1]     VARCHAR (5)  NULL,
    [ToTime1]       VARCHAR (5)  NULL,
    [FromTime2]     VARCHAR (5)  NULL,
    [ToTime2]       VARCHAR (5)  NULL,
    [FromTime3]     VARCHAR (5)  NULL,
    [ToTime3]       VARCHAR (5)  NULL,
    [ScheduleDay]   TINYINT      NOT NULL,
    [InterApm]      INT          NULL,
    [TimeBeforeApm] SMALLINT     NULL,
    [VisitType]     TINYINT      NOT NULL,
    [LimitTime]     SMALLINT     NULL,
    [FromTime4]     VARCHAR (5)  NULL,
    [ToTime4]       VARCHAR (5)  NULL,
    CONSTRAINT [PK_tblVisitLocationSchedule] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [LocationID] ASC, [ScheduleDay] ASC, [VisitType] ASC)
);

