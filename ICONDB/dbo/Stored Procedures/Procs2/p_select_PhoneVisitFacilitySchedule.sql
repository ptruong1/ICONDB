-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_PhoneVisitFacilitySchedule] 
	@facilityID int
	
AS
BEGIN
	
	SET NOCOUNT ON;

    Select  
    [FacilityID]
      ,[ScheduleDay]
       ,isnull([FromTime1], '') as FromTime1
      ,isnull([ToTime1], '') as ToTime1
      ,isnull([FromTime2], '') as FromTime2
      ,isnull([ToTime2], '') as ToTime2
      ,isnull([FromTime3], '') as FromTime3
      ,isnull([ToTime3], '') as ToTime3
      ,isnull([FromTime4], '') as FromTime4
      ,isnull([ToTime4], '') as ToTime4
      ,[InterApm]
      ,[UserName]
      ,[InputDate]
      ,[ModifyDate]
         
   
	FROM [leg_Icon].[dbo].[tblPhoneVisitFacilitySchedule] 
	where FacilityID = @facilityID 


END

