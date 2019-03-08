-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[p_select_available_appointment_by_facility1]
	@facilityID	int,
	@locationID int,
	@InmateID	varchar(12),
	@scheduleDate	smalldatetime,
	@VisitorID	int	
AS
SET NOCOUNT ON;

---- Current user
BEGIN
	If (@facilityID = 607) --- only dona use this one
		exec p_select_available_appointment_by_admin @facilityID, @locationID, 	@InmateID, 	@scheduleDate, 	@VisitorID;
	else
		--exec p_select_available_appointment_140604 @facilityID, @locationID, 	@InmateID, 	@scheduleDate, 	@VisitorID
		exec p_select_available_appointment_by_admin_v2 @facilityID, @locationID, 	@InmateID, 	@scheduleDate, 	@VisitorID;
END

