-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_VisitFacilitySchedule] 
	@facilityID int
	
AS
BEGIN
	
	SET NOCOUNT ON;

    Select       *
	FROM [leg_Icon].[dbo].[tblVisitFacilitySchedule] 
	where FacilityID = @facilityID 

END

