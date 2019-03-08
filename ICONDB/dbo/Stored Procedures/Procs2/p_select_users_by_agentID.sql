
CREATE PROCEDURE [dbo].[p_select_users_by_agentID]
(
	@AgentID int
)
AS
	SET NOCOUNT ON;
SELECT        tblUserprofiles.UserID, tblUserprofiles.LastName, tblStatus.Descrip as Status, FacilityConfig, UserControl, PhoneConfig, CallControl, DebitCard, InmateProfile, Report, CallMonitor, Messaging, VideoVisit, ServiceRequest
FROM            tblUserprofiles  with(nolock)

	  INNER JOIN
                         tblAuthUsers   with(nolock) ON tblUserprofiles.authID = tblAuthUsers.AuthID
	 INNER JOIN
		tblStatus   with(nolock) ON tblUserprofiles.Status = tblStatus.StatusID
		
WHERE AgentID = @AgentID
ORDER BY tblUserprofiles.inputdate DESC
