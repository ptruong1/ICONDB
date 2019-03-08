-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_VisitFacilitySchedule_v1] 
	@facilityID int
	
AS
BEGIN
	
	SET NOCOUNT ON;

    Select     
      [FacilityID]
      ,[UserName]
      ,[InputDate]
      ,[ModifyDate]
      ,[LimitTime]
      ,isnull([FromTime1], '') as FromTime1
      ,isnull([ToTime1], '') as ToTime1
      ,isnull([FromTime2], '') as FromTime2
      ,isnull([ToTime2], '') as ToTime2
      ,isnull([FromTime3], '') as FromTime3
      ,isnull([ToTime3], '') as ToTime3
      ,isnull([FromTime4], '') as FromTime4
      ,isnull([ToTime4], '') as ToTime4
      ,[ScheduleDay]
      ,[LocationID]
      ,[InterApm]
      ,[TimeBeforeApm]
      ,[FvisitType]
      ,[PriFromTime]
      ,[PriToTime]
      ,[PriLimitTime]
	FROM [leg_Icon].[dbo].[tblVisitFacilitySchedule] 
	where FacilityID = @facilityID 


END

