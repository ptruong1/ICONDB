
CREATE PROCEDURE [dbo].[p_select_users_by_AgentID_04272016]
(
	@AgentID int
)
AS
	SET NOCOUNT ON;
if @agentID = 1
SELECT        tblUserprofiles.facilityID,
			  tblUserprofiles.UserID, 
		      tblUserprofiles.LastName, 
		      tblStatus.Descrip as Status,
		      ISNULL(Admin, 0) as Admin,
		      ISNULL(PowerUser,0) As PowerUser,
		      ISNULL([Finance-Auditor],0) as [Finance-Auditor],
		      ISNULL(Investigator,0) as Investigator,
		      ISNULL(DataEntry, 0) as DataEntry, 
		      ISNULL(UserDefine, 0) as UserDefine
FROM            tblUserprofiles  with(nolock)

	  INNER JOIN
                         tblAuthUsers   with(nolock) ON tblUserprofiles.authID = tblAuthUsers.AuthID
	 INNER JOIN
		tblStatus   with(nolock) ON tblUserprofiles.Status = tblStatus.StatusID
		
WHERE  AgentID=@AgentID and FacilityID =1 
ORDER BY tblUserprofiles.inputdate DESC
else

SELECT        tblUserprofiles.facilityID,
			  tblUserprofiles.UserID, 
		      tblUserprofiles.LastName, 
		      tblStatus.Descrip as Status,
		      ISNULL(Admin, 0) as Admin,
		      ISNULL(PowerUser,0) As PowerUser,
		      ISNULL([Finance-Auditor],0) as [Finance-Auditor],
		      ISNULL(Investigator,0) as Investigator,
		      ISNULL(DataEntry, 0) as DataEntry, 
		      ISNULL(UserDefine, 0) as UserDefine
FROM            tblUserprofiles  with(nolock)

	  INNER JOIN
                         tblAuthUsers   with(nolock) ON tblUserprofiles.authID = tblAuthUsers.AuthID
	 INNER JOIN
		tblStatus   with(nolock) ON tblUserprofiles.Status = tblStatus.StatusID
		
WHERE  AgentID=@AgentID and FacilityID =0
ORDER BY tblUserprofiles.inputdate DESC
