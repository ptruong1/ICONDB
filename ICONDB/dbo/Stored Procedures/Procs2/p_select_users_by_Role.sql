
CREATE PROCEDURE [dbo].[p_select_users_by_Role]
(
	@FacilityID int,
	@AuthID int
)
AS
	SET NOCOUNT ON;
SELECT   A.FacilityID, authID, userID, LastName, FirstName, RoleDescript
		     
FROM            tblUserprofiles A with(nolock)
				left join tblUserRole B with(nolock)  on A.authID=B.RoleAuthID
		
WHERE A.facilityID = @FacilityID and authID =@AuthID
ORDER BY LastName DESC
