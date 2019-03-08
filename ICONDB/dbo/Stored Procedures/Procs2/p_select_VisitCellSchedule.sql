-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_VisitCellSchedule] 
	@facilityID int,
	@ExtID varchar(15)
	
AS
BEGIN
	
	SET NOCOUNT ON;

    Select       *
	FROM [leg_Icon].[dbo].[tblVisitCellSchedule] 
	where FacilityID = @facilityID and 
	ExtID = @ExtID
	
END

