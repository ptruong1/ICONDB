CREATE TABLE [dbo].[tblVisitGenderSchedule] (
    [FacilityID]    INT          NOT NULL,
    [Gender]        VARCHAR (1)  NOT NULL,
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
    [WeekInd]       TINYINT      NULL
);


GO
CREATE NONCLUSTERED INDEX [ind_facility_gen]
    ON [dbo].[tblVisitGenderSchedule]([FacilityID] ASC, [Gender] ASC, [ScheduleDay] ASC);

