-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_determine_inmate_visit_per_week]
(
	@facilityID int,
	@InmateID varchar(12),
	@scheduleDate smalldatetime,
	@VisitPerWeek smallint
)
RETURNS tinyint
AS
BEGIN
	IF ( (select COUNT(*) from tblVisitEnduserScheduleTemp with(nolock) where FacilityID = @facilityID and InmateID = @InmateID and ApmDate = @scheduleDate) + (select  COUNT(*) from tblVisitEnduserSchedule where FacilityID =@facilityID  and  DATEPART(wk,ApmDate) =DATEPART(wk,@scheduleDate) and InmateID =@InmateID and [status] in(1,2,3,5,8)) >= @visitPerWeek )
	 begin
		RETURN 0;
	 end
	 
	RETURN  1;
	
END
