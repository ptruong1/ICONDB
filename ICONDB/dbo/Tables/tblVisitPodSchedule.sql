CREATE TABLE [dbo].[tblVisitPodSchedule] (
    [FacilityID]    INT          NOT NULL,
    [PodID]         VARCHAR (15) NOT NULL,
    [UserName]      VARCHAR (25) NULL,
    [InputDate]     DATETIME     NULL,
    [ModifyDate]    DATETIME     NULL,
    [FromTime1]     VARCHAR (5)  NULL,
    [ToTime1]       VARCHAR (5)  NULL,
    [FromTime2]     VARCHAR (5)  NULL,
    [ToTime2]       VARCHAR (5)  NULL,
    [FromTime3]     VARCHAR (5)  NULL,
    [ToTime3]       VARCHAR (5)  NULL,
    [FromTime4]     VARCHAR (5)  NULL,
    [ToTime4]       VARCHAR (5)  NULL,
    [ScheduleDay]   TINYINT      NOT NULL,
    [InterApm]      INT          NULL,
    [TimeBeforeApm] SMALLINT     NULL,
    [VisitType]     TINYINT      NOT NULL,
    [LimitTime]     SMALLINT     NULL,
    [LocationID]    INT          NULL,
    [WeekInd]       TINYINT      NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_pod]
    ON [dbo].[tblVisitPodSchedule]([FacilityID] ASC, [PodID] ASC, [ScheduleDay] ASC, [VisitType] ASC, [WeekInd] ASC);

