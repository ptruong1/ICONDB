


CREATE PROCEDURE [dbo].[SELECT_UsersByAgentID]
(
	@AgentID int
)
AS
	SET NOCOUNT ON;
SELECT        tblUserprofiles.UserID, tblUserprofiles.LastName, tblUserprofiles.FirstName, tblAuth.admin, tblAuth.monitor, tblAuth.finance, tblAuth.dataEntry
FROM            tblUserprofiles  with(nolock)  INNER JOIN
                         tblAuth   with(nolock) ON tblUserprofiles.authID = tblAuth.authID
WHERE AgentID = @AgentID
ORDER BY tblUserprofiles.inputdate DESC


