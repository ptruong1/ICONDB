CREATE TABLE [dbo].[tblTabletDivisionSchedule] (
    [FacilityID]  INT          NOT NULL,
    [CenterID]    INT          NOT NULL,
    [ScheduleDay] TINYINT      NOT NULL,
    [FromTime1]   VARCHAR (5)  NULL,
    [ToTime1]     VARCHAR (5)  NULL,
    [FromTime2]   VARCHAR (5)  NULL,
    [ToTime2]     VARCHAR (5)  NULL,
    [FromTime3]   VARCHAR (5)  NULL,
    [ToTime3]     VARCHAR (5)  NULL,
    [FromTime4]   VARCHAR (5)  NULL,
    [ToTime4]     VARCHAR (5)  NULL,
    [UserName]    VARCHAR (25) NULL,
    [InputDate]   DATETIME     NULL,
    [ModifyDate]  DATETIME     NULL,
    CONSTRAINT [PK_tblTabletDivisionSchedule] PRIMARY KEY CLUSTERED ([FacilityID] ASC, [CenterID] ASC, [ScheduleDay] ASC)
);

