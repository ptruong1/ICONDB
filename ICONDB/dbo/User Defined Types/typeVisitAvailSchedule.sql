CREATE TYPE [dbo].[typeVisitAvailSchedule] AS TABLE (
    [facilityID]   INT           NULL,
    [ScheduleDate] SMALLDATETIME NULL,
    [ScheduleTime] TIME (0)      NULL,
    [CurrentApm]   SMALLINT      NULL);

