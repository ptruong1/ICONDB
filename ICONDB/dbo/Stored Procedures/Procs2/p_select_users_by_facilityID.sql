
CREATE PROCEDURE [dbo].[p_select_users_by_facilityID]
(
	@FacilityID int
)
AS
	SET NOCOUNT ON;
SELECT        tblUserprofiles.UserID, 
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
		
WHERE facilityID = @FacilityID
ORDER BY tblUserprofiles.inputdate DESC
