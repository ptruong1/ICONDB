-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_VisitLocationSchedule] 
	@facilityID int,
	@LocationID int
AS
BEGIN
	
	SET NOCOUNT ON;

    Select    A.FacilityID
      ,A.[LocationID]
      ,A.[UserName]
      ,A.[InputDate]
      ,A.[ModifyDate]
      ,[FromTime1]
      ,[ToTime1]
      ,[FromTime2]
      ,[ToTime2]
      ,[FromTime3]
      ,[ToTime3]
      ,[ScheduleDay]
      ,[InterApm]
      ,[TimeBeforeApm]
      ,[VisitType]
      ,A.[LimitTime]
      ,[FromTime4]
      ,[ToTime4]
      ,B.LocationName
      
	FROM [leg_Icon].[dbo].[tblVisitLocationSchedule] A, [leg_Icon].[dbo].[tblVisitLocation] B
	where A.FacilityID = @facilityID and 
	A.LocationID = @LocationID and
	A.LocationID = B.LocationID
END

