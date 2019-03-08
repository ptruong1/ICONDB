
CREATE PROCEDURE [dbo].[p_select_userrole]
(
	
	@RoleDescript varchar(25)
)
AS
	SET NOCOUNT ON;
	SELECT FacilityConfig, UserControl, PhoneConfig, CallControl, DebitCard, InmateProfile, Report, CallMonitor, Messaging, VideoVisit, ServiceRequest
	From tblUserRole      
	where RoleDescript = @RoleDescript
	--RoleDescript = @RoleDescript
	--RoleID =@RoleID
