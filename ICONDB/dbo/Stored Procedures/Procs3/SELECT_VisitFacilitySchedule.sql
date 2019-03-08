-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_VisitFacilitySchedule] 
	@facilityID int,
	@LocationID int
AS
BEGIN
	
	SET NOCOUNT ON;

    Select       *
	FROM [leg_Icon].[dbo].[tblVisitFacilitySchedule] 
	where FacilityID = @facilityID and 
	LocationID = @LocationID
END

